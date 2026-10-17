// Transport only: Flutter owns classroom validation, persistence and acknowledgements.
const http = require('node:http');
const os = require('node:os');
const { randomInt, randomUUID, timingSafeEqual } = require('node:crypto');
const MAX_BODY = 2 * 1024 * 1024;
function privateIPv4(host) {
  if (!/^\d{1,3}(\.\d{1,3}){3}$/.test(host)) return false;
  const p = host.split('.');
  if (p.some(v => String(Number(v)) !== v || Number(v) > 255)) return false;
  const [a,b] = p.map(Number);
  return a === 10 || a === 127 || (a === 172 && b >= 16 && b <= 31) || (a === 192 && b === 168);
}
function validateEndpoint(endpoint) {
  if (typeof endpoint !== 'string' || !/^http:\/\/\d{1,3}(?:\.\d{1,3}){3}(?::[1-9]\d{0,4})?\/?$/.test(endpoint)) throw Error('Invalid private endpoint');
  if (!privateIPv4(endpoint.slice(7).split(/[/:]/)[0])) throw Error('Invalid private endpoint');
  const url = new URL(endpoint);
  if (!privateIPv4(url.hostname) || (url.port && Number(url.port) > 65535)) throw Error('Invalid private endpoint');
  return url;
}
function route(method, path) {
  if (typeof path !== 'string' || path.length > 1024) return 404;
  const read = path === '/v1/hello' || path === '/v1/assignments' || /^\/v1\/assignments\/[A-Za-z0-9_~.%-]+$/.test(path);
  if (read) {try {if(decodeURIComponent(path).includes('..')) return 404;}catch {return 404;} return method === 'GET' ? 0 : 405;}
  if (path === '/v1/submissions') return method === 'POST' ? 0 : 405;
  return 404;
}
function createClassroomLan(options = {}) {
  const bodyLimit = Math.min(options.maxBodyBytes || MAX_BODY, MAX_BODY);
  const pendingLimit = Math.min(options.maxPending || 32, 32);
  const memoryLimit = Math.min(options.maxPendingBytes || 8 * 1024 * 1024, 8 * 1024 * 1024);
  const deadline = options.requestDeadlineMs || 15000;
  let server = null, session = null, starting = null, retained = 0;
  const pending = new Map(), sockets = new Set(), authAttempts = new Map(), clients = new Set();
  function json(res, status, body) { if(!res.destroyed && !res.writableEnded) {res.writeHead(status, {'content-type':'application/json; charset=utf-8','cache-control':'no-store','connection':'close','x-content-type-options':'nosniff'});res.end(body);} }
  function error(res,status) {json(res,status,JSON.stringify({error:({401:'Unauthorized',403:'Forbidden',404:'Not found',405:'Method not allowed',409:'Session expired',413:'Request too large',429:'Try again later',503:'Classroom unavailable',504:'Request timed out'})[status] || 'Invalid request'}));}
  function finish(entry,status,body) {if(!pending.delete(entry.id))return;clearTimeout(entry.timer);retained-=entry.bytes;entry.chunks.length=0;entry.body='';json(entry.res,status,body);}
  function receive(req,res) {
    const fail = status => {error(res,status);req.resume();};
    if (!session) return fail(503);
    if (req.headers.origin !== undefined) return fail(403);
    const peer=req.socket.remoteAddress || '';
    const now=Date.now();
    for(const [key,value] of authAttempts) if(value.until<now) authAttempts.delete(key);
    const attempt=authAttempts.get(peer);
    if(attempt && attempt.count>=12) return fail(429);
    const code=req.headers['x-norie-join-code'];
    if(typeof code!=='string' || !/^\d{6}$/.test(code) || !timingSafeEqual(Buffer.from(code),Buffer.from(session.join_code))) {
      if(!attempt && authAttempts.size>=64) return fail(429);
      authAttempts.set(peer,{count:(attempt?.count||0)+1,until:attempt?.until||now+60000});return fail(401);
    }
    if(req.headers['x-norie-session-id'] !== session.session_id && !(req.url === '/v1/hello' && req.headers['x-norie-session-id'] === undefined)) return fail(409);
    const invalid=route(req.method,req.url);if(invalid)return fail(invalid);
    if(pending.size>=pendingLimit || retained>=memoryLimit) return fail(503);
    const id=randomUUID(), entry={id,res,bytes:0,ready:false,delivered:false,method:req.method,path:req.url,body:'',chunks:[]};
    pending.set(id,entry);
    entry.timer=setTimeout(()=>finish(entry,504,'{"error":"Request timed out"}'),deadline);
    const chunks=entry.chunks;
    req.on('data', chunk=>{
      if(!pending.has(id))return;
      if(entry.bytes/4+chunk.length>bodyLimit){finish(entry,413,'{"error":"Request too large"}');return;}
      // Reserve original/concatenated buffers plus UTF-16 string before retention.
      if(retained+chunk.length*4>memoryLimit){finish(entry,503,'{"error":"Classroom unavailable"}');return;}
      entry.bytes+=chunk.length*4;retained+=chunk.length*4;chunks.push(chunk);
    });
    req.on('end',()=>{
      if(!pending.has(id))return;
      try {entry.body=new TextDecoder('utf-8',{fatal:true}).decode(Buffer.concat(chunks));}
      catch {finish(entry,400,'{"error":"Invalid request"}');return;}
      chunks.length=0;entry.ready=true;
    });
    req.on('error',()=>finish(entry,400,'{"error":"Invalid request"}'));
    res.on('close',()=>{if(pending.has(id))finish(entry,503,'{"error":"Classroom unavailable"}');});
  }
  async function start() {
    if(session)return {...session,addresses:[...session.addresses]};
    if(starting)return starting;
    starting=(async()=>{
      const listener=http.createServer({maxHeaderSize:8192},receive);server=listener;
      listener.maxConnections=64;listener.headersTimeout=5000;listener.requestTimeout=10000;listener.timeout=deadline;listener.keepAliveTimeout=1000;listener.maxRequestsPerSocket=8;
      listener.on('connection', socket=>{sockets.add(socket);socket.on('close',()=>sockets.delete(socket));socket.setTimeout(Math.max(deadline+1000,5000),()=>socket.destroy());});
      listener.on('clientError',(_err,socket)=>socket.destroy());
      try {await new Promise((resolve,reject)=>{listener.once('error',reject);listener.listen(0,'0.0.0.0',resolve);});} catch {server=null;throw Error('Unable to start classroom');}
      const addresses=[...new Set(Object.values(os.networkInterfaces()).flat().filter(a=>a&&a.family==='IPv4'&&privateIPv4(a.address)&&!a.internal).map(a=>a.address))];
      if(!addresses.length)addresses.push('127.0.0.1');
      session={session_id:randomUUID(),join_code:String(randomInt(0,1000000)).padStart(6,'0'),host:addresses[0],port:listener.address().port,started_at:new Date().toISOString(),addresses};
      return {...session,addresses:[...addresses]};
    })();try{return await starting;}finally{starting=null;}
  }
  async function stop() {
    if(starting)await starting.catch(()=>{});
    session=null;authAttempts.clear();
    for(const entry of [...pending.values()])finish(entry,503,'{"error":"Classroom stopped"}');
    for(const client of clients)client.destroy(Error('Classroom stopped'));clients.clear();
    const listener=server;server=null;
    if(listener){const closed=new Promise(resolve=>listener.close(resolve));listener.closeIdleConnections();for(const socket of sockets){socket.end();setTimeout(()=>socket.destroy(),50).unref();}await closed;}
    retained=0;
  }
  function poll() {const requests=[];for(const e of pending.values())if(e.ready&&!e.delivered){e.delivered=true;requests.push({request_id:e.id,method:e.method,path:e.path,body:e.body});}return {session:session?{...session,addresses:[...session.addresses]}:null,requests};}
  function respond(data) {
    if(!data || typeof data.body!=='string' || Buffer.byteLength(data.body)>bodyLimit || !Number.isInteger(data.status) || data.status<200 || data.status>599 || (data.status>=300&&data.status<400))throw Error('Invalid classroom response');
    const entry=pending.get(data.request_id);if(!entry || !entry.ready || !entry.delivered)return {accepted:false};
    finish(entry,data.status,data.body);return {accepted:true};
  }
  function request(data) {
    const url=validateEndpoint(data?.endpoint);
    if(route(data.method,data.path) || typeof data.join_code!=='string' || !/^\d{6}$/.test(data.join_code) || (data.session_id!=null && !/^[\da-f-]{36}$/i.test(data.session_id)) || (data.path!=='/v1/hello'&&!data.session_id) || typeof data.body!=='string' || Buffer.byteLength(data.body)>bodyLimit)throw Error('Invalid classroom request');
    if(clients.size>=32)throw Error('Classroom busy');
    return new Promise((resolve,reject)=>{
      let settled=false;const done=(err,value)=>{if(settled)return;settled=true;clearTimeout(timer);clients.delete(req);err?reject(Error('Classroom connection failed')):resolve(value);};
      const req=http.request({hostname:url.hostname,port:url.port||80,method:data.method,path:data.path,agent:false,headers:{'x-norie-join-code':data.join_code,...(data.session_id?{'x-norie-session-id':data.session_id}:{}),'content-type':'application/json','content-length':Buffer.byteLength(data.body)}},res=>{
        let size=0;const chunks=[];res.on('data',chunk=>{size+=chunk.length;if(size>bodyLimit){req.destroy();done(true);return;}chunks.push(chunk);});
        res.on('end',()=>{
          if(res.statusCode>=300&&res.statusCode<400)return done(true);
          try {done(null,{status:res.statusCode,body:new TextDecoder('utf-8',{fatal:true}).decode(Buffer.concat(chunks))});}
          catch {done(true);}
        });res.on('error',()=>done(true));
      });
      const timer=setTimeout(()=>{req.destroy();done(true);},deadline);clients.add(req);req.on('error',()=>done(true));req.end(data.body);
    });
  }
  async function invoke(action,data) {switch(action){case 'start':return start();case 'stop':await stop();return {};case 'poll':return poll();case 'respond':return respond(data);case 'request':return request(data);default:throw Error('Unsupported classroom action');}}
  return {start,stop,poll,respond,request,invoke};
}
module.exports={createClassroomLan,validateEndpoint,privateIPv4};
