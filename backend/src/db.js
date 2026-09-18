const fs = require('fs');
const path = require('path');

const dataDir = path.join(__dirname, '..', 'data');
const dataFile = path.join(dataDir, 'healthage.json');

if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir, { recursive: true });
}

function loadData() {
  try {
    if (!fs.existsSync(dataFile)) {
      return {
        users: [],
        emergencyContacts: [],
        sosEvents: [],
        sosRecipients: [],
        userDevices: []
      };
    }
    const json = fs.readFileSync(dataFile, 'utf8');
    return JSON.parse(json || '{}');
  } catch (error) {
    console.error('Failed to load DB file:', error);
    return {
      users: [],
      emergencyContacts: [],
      sosEvents: [],
      sosRecipients: [],
      userDevices: []
    };
  }
}

function saveData(data) {
  fs.writeFileSync(dataFile, JSON.stringify(data, null, 2), 'utf8');
}

function nextId(list) {
  const last = list.reduce((max, item) => Math.max(max, item.id || 0), 0);
  return last + 1;
}

function findUserByEmail(email) {
  if (!email) return null;
  const data = loadData();
  return data.users.find((user) => user.email && user.email.toLowerCase() === email.toLowerCase()) || null;
}

function findUserByUserCode(userCode) {
  if (!userCode) return null;
  const data = loadData();
  return data.users.find((user) => user.userCode === userCode) || null;
}

function createUser({ name, email, password, role, userCode }) {
  const data = loadData();
  const user = {
    id: nextId(data.users),
    name,
    email,
    password,
    role,
    userCode
  };
  data.users.push(user);
  saveData(data);
  return user;
}

function updateUser(user) {
  const data = loadData();
  const index = data.users.findIndex((item) => item.id === user.id);
  if (index < 0) return user;
  data.users[index] = { ...data.users[index], ...user };
  saveData(data);
  return data.users[index];
}

function getPractitioners() {
  const data = loadData();
  return data.users.filter((user) => ['Practitioner', 'Caregiver'].includes(user.role));
}

function addEmergencyContact({ patientId, name, userCode }) {
  const data = loadData();
  const contact = {
    id: nextId(data.emergencyContacts),
    patientId,
    name,
    userCode,
    userId: null,
    accepted: false,
    acceptedAt: null
  };
  data.emergencyContacts.push(contact);
  saveData(data);
  return contact;
}

function getEmergencyContacts(patientId) {
  const data = loadData();
  return data.emergencyContacts.filter((contact) => contact.patientId === patientId);
}

function deleteEmergencyContact(id) {
  const data = loadData();
  const originalLength = data.emergencyContacts.length;
  data.emergencyContacts = data.emergencyContacts.filter((contact) => contact.id !== id);
  const deleted = data.emergencyContacts.length < originalLength;
  if (deleted) saveData(data);
  return deleted;
}

function findEmergencyContactById(id) {
  const data = loadData();
  return data.emergencyContacts.find((contact) => contact.id === id) || null;
}

function acceptEmergencyContact(id, userId) {
  const data = loadData();
  const contact = data.emergencyContacts.find((item) => item.id === id);
  if (!contact) return null;
  contact.accepted = true;
  contact.userId = userId;
  contact.acceptedAt = new Date().toISOString();
  saveData(data);
  return contact;
}

function findPendingInvitesByUserCode(userCode) {
  const data = loadData();
  return data.emergencyContacts.filter((contact) => contact.userCode === userCode && !contact.accepted);
}

function findPendingInvitesByUserId(userId) {
  const data = loadData();
  return data.emergencyContacts.filter((contact) => contact.userId === userId && !contact.accepted);
}

function createSosEvent({ patientId, type, message, status }) {
  const data = loadData();
  const sos = {
    id: nextId(data.sosEvents),
    patientId,
    type,
    message,
    status,
    createdAt: new Date().toISOString()
  };
  data.sosEvents.push(sos);
  saveData(data);
  return sos;
}

function createSosRecipient({ sosId, contactId, userId }) {
  const data = loadData();
  const recipient = {
    id: nextId(data.sosRecipients),
    sosId,
    contactId,
    userId: userId || null,
    acked: false,
    attempts: 0,
    lastNotifiedAt: null
  };
  data.sosRecipients.push(recipient);
  saveData(data);
  return recipient;
}

function findSosEventById(id) {
  const data = loadData();
  return data.sosEvents.find((sos) => sos.id === id) || null;
}

function findSosRecipientsBySosId(sosId) {
  const data = loadData();
  return data.sosRecipients.filter((recipient) => recipient.sosId === sosId);
}

function findSosRecipientBySosIdAndUserId(sosId, userId) {
  const data = loadData();
  return data.sosRecipients.find((recipient) => recipient.sosId === sosId && recipient.userId === userId) || null;
}

function findAllSosRecipients() {
  const data = loadData();
  return data.sosRecipients;
}

function findSosRecipientById(id) {
  const data = loadData();
  return data.sosRecipients.find((recipient) => recipient.id === id) || null;
}

function ackSosRecipient(id) {
  const data = loadData();
  const recipient = data.sosRecipients.find((item) => item.id === id);
  if (!recipient) return null;
  recipient.acked = true;
  saveData(data);
  return recipient;
}

function registerDeviceToken(userId, token) {
  const data = loadData();
  const exists = data.userDevices.some((entry) => entry.userId === userId && entry.token === token);
  if (!exists) {
    data.userDevices.push({ id: nextId(data.userDevices), userId, token });
    saveData(data);
  }
}

function getDeviceTokens(userId) {
  const data = loadData();
  return data.userDevices.filter((entry) => entry.userId === userId).map((entry) => entry.token);
}

module.exports = {
  findUserByEmail,
  findUserByUserCode,
  createUser,
  updateUser,
  getPractitioners,
  addEmergencyContact,
  getEmergencyContacts,
  deleteEmergencyContact,
  findEmergencyContactById,
  acceptEmergencyContact,
  findPendingInvitesByUserCode,
  findPendingInvitesByUserId,
  createSosEvent,
  createSosRecipient,
  findSosEventById,
  findSosRecipientsBySosId,
  findSosRecipientBySosIdAndUserId,
  findAllSosRecipients,
  findSosRecipientById,
  ackSosRecipient,
  registerDeviceToken,
  getDeviceTokens
};
