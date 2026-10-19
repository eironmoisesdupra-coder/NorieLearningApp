// Offline protocol preparation. No HTTP handler, deployed signer, embedded key,
// or runtime installation path. Never accept a public key from the package.
const utf8 = new TextEncoder();
const decoder = new TextDecoder('utf-8', {fatal:true});
const hashPattern = /^[a-f0-9]{64}$/;
const idPattern = /^[A-Za-z0-9][A-Za-z0-9_.-]{0,199}$/;
const maxBytes = 2 * 1024 * 1024;
export const publicationMaxHistoryPins = 4096;
function requireValue(condition, message) { if (!condition) throw new Error(message); }
function fields(value, names) {
 requireValue(value && Object.getPrototypeOf(value) === Object.prototype &&
 Object.keys(value).length === names.length && names.every(k => Object.hasOwn(value,k)), 'schema_fields');
}
function integer(value) { return Number.isSafeInteger(value) && value >= 1; }
function text(value) { return typeof value === 'string' && value.trim().length > 0 && value.length <= 32768; }
function boundedJson(source, maxString=32768, maxFields=128) {
 requireValue(typeof source === 'string' && utf8.encode(source).length <= maxBytes, 'byte_budget');
 let depth=0, quoted=false, escape=false;
 for (const c of source) {
  if (quoted) { if (escape) escape=false; else if(c==='\\') escape=true; else if(c==='"') quoted=false; }
  else if(c==='"') quoted=true;
  else if(c==='{' || c==='[') requireValue(++depth<=24,'depth_budget');
  else if(c==='}' || c===']') depth--;
 }
 const result=JSON.parse(source);
 function visit(value) {
  if(typeof value==='string') requireValue(value.length<=maxString,'string_budget');
  if(Array.isArray(value)) { requireValue(value.length<=512,'array_budget'); value.forEach(visit); }
  else if(value && typeof value==='object') {
   requireValue(Object.keys(value).length<=maxFields,'field_budget');
   for (const [key,item] of Object.entries(value)) { visit(key); visit(item); }
  }
 }
 visit(result); return result;
}
function fromBase64(value, limit=maxBytes) {
 requireValue(typeof value==='string' && value.length<=Math.ceil(limit/3)*4 &&
 /^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/.test(value),'invalid_base64');
 const raw=atob(value); requireValue(raw.length<=limit,'byte_budget');
 const bytes=Uint8Array.from(raw,c=>c.charCodeAt(0));
 requireValue(btoa(raw)===value,'invalid_base64'); return bytes;
}
export async function publicationSha256(bytes) {
 return Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256',bytes)),x=>x.toString(16).padStart(2,'0')).join('');
}
function validPath(path) {
 return typeof path==='string' && /^assets\/[A-Za-z0-9_./-]+$/.test(path) &&
 !path.includes('..') && !path.includes('//') && !path.endsWith('/');
}
function validatePin(pin) {
 fields(pin,['id','revision','subject','grade','sha256']);
 requireValue(typeof pin.id==='string' && idPattern.test(pin.id) && integer(pin.revision) &&
 text(pin.subject) && text(pin.grade) && typeof pin.sha256==='string' && hashPattern.test(pin.sha256),'revision_pin');
}
function checkpointState(checkpoint) {
 const history=checkpoint.sequence===0 ? {} : boundedJson(checkpoint.historyJson,32768,publicationMaxHistoryPins);
 const active=checkpoint.sequence===0 ? {} : boundedJson(checkpoint.activeJson);
 requireValue(history && Object.getPrototypeOf(history)===Object.prototype &&
 active && Object.getPrototypeOf(active)===Object.prototype,'invalid_checkpoint');
 requireValue(Object.keys(history).length<=publicationMaxHistoryPins,'checkpoint_history_budget');
 for(const [key,pin] of Object.entries(history)) {
  validatePin(pin);
  requireValue(key===`${pin.id}@${pin.revision}`,'invalid_checkpoint_history');
 }
 for(const [id,pin] of Object.entries(active)) {
  validatePin(pin);
  const known=history[`${pin.id}@${pin.revision}`];
  requireValue(id===pin.id && known && known.sha256===pin.sha256 && known.subject===pin.subject &&
   known.grade===pin.grade,'invalid_checkpoint_active');
 }
 return {history,active};
}

/** Verify exact signed manifest bytes and all offline payload bytes.
 * trustedKeys and checkpoint MUST come from the application/operator trust root.
 * Caller must atomically persist the returned checkpoint with accepted assets.
 * This returns an immutable candidate, never installs lessons or grants approval.
 * A higher sequence can intentionally restore a known older revision only with
 * action=rollback; the signature covers both action and the complete registry.
 */
