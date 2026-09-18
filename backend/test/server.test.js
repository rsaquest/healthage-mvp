const test = require('node:test');
const assert = require('node:assert/strict');
const { createApp } = require('../src/server');

test('service request endpoint returns a created request', async () => {
  const app = createApp();
  const server = app.listen(0);

  try {
    const address = server.address();
    const response = await fetch(`http://127.0.0.1:${address.port}/api/service-request`, {
      method: 'POST',
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({
        patientName: 'Ada',
        serviceType: 'Home Visit',
        location: 'Lagos'
      })
    });

    assert.equal(response.status, 200);
    const body = await response.json();
    assert.equal(body.message, 'request created');
    assert.equal(body.data.serviceType, 'Home Visit');
  } finally {
    await new Promise((resolve) => server.close(resolve));
  }
});

test('admin overview exposes the defense metrics', async () => {
  const app = createApp();
  const server = app.listen(0);

  try {
    const address = server.address();
    const response = await fetch(`http://127.0.0.1:${address.port}/api/admin/overview`);

    assert.equal(response.status, 200);
    assert.deepEqual(await response.json(), {
      activePatients: 14,
      emergencyIncidents: 2,
      practitionersOnline: 8,
      pendingVerification: 3,
      totalSignups: 153,
      activeSignups: 15,
      serviceRequests: 16,
      completedTransactions: 16
    });
  } finally {
    await new Promise((resolve) => server.close(resolve));
  }
});
