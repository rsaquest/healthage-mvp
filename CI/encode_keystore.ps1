param(
  [string]$KeyPath = "android\key.jks",
  [switch]$Upload,
  [string]$KeyStorePassword = "",
  [string]$KeyAlias = "",
  [string]$KeyPassword = ""
)

if (-not (Test-Path $KeyPath)) {
  Write-Error "Keystore not found: $KeyPath"
  exit 1
}

$bytes = [IO.File]::ReadAllBytes((Resolve-Path $KeyPath))
$b64 = [Convert]::ToBase64String($bytes)
Write-Output $b64

if ($Upload) {
  if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "gh CLI not found. Install GitHub CLI to upload secrets."
    exit 1
  }
  gh secret set KEYSTORE_BASE64 --body $b64
  gh secret set KEYSTORE_PASSWORD --body $KeyStorePassword
  gh secret set KEY_ALIAS --body $KeyAlias
  gh secret set KEY_PASSWORD --body $KeyPassword
  Write-Output "Secrets uploaded to GitHub repository."
}
