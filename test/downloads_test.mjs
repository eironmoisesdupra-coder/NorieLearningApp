import test from 'node:test';
import assert from 'node:assert/strict';
import { releaseDetails } from '../branding/web/downloads.mjs';
const repository = 'owner/repo';
const meta = { schema: 1, version: '0.5.0+8', tag: 'v0.5.0', revision: 'a'.repeat(40), assets: ['NorieLearning-Windows.zip','NorieLearning-Android.apk'].map(name=>({name,bytes:3,sha256:'b'.repeat(64)})) };
const fixture = () => ({tag_name:meta.tag, draft:false, prerelease:false, html_url:'https://github.com/owner/repo/releases/tag/v0.5.0', body:'<!-- norie-release-metadata -->\n```json\n'+JSON.stringify(meta)+'\n```', assets:meta.assets.map(asset=>({name:asset.name,size:3,browser_download_url:`https://github.com/owner/repo/releases/download/v0.5.0/${asset.name}`}))});
test('serves both exact version packages and checked metadata',()=>{
 const details=releaseDetails(fixture(),repository);
 assert.equal(details.revision,'a'.repeat(40));
 assert.equal(details.assets.length,2);
 assert.equal(details.assets[0].url,'https://github.com/owner/repo/releases/download/v0.5.0/NorieLearning-Windows.zip');
});
test('refuses incomplete releases, wrong package bytes and external links',()=>{
 for(const change of [r=>r.assets.pop(),r=>r.assets[0].size=9,r=>r.assets[0].browser_download_url='https://evil.example/download',r=>r.draft=true,r=>r.body='',r=>r.tag_name='v0.6.0']) {
  const release=fixture(); change(release); assert.throws(()=>releaseDetails(release,repository));
 }
});
