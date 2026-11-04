export function releaseDetails(release, repository) {
  const match = release.body?.match(/<!-- norie-release-metadata -->\s*```json\s*([\s\S]*?)\s*```/);
  if (!match || release.draft || release.prerelease) throw new Error('No complete public release');
  const data = JSON.parse(match[1]);
  if (data.schema !== 1 || !/^\d+\.\d+\.\d+\+\d+$/.test(data.version)
      || data.tag !== release.tag_name || data.tag !== 'v' + data.version.split('+')[0]
      || !/^[a-f0-9]{40}$/.test(data.revision)) throw new Error('Invalid release metadata');
  const base = `https://github.com/${repository}/releases/download/${encodeURIComponent(data.tag)}/`;
  const assets = ['NorieLearning-Windows.zip', 'NorieLearning-Android.apk'].map(name => {
    const entry = data.assets.find(item => item.name === name);
    const asset = release.assets.find(item => item.name === name);
    if (!entry || !asset || !/^[a-f0-9]{64}$/.test(entry.sha256)
        || !Number.isSafeInteger(entry.bytes) || entry.bytes <= 0 || entry.bytes !== asset.size
        || asset.browser_download_url !== base + name) throw new Error('Incomplete or invalid release packages');
    return { ...entry, url: asset.browser_download_url };
  });
  return { version: data.version, revision: data.revision, assets };
}

async function showDownloads() {
  const repository = 'eironmoisesdupra-coder/NorieLearningApp';
  const status = document.getElementById('release-status');
  try {
    const response = await fetch(`https://api.github.com/repos/${repository}/releases/latest`, {
      headers: { Accept: 'application/vnd.github+json' }, signal: AbortSignal.timeout(12000), cache: 'no-store',
    });
    if (!response.ok) throw new Error('Release service unavailable');
    const details = releaseDetails(await response.json(), repository);
    status.textContent = `Version ${details.version} · Revision ${details.revision}`;
    for (const [index, asset] of details.assets.entries()) {
      const card = document.getElementById(index === 0 ? 'windows-package' : 'android-package');
      const link = document.createElement('a');
      link.className = 'button';
      link.href = asset.url;
      link.textContent = index === 0 ? 'Download Windows ZIP' : 'Download Android APK';
      const size = document.createElement('p');
      size.textContent = `${(asset.bytes / (1024 * 1024)).toFixed(1)} MB · ${details.version}`;
      const checksum = document.createElement('p');
      checksum.className = 'checksum';
      checksum.textContent = `SHA-256: ${asset.sha256}`;
      card.replaceChildren(link, size, checksum);
    }
  } catch {
    status.textContent = 'Download details are unavailable. A public release may not have been published yet, or the connection may be unavailable. Open GitHub releases below to check. No GitHub account is needed for published public packages.';
  }
}
if (typeof document !== 'undefined') showDownloads();
