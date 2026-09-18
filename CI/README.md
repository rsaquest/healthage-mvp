# CI instructions — build signing and secrets

This document explains how to provide the Android signing keystore to the GitHub Actions workflow and the secret names the workflow expects.

Secrets required (GitHub repository settings -> Secrets):

- `KEYSTORE_BASE64` — base64-encoded `key.jks` content
- `KEYSTORE_PASSWORD` — keystore store password
- `KEY_ALIAS` — key alias in the keystore
- `KEY_PASSWORD` — key password (often same as store password)

How to create `KEYSTORE_BASE64` locally

Windows (PowerShell):

```powershell
$b = [Convert]::ToBase64String([IO.File]::ReadAllBytes('android\\key.jks'))
Write-Output $b | clip
```

macOS / Linux:

```bash
base64 android/key.jks | pbcopy   # macOS
base64 android/key.jks            # linux - copy the output
```

Paste the base64 string into the `KEYSTORE_BASE64` secret value in GitHub.

How the workflow uses these secrets

- The workflow decodes `KEYSTORE_BASE64` to `android/key.jks` at runtime.
- It writes a `android/key.properties` file using `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, and `KEY_ALIAS`.

Notes & security

- Do NOT commit `key.jks` or `key.properties` to the repository. Keep them out of source control.
- If you prefer, use Google Play App Signing rather than storing the release key in CI.

Triggering the workflow

- Push to `main` or open a PR against `main` to trigger the workflow. Build artifacts are available on the Actions run page.

Optional: create the secrets with GitHub CLI

```bash
gh secret set KEYSTORE_BASE64 --body "$(base64 android/key.jks)"
gh secret set KEYSTORE_PASSWORD --body "your_store_password"
gh secret set KEY_ALIAS --body "your_key_alias"
gh secret set KEY_PASSWORD --body "your_key_password"
```

Helper scripts

Two helper scripts are included to simplify encoding and uploading the keystore:

- `CI/encode_keystore.sh` — POSIX shell script. Usage:

```bash
./CI/encode_keystore.sh android/key.jks            # prints base64 to stdout
./CI/encode_keystore.sh android/key.jks --upload storePass alias keyPass   # uploads secrets via gh
```

- `CI/encode_keystore.ps1` — PowerShell version. Usage:

```powershell
.\CI\encode_keystore.ps1 -KeyPath "android\key.jks"            # prints base64
.\CI\encode_keystore.ps1 -Upload -KeyStorePassword storePass -KeyAlias alias -KeyPassword keyPass
```

Remember: do not commit `key.jks` or `key.properties` to the repo. Use secrets.
