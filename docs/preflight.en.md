# Before the Directions EMEA lab

Bring VS Code with **GitHub Copilot Chat** or **Claude Code**. This edition uses **ALDC 5**. Complete installation, initialization, symbols, BCQuality mounting and a baseline compile/test before the 105 minutes begin.

## Your copy

1. Create your repository from this template, clone it, and clone BCQuality next to it at `07e324ddbc42597c479e041e06a7833740e05d0f` (see [README](../README.en.md)).
2. Open `aldc-workshop-lab.code-workspace`. Copy `App/.vscode/launch.json.example` and `Test/.vscode/launch.json.example` to `launch.json` with your tenant and sandbox.
3. Download symbols, compile App then Test. Your sandbox must not have another extension using objects **71200–71349**.
4. Publish and run the tests: with the untouched starter exactly **C02, C03, C04, C11 and C12** fail.
5. Install APM and check `apm --version`.

## Selected distributions

| Track | Workshop source |
|---|---|
| Copilot Chat | Published ALDC VSIX 5.0.0 |
| Claude Code | Plugin manifest 5.0.1 at `f17eab0d8fb2ded3b5189b4db01ee441ee255ce8` (merged MCP fix, loaded from a pinned checkout) |
| BCQuality | External corpus at `07e324ddbc42597c479e041e06a7833740e05d0f` |

## GitHub Copilot

```powershell
code --install-extension javierarmestogonzalez.al-development-collection@5.0.0
code --list-extensions --show-versions
```

Open the repository root. Use **AL Collection: Open Project Manager**, inspect the changes and install the BC28-compatible toolkit profile. Reload the window. Check Architect, **AL Spec Agent**, Conductor and Developer Reviewer; `al-spec.create` routes to the Spec Agent. Run **AL Collection: Run Doctor** and `al-initialize` against the existing App/Test solution.

## Claude Code

Use a tools directory outside this repository:

```powershell
git clone https://github.com/javiarmesto/ALDC-AL-Development-Collection.git aldc-workshop-5.0.1
git -C aldc-workshop-5.0.1 checkout --detach f17eab0d8fb2ded3b5189b4db01ee441ee255ce8
$workshopAldc = (Resolve-Path aldc-workshop-5.0.1).Path
$workshopProject = (Resolve-Path 'C:/PATH/TO/aldc-workshop-lab').Path
node "$workshopAldc/claude-plugin/scripts/init.js" --project "$workshopProject"
node "$workshopAldc/claude-plugin/scripts/init.js" --project "$workshopProject" --apply
node "$workshopAldc/claude-plugin/scripts/init.js" --project "$workshopProject" --verify
Set-Location -LiteralPath $workshopProject
claude --plugin-dir "$workshopAldc/claude-plugin"
```

Inspect the preview before `--apply`. Run `/aldc:al-initialize` for the existing project and verify `/agents`, `/mcp` and `/aldc:al-spec-create`. If `aldc.yaml` is missing, copy `claude-plugin/aldc.yaml` to the repository root and set `toolkitRoot`, `solution.roots.application: App` and `solution.roots.test: Test`.

## BCQuality

Add to `aldc.yaml`:

```yaml
external:
  bcquality:
    mode: external-multiroot
    enabled: auto
    url: https://github.com/microsoft/BCQuality.git
    ref: main
    pinnedCommit: 07e324ddbc42597c479e041e06a7833740e05d0f
    home: ../bcquality
    entryPoint: skills/entry.md
    pilotSkills: []
```

Confirm the executing agent can read `../bcquality/skills/entry.md`. In Claude, give the host access to that folder.

## Tools

Confirm a real Customer symbol result, a Microsoft Learn result and a control test. A tool listed in the catalog is not proof it ran. Copilot plans default to `.github/plans`, Claude to `.claude/plans`; `aldc.yaml → plans.root` is authoritative.
