// Actual packaged Windows Flutter host -> native Dart learner; loopback only.
// This is automated interoperability coverage, not physical Wi-Fi certification.
const assert = require('node:assert/strict');
const fs = require('node:fs/promises');
const os = require('node:os');
const path = require('node:path');
const {spawn} = require('node:child_process');
const {_electron: electron} = require('playwright');
const root = path.resolve(__dirname,'../..');
const exe = process.env.NORIE_DESKTOP_EXE || path.join(root,'build/windows-desktop/NorieLearning-win32-x64/NorieLearning.exe');

async function main(){
  console.log('Launching packaged LAN teacher');
  const profile = await fs.mkdtemp(path.join(os.tmpdir(),'norie-lan-qa-'));
  const env = {...process.env}; delete env.ELECTRON_RUN_AS_NODE;
  const application = await electron.launch({executablePath:exe,env,
    args:['--test-hidden',`--user-data-dir=${profile}`,'--host-resolver-rules=MAP * ~NOTFOUND','--no-proxy-server'],timeout:60000});
  let page, endpoint;
  const errors=[];
  const state=async()=>page.evaluate(()=>{
    const value=JSON.parse(localStorage.getItem('flutter.norie.classroom.phase_a.v1'));
    // shared_preferences_web JSON-encodes its stored String value.
    return typeof value==='string'?JSON.parse(value):value;
  });
  try{
    page=await application.firstWindow(); page.setDefaultTimeout(30000);
    page.on('pageerror',error=>errors.push(error.message));
    await page.waitForURL('norie://app/',{timeout:60000});
    await page.waitForLoadState('domcontentloaded');
    await page.setViewportSize({width:390,height:844});
    const cdp=await application.context().newCDPSession(page);
    await cdp.send('Emulation.setFocusEmulationEnabled',{enabled:true});
    await cdp.send('Page.setWebLifecycleState',{state:'active'});
    // Only onboarding state is seeded. Assignment/result/account data use UI.
    await page.evaluate(()=>{for(const id of ['complete.v2','home.v1','learn.v1','profile.v1','progress.v1'])localStorage.setItem('flutter.norie.tutorial.'+id+'.complete','true');});
    await page.reload();
    await page.waitForSelector('flt-semantics-placeholder',{state:'attached',timeout:90000});
    await page.evaluate(()=>document.querySelector('flt-semantics-placeholder').click());
    await page.getByRole('button',{name:'Home Home',exact:true}).waitFor();
    await page.evaluate(()=>window.dispatchEvent(new Event('focus')));
    async function click(locator){
      for(let i=0;i<25;i++){
        if(await locator.count()){
          const box=await locator.boundingBox();
          if(box&&box.y>=56&&box.y+box.height<=840){await page.waitForTimeout(300);await locator.click();return;}
          if(box&&box.y<56){await page.mouse.move(180,400);await page.mouse.wheel(0,-300);await page.waitForTimeout(150);continue;}
        }
        await page.mouse.move(180,400);await page.mouse.wheel(0,300);await page.waitForTimeout(150);
      }
      throw Error('LAN UI target not visible: '+locator);
    }
    async function select(locator){
      await click(locator);
      for(let frame=0;frame<30;frame++){
        if(await locator.isChecked())return;
        await page.waitForTimeout(100);
      }
      assert.equal(await locator.isChecked(),true);
    }
    await page.getByRole('button',{name:'Learn Learn',exact:true}).click();
    await click(page.getByRole('progressbar',{name:/Classroom/}).first());
    await click(page.getByRole('button',{name:'Build assignment',exact:true}));
    console.log('Building the classroom assignment through the app');
    const title=page.getByRole('textbox',{name:'Assignment title'});
    await title.waitFor();
    // Wait for the route before focusing Flutter's editable text connection.
    // DOM fill alone changes the semantics input without updating its controller.
    await page.waitForTimeout(350);
    await title.click();
    // DOM focus precedes Flutter attaching its editing strategy. Wait for the
    // actual input handler rather than typing into an unconnected semantics proxy.
    let editing=false;
    for(let attempt=0;attempt<50&&!editing;attempt++){
      const {result}=await cdp.send('Runtime.evaluate',{expression:'document.querySelector(\'input[aria-label="Assignment title"]\')'});
      if(result.objectId){
        const {listeners}=await cdp.send('DOMDebugger.getEventListeners',{objectId:result.objectId});
        editing=listeners.some(listener=>listener.type==='input');
        await cdp.send('Runtime.releaseObject',{objectId:result.objectId});
      }
      if(!editing)await page.waitForTimeout(100);
    }
    assert.ok(editing,'Flutter must attach its editable input connection before typing');
    await title.pressSequentially('LAN discovery practice');
    await page.waitForFunction(()=>[...document.querySelectorAll('input,textarea')].some(e=>e.value==='LAN discovery practice'),null,{timeout:5000});
    console.log('Assignment title entered');
    await click(page.getByText(/Living & Nonliving Things/).first());
    const question=page.getByRole('checkbox',{name:'Which thing is living?',exact:true});
    await select(question);
    console.log('Authored question selected');
    await click(page.getByRole('button',{name:'Save assignment',exact:true}));
    await page.getByRole('heading',{name:'Offline Classroom',exact:true}).waitFor();
    const beforeXp=await page.evaluate(()=>localStorage.getItem('flutter.norie.totalXp'));
    await click(page.getByRole('button',{name:'Local Wi-Fi Classroom',exact:true}));
    assert.equal(await page.evaluate(()=>typeof window.norieClassroomLan?.invoke),'function');
    await click(page.getByRole('button',{name:'Host a classroom',exact:true}));
    const selected=page.getByRole('checkbox',{name:/LAN discovery practice/});
    await select(selected);
    await click(page.getByRole('button',{name:'Start local classroom',exact:true}));
    await page.getByText('Classroom is open',{exact:true}).waitFor();
    console.log('Teacher session open; starting native learner interoperability check');
    const info=await page.evaluate(async()=>JSON.parse(await window.norieClassroomLan.invoke('poll','{}')).session);
    assert.ok(info?.session_id); endpoint=`http://127.0.0.1:${info.port}`;
    await page.screenshot({path:path.join(root,'build/windows-lan-teacher-phone.png')});
    const connection=path.join(profile,'test-connection.json');
    await fs.writeFile(connection,JSON.stringify({endpoint,join_code:info.join_code,session_id:info.session_id}));
    const flutterRoot=process.env.FLUTTER_ROOT;
    assert.ok(flutterRoot,'FLUTTER_ROOT must identify installed Flutter SDK for native interoperability test');
    const dart=path.join(flutterRoot,'bin/cache/dart-sdk/bin',process.platform==='win32'?'dart.exe':'dart');
    const snapshot=path.join(flutterRoot,'bin/cache/flutter_tools.snapshot');
    await new Promise((resolve,reject)=>{
      const child=spawn(dart,[snapshot,'test','test/norie_classroom_lan_electron_interop_test.dart','--reporter','expanded'],
        {cwd:root,env:{...env,FLUTTER_ROOT:flutterRoot,NORIE_LAN_CONNECTION_FILE:connection},stdio:['ignore','pipe','pipe']});
      child.stdout.pipe(process.stdout);child.stderr.pipe(process.stderr);
      const timer=setTimeout(()=>{child.kill();reject(Error('Native learner interop timed out'));},180000);
      child.once('error',e=>{clearTimeout(timer);reject(e);});
      child.once('exit',code=>{clearTimeout(timer);code===0?resolve():reject(Error('Native learner interop failed: '+code));});
    });
    await click(page.getByRole('button',{name:'Refresh results',exact:true}));
    // Flutter combines the roster alias and its result summary in one node.
    await page.getByText(/^LAN Mina\b/).waitFor();
    const saved=await state();assert.equal(saved.submissions.length,1);assert.equal(saved.submissions[0].correct,1);
    assert.equal(await page.evaluate(()=>localStorage.getItem('flutter.norie.totalXp')),beforeXp);
    await page.screenshot({path:path.join(root,'build/windows-lan-results-phone.png')});
    // Stop by leaving the teacher route, the same action a learner uses.
    await page.getByRole('button',{name:'Back',exact:true}).click();
    let stopped=false;
    for(let attempt=0;attempt<20&&!stopped;attempt++){
      try{await fetch(endpoint+'/v1/hello',{signal:AbortSignal.timeout(1000)});}
      catch(error){if(error.cause?.code==='ECONNREFUSED')stopped=true;else throw error;}
      if(!stopped)await page.waitForTimeout(100);
    }
    assert.ok(stopped,'Leaving the teacher route must close its listener');
    assert.deepEqual(errors,[]);
    console.log('PASS packaged Electron teacher: actual UI selection/QR, native Dart learner download and recomputed durable result, duplicate/reconnect retry, unchanged XP and stop-on-exit. Loopback QA only.');
  }catch(error){
    if(page){console.error((await page.locator('body').innerText()).slice(-12000));await page.screenshot({path:path.join(root,'build/windows-lan-failure.png'),timeout:5000}).catch(()=>{});}
    throw error;
  }finally{await application.close();}
}
main().catch(error=>{console.error(error);process.exitCode=1;});
