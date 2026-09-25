# ALDC Workshop Lab · Customer Follow-up

Practice repository for the workshops by **Roberto Corella and Javier Armesto** on agentic AL development with ALDC. It is a template: each participant creates their own copy and works in it during and after the session.

**Directions EMEA · Spec-Driven AL Development: A Hands-On Lab on Multi-Agent Workflows for Business Central.** 105 minutes, 72 of them hands-on. Tracks: GitHub Copilot Chat or Claude Code.

## Create your copy

1. Click **Use this template → Create a new repository** on GitHub.
2. Clone it and, **next to it** (not inside), clone BCQuality at the workshop revision:

```powershell
git clone https://github.com/<you>/<your-copy>.git aldc-workshop-lab
git clone https://github.com/microsoft/BCQuality.git bcquality
git -C bcquality checkout --detach 07e324ddbc42597c479e041e06a7833740e05d0f
```

3. Open `aldc-workshop-lab.code-workspace` and complete the [preflight](docs/preflight.en.md) **before** the lab.
4. Follow the [participant guide](labs/directions/README.md).

## Contents

| Path | Purpose |
|---|---|
| `App/`, `Test/` | AL starter: fields, Customer Card, helpers and 12 tests. Two TODOs in `App/src/CustomerFollowUpMgt.Codeunit.al`. |
| `contract.md`, `cases.csv` | Teaching contract and acceptance cases C01–C12. |
| `packages/october-workshop-primitives` | APM package for Lab 4. |
| `templates/evidence` | Evidence cards for design, checkpoints and runs. |
| `evidence/` | Where you keep architecture, specification, results and decisions. |

Object ranges: App 71200–71249, Test 71300–71349. BC 28.0+ (tested on BC online 29), runtime 16.0. With the untouched starter, exactly C02, C03, C04, C11 and C12 fail; your goal is 12 of 12. The reference solution is published after the workshop.


Stage recovery and commit instructions (Spanish): [checkpoints](docs/checkpoints.md).
