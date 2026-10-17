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
  try{
    const context=await browser.newContext({viewport:{width:390,height:844},acceptDownloads:true});
    await context.route('**/*',r=>new URL(r.request().url()).origin===new URL(site).origin?r.continue():r.abort());
    await context.addInitScript(()=>{
      for(const id of ['complete.v2','home.v1','learn.v1','profile.v1','progress.v1'])localStorage.setItem('flutter.norie.tutorial.'+id+'.complete','true');
    });
    const page=await context.newPage();page.setDefaultTimeout(30000);
    page.on('pageerror',e=>errors.push(e.message));
    async function dismiss(){const close=page.getByRole('button',{name:'Close',exact:true});if(await close.isVisible())await close.click();}
    async function click(locator){
      await dismiss();
      for(let i=0;i<20;i++){
        if(await locator.count()){const box=await locator.boundingBox();if(box&&box.y>60&&box.y+box.height<790){await locator.click();return;}}
        await page.mouse.move(190,600);await page.mouse.wheel(0,300);await page.waitForTimeout(100);
      }
      await locator.click();
    }
    async function settings(){
      await page.getByRole('button',{name:'Open menu',exact:true}).click();
      await click(page.getByRole('button',{name:'App & progress',exact:true}));
      await page.getByRole('button',{name:'Local diagnostics',exact:true}).waitFor();
    }
    async function open(){
      await page.goto(site,{waitUntil:'domcontentloaded',timeout:90000});
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
  }finally{await browser.close();if(server){server.closeAllConnections();await new Promise(resolve=>server.close(resolve));}}
})().catch(error=>{console.error(error);process.exitCode=1});
