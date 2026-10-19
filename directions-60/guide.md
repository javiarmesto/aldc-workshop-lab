# Your 60-minute ALDC build

One feature. Keep the same local folder, contract and evidence from start to finish.

| Minute | Action | Output |
|---|---|---|
| 00–05 | Read contract and inspect scaffold | Starting ZIP edition and scope |
| 05–13 | Architect, then specification | Compact architecture/spec and test mapping |
| 13–17 | Review with a partner and approve | Named decision tied to spec revision |
| 17–40 | Conductor coordinates build and tests | Functional objects, actual results and diff |
| 40–50 | Review, repair and rerun affected checks | Findings or checks performed; remaining gaps |
| 50–57 | Publish and perform UI acceptance | Dates/history, reopen, decision |
| 57–60 | Handoff and closing | Evidence record and next action |

These are delivery budgets. A measured rehearsal is still required; a compilation duration is not a workshop timing result.

## 1 · Understand and specify
Open `contract.md` and `api-contract.md`. Use the installed ALDC Architect role:

> Analyse the Customer Review requirement and this scaffold. Inspect standard Customer symbols. Propose the smallest design covering dates, status, history, duplicates and rollback. Follow api-contract.md. Identify relevant BCQuality knowledge if available and cite what you actually read. Do not implement yet.

Then use the installed specification workflow:

> Turn the reviewed architecture and contract into one compact specification. Map the rules to A01–A16, keeping A14 manual. Make duplicate older dates, invalid dates and atomic updates explicit. Keep the supplied API. Do not claim runtime results.

Save both under `evidence/`. Review the 30-day rule, duplicate-before-older ordering, persisted Customer state and transaction boundary with your partner. Record approval against the exact spec revision.

## 2 · Build one feature

> Implement only the approved Customer Review feature using the installed ALDC conductor workflow. Use evidence/architecture.md, evidence/spec.md, contract.md and api-contract.md. Coordinate appropriate implementation and testing, then independent review. Activate the supplied tests once the interfaces exist. Return changed files, observed operations, results and gaps. Stop for a human decision if a business rule must change.

At a stable API, run `./tools/Enable-AcceptanceTests.ps1`. Compile App and Test, publish both to your sandbox and run the isolated test runner. Use actual tool names supported by your harness, not invented slash commands. Keep outputs; a manual VS Code operation is valid evidence when attributed correctly.

## 3 · Review and repair

> Review the actual diff against the approved contract. Check duplicate ordering, stale customer buffers, transaction rollback, customer-filtered history and unrelated fields. Give location, expected behavior and evidence for each finding. Separate source inspection from tests you actually executed. Request bounded repairs and rerun affected checks.

Do not manufacture a review finding. Record what was checked even when no issue was found.

## 4 · A14 manual acceptance
Use a synthetic sandbox customer and note its number. Save your current Work Date, then set it to 15 October 2026.

1. Open Customer Card. Blank next date shows Unscheduled. Click Mark as reviewed.
2. Expect Last=15 October 2026; Next=14 November 2026; status=Scheduled. History contains one matching row.
3. Click again. Expect one history row and unchanged dates. Close/reopen both pages and check persistence.
4. Set Work Date to 20 October 2026 and review again. Expect Last=20 October; Next=19 November; two rows.
5. Open a different customer and its history. The first customer's rows must not appear. Confirm history cannot be edited via this page.
6. Return Work Date to its original value. Record user permissions and any manual step not completed. Tests with disabled permissions do not prove participant access.

Record `accept`, `accept within verified scope`, or `return for repair` in evidence/acceptance.md. Include the exact published version and outstanding checks.

## Recovery
Save current changes and the error before switching copies. At minute 17 an instructor can supply a specification checkpoint; at minute 40 a compiled reference checkpoint can support review/UI work. These are prepared aids, not evidence that your own build passed. Use a separate folder; importing source does not publish it. Record what you skipped. Never silently reset participant work.
