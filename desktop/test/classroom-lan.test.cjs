const test = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const {createClassroomLan, validateEndpoint} = require('../classroom-lan.cjs');
const {isTrustedSender} = require('../classroom-lan-ipc.cjs');
const tick = () => new Promise(resolve => setTimeout(resolve, 15));
function raw(s, path='/v1/hello', extra={}) {
  return new Promise((resolve,reject)=> {
    const req=http.request({host:'127.0.0.1',port:s.port,path,method:extra.method||'GET',headers:{'x-norie-join-code':s.join_code,'x-norie-session-id':s.session_id,...extra.headers}}, res=>{let body=''; res.on('data',b=>body+=b);res.on('end',()=>resolve({status:res.statusCode,body}));});req.on('error',reject);req.end(extra.body);
  });
}
async function queued(lan) { for(let i=0;i<100;i++){const p=lan.poll();if(p.requests.length)return p.requests;await tick();}throw Error('Request not queued'); }
test('does not acknowledge until renderer durably responds; relays raw JSON unchanged',async t=>{
 const lan=createClassroomLan();t.after(()=>lan.stop()); assert.equal(lan.poll().session,null);
 const s=await lan.start(); assert.match(s.join_code,/^\d{6}$/);assert.match(s.session_id,/^[\da-f-]{36}$/);
 let done=false;const response=raw(s,'/v1/submissions',{method:'POST',body:'{"package":"learner"}'}).then(r=>{done=true;return r});
 const [r]=await queued(lan);assert.equal(r.body,'{"package":"learner"}');assert.equal(done,false);assert.deepEqual(lan.poll().requests,[]);
 lan.respond({request_id:r.request_id,status:201,body:'{"accepted":true}'});assert.deepEqual(await response,{status:201,body:'{"accepted":true}'});
});
test('rejects wrong code, stale session, origin, route and method before relay',async t=>{
 const lan=createClassroomLan();t.after(()=>lan.stop());const s=await lan.start();
 for(const [extra,status,path] of [[{headers:{'x-norie-join-code':'000000'}},401],[{headers:{'x-norie-session-id':'stale'}},409],[{headers:{origin:'https://evil.test'}},403],[{method:'POST'},405],[{},404,'/v1/nope']]) assert.equal((await raw(s,path,extra)).status,status);
 assert.deepEqual(lan.poll().requests,[]);
});
test('stop rejects pending and restart rotates identity',async t=>{
 const lan=createClassroomLan();t.after(()=>lan.stop());const s=await lan.start();const pending=raw(s);await queued(lan);await lan.stop();assert.equal((await pending).status,503);assert.equal(lan.poll().session,null);const next=await lan.start();assert.notEqual(next.session_id,s.session_id);assert.equal((await raw(next,'/v1/assignments',{headers:{'x-norie-session-id':s.session_id}})).status,409);
});
test('bounds streamed body, pending count, total retained bytes and response deadline',async t=>{
 const lan=createClassroomLan({maxBodyBytes:32,maxPending:1,maxPendingBytes:128,requestDeadlineMs:150});t.after(()=>lan.stop());const s=await lan.start();
 assert.equal((await raw(s,'/v1/submissions',{method:'POST',body:'x'.repeat(33)})).status,413);
 const pending=raw(s);await queued(lan);assert.equal((await raw(s)).status,503);assert.equal((await pending).status,504);
 const full=raw(s,'/v1/submissions',{method:'POST',body:'x'.repeat(32)});await queued(lan);assert.equal((await raw(s)).status,503);await full;
});
test('private client round trips and rejects public/DNS/redirect endpoints',async t=>{
 for(const endpoint of ['http://example.com:80','http://8.8.8.8','https://192.168.1.2','http://127.0.0.1/secret','http://user@127.0.0.1','http://2130706433','http://127.1','http://[::1]'])assert.throws(()=>validateEndpoint(endpoint));
 const lan=createClassroomLan();t.after(()=>lan.stop());const s=await lan.start();const response=lan.request({endpoint:`http://127.0.0.1:${s.port}`,join_code:s.join_code,session_id:s.session_id,method:'GET',path:'/v1/hello',body:''});const [r]=await queued(lan);lan.respond({request_id:r.request_id,status:200,body:'{"ok":true}'});assert.deepEqual(await response,{status:200,body:'{"ok":true}'});
});
test('sender requires exact top level app document and owning web contents',()=>{
 const frame={url:'norie://app/'};const wc={mainFrame:frame};assert.equal(isTrustedSender({sender:wc,senderFrame:frame},wc),true);
 for(const url of ['norie://app/other','norie://app/?x=1','https://app/','norie://app.evil/']){assert.equal(isTrustedSender({sender:wc,senderFrame:{url}},wc),false);}
 assert.equal(isTrustedSender({sender:wc,senderFrame:{url:'norie://app/'}},wc),false);assert.equal(isTrustedSender({sender:{},senderFrame:frame},wc),false);
});
test('rejects multibyte auth and noncanonical endpoints safely',async t=>{
 const lan=createClassroomLan();t.after(()=>lan.stop());const s=await lan.start();assert.equal((await raw(s,'/v1/hello',{headers:{'x-norie-join-code':'\u00e9\u00e9\u00e9\u00e9\u00e9\u00e9'}})).status,401);
 for(const endpoint of ['http://0177.0.0.1','http://127.000.0.1'])assert.throws(()=>validateEndpoint(endpoint));
});
test('stalled streamed body expires and aggregate pending memory is bounded',async t=>{
 const lan=createClassroomLan({maxBodyBytes:64,maxPendingBytes:80,requestDeadlineMs:120});t.after(()=>lan.stop());const s=await lan.start();
 const first=raw(s,'/v1/submissions',{method:'POST',body:'x'.repeat(20)});await queued(lan);
 assert.equal((await raw(s,'/v1/submissions',{method:'POST',body:'x'.repeat(20)})).status,503);await first;
 const stalled=new Promise((resolve,reject)=>{const req=http.request({host:'127.0.0.1',port:s.port,path:'/v1/submissions',method:'POST',headers:{'x-norie-join-code':s.join_code,'x-norie-session-id':s.session_id,'content-length':8}},res=>{res.resume();res.on('end',()=>{req.destroy();resolve(res.statusCode);});});req.on('error',reject);req.write('x');});
 assert.equal(await stalled,504);
});
test('client refuses redirect and oversized response, and auth attempts are bounded',async t=>{
 const target=http.createServer((req,res)=>{if(req.url==='/v1/hello'){res.writeHead(302,{location:'http://8.8.8.8'});res.end();}else res.end('x'.repeat(33));});await new Promise(r=>target.listen(0,'127.0.0.1',r));t.after(()=>new Promise(r=>target.close(r)));
 const lan=createClassroomLan({maxBodyBytes:32});t.after(()=>lan.stop());const data={endpoint:`http://127.0.0.1:${target.address().port}`,join_code:'123456',session_id:'11111111-1111-1111-1111-111111111111',method:'GET',path:'/v1/hello',body:''};await assert.rejects(lan.request(data));await assert.rejects(lan.request({...data,path:'/v1/assignments'}));
 const s=await lan.start();for(let i=0;i<12;i++)assert.equal((await raw(s,undefined,{headers:{'x-norie-join-code':'wrong'}})).status,401);assert.equal((await raw(s)).status,429);
});

test('IPC denies foreign frames, unknown actions and malformed input before transport',async()=>{
 const {installClassroomLanIpc}=require('../classroom-lan-ipc.cjs');const frame={url:'norie://app/'};const contents={mainFrame:frame};let calls=0,handler;
 installClassroomLanIpc({handle:(_channel,fn)=>{handler=fn}},()=>contents,{invoke:async(action,data)=>{calls++;return {action,data};}});
 const event={sender:contents,senderFrame:frame};
 await assert.rejects(handler({...event,senderFrame:{url:'norie://app/'}},'start','{}'));
 await assert.rejects(handler(event,'arbitrary','{}'));await assert.rejects(handler(event,'start','{'));assert.equal(calls,0);
 assert.deepEqual(JSON.parse(await handler(event,'poll','{}')),{action:'poll',data:{}});assert.equal(calls,1);
});

test('rejects invalid UTF8 without altering classroom package bytes',async t=>{
 const lan=createClassroomLan();t.after(()=>lan.stop());const s=await lan.start();assert.equal((await raw(s,'/v1/submissions',{method:'POST',body:Buffer.from([0xff])})).status,400);assert.deepEqual(lan.poll().requests,[]);
});
