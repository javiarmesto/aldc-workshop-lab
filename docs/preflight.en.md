# Before the Directions EMEA lab

For VS Code Insiders, replace `code` with `code-insiders` throughout this guide and keep the same editor/profile. Copilot APM rehearsal used 0.23.1; record your own version and check command help before Lab 4.

Bring VS Code with **GitHub Copilot Chat** or **Claude Code**. This edition uses **ALDC 5**. Complete installation, initialization, symbols, BCQuality mounting and a baseline compile/test before the 105 minutes begin.

## Your copy

1. Create your repository from this template, clone it, and clone BCQuality next to it at `07e324ddbc42597c479e041e06a7833740e05d0f` (see [README](../README.en.md)).
2. Open `aldc-workshop-lab.code-workspace`. Copy `App/.vscode/launch.json.example` and `Test/.vscode/launch.json.example` to `launch.json` with your tenant and sandbox.
3. Download symbols and compile **App** first; publish it to your sandbox if Test needs the installed app as a dependency. Then download symbols and compile **Test**. Select the appropriate AL project for each operation. Your sandbox must not have another extension using objects **71200–71349**.
4. Follow [Running the tests](#running-the-tests): with the untouched starter exactly **C02, C03, C04, C11 and C12** fail.
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

After installing the extension, run **Developer: Reload Window**. Installing the extension and installing the project toolkit are separate steps. Use **AL Collection: Open Project Manager**, select **your repository root** (not App, Test or BCQuality), inspect the changes and install the BC28-compatible toolkit profile. The apps target BC28/runtime 16 even when the sandbox runs BC29.

`aldc.yaml` is not included in this participant template. After preparing the toolkit, check that it exists at the repository root and that `solution.roots.application: App` and `solution.roots.test: Test` are correct. If it is missing, check the installation destination and result before continuing.

Configure BCQuality as described below, reload the window and run **AL Collection: Run Doctor**. Check Architect, **AL Spec Agent**, Conductor and Developer Reviewer; `al-spec.create` routes to the Spec Agent. Run `al-initialize` with: “Initialize context for the existing project: application in App and tests in Test. Do not create another app or implement the TODOs.” Review the diff before committing preparation; exclude launch configurations, compiled packages, caches and credentials.

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


## Running the tests

The 12 tests are in codeunit **71300 "OW Follow-up Tests"**, in **Test**. They do not depend on Library Assert.

### Primary route · VS Code Test Explorer (BC28+)

1. Open the supplied workspace with **App** and **Test**, configured for your sandbox with symbols available.
2. Open **Testing**. The built-in AL Test Explorer discovers workspace tests and groups them by app and codeunit. Locate Test → 71300 → C01–C12.
3. Choose **Publish & Run** for the whole codeunit or selected cases. This publishes the test project and changed dependencies before execution. After edits, do not use **Run** until the changes have been published: that profile does not publish.
4. Inspect **Test Results**. Record the tested commit or diff, AL/BC versions, run profile, executed cases and **observed** results in `evidence/`.

This route does not execute tests under a TestRunner codeunit; installing the Microsoft Test Runner app is not a general prerequisite. See [Microsoft's documentation](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-test-explorer-vscode). Claude Code participants can use this VS Code route and provide its actual output.

If tests are missing, check that Test is part of the workspace, AL Language is active and project loading/compilation succeeds. For execution errors, record the diagnostic and check publishing, authentication, environment and compatibility; a missing runner is not the only possible cause.

### Alternative · Instructor-prepared runner

**AL Test Tool** requires the toolkit/runner that supplies the page and its dependencies in the sandbox. Confirm these with the instructor or administrator; they are separate from the integrated route above.

Publish **App**, then **Test**, using **AL: Publish without debugging** with the appropriate project selected. In the prepared environment, open **AL Test Tool** (130451), choose **Get Test Codeunits → Select Test Codeunits**, select 71300 and use **Run All**. If the page/actions are unavailable, record the versions and request runner preparation.

### Expected results

| Stage | Passing | Failing |
|---|---|---|
| Untouched starter | C01, C05, C06, C07, C08, C09, C10 | C02, C03, C04, C11, C12 |
| After full-day Lab 01, complete suite | C01–C10 | C11, C12 |
| After full-day Lab 05 / Directions Lab 2 | C01–C12 | None |

In the starter, C02–C04 report `Unscheduled` instead of the expected status; C11 and C12 report `Workshop action pending implementation.`. These are expectations, not evidence of an actual run.

C12 creates a synthetic customer and deletes it at the end; failure can prevent reaching that deletion. Keep test isolation enabled and verify cleanup with any alternative runner. `TestPermissions = Disabled`: these tests do not demonstrate user permissions. Do not run them in production.

## Tools

Confirm a real Customer symbol result, a Microsoft Learn result and a control test. A tool listed in the catalog is not proof it ran. Copilot plans default to `.github/plans`, Claude to `.claude/plans`; `aldc.yaml → plans.root` is authoritative.

