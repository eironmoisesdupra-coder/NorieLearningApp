$ErrorActionPreference = 'Stop'
$ollama = Join-Path $env:USERPROFILE '.codex\tools\ollama\ollama.exe'
if (-not (Test-Path $ollama)) {
  $ollama = (Get-Command ollama -ErrorAction Stop).Source
}
$env:OLLAMA_HOST = '127.0.0.1:11434'
$env:OLLAMA_NO_CLOUD = 'true'
$env:OLLAMA_NUM_PARALLEL = '1'
try {
  $null = Invoke-RestMethod 'http://127.0.0.1:11434/api/tags' -TimeoutSec 3
} catch {
  Start-Process -FilePath $ollama -ArgumentList 'serve' -WindowStyle Hidden
}
node (Join-Path $PSScriptRoot 'server.mjs')