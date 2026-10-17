param([Parameter(Mandatory=$true)][string]$Artifact)
$ErrorActionPreference = 'Stop'
$signature = Get-AuthenticodeSignature -LiteralPath $Artifact
$timestampValid = $null -ne $signature.TimeStamperCertificate
if ($timestampValid) {
  $chain = [System.Security.Cryptography.X509Certificates.X509Chain]::new()
  $chain.ChainPolicy.RevocationMode = [System.Security.Cryptography.X509Certificates.X509RevocationMode]::Online
  $timestampValid = $chain.Build($signature.TimeStamperCertificate)
  $chain.Dispose()
}
$fingerprint = ''
if ($signature.SignerCertificate) {
  $fingerprint = $signature.SignerCertificate.GetCertHashString([System.Security.Cryptography.HashAlgorithmName]::SHA256)
}
@{status=$signature.Status.ToString(); sha256=$fingerprint; timestamp_valid=$timestampValid} | ConvertTo-Json -Compress
