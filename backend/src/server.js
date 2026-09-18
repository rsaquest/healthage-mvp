const express = require('express');
const cors = require('cors');
const http = require('http');
const WebSocket = require('ws');
const db = require('./db');
const wsClients = new Map(); // userId -> ws (shared scope)
const FCM_KEY = process.env.FCM_SERVER_KEY || process.env.FIREBASE_SERVER_KEY || null;
const fetch = require('node-fetch');

function createApp() {
  const app = express();
  app.use(cors());
  app.use(express.json());

  const requests = [];

  app.get('/', (req, res) => res.json({ name: 'HealthAge MVP', status: 'running' }));

  app.post('/api/register', (req, res) => {
    const { role, name, email, userCode } = req.body;
    let user = null;
    if (email) user = db.findUserByEmail(email);
    if (!user && userCode) user = db.findUserByUserCode(userCode);
    if (user) {
      user.name = name || user.name;
      user.role = role || user.role;
      user.email = email || user.email;
      user.userCode = userCode || user.userCode;
      user = db.updateUser(user);
      return res.json({ message: 'already registered', user });
    }
    const code = userCode || `${name?.split(' ').map((part) => part.substring(0, 2).toUpperCase()).join('')}-AUTO`;
    user = db.createUser({ name: name || 'User', email: email || '', password: '', role: role || 'Patient', userCode: code });
    res.json({ message: 'registered', user });
  });

  // identify or create user by email or userCode
  app.post('/api/users/identify', (req, res) => {
    const { email, name, userCode, role } = req.body;
    console.log('[IDENTIFY] request', { email, name, userCode, role });
    let user = null;
    if (email) user = db.findUserByEmail(email);
    if (!user && userCode) user = db.findUserByUserCode(userCode);
    if (!user) {
      const code = userCode || `${(name || 'User').split(' ').map((part) => part.substring(0, 2).toUpperCase()).join('')}-AUTO`;
      user = db.createUser({ name: name || 'User', email: email || '', password: '', role: role || 'Patient', userCode: code });
    } else {
      if (name) user.name = name;
      if (role) user.role = role;
      if (userCode) user.userCode = userCode;
      user = db.updateUser(user);
    }
    res.json({ user });
  });

  app.post('/api/service-request', (req, res) => {
    const request = {
      id: requests.length + 1,
      createdAt: new Date().toISOString(),
      ...req.body,
      status: 'matched'
    };
    requests.push(request);
    res.json({ message: 'request created', data: request });
  });

  app.get('/api/practitioners', (req, res) => {
    const list = db.getPractitioners();
    res.json({ data: list });
  });

  app.post('/api/emergency', (req, res) => {
    const { patientId, type, message, recipients } = req.body;
    const sos = db.createSosEvent({ patientId: patientId || null, type: type || 'require_attention', message: message || '', status: 'active' });

    let targetContacts = [];
    if (Array.isArray(recipients) && recipients.length) {
      targetContacts = recipients.map((recipient) => {
        if (typeof recipient === 'number') return db.findEmergencyContactById(recipient);
        return db.findEmergencyContactById(recipient);
      }).filter(Boolean);
    } else if (sos.patientId) {
      targetContacts = db.getEmergencyContacts(sos.patientId).filter(c => c.accepted);
    }

    targetContacts.forEach(contact => {
      const r = db.createSosRecipient({ sosId: sos.id, contactId: contact.id, userId: contact.userId || null });
      notifyRecipient(r, sos, contact);
      if (contact.userId && wsClients.has(contact.userId)) {
        try {
          wsClients.get(contact.userId).send(JSON.stringify({ type: 'sos', sosId: sos.id, patientId: sos.patientId, typeLabel: sos.type, message: sos.message }));
        } catch (e) { console.error('ws send error', e); }
      }
    });

    // If medical emergency, also notify HealthAge admin (mock)
    if (sos.type === 'medical_emergency') {
      console.log('[ALERT] HealthAge admin notified for SOS', sos.id);
    }

    res.json({ message: 'SOS received', data: sos, recipients: targetContacts.map(c => ({ id: c.id, name: c.name })) });
  });

  app.post('/api/emergency/:sosId/ack', (req, res) => {
    const sosId = Number(req.params.sosId);
    const { userId } = req.body;
    const recipient = db.findSosRecipientBySosIdAndUserId(sosId, userId);
    if (!recipient) return res.status(404).json({ message: 'recipient not found' });
    db.ackSosRecipient(recipient.id);
    const sos = db.findSosEventById(sosId);
    if (sos && sos.patientId && wsClients.has(sos.patientId)) {
      try {
        wsClients.get(sos.patientId).send(JSON.stringify({ type: 'sos_ack', sosId, byUserId: userId }));
      } catch (e) { console.error('ws patient ack error', e); }
    }
    res.json({ message: 'acknowledged', recipient });
  });

  app.get('/api/emergency/:sosId/status', (req, res) => {
    const sosId = Number(req.params.sosId);
    const sos = db.findSosEventById(sosId);
    if (!sos) return res.status(404).json({ message: 'sos not found' });
    const recipients = db.findSosRecipientsBySosId(sosId).map(r => ({ id: r.id, contactId: r.contactId, userId: r.userId, acked: r.acked }));
    res.json({ sos, recipients });
  });

  app.post('/api/emergency-contacts', (req, res) => {
    const { patientId, name, userCode } = req.body;
    if (!patientId || !userCode) return res.status(400).json({ message: 'patientId and userCode required' });
    const contact = db.addEmergencyContact({ patientId, name: name || userCode, userCode });
    res.json({ message: 'contact added (invite sent)', contact });
  });

  app.get('/api/emergency-contacts', (req, res) => {
    const patientId = Number(req.query.patientId);
    if (!patientId) return res.json({ contacts: [] });
    const list = db.getEmergencyContacts(patientId);
    res.json({ contacts: list });
  });

  app.delete('/api/emergency-contacts/:id', (req, res) => {
    const id = Number(req.params.id);
    const removed = db.deleteEmergencyContact(id);
    if (!removed) return res.status(404).json({ message: 'contact not found' });
    res.json({ message: 'contact removed', contact: { id } });
  });

  app.post('/api/emergency-contacts/:id/resend', (req, res) => {
    const id = Number(req.params.id);
    const contact = db.findEmergencyContactById(id);
    if (!contact) return res.status(404).json({ message: 'contact not found' });
    // Mock resend: if contact has userId and device tokens, send FCM; otherwise log
    if (contact.userId && FCM_KEY) {
      const tokens = db.getDeviceTokens(contact.userId);
      tokens.forEach(async (token) => {
        try {
          const payload = {
            to: token,
            notification: {
              title: 'HealthAge Invite',
              body: `You have an emergency contact invite from patient ${contact.patientId}`
            },
            data: { info: 'invite_resend', contactId: contact.id }
          };
          const resp = await fetch('https://fcm.googleapis.com/fcm/send', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', Authorization: `key=${FCM_KEY}` },
            body: JSON.stringify(payload)
          });
          const text = await resp.text();
          console.log('[FCM resend]', resp.status, text);
        } catch (err) {
          console.error('FCM resend error', err);
        }
      });
      res.json({ message: 'invite resent (pushed to device tokens)' });
    } else {
      console.log('[MOCK RESEND] invite resent for contact', contact.id);
      res.json({ message: 'invite resent (mock)' });
    }
  });

  app.post('/api/emergency-contacts/:id/accept', (req, res) => {
    const id = Number(req.params.id);
    const { userId } = req.body;
    const contact = db.findEmergencyContactById(id);
    if (!contact) return res.status(404).json({ message: 'contact not found' });
    const acceptedContact = db.acceptEmergencyContact(id, userId);
    res.json({ message: 'contact accepted', contact: acceptedContact });

    try {
      notifyPatient(acceptedContact.patientId, `${acceptedContact.name} accepted your emergency contact invite`);
    } catch (e) {
      console.error('notify patient error', e);
    }
    if (acceptedContact.patientId && wsClients.has(acceptedContact.patientId)) {
      try {
        wsClients.get(acceptedContact.patientId).send(JSON.stringify({ type: 'contact_accept', contact: acceptedContact }));
      } catch (e) { console.error('ws notify patient accept', e); }
    }
  });

  // List invites for a recipient by userCode or userId
  app.get('/api/invites', (req, res) => {
    const { userCode, userId } = req.query;
    if (userCode) {
      const list = db.findPendingInvitesByUserCode(userCode);
      return res.json({ invites: list });
    }
    if (userId) {
      const idnum = Number(userId);
      const list = db.findPendingInvitesByUserId(idnum);
      return res.json({ invites: list });
    }
    res.json({ invites: [] });
  });

  function notifyRecipient(recipient, sos, contact) {
    recipient.attempts += 1;
    recipient.lastNotifiedAt = new Date().toISOString();
    // Mock sending: log to console. In production, call push service (FCM) or SMS.
    console.log(`[NOTIFY] to contact:${contact.id} userId:${contact.userId} sos:${sos.id} type:${sos.type} attempt:${recipient.attempts}`);
    // Send FCM if key available and user has device tokens
    if (FCM_KEY && contact.userId) {
      const tokens = db.getDeviceTokens(contact.userId);
      tokens.forEach(async (token) => {
        try {
          const payload = {
            to: token,
            notification: {
              title: `${contact.name ?? 'Contact'} — ${sos.type === 'medical_emergency' ? 'Medical Emergency' : 'Needs attention'}`,
              body: sos.message || 'Please respond in the HealthAge app.'
            },
            data: { sosId: sos.id, patientId: sos.patientId, type: sos.type }
          };
          const resp = await fetch('https://fcm.googleapis.com/fcm/send', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', Authorization: `key=${FCM_KEY}` },
            body: JSON.stringify(payload)
          });
          const text = await resp.text();
          console.log('[FCM]', resp.status, text);
        } catch (err) {
          console.error('FCM send error', err);
        }
      });
    }
  }

  function notifyPatient(patientId, message) {
    if (!patientId) return;
    const tokens = db.getDeviceTokens(patientId);
    if (!tokens.length) {
      console.log('[NOTIFY] patient has no registered devices', patientId);
      return;
    }
    tokens.forEach(async (token) => {
      try {
        const payload = {
          to: token,
          notification: {
            title: 'HealthAge',
            body: message
          },
          data: { info: 'contact_accept' }
        };
        if (FCM_KEY) {
          const resp = await fetch('https://fcm.googleapis.com/fcm/send', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', Authorization: `key=${FCM_KEY}` },
            body: JSON.stringify(payload)
          });
          const text = await resp.text();
          console.log('[FCM patient]', resp.status, text);
        } else {
          console.log('[MOCK NOTIFY PATIENT]', patientId, message);
        }
      } catch (err) {
        console.error('patient notify error', err);
      }
    });
  }

  // Retry and escalation scheduler: runs periodically and retries notifying recipients
  const RETRY_INTERVAL_MS = 20 * 1000; // 20s for development
  const MAX_ATTEMPTS = 5;
  const ESCALATION_AFTER_ATTEMPTS = 5; // escalate after max attempts

  setInterval(() => {
    const now = Date.now();
    const recipients = db.findAllSosRecipients();
    recipients.forEach(recipient => {
      if (recipient.acked) return;
      if (!recipient.lastNotifiedAt || (now - new Date(recipient.lastNotifiedAt).getTime()) > RETRY_INTERVAL_MS) {
        if (recipient.attempts >= MAX_ATTEMPTS) {
          const sos = db.findSosEventById(recipient.sosId);
          if (sos && sos.type === 'medical_emergency') {
            console.log('[ESCALATE] sos', sos.id, 'recipient', recipient.id);
            console.log('[ALERT] Escalation: notify HealthAge admin for SOS', sos.id);
            // optional escalation logic could update sos.status in DB here if desired
          }
        } else {
          const contact = db.findEmergencyContactById(recipient.contactId);
          const sos = db.findSosEventById(recipient.sosId);
          if (contact && sos) {
            notifyRecipient(recipient, sos, contact);
          }
        }
      }
    });
  }, RETRY_INTERVAL_MS);

  app.post('/api/register-device', (req, res) => {
    const { userId, token } = req.body;
    if (!userId || !token) return res.status(400).json({ message: 'userId and token required' });
    db.registerDeviceToken(userId, token);
    res.json({ message: 'device registered', userId, token });
  });

  // Attach WebSocket handling will be done when server created below

  app.get('/api/admin/overview', (req, res) => {
    res.json({
      activePatients: 14,
      emergencyIncidents: 2,
      practitionersOnline: 8,
      pendingVerification: 3,
      totalSignups: 153,
      activeSignups: 15,
      serviceRequests: 16,
      completedTransactions: 16
    });
  });

  return app;
}

if (require.main === module) {
  const app = createApp();
  const server = http.createServer(app);
  const wss = new WebSocket.Server({ server, path: '/ws' });

  wss.on('connection', (ws, req) => {
    console.log('ws connection');
    ws.on('message', (msg) => {
      try {
        const data = JSON.parse(msg.toString());
        if (data.type === 'register' && data.userId) {
          const parsedId = Number(data.userId);
          const clientKey = Number.isNaN(parsedId) ? data.userId : parsedId;
          ws.userId = clientKey; // attach for reference
          wsClients.set(clientKey, ws);
          console.log('registered ws client', clientKey);
        }
      } catch (e) { console.error('ws message parse', e); }
    });
    ws.on('close', () => {
      // remove from map
      for (const [uid, client] of wsClients.entries()) {
        if (client === ws) wsClients.delete(uid);
      }
    });
  });

  server.listen(3000, () => console.log('HealthAge backend running on port 3000 with WebSocket'));
}

module.exports = { createApp };
