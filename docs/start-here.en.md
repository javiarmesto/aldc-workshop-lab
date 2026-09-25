# Start here · Participant guide

[Castellano](start-here.md) · [Repository home](../README.en.md)

Work in your own **Customer Follow-up** repository. App, Test, contracts and lab materials are supplied. You do not need access to the instructors' private repository or reference solution. Complete setup before the session.

## Choose your track

- **Full-day workshop (Spanish):** GitHub Copilot Chat; [Spanish preflight](preflight.md), then [Lab 01](../labs/jornada/01-contrato-y-contexto.md).
- **Directions (English):** Copilot Chat or Claude Code, as offered by the instructors; [English preflight](preflight.en.md), then [Directions Lab 1](../labs/directions/README.md#lab-1-specification).

Arrange access to a BC sandbox and publishing permissions with the organizers. The Customer Card walkthrough also needs ordinary Customer editing permissions and OW FOLLOWUP. Different companies do not isolate app publication within one sandbox; agree who publishes or use separate environments.

## Create your own copy

1. Open [the template](https://github.com/javiarmesto/aldc-workshop-lab) and choose **Use this template → Create a new repository**.
2. Select your account and repository name. Leave **Include all branches** unchecked; start from the default branch. Checkpoint branches are for later recovery.
3. Your copy may stay private. Work in your copy, not the instructor template.
4. Copy your new repository's HTTPS URL from Code. Use normal Git authentication; do not put a token in the URL.

Template copies have independent history: pulling your origin does not import future template updates. Follow the instructor's instructions for a specific correction rather than replacing your remote.

## Clone and open (Windows / PowerShell)

Replace the URL. These commands refuse existing destinations. If a later step fails, keep the successful clone and resume only the failed step.

```powershell
$root = 'C:\Workshops'
$lab = Join-Path $root 'my-workshop'
$bcquality = Join-Path $root 'bcquality'
$repoUrl = 'https://github.com/YOUR-USER/YOUR-REPO.git'
if ($repoUrl -match 'YOUR-USER|YOUR-REPO') { throw 'Set the URL of your own repository.' }
if (Test-Path -LiteralPath $lab) { throw "Already exists: $lab" }
if (Test-Path -LiteralPath $bcquality) { throw "Check the existing checkout: $bcquality" }
New-Item -ItemType Directory -Path $root -Force | Out-Null
git clone $repoUrl $lab
if ($LASTEXITCODE -ne 0) { throw 'Repository clone failed.' }
git clone https://github.com/microsoft/BCQuality.git $bcquality
if ($LASTEXITCODE -ne 0) { throw 'BCQuality clone failed; keep your workshop copy.' }
git -C $bcquality checkout --detach 07e324ddbc42597c479e041e06a7833740e05d0f
if ($LASTEXITCODE -ne 0) { throw 'BCQuality checkout failed.' }
git -C $bcquality rev-parse HEAD
Set-Location -LiteralPath $lab
git remote -v
code-insiders .\aldc-workshop-lab.code-workspace
# Stable VS Code instead: code .\aldc-workshop-lab.code-workspace
```

If the editor command is not in PATH, use **File → Open Workspace from File**. Keep the lab terminal at the repository root, not inside App/Test or BCQuality. BCQuality is a sibling directory. The plugin and APM consumer are prepared later, when their lab asks for them.

## Complete setup and record it

Follow [preflight.en.md](preflight.en.md). Configure your own tenant/sandbox in both launch.json files. Install the selected ALDC distribution and project toolkit, download symbols, compile and publish the correct projects. Missing aldc.yaml immediately after cloning is normal: the toolkit preparation supplies it.

Use [the preflight evidence card](../templates/evidence/preflight.md) as `evidence/preflight.md`. Before starting, confirm:

- The workspace includes root, App, Test and BCQuality.
- The agent reads your contract and can access its actual tools.
- ALDC configuration points to App/Test and the external BCQuality checkout.
- App/Test compile and use the same sandbox; App has been published.
- Customer symbol and Microsoft Learn queries return actual results.
- You recorded a real starter test run and installed tool versions; APM responds to `apm --version`.

The starter deliberately passes **7/12** and fails **C02, C03, C04, C11, C12**. Other failures need diagnosis. The target after Directions Lab 2 is 12/12. `starter_expected` remains the original baseline and must not change as you progress.

## During and after the workshop

Use [the four-lab Directions guide](../labs/directions/README.md). The Test-Lab01…08 helpers are numbered for the Spanish full-day workshop; do not equate them with Directions lab numbers.

Save your code, specification, decisions and observed results in your own repository. [Evidence index](../evidence/README.md). If blocked, preserve your work and consult [Help](help.md). Checkpoints are opened in a different folder; switching folders does not change the App deployed in BC. The supplied full-day approved-spec checkpoint already includes GetReviewStatus and is not an untouched Directions starting point.

Deliver a handoff another person can reproduce. Separate results you executed from supplied reports, static inspection and remaining uncertainty. Acceptance belongs to the receiving person, not the agent.
