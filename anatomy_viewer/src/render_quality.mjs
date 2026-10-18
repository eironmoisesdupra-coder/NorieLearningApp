const caps = new Map([['low', 1], ['balanced', 1.5], ['high', 2]]);

export function qualityPixelRatio(profile, deviceRatio) {
  if (!caps.has(profile)) throw Error('Invalid quality profile');
  const ratio = Number.isFinite(deviceRatio) ? deviceRatio : 1;
  return Math.max(.75, Math.min(ratio, caps.get(profile)));
}
