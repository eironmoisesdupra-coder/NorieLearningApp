const encoder = new TextEncoder();
export async function digest(value) {
  return Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256',encoder.encode(value))))
    .map(b => b.toString(16).padStart(2,'0')).join('');
}
// A dedicated secret can rotate independently. Without one, domain separation
// keeps the server's automatic service credential out of the signing messages.
// Never return this value or log the source credential.
export async function resolveNonceSecret(serviceKey,override) {
  if (override !== undefined && override !== '') {
    if (typeof override !== 'string' || override.length < 32) throw new Error('league_backend_not_configured');
    return override;
  }
  if (typeof serviceKey !== 'string' || serviceKey.length < 32) throw new Error('league_backend_not_configured');
  return digest(`norie-league-nonce:v1:${serviceKey}`);
}
export function nonceMessage(attempt) {
  return `${attempt.id}:${attempt.user_id}:${attempt.bank_version}:${Date.parse(attempt.expires_at)}`;
}
export async function signNonce(value,secret) {
  const key = await crypto.subtle.importKey('raw',encoder.encode(secret),{name:'HMAC',hash:'SHA-256'},false,['sign']);
  return Array.from(new Uint8Array(await crypto.subtle.sign('HMAC',key,encoder.encode(value))))
    .map(b => b.toString(16).padStart(2,'0')).join('');
}
export async function validNonce(nonce,value,secret) {
  if (typeof nonce !== 'string' || !/^[a-f0-9]{64}$/.test(nonce)) return false;
  const key = await crypto.subtle.importKey('raw',encoder.encode(secret),{name:'HMAC',hash:'SHA-256'},false,['verify']);
  const signature = new Uint8Array(nonce.match(/../g).map(byte => parseInt(byte,16)));
  return crypto.subtle.verify('HMAC',key,signature,encoder.encode(value));
}
