import assert from 'node:assert/strict';
import {test} from 'node:test';
import {publicationSha256,publicationMaxHistoryPins,verifyPublishedOfflineBundle} from '../supabase/functions/curriculum-publication/offline-verification.mjs';
const enc=new TextEncoder();
const keys=await crypto.subtle.generateKey('Ed25519',true,['sign','verify']);
const attacker=await crypto.subtle.generateKey('Ed25519',true,['sign','verify']);
const b64=bytes=>Buffer.from(bytes).toString('base64');
const now=1792400000;
const checkpoint={sequence:0,sha256:'0'.repeat(64)};
const options={trustedKeys:new Map([['test-key',keys.publicKey]]),checkpoint,clientVersion:1,now};
const question={id:'q1',prompt:'Which equals two?',options:['1+1','1+2'],correct_index:0,explanation:'Adding one to one gives two.'};
const topic={id:'science-one',subject:'science',grade_level:'g1',title:'Counting objects',
 lesson:{heading:'Count',introduction:'Count these objects.',sections:[{title:'Count',body:'One and one make two.'}]},
 quiz:{questions:[question]},challenge:{rounds:[question]}};
const revision={topic,metadata:{assets:[]}};
const manifest={format:'norie-published-offline',schema:1,sequence:1,previous_sha256:checkpoint.sha256,
 action:'publish',issued_at:now-10,expires_at:now+1000,minimum_client:1,maximum_client:1,
 entries:[{id:topic.id,revision:1,subject:'science',grade:'g1',sha256:''}],assets:[]};
