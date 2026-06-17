# Run once after: gh auth login
$ErrorActionPreference = "Stop"
$env:Path = "C:\Program Files\GitHub CLI;" + $env:Path

Set-Location (Split-Path $PSScriptRoot -Parent)

gh auth status
if ($LASTEXITCODE -ne 0) {
  Write-Host "Run: gh auth login" -ForegroundColor Yellow
  exit 1
}

gh repo view walednajjar2-salam/launch-quality-mobile 2>$null
if ($LASTEXITCODE -ne 0) {
  gh repo create walednajjar2-salam/launch-quality-mobile --private --source=. --remote=origin --push --description "Launch Quality staff Flutter app (Jawdah Cloud Railway API)"
} else {
  git push -u origin main
}

Write-Host "Done: https://github.com/walednajjar2-salam/launch-quality-mobile" -ForegroundColor Green
