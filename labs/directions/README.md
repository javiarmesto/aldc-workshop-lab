# Spec-Driven AL Development: A Hands-On Lab on Multi-Agent Workflows for Business Central

Coauthors and speakers: Roberto Corella and Javier Armesto. Directions EMEA, 105 minutes.

Build **Customer Follow-up** with VS Code and GitHub Copilot or Claude Code. The lab allocates 72 minutes to participant work. Complete the [preflight](../../docs/preflight.en.md) before attending.

## Your working folder

Open `aldc-workshop-lab.code-workspace` in your copy of this template. It contains App, Test, contract.md and cases.csv. Fields, Customer Card UI, helpers and tests are already supplied. Complete the two TODOs in CustomerFollowUpMgt.Codeunit.al: status selection and the persistent review action. The reference solution is not part of this repository.

## Business requirement

The sales team wants to know which customers need a review. Show the last and next review dates and the status on Customer Card. Mark as reviewed must record the session work date and schedule the next review in 30 calendar days.

Read the [contract](../../contract.md). Blank next date means Unscheduled, an earlier date means Overdue, the same date means DueToday and a later date means Scheduled. The UI supplies WorkDate. The status function receives an explicit date and does not modify data.

Example: reference 2026-10-15. Marking reviewed stores last 2026-10-15 and next 2026-11-14, counted from this review. Repeating the action that day keeps those dates. History and background notifications are outside this increment.

## Lab 1: specification

**00:15–00:30, 15 minutes.**

Ask the installed ALDC architect to identify scope, dependencies and design. Inspect Customer and Customer Card symbols. After approving the design, run `al-spec.create` in Copilot or `/aldc:al-spec-create` in Claude Code.

> Analyse Customer Follow-up against contract.md and the supplied scaffold. Identify the two TODOs, standard objects, interfaces and acceptance cases. Prepare a bounded architecture before implementation. After approval, use the specification workflow to define the increment. Keep the work-date, calendar-day and repeat-action decisions explicit. Read the mounted BCQuality corpus and inspect relevant symbols. Return a run card naming caller, executing role and objective, plus a compact table of actual reading, contextual selection and application to the design. Do not execute the review provider or implement AL yet.

The specification workflow routes to **AL Spec Agent**. Ask it to use the approved architecture and add the applicable BCQuality review criteria, with their actual source paths. Use the [design evidence card](../../templates/evidence/bcq-design-evidence.md) for both stages. A reading is recorded as loaded; review execution, compilation and tests need separate evidence. Read plans.root: .github/plans for the default Copilot track and .claude/plans for Claude. Keep one specification for this small increment.

Deliver architecture and specification with C01–C12 mapped to the relevant behavior. The existing helpers and UI are context; no need to redesign them.

## Human checkpoint

**00:30–00:35, 5 minutes.**

Review with a partner. Confirm blank/same-day behavior, which date starts the 30 days, repetition and persistence. Record approval or a specific correction against the specification version. Business decisions are settled in the supplied contract; if you change one, update scope and acceptance explicitly.

## Lab 2: implementation

**00:40–01:05, 25 minutes.**

Pass approved architecture/specification to the conductor. Observe planning, implementation and review responsibilities. Identify an instruction and a reusable skill actually used. A sequential workflow is sufficient for this small change.

> Implement the approved Customer Follow-up increment. Complete GetReviewStatus and MarkReviewed while preserving signatures, object ranges, supplied helpers and unrelated Customer fields. Use the installed ALDC workflow to delegate the required implementation and review. Compile and run the prepared acceptance tests. Return changed files, actual operations, results and pending checks.

Follow [Running the tests](../../docs/preflight.en.md#running-the-tests). Use **Publish & Run** after edits or the rehearsed execution route for your surface. The goal after Lab 2 is **12 of 12 passing tests**. In Claude, a participant may execute from VS Code and supply the real output. Record whether the tool or the participant ran the operation.

## Lab 3: review

**01:10–01:24, 14 minutes.**

Review the diff against contract.md. Reproduce an actionable finding, correct it if needed and repeat affected checks. If no finding appears, record what you checked and why it supports acceptance.

Prepared teaching example: treating the same day as Overdue instead of DueToday. C03 exposes that defect. It is a deliberately introduced variant, not a claim about the reference code.

Open Customer Card with work date 2026-10-15, run Mark as reviewed, inspect 2026-11-14, repeat the action and reopen the card. Record any browser or runtime check you could not perform. Relate the BCQuality review criteria declared in the spec to the observed review results. The corpus is prepared before class; unavailable evidence stays explicit. The full-day workshop has a dedicated practice.

| Review record | Your evidence |
|---|---|
| Specification and code revision | |
| Finding or check | |
| Expected and observed result | |
| Correction and repeated checks | |
| Browser action and persisted dates | |
| Human decision and pending work | |

Stop this block at 01:24 and preserve unfinished work so the final 21 minutes remain available.

## Lab 4: APM

**01:30–01:38, 8 minutes.** APM must already be installed.

From the root of your repository:

```sh
mkdir apm-consumer
cd apm-consumer
apm install ../packages/october-workshop-primitives --target copilot
apm install --frozen --target copilot
```

For Claude use `--target claude` in both commands. Inspect manifest, generated lockfile, installed instruction and review-al-evidence skill. Open the consumer and confirm discovery. The supplied package is version **1.1.0** and includes the follow-up date conventions. [APM install](https://microsoft.github.io/apm/reference/cli/install/).

## Retrospective

**01:38–01:43, 5 minutes.** Identify a useful handoff and one repeated instruction or wait that did not help. Choose a simpler workflow for an isolated future change. More agents do not automatically improve quality.

## If execution stops

Commit your work and the failed operation, ask the instructors for the next checkpoint and record what remains unverified. Compilation and BC execution must be recorded for your actual environment.

## What you keep

Your architecture/specification, reviewed increment, execution evidence, human decisions and APM consumer, all in your own repository. Keep evidence in [`evidence/`](../../evidence/README.md). See the [105-minute timeline](../../docs/agenda.md#directions-emea--105-minutes).