async function bundle(m=structuredClone(manifest), r=[structuredClone(revision)], signer=keys.privateKey, assets=[]) {
 const sources=r.map(v=>enc.encode(JSON.stringify(v)));
 for(let i=0;i<sources.length;i++) m.entries[i].sha256=await publicationSha256(sources[i]);
 const bytes=enc.encode(JSON.stringify(m));
 return JSON.stringify({key_id:'test-key',manifest_base64:b64(bytes),
 signature_base64:b64(await crypto.subtle.sign('Ed25519',signer,bytes)),revisions:sources.map(b64),assets});
}
const good=await bundle(); const accepted=await verifyPublishedOfflineBundle(good,options);
assert.equal(accepted.checkpoint.sequence,1); assert.ok(Object.isFrozen(accepted.checkpoint));
await assert.rejects(verifyPublishedOfflineBundle(good,{...options,trustedKeys:new Map()}),/untrusted_signing_key/);
await assert.rejects(verifyPublishedOfflineBundle(await bundle(undefined,undefined,attacker.privateKey),options),/invalid_signature/);
const unsigned=JSON.parse(good); unsigned.signature_base64='';
await assert.rejects(verifyPublishedOfflineBundle(JSON.stringify(unsigned),options),/invalid_signature/);
const changed=JSON.parse(good); changed.revisions[0]=b64(enc.encode(JSON.stringify({...revision,metadata:{approved:true}})));
await assert.rejects(verifyPublishedOfflineBundle(JSON.stringify(changed),options),/revision_hash/);
const changedManifest=JSON.parse(good); changedManifest.manifest_base64=b64(enc.encode(JSON.stringify({...manifest,sequence:55})));
await assert.rejects(verifyPublishedOfflineBundle(JSON.stringify(changedManifest),options),/invalid_signature/);
await assert.rejects(verifyPublishedOfflineBundle(good,{...options,checkpoint:accepted.checkpoint}),/registry_replay_or_gap/);
for(const [field,value,error] of [['schema',2,/manifest_version/],['sequence',3,/registry_replay_or_gap/],
 ['previous_sha256','f'.repeat(64),/registry_replay_or_gap/],['expires_at',now,/registry_expired_or_future/],
 ['issued_at',now+1,/registry_expired_or_future/],['minimum_client',2,/incompatible_client/],['action','draft',/registry_action/]]) {
 const m=structuredClone(manifest); m[field]=value;
 await assert.rejects(verifyPublishedOfflineBundle(await bundle(m),options),error);
}
const wrong=structuredClone(revision); wrong.topic.quiz.questions[0].correct_index=5;
await assert.rejects(verifyPublishedOfflineBundle(await bundle(undefined,[wrong]),options),/answer_key/);
const privateIdentity=structuredClone(revision); privateIdentity.metadata.reviewer_id='private-human-id';
await assert.rejects(verifyPublishedOfflineBundle(await bundle(undefined,[privateIdentity]),options),/private_review_identity/);
const unsupported=structuredClone(manifest); unsupported.unrecognized='signed but unsupported';
await assert.rejects(verifyPublishedOfflineBundle(await bundle(unsupported),options),/schema_fields/);
const cycle=structuredClone(revision); cycle.topic.prerequisite_topic_id=topic.id;
await assert.rejects(verifyPublishedOfflineBundle(await bundle(undefined,[cycle]),options),/prerequisite_cycle/);
cycle.topic.prerequisite_topic_id='missing';
await assert.rejects(verifyPublishedOfflineBundle(await bundle(undefined,[cycle]),options),/missing_prerequisite/);
const duplicate=structuredClone(manifest); duplicate.entries.push({...duplicate.entries[0]});
await assert.rejects(verifyPublishedOfflineBundle(await bundle(duplicate,[revision,revision]),options),/revision_pin/);
const assetBytes=enc.encode('fixture offline diagram');
const licensed=structuredClone(revision); licensed.metadata.assets=[{path:'assets/diagram.png',license:'CC-BY-4.0',alt_text:'Two objects',sha256:await publicationSha256(assetBytes)}];
await assert.rejects(verifyPublishedOfflineBundle(await bundle(undefined,[licensed]),options),/missing_or_unlicensed_asset/);
const withAsset=structuredClone(manifest); withAsset.assets=[{...licensed.metadata.assets[0],bytes:assetBytes.length,sha256:await publicationSha256(assetBytes)}];
await verifyPublishedOfflineBundle(await bundle(withAsset,[licensed],keys.privateKey,[b64(assetBytes)]),options);
await assert.rejects(verifyPublishedOfflineBundle(await bundle(withAsset,[licensed],keys.privateKey,[b64(enc.encode('changed'))]),options),/asset_hash/);
const badPath=structuredClone(withAsset); badPath.assets[0].path='assets/../secret';
await assert.rejects(verifyPublishedOfflineBundle(await bundle(badPath,[licensed],keys.privateKey,[b64(assetBytes)]),options),/asset_metadata/);
const noLicense=structuredClone(withAsset); noLicense.assets[0].license='';
await assert.rejects(verifyPublishedOfflineBundle(await bundle(noLicense,[licensed],keys.privateKey,[b64(assetBytes)]),options),/asset_metadata/);
const tooLarge=JSON.parse(good); tooLarge.revisions[0]=b64(new Uint8Array(1024*1024+1));
await assert.rejects(verifyPublishedOfflineBundle(JSON.stringify(tooLarge),options),/invalid_base64|byte_budget/);
await assert.rejects(verifyPublishedOfflineBundle(' '.repeat(2*1024*1024+1),options),/byte_budget/);
await assert.rejects(verifyPublishedOfflineBundle('['.repeat(25)+'0'+']'.repeat(25),options),/depth_budget/);
const upgrade=structuredClone(manifest); upgrade.sequence=2; upgrade.previous_sha256=accepted.checkpoint.sha256; upgrade.entries[0].revision=2;
const upgraded=await verifyPublishedOfflineBundle(await bundle(upgrade),{...options,checkpoint:accepted.checkpoint});
const rollback=structuredClone(manifest); rollback.sequence=3; rollback.previous_sha256=upgraded.checkpoint.sha256; rollback.action='rollback';
const restored=await verifyPublishedOfflineBundle(await bundle(rollback),{...options,checkpoint:upgraded.checkpoint});
assert.equal(restored.checkpoint.sequence,3);
const downgrade=structuredClone(rollback); downgrade.action='publish';
await assert.rejects(verifyPublishedOfflineBundle(await bundle(downgrade),{...options,checkpoint:upgraded.checkpoint}),/unsigned_revision_downgrade/);
const unknown=structuredClone(rollback); unknown.entries[0].revision=3;
await assert.rejects(verifyPublishedOfflineBundle(await bundle(unknown),{...options,checkpoint:upgraded.checkpoint}),/unknown_rollback_revision/);
const retired=structuredClone(manifest); retired.sequence=4; retired.previous_sha256=restored.checkpoint.sha256;
retired.action='retire'; retired.entries=[];
const retirement=await verifyPublishedOfflineBundle(await bundle(retired,[]),{...options,checkpoint:restored.checkpoint});
assert.equal(JSON.parse(retirement.checkpoint.activeJson)['science-one'],undefined);
const implicit=structuredClone(retired); implicit.action='publish';
await assert.rejects(verifyPublishedOfflineBundle(await bundle(implicit,[]),{...options,checkpoint:restored.checkpoint}),/implicit_retirement/);
await assert.rejects(verifyPublishedOfflineBundle(good,{...options,checkpoint:restored.checkpoint}),/registry_replay_or_gap/);
console.log('Offline Ed25519 signatures, byte hashes, schema, budgets, assets, DAG, replay and signed rollback passed.');

