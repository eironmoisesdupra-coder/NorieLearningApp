const {contextBridge,ipcRenderer}=require('electron');
const actions=new Set(['start','stop','poll','respond','request']);
contextBridge.exposeInMainWorld('norieClassroomLan',Object.freeze({
  invoke(action,dataJSON) {
    if(!actions.has(action) || typeof dataJSON!=='string' || dataJSON.length>12648448)return Promise.reject(Error('Invalid classroom request'));
    return ipcRenderer.invoke('norie-classroom-lan',action,dataJSON);
  },
}));
