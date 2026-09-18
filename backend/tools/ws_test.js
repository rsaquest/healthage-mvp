const WebSocket = require('ws');
const ws = new WebSocket('ws://localhost:3000/ws');
ws.on('open', () => {
  console.log('WS open');
  ws.send(JSON.stringify({type:'register', userId:3}));
  console.log('sent register');
  setTimeout(()=>ws.close(), 500);
});
ws.on('message', (m) => console.log('received', m.toString()));
ws.on('close', ()=> console.log('WS closed'));
ws.on('error', (e)=> console.error('WS error', e));