test('approved source asset digest rejects a resigned replacement at the same path',async()=>{
 const approved=structuredClone(revision);
 const approvedBytes=enc.encode('approved offline diagram');
 const approvedAsset={path:'assets/diagram.png',license:'CC-BY-4.0',alt_text:'Two objects',
 sha256:await publicationSha256(approvedBytes)};
 approved.metadata.assets=[approvedAsset];
 const initial=structuredClone(manifest);
 initial.assets=[{...approvedAsset,bytes:approvedBytes.length}];
 const first=await verifyPublishedOfflineBundle(await bundle(initial,[approved],keys.privateKey,[b64(approvedBytes)]),options);
 const replacementBytes=enc.encode('different diagram with an incorrect lesson');
 const replacement=structuredClone(initial);
 replacement.sequence=2; replacement.previous_sha256=first.checkpoint.sha256;
 replacement.assets[0].sha256=await publicationSha256(replacementBytes);
 replacement.assets[0].bytes=replacementBytes.length;
 await assert.rejects(verifyPublishedOfflineBundle(
  await bundle(replacement,[approved],keys.privateKey,[b64(replacementBytes)]),
  {...options,checkpoint:first.checkpoint}),/approved_asset_hash/);
 const unpinned=structuredClone(approved); delete unpinned.metadata.assets[0].sha256;
 await assert.rejects(verifyPublishedOfflineBundle(
  await bundle(initial,[unpinned],keys.privateKey,[b64(approvedBytes)]),options),/approved_asset_hash/);
 const changedApproval=structuredClone(approved);
 changedApproval.metadata.assets[0].sha256=replacement.assets[0].sha256;
 await assert.rejects(verifyPublishedOfflineBundle(
  await bundle(replacement,[changedApproval],keys.privateKey,[b64(replacementBytes)]),
  {...options,checkpoint:first.checkpoint}),/immutable_revision_pin/);
});

test('every accepted checkpoint remains reusable beyond 128 historical revisions',async()=>{
 let previous=checkpoint;
 for(let number=1;number<=130;number++) {
  const next=structuredClone(manifest); next.sequence=number;
  next.previous_sha256=previous.sha256; next.entries[0].revision=number;
  const accepted=await verifyPublishedOfflineBundle(await bundle(next),{...options,checkpoint:previous});
  previous=JSON.parse(JSON.stringify(accepted.checkpoint));
 }
 assert.equal(previous.sequence,130);
 assert.equal(Object.keys(JSON.parse(previous.historyJson)).length,130);
});

test('history cap rejects overflow before acceptance while the last valid checkpoint remains reusable',async()=>{
 const initialPin=JSON.parse(accepted.checkpoint.activeJson)[topic.id];
 const history={};
 for(let number=1;number<publicationMaxHistoryPins;number++) {
  history[`${topic.id}@${number}`]={...initialPin,revision:number};
 }
 const lastPin=history[`${topic.id}@${publicationMaxHistoryPins-1}`];
 const seeded={sequence:publicationMaxHistoryPins-1,sha256:accepted.checkpoint.sha256,
  historyJson:JSON.stringify(history),activeJson:JSON.stringify({[topic.id]:lastPin})};
 const next=structuredClone(manifest); next.sequence=publicationMaxHistoryPins;
 next.previous_sha256=seeded.sha256; next.entries[0].revision=publicationMaxHistoryPins;
 const full=await verifyPublishedOfflineBundle(await bundle(next),{...options,checkpoint:seeded});
 assert.equal(Object.keys(JSON.parse(full.checkpoint.historyJson)).length,publicationMaxHistoryPins);
 // A snapshot retaining existing pins remains usable at the cap.
 const retained=structuredClone(next); retained.sequence++;
 retained.previous_sha256=full.checkpoint.sha256;
 const reused=await verifyPublishedOfflineBundle(await bundle(retained),
  {...options,checkpoint:JSON.parse(JSON.stringify(full.checkpoint))});
 const overflow=structuredClone(retained); overflow.sequence++;
 overflow.previous_sha256=reused.checkpoint.sha256; overflow.entries[0].revision++;
 const preserved=JSON.stringify(reused.checkpoint);
 await assert.rejects(verifyPublishedOfflineBundle(await bundle(overflow),
  {...options,checkpoint:reused.checkpoint}),/checkpoint_history_budget/);
 assert.equal(JSON.stringify(reused.checkpoint),preserved);
});
