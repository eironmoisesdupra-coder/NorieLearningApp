param([string]$Root, [string]$Pfx, [string]$Version)
$ErrorActionPreference = 'Stop'
$app = @(Get-ChildItem -LiteralPath $Root -Recurse -Filter NorieLearning.exe)
if ($app.Count -ne 1 -or $app[0].VersionInfo.ProductVersion -ne $Version) {
  throw 'Tested Windows executable version does not match source'
}
$password = ConvertTo-SecureString $env:NORIE_WINDOWS_CERT_PASSWORD -AsPlainText -Force
$cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($Pfx, $password, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::EphemeralKeySet)
try {
  if (-not $cert.HasPrivateKey) { throw 'Certificate has no private key' }
  $expected = $env:NORIE_WINDOWS_CERT_SHA256.Replace(':', '').ToUpperInvariant()
  if ($cert.GetCertHashString([System.Security.Cryptography.HashAlgorithmName]::SHA256) -ne $expected) { throw 'Unexpected Windows signing certificate' }
  $uri = [Uri]$env:NORIE_WINDOWS_TIMESTAMP_URL
  if ($uri.Scheme -notin @('http', 'https')) { throw 'Invalid timestamp server URL' }
  Get-ChildItem -LiteralPath $Root -Recurse -File | Where-Object { $_.Extension.ToLowerInvariant() -in @('.exe','.dll','.node') } | ForEach-Object {
    $result = Set-AuthenticodeSignature -LiteralPath $_.FullName -Certificate $cert -HashAlgorithm SHA256 -TimestampServer $uri.AbsoluteUri
    if ($result.Status -ne 'Valid' -or -not $result.TimeStamperCertificate) { throw 'Signing or timestamp failed' }
  }
} finally { $cert.Dispose(); $password.Dispose() }
