const {chromium}=require('playwright');
const assert=require('node:assert/strict');
const fs=require('node:fs/promises');
const path=require('node:path');
const http=require('node:http');
let site=process.env.NORIE_TEST_SITE, server;
async function serve(){
  if(site)return;
  const root=path.resolve(__dirname,'../../build/web');
  const mime={'.js':'text/javascript','.mjs':'text/javascript','.json':'application/json','.wasm':'application/wasm','.html':'text/html','.svg':'image/svg+xml','.ttf':'font/ttf','.woff2':'font/woff2'};
  server=http.createServer(async(req,res)=>{
    try{
      let name=decodeURIComponent(new URL(req.url,'http://localhost').pathname).replace(/^\/NorieLearningApp/,'');
      if(name.endsWith('/'))name+='index.html';
      const target=path.resolve(root,'.'+name);
      if(!target.startsWith(root+path.sep)){res.writeHead(403);res.end();return;}
      res.setHeader('Content-Type',mime[path.extname(target)]||'application/octet-stream');
      res.end(await fs.readFile(target));
    }catch{res.writeHead(404);res.end();}
  });
  await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
  site=`http://127.0.0.1:${server.address().port}/NorieLearningApp/`;
}
(async()=>{
  await serve();
  const browser=await chromium.launch({channel:'msedge',headless:true});
  const errors=[];
  let page;
  try{
    const context=await browser.newContext({viewport:{width:390,height:844},acceptDownloads:true});
    await context.route('**/*',r=>new URL(r.request().url()).origin===new URL(site).origin?r.continue():r.abort());
    await context.addInitScript(()=>{
      for(const id of ['complete.v2','home.v1','learn.v1','profile.v1','progress.v1'])localStorage.setItem('flutter.norie.tutorial.'+id+'.complete','true');
    });
    page=await context.newPage();page.setDefaultTimeout(30000);
    page.on('pageerror',e=>errors.push(e.message));
    async function dismiss(){
      const later=page.getByRole('button',{name:'Later',exact:true});
      if(await later.isVisible())await later.click();
      const close=page.getByRole('button',{name:'Close',exact:true});
      if(await close.isVisible())await close.click();
    }
    async function settled(locator){
      // Flutter paints Drawer and scroll transitions outside the DOM. A
      // semantic node can be visible before its painted hit target settles.
      let previous,stable=0;
      for(let frame=0;frame<20;frame++){
        const box=await locator.boundingBox();
        if(box&&previous&&['x','y','width','height'].every(key=>Math.abs(box[key]-previous[key])<0.5))stable++;
        else stable=0;
        if(stable>=3){
          return box;
        }
        previous=box;
        await page.waitForTimeout(100);
      }
      throw new Error('Painted navigation target did not settle');
    }
    async function click(locator){
      await dismiss();
      for(let i=0;i<20;i++){
        await dismiss();
        if(await locator.count()){const box=await settled(locator);if(box&&box.x>=0&&box.y>60&&box.y+box.height<790){await dismiss();if(process.env.NORIE_DIAGNOSTICS_TRACE){console.log('Tap',await locator.getAttribute('aria-label'),JSON.stringify(box));await page.screenshot({path:'build/windows-trace-'+Date.now()+'.png'});}await locator.click();return;}}
        // Scroll above the update banner if it arrives during this gesture.
        await page.mouse.move(190,400);await page.mouse.wheel(0,300);await page.waitForTimeout(100);
      }
      throw new Error('Navigation target did not become visible: '+locator);
    }
    async function settings(){
      // Flutter semantics can appear before the entry-route transition stops
      // absorbing pointer events. Confirm the drawer opened before scrolling.
      const drawerReady=page.getByRole('button',{name:'My Learning Path',exact:true});
      for(let attempt=0;attempt<3;attempt++){
        if(await drawerReady.isVisible())break;
        await page.getByRole('button',{name:'Open menu',exact:true}).click();
        try{await drawerReady.waitFor({state:'visible',timeout:2000});break;}
        catch(error){if(attempt===2)throw error;}
      }
      await settled(drawerReady);
      console.log('Drawer ready');
      await click(page.getByRole('button',{name:'App & progress',exact:true}));
      await page.getByRole('button',{name:'Local diagnostics',exact:true}).waitFor();
    }
    async function open(){
      await page.goto(site,{waitUntil:'domcontentloaded',timeout:90000});
      // On a warm reload the engine placeholder precedes the framework's
      // first frame. Enable semantics after the app is actually painting.
      await page.locator('canvas').first().waitFor({state:'visible',timeout:90000});
      await page.waitForSelector('flt-semantics-placeholder',{state:'attached',timeout:90000});
      await page.evaluate(()=>document.querySelector('flt-semantics-placeholder').click());
      await page.getByRole('button',{name:'Home Home',exact:true}).waitFor({timeout:90000});
      await dismiss();
      await settings();
    }
    console.log('Opening offline-origin app settings');
    await open();
    console.log('App settings opened');
    await click(page.getByRole('button',{name:'Local diagnostics',exact:true}));
    await page.getByRole('heading',{name:'Local diagnostics',exact:true}).waitFor();
    console.log('Diagnostics screen opened');
    const pending=page.waitForEvent('download');
    await click(page.getByRole('button',{name:'Save diagnostics file',exact:true}));
    const download=await pending;
    console.log('Diagnostics file downloaded');
    const file=await download.path();
    const document=JSON.parse(await fs.readFile(file,'utf8'));
    assert.equal(document.schema,1);
    const version=(await fs.readFile(path.resolve(__dirname,'../../pubspec.yaml'),'utf8')).match(/^version: ([^\r\n]+)$/m)[1].split('+');
    assert.equal(document.appVersion,version[0]);
    assert.equal(document.appBuild,version[1]);
    for(const entry of document.entries){
      assert.deepEqual(Object.keys(entry).sort(),['at','category','route','source']);
      assert.ok(['home','learn','profile','settings','diagnostics','other'].includes(entry.route));
    }
    await page.screenshot({path:'build/windows-diagnostics-phone.png'});
    await click(page.getByRole('switch',{name:/Keep local error history/}));
    await page.waitForTimeout(200);
    console.log('Checking disabled history after restart');
    await open();
    await click(page.getByRole('button',{name:'Local diagnostics',exact:true}));
    assert.equal(await page.getByRole('switch',{name:/Keep local error history/}).getAttribute('aria-checked'),'false');
    await page.getByRole('button',{name:'Back',exact:true}).click();
    await click(page.getByRole('button',{name:'Credits and device budget',exact:true}));
    await page.getByRole('heading',{name:'Rewards & devices',exact:true}).waitFor();
    assert.equal(await page.getByRole('button',{name:'Refresh account & devices',exact:true}).count(),0);
    await page.screenshot({path:'build/windows-economy-phone.png'});
    assert.deepEqual(errors,[]);
    console.log('PASS offline-origin phone settings, sanitized manual diagnostics download, disabled-history restart persistence and guest reward controls.');
  }catch(error){
    if(page){
      await page.screenshot({path:'build/windows-diagnostics-failure.png'}).catch(()=>{});
      const state=await page.locator('body').innerText().catch(()=>'Page unavailable');
      console.error('Diagnostics test failure state:',state.slice(0,8000),JSON.stringify(errors));
    }
    throw error;
  }finally{await browser.close();if(server){server.closeAllConnections();await new Promise(resolve=>server.close(resolve));}}
})().catch(error=>{console.error(error);process.exitCode=1});
