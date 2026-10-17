const {chromium}=require('playwright');
const assert=require('node:assert/strict');
const fs=require('node:fs/promises');
const path=require('node:path');
const http=require('node:http');
let site=process.env.NORIE_TEST_SITE, server;
async function serve(){
 if(site)return;
 const root=path.resolve(__dirname,'../../build/web');
 const mime={'.js':'text/javascript','.mjs':'text/javascript','.json':'application/json','.wasm':'application/wasm','.html':'text/html','.css':'text/css','.svg':'image/svg+xml','.ttf':'font/ttf','.woff2':'font/woff2'};
 server=http.createServer(async(req,res)=>{
  try{
   let name=decodeURIComponent(new URL(req.url,'http://localhost').pathname).replace(/^\/NorieLearningApp/, '');
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
 async function open(){
  const context=await browser.newContext({viewport:{width:390,height:844},acceptDownloads:true});
  await context.route('**/*',r=>new URL(r.request().url()).origin===new URL(site).origin?r.continue():r.abort());
  await context.addInitScript(()=>{for(const id of ['complete.v2','home.v1','learn.v1','profile.v1','progress.v1'])localStorage.setItem('flutter.norie.tutorial.'+id+'.complete','true');});
  const page=await context.newPage();page.setDefaultTimeout(20000);page.setDefaultNavigationTimeout(90000);
  page.on('pageerror',e=>errors.push(e.message));
  await page.goto(site,{waitUntil:'domcontentloaded'});
  await page.waitForSelector('flt-semantics-placeholder',{state:'attached',timeout:90000});
  await page.evaluate(()=>document.querySelector('flt-semantics-placeholder').click());
  await page.getByRole('button',{name:'Learn Learn',exact:true}).click();
  return page;
 }
 async function dismiss(page){const close=page.getByRole('button',{name:'Close',exact:true});if(await close.isVisible())await close.click();}
 async function seek(page,l){await dismiss(page);for(let i=0;i<20;i++){if(await l.count()){const b=await l.boundingBox();if(b&&b.y>75&&b.y+b.height<760)return;}await page.mouse.move(190,600);await page.mouse.wheel(0,350);await page.waitForTimeout(100);}await l.waitFor();}
 async function click(page,l){await seek(page,l);await l.click();}
 async function classroom(page){await click(page,page.getByRole('progressbar',{name:/Classroom/}).first());await page.getByRole('heading',{name:'Offline Classroom',exact:true}).waitFor();}
 async function download(page,button,path){await seek(page,button);const pending=page.waitForEvent('download');await button.click();const file=await pending;await file.saveAs(path);return path;}
 async function upload(page,button,path){await seek(page,button);const pending=page.waitForEvent('filechooser');await button.click();await(await pending).setFiles(path);await page.waitForTimeout(500);}
 try{
  const teacher=await open();await classroom(teacher);
  await click(teacher,teacher.getByRole('button',{name:'Build assignment',exact:true}));
  const title=teacher.getByRole('textbox',{name:'Assignment title'});await title.click();await title.pressSequentially('Discovery practice');
  const note=teacher.getByRole('textbox',{name:'Teacher note'});await note.click();await note.pressSequentially('Look closely at the living things.');
  const topic=teacher.getByText(/Living & Nonliving Things/).first();await click(teacher,topic);
  const check=teacher.getByRole('checkbox',{name:'Which thing is living?',exact:true});for(let attempt=0;attempt<4&&!await check.isChecked();attempt++){await seek(teacher,check);await dismiss(teacher);const cb=await check.boundingBox();await teacher.mouse.click(cb.x+24,cb.y+cb.height/2);await teacher.waitForTimeout(200);}assert.equal(await check.isChecked(),true);
  await click(teacher,teacher.getByRole('button',{name:'Save assignment',exact:true}));
  await teacher.getByRole('heading',{name:'Offline Classroom',exact:true}).waitFor();
  const assignment=await download(teacher,teacher.getByRole('button',{name:'Export assignment',exact:true}),'build/qa-assignment.norieclass');
  const learner=await open();await classroom(learner);
  await upload(learner,learner.getByRole('button',{name:'Import assignment',exact:true}),assignment);
  await click(learner,learner.getByRole('button',{name:'Start practice',exact:true}));
  const alias=learner.getByRole('textbox',{name:'Classroom alias'});await alias.click();await alias.pressSequentially('Mina');
  const option=learner.getByRole('button',{name:'Dog',exact:true});await click(learner,option);
  await click(learner,learner.getByRole('button',{name:'Finish assignment',exact:true}));
  await learner.getByRole('heading',{name:'Classroom result',exact:true}).waitFor();
  const submission=await download(learner,learner.getByRole('button',{name:'Export submission',exact:true}),'build/qa-submission.noriesubmission');
  await upload(teacher,teacher.getByRole('button',{name:'Import submission',exact:true}),submission);
  await click(teacher,teacher.getByRole('button',{name:'Submissions and report',exact:true}));
  await teacher.getByRole('button',{name:'Export submission JSON',exact:true}).waitFor();
  const csv=await download(teacher,teacher.getByRole('button',{name:'Export CSV report',exact:true}),'build/qa-classroom-report.csv');
  assert.match(await fs.readFile(csv,'utf8'),/Mina/);
  await teacher.screenshot({path:'build/classroom-report-phone.png'});
  console.log('PASS actual teacher build/export, learner import/practice/export, teacher import/report CSV across isolated browser profiles.');
  const seasonal=await open();await click(seasonal,seasonal.getByRole('progressbar',{name:/Seasonal Learning/}).first());
  await seasonal.getByRole('heading',{name:'Seasonal learning',exact:true}).waitFor();
  await seek(seasonal,seasonal.getByRole('button',{name:/Open lesson: Living/}));
  await seasonal.screenshot({path:'build/seasonal-phone.png'});
  assert.deepEqual(errors,[]);
  console.log('PASS seasonal campaign reachable with external origins blocked; no page errors.');
 }catch(e){for(const c of browser.contexts())for(const p of c.pages()){console.error((await p.locator('body').innerText()).slice(-14000));await p.screenshot({path:'build/classroom-browser-failure.png',timeout:5000}).catch(()=>{});}throw e;}
 finally{await browser.close();if(server)await new Promise(resolve=>server.close(resolve));}
})().catch(e=>{console.error(e);if(server)server.close();process.exitCode=1;});