export async function verifyPublishedOfflineBundle(source, {trustedKeys, checkpoint, clientVersion, now, minimumSequence=1}) {
 const envelope=boundedJson(source,maxBytes);
 fields(envelope,['key_id','manifest_base64','signature_base64','revisions','assets']);
 requireValue(text(envelope.key_id),'key_id');
 const key=trustedKeys.get(envelope.key_id);
 requireValue(key && key.type==='public' && key.algorithm.name==='Ed25519','untrusted_signing_key');
 const manifestBytes=fromBase64(envelope.manifest_base64,128*1024);
 const signature=fromBase64(envelope.signature_base64,64);
 requireValue(signature.length===64 && await crypto.subtle.verify('Ed25519',key,signature,manifestBytes),'invalid_signature');
 const manifest=boundedJson(decoder.decode(manifestBytes));
 fields(manifest,['format','schema','sequence','previous_sha256','action','issued_at','expires_at',
 'minimum_client','maximum_client','entries','assets']);
 requireValue(manifest.format==='norie-published-offline' && manifest.schema===1,'manifest_version');
 requireValue(integer(manifest.sequence) && integer(minimumSequence) &&
 Number.isSafeInteger(clientVersion) && clientVersion>=1 && Number.isSafeInteger(now),'invalid_verification_context');
 requireValue(checkpoint && Number.isSafeInteger(checkpoint.sequence) && checkpoint.sequence>=0 &&
 hashPattern.test(checkpoint.sha256),'invalid_checkpoint');
 const {history,active}=checkpointState(checkpoint);
 requireValue(manifest.sequence>=minimumSequence && manifest.sequence===checkpoint.sequence+1 &&
 manifest.previous_sha256===checkpoint.sha256,'registry_replay_or_gap');
 requireValue(['publish','rollback','retire'].includes(manifest.action),'registry_action');
 requireValue(integer(manifest.issued_at) && integer(manifest.expires_at) &&
 manifest.issued_at<=now && manifest.expires_at>now &&
 manifest.expires_at-manifest.issued_at<=30*24*60*60,'registry_expired_or_future');
 requireValue(integer(manifest.minimum_client) && integer(manifest.maximum_client) &&
 clientVersion>=manifest.minimum_client && clientVersion<=manifest.maximum_client,'incompatible_client');
 requireValue(Array.isArray(manifest.entries) && manifest.entries.length<=128 &&
 Array.isArray(envelope.revisions) && envelope.revisions.length===manifest.entries.length &&
 Array.isArray(manifest.assets) && manifest.assets.length<=128 &&
 Array.isArray(envelope.assets) && envelope.assets.length===manifest.assets.length,'registry_count');
 const assetPaths=new Set();
 for(let i=0;i<manifest.assets.length;i++) {
  const asset=manifest.assets[i]; fields(asset,['path','sha256','bytes','license','alt_text']);
  requireValue(validPath(asset.path) && !assetPaths.has(asset.path) && text(asset.license) && text(asset.alt_text) &&
  integer(asset.bytes) && asset.bytes<=maxBytes && hashPattern.test(asset.sha256),'asset_metadata');
  const bytes=fromBase64(envelope.assets[i]);
  requireValue(bytes.length===asset.bytes && await publicationSha256(bytes)===asset.sha256,'asset_hash');
  assetPaths.add(asset.path);
 }
 const topics=new Map(); const questionOwners=new Map(); const nextActive=Object.create(null); let rollbackCount=0;
 for(let i=0;i<manifest.entries.length;i++) {
  const pin=manifest.entries[i]; validatePin(pin);
  requireValue(!topics.has(pin.id),'revision_pin');
  const previous=Object.hasOwn(active,pin.id) ? active[pin.id] : null; const historyKey=`${pin.id}@${pin.revision}`;
  const known=history[historyKey];
  requireValue(!known || (known.sha256===pin.sha256 && known.subject===pin.subject && known.grade===pin.grade),'immutable_revision_pin');
  if(previous) requireValue(previous.subject===pin.subject && previous.grade===pin.grade,'content_scope_conflict');
  if(manifest.action==='publish') {
   const maximum=Math.max(0,...Object.values(history).filter(p=>p.id===pin.id).map(p=>p.revision));
   requireValue(pin.revision>=maximum && (!previous || pin.revision>=previous.revision),'unsigned_revision_downgrade');
  } else if(manifest.action==='rollback') {
   requireValue(known && previous && pin.revision<=previous.revision,'unknown_rollback_revision');
   if(pin.revision<previous.revision) rollbackCount++;
  } else requireValue(previous && previous.revision===pin.revision && previous.sha256===pin.sha256,'retirement_changes_content');
  if(!known) requireValue(Object.keys(history).length<publicationMaxHistoryPins,'checkpoint_history_budget');
  nextActive[pin.id]=pin; history[historyKey]=pin;
  const bytes=fromBase64(envelope.revisions[i],1024*1024);
  requireValue(await publicationSha256(bytes)===pin.sha256,'revision_hash');
  const revision=boundedJson(decoder.decode(bytes)); fields(revision,['topic','metadata']);
  const topic=revision.topic, metadata=revision.metadata;
  requireValue(topic && topic.id===pin.id && topic.subject===pin.subject && topic.grade_level===pin.grade &&
  metadata && typeof metadata==='object' && !Array.isArray(metadata),'revision_schema');
  // Review identities and private evidence belong in backend tables. Public
  // license attribution remains permitted in the public-safe source metadata.
  requireValue(!['author','reviewer','author_id','reviewer_id','publisher_id','email','reviewer_scope','approval_evidence']
   .some(field=>Object.hasOwn(metadata,field)),'private_review_identity');
  requireValue(topic.lesson && text(topic.title) && text(topic.lesson.heading) &&
  text(topic.lesson.introduction) && Array.isArray(topic.lesson.sections) &&
  topic.lesson.sections.length>0 && topic.lesson.sections.length<=64,'lesson_schema');
  for(const [bankName,questionName] of [['quiz','questions'],['challenge','rounds']]) {
   const questions=topic[bankName]?.[questionName];
   requireValue(Array.isArray(questions) && questions.length>0 && questions.length<=128,'assessment_schema');
   const seen=new Set();
   for(const q of questions) {
    requireValue(q && text(q.id) && !seen.has(q.id) && text(q.prompt) && text(q.explanation) &&
    Array.isArray(q.options) && q.options.length>=2 && q.options.length<=16 &&
    q.options.every(text) && new Set(q.options).size===q.options.length &&
    Number.isSafeInteger(q.correct_index) && q.correct_index>=0 && q.correct_index<q.options.length,'answer_key');
    seen.add(q.id);
    const previousQuestion=questionOwners.get(q.id);
    requireValue(!previousQuestion || (previousQuestion.owner===pin.id && previousQuestion.source===JSON.stringify(q)),'duplicate_question');
    questionOwners.set(q.id,{owner:pin.id,source:JSON.stringify(q)});
   }
  }
  requireValue(Array.isArray(metadata.assets) && metadata.assets.length<=128,'asset_metadata');
  for(const asset of metadata.assets) {
   requireValue(asset && validPath(asset.path) && assetPaths.has(asset.path) &&
    manifest.assets.some(a=>a.path===asset.path && a.license===asset.license &&
    a.alt_text===asset.alt_text),'missing_or_unlicensed_asset');
   // The source digest approved by the reviewer must transitively bind every
   // referenced asset's bytes, not merely its path/license/accessibility label.
   requireValue(typeof asset.sha256==='string' && hashPattern.test(asset.sha256) &&
    manifest.assets.some(a=>a.path===asset.path && a.sha256===asset.sha256),'approved_asset_hash');
  }
  topics.set(pin.id,topic);
 }
 const visiting=new Set(), visited=new Set();
 function visit(id) {
  requireValue(!visiting.has(id),'prerequisite_cycle'); if(visited.has(id)) return;
  visiting.add(id); const prerequisite=topics.get(id).prerequisite_topic_id;
  if(prerequisite!=null) { requireValue(topics.has(prerequisite),'missing_prerequisite'); visit(prerequisite); }
  visiting.delete(id); visited.add(id);
 }
 for(const id of topics.keys()) visit(id);
 const removed=Object.keys(active).filter(id=>!Object.hasOwn(nextActive,id));
 if(manifest.action==='publish') requireValue(removed.length===0,'implicit_retirement');
 if(manifest.action==='rollback') requireValue(removed.length===0 && rollbackCount>0,'invalid_rollback');
 if(manifest.action==='retire') requireValue(removed.length>0,'invalid_retirement');
 const digest=await publicationSha256(manifestBytes);
 const nextCheckpoint={sequence:manifest.sequence,sha256:digest,
  historyJson:JSON.stringify(history),activeJson:JSON.stringify(nextActive)};
 // Never return a state that the next verification call cannot deserialize.
 // Histories are bounded independently from lesson objects and active pins.
 checkpointState(nextCheckpoint);
 // A serialized immutable snapshot avoids callers modifying verified objects.
 return Object.freeze({bundleJson:source,manifestJson:JSON.stringify(manifest), checkpoint:Object.freeze(nextCheckpoint)});
}
