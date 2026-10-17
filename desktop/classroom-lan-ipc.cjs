const CHANNEL = 'norie-classroom-lan';
const ACTIONS = new Set(['start','stop','poll','respond','request']);
function isTrustedSender(event, contents) {
  try {return Boolean(contents && event.sender === contents && event.senderFrame === contents.mainFrame && event.senderFrame.url === 'norie://app/');} catch {return false;}
}
function installClassroomLanIpc(ipcMain, getContents, lan) {
  ipcMain.handle(CHANNEL, async(event,action,dataJSON)=>{
    if(!isTrustedSender(event,getContents()) || !ACTIONS.has(action) || typeof dataJSON!=='string' || Buffer.byteLength(dataJSON)>12*1024*1024+65536)throw Error('Classroom request denied');
    let data;try{data=JSON.parse(dataJSON);}catch{throw Error('Invalid classroom request');}
    try{return JSON.stringify(await lan.invoke(action,data));}catch{throw Error('Classroom request failed');}
  });
}
module.exports={CHANNEL,isTrustedSender,installClassroomLanIpc};
