> Recovery copy from the approved rehearsal on 2026-09-25. “This session” and tool/source readings below refer to that historical session, not your current environment. See `evidence/checkpoint-source.md` for provenance, editorial corrections and setup requirements.

# customer-follow-up — Technical Specification

**Version:** 1 (initial, corrected)
**Complexity:** LOW
**Status:** Approved
**Approval:** human owner, 2026-09-25 — approved after two corrections: (1) `starter_expected` reframed as the pre-Lab 01 baseline, not a discrepancy or pending verification; (2) ALDC's general LOW routing separated from the workshop's Lab 05 Conductor path, with the routing tension flagged rather than resolved by Spec

> **Skills applied**: skill-events (consulted only to confirm TD-04's rejected alternative shape; no event is being specified)
> **BCQuality**: loaded · bcq@07e324d · 19 articles (0 house rules) · selection: manual

## 1. Overview

Business context: commercial users need to see a customer's review status on the Customer Card and record that a review took place, per `contract.es.md`. `GetReviewStatus(NextReviewDate, AsOfDate)` was completed in Lab 01 and is **preserved unchanged** — this spec documents its existing, already-implemented contract for completeness (it is exercised by C01–C06) but authorizes no change to its body. `MarkReviewed(var Customer: Record Customer; ReviewDate: Date)` is the only pending implementation: today it calls `CheckRequiredDate(ReviewDate)` and then unconditionally raises `Error('Workshop action pending implementation.')`.

Approved scope in: the `MarkReviewed` procedure body (persist last/next review date, +30 calendar days, preserve unrelated fields, idempotent repeat). Approved scope out (per contract and architecture): history, email notices, scheduled tasks, blocking rules, sales documents, and — per the architecture approval recorded 2026-09-25 — no `OnBeforeMarkReviewed`/`OnAfterMarkReviewed` integration events.

Architecture path: `.github/plans/customer-follow-up/customer-follow-up.architecture.md`, **Approved**, revision 1 (2026-09-25). This is a single-spec requirement (architecture Section 14): SPEC-01, output path `.github/plans/customer-follow-up/customer-follow-up.spec.md` (this file). No predecessor unit exists.

| Dependency type | Predecessor / contract consumed | Required revision / actual approval reference | Availability and effect |
| --- | --- | --- | --- |
| None | — | — | Single unit; nothing to wait on |

| Shared resource / contract | Owner / approved allocation | Consumers | Change or coordination issue |
| --- | --- | --- | --- |
| `codeunit 71200 "OW Customer Follow-up Mgt."` (existing, no new object IDs) | SPEC-01 (this unit) | `CustomerFollowUp.PageExt.al` (existing caller, unchanged), `Test/src/FollowUpTests.Codeunit.al` (existing caller, unchanged) | None — no other unit touches this codeunit |

### Governing sources

- `.github/instructions/al-guidelines.instructions.md` (`**/*.al`)
- `.github/instructions/al-naming-conventions.instructions.md` (`**/*.al`)
- `.github/instructions/al-error-handling.instructions.md` (`**/*.Codeunit.al`)
- `.github/instructions/al-events.instructions.md` (`**/*.Codeunit.al`)
- `.github/instructions/al-performance.instructions.md` (`**/*.Codeunit.al, **/*.Query.al`)
- `.github/instructions/al-testing.instructions.md` (`**/test/**/*.al`, matched by `Test/src/FollowUpTests.Codeunit.al`) — read for context only; this spec authorizes no test edits (rule 1: "Do not generate tests unless explicitly requested" — not requested here)
- `.github/skills/skill-events/SKILL.md`, Pattern 3 — read to confirm the thin-publisher shape that TD-04 explicitly rejects
- `App/src/CustomerFollowUpMgt.Codeunit.al`, `App/src/CustomerFollowUp.TableExt.al`, `App/src/CustomerFollowUp.PageExt.al`, `App/src/ReviewStatus.Enum.al`, `App/src/FollowUp.PermissionSet.al`, `Test/src/FollowUpTests.Codeunit.al`, `App/app.json` — direct source reads
- `contract.es.md`, `cases.csv` — requirement source and acceptance table
- `customer-follow-up.architecture.md` (Approved rev. 1) and `customer-follow-up.bcq-selection.json` — carried decisions and prior BCQuality selection
- AL MCP symbol check performed in this session: `al_packages` (load, path `App`) + `al_get_object_definition` (`Customer`, `Table`) resolved `Table 18 "Customer"` from Base Application — confirms the standard `Customer` table and its `No.`/`Name` fields exist as assumed; no other standard symbol needed verification for this scope

## 2. AL Object Inventory

| Project / app ID | Type | ID | Name | Repo-relative path | Extends / source | Purpose / decision |
| --- | --- | --- | --- | --- | --- | --- |
| App (`ec07de92-03fa-4cef-8fe7-62b970059c02`) | TableExtension | 71200 | "OW Customer Follow-up" | `App/src/CustomerFollowUp.TableExt.al` | Table 18 "Customer" (Base Application, verified via AL MCP) | Existing; unchanged. Adds `OW Last Review Date` / `OW Next Review Date` |
| App | Enum | 71200 | "OW Review Status" | `App/src/ReviewStatus.Enum.al` | n/a | Existing; unchanged. Closed 4-value set (`Extensible = false`) |
| App | Codeunit | 71200 | "OW Customer Follow-up Mgt." | `App/src/CustomerFollowUpMgt.Codeunit.al` | n/a | Existing; `MarkReviewed` body is the only pending gap (this spec) |
| App | PageExtension | 71200 | "OW Customer Follow-up Card" | `App/src/CustomerFollowUp.PageExt.al` | Page "Customer Card" | Existing; unchanged. Calls `MarkReviewed` and `GetReviewStatus` |
| App | PermissionSet | 71200 | "OW FOLLOWUP" | `App/src/FollowUp.PermissionSet.al` | n/a | Existing; unchanged. Grants codeunit execute only |
| Test (depends on App) | Codeunit | 71300 | "OW Follow-up Tests" | `Test/src/FollowUpTests.Codeunit.al` | n/a | Existing; **not modified by this spec**. C01–C12 defined here |

No new object IDs are requested; no collision check is needed.

## 3. Data Contracts

| Object / field | Type / relation | Classification | Validation / default | Observable error or outcome |
| --- | --- | --- | --- | --- |
| `Customer."OW Last Review Date"` (71200) | `Date`, no relation | `CustomerContent` (existing) | Read-only in UI; set only by `MarkReviewed`; no `OnValidate` | After `MarkReviewed(Customer, ReviewDate)`, equals `ReviewDate` exactly |
| `Customer."OW Next Review Date"` (71201) | `Date`, no relation | `CustomerContent` (existing) | Editable in UI; `OnValidate` calls `CheckOptionalDate` (allows `0D`, rejects closing dates); set by `MarkReviewed` via plain field assignment (not `Validate()`) | After `MarkReviewed(Customer, ReviewDate)`, equals `GetNextReviewDate(ReviewDate)` = `ReviewDate + 30` |
| `enum "OW Review Status"` (71200) | `Unscheduled` / `Overdue` / `DueToday` / `Scheduled`, `Extensible = false` | n/a | Computed only, never persisted on `Customer` | Returned by `GetReviewStatus`; recalculated on every page refresh/action, per contract |

No schema change, no migration, no upgrade codeunit: both fields already exist in the shipped `1.0.0.0` app (unreleased baseline — see BCQuality `microsoft/knowledge/upgrade/unreleased-schema-change-needs-no-upgrade-path.md`, consistent with architecture TD-01's breaking-change analysis).

## 4. Procedure Contracts

| Owning object / procedure | Inputs / types / var / temporary | Return / outputs | Preconditions | Side effects / errors | Consumers / acceptance |
| --- | --- | --- | --- | --- | --- |
| `codeunit "OW Customer Follow-up Mgt."`.`GetReviewStatus` | `NextReviewDate: Date`; `AsOfDate: Date` | `Enum "OW Review Status"` | none (validates internally) | Errors: `AsOfDate = 0D` → `DateRequiredErr`; either date is a closing date → `ClosingDateErr`. No persistence, no record access | Existing/unchanged — `CustomerFollowUp.PageExt.al` `UpdateReviewStatus`; tests C01–C06 |
| `codeunit "OW Customer Follow-up Mgt."`.`GetNextReviewDate` | `ReviewDate: Date` | `Date` = `ReviewDate + 30` (calendar days) | none (validates internally) | Errors: `ReviewDate = 0D` → `DateRequiredErr`; closing date → `ClosingDateErr` | Existing/unchanged — reused by `MarkReviewed`; tests C07–C10 |
| `codeunit "OW Customer Follow-up Mgt."`.`MarkReviewed` **(pending body — this spec's scope)** | `var Customer: Record Customer` (real or `temporary`, in/out); `ReviewDate: Date` | none (mutates `Customer` by `var`) | `ReviewDate` passes `CheckRequiredDate` (already called; unchanged) | Sets `Customer."OW Last Review Date" := ReviewDate`; sets `Customer."OW Next Review Date" := GetNextReviewDate(ReviewDate)` (reuse, no inline recomputation — architecture Risk R-01); persists with `Customer.Modify(true)` (architecture TD-02); no `Commit()` (TD-03); every other field of `Customer` is left untouched by construction (only these two fields are assigned); no chronological guard against an earlier `Last Review Date` (contract explicitly allows an earlier/anticipated review; architecture Risk R-02) | `CustomerFollowUp.PageExt.al` `OWMarkReviewed` action (existing caller, unchanged signature — TD-01); tests C11 (temporary buffer) and C12 (real record, reload) |
| `codeunit "OW Customer Follow-up Mgt."`.`CheckOptionalDate` | `Value: Date` | none | none | `Value = 0D` → no error (allowed blank); `Value <> NormalDate(Value)` → `ClosingDateErr` | Existing/unchanged — field `OnValidate` on `OW Next Review Date`; internally by `CheckRequiredDate` |
| `codeunit "OW Customer Follow-up Mgt."`.`CheckRequiredDate` (local) | `Value: Date` | none | none | `Value = 0D` → `DateRequiredErr`; otherwise delegates to `CheckOptionalDate` | Existing/unchanged — gate for `GetReviewStatus` (`AsOfDate`), `GetNextReviewDate`, `MarkReviewed` |

**Idempotent-repeat contract (C11)**: calling `MarkReviewed(Customer, SameReviewDate)` twice in succession with the same `ReviewDate` must leave `"OW Last Review Date"` and `"OW Next Review Date"` at the same values after the second call as after the first — this falls out of the body being a pure re-assignment (no delta/accumulation logic), not from an explicit equality guard. No special-case branch for "already reviewed on this date" is introduced or needed.

## 5. Event Contracts

Not applicable. No standard BC event is subscribed (no `EventSubscriber` in scope) and no new integration event is published — TD-04 resolved (architecture, Approved 2026-09-25) to add none. Section omitted beyond this statement per template guidance ("omit inapplicable areas with a brief reason").

## 6. UI, Permissions and API Contracts

**UI**: No change to `CustomerFollowUp.PageExt.al`. Existing flow, unchanged by this spec: `OWMarkReviewed` action calls `CurrPage.SaveRecord()`, then `ReviewMgt.MarkReviewed(Rec, WorkDate())`, then `UpdateReviewStatus()`, then `CurrPage.Update(false)`. `WorkDate()` is read at the UI edge only; `MarkReviewed` never reads the clock itself. `"OW Last Review Date"` stays `Editable = false`; `"OW Next Review Date"` stays editable with its own `OnValidate → UpdateReviewStatus`.

**Permissions**: No change to `permissionset 71200 "OW FOLLOWUP"` (grants `codeunit "OW Customer Follow-up Mgt." = X` only). `MarkReviewed` relies on the caller's own Customer-modify entitlement for the `Modify(true)` call to succeed — no `[InherentPermissions]`/`[InherentEntitlements]` attribute is added (architecture TD-05, unchanged).

**API**: Not applicable — Customer Card interaction only, no API page in scope.

## 7. Tests — Given / When / Then

All 12 cases are **existing** in `Test/src/FollowUpTests.Codeunit.al`; this spec documents their contract and expected outcome against the new `MarkReviewed` body. No test file is created or edited by this spec.

| Test | Acceptance / decision | Given | When | Then | Required compiler/runtime check and owner |
| --- | --- | --- | --- | --- | --- |
| C01 | `GetReviewStatus` unchanged | `NextReviewDate = 0D` | `GetReviewStatus(0D, 2026-10-15)` | Returns `Unscheduled` | Expected to pass post-Lab 01; no execution recorded yet in this spec — Implementer confirms by compiling and running |
| C02 | `GetReviewStatus` unchanged | `NextReviewDate = 2026-10-14` | `GetReviewStatus(2026-10-14, 2026-10-15)` | Returns `Overdue` | Expected to pass post-Lab 01 (per Section 1's contract, this procedure is already implemented); `cases.csv`'s `starter_expected = fail` documents the pre-Lab 01 starter baseline, not the current expectation, and is not itself an executed result. No execution recorded yet — Implementer confirms by compiling and running |
| C03 | `GetReviewStatus` unchanged | `NextReviewDate = 2026-10-15` | `GetReviewStatus(2026-10-15, 2026-10-15)` | Returns `DueToday` | Same post-Lab 01 expectation as C02 |
| C04 | `GetReviewStatus` unchanged | `NextReviewDate = 2026-10-16` | `GetReviewStatus(2026-10-16, 2026-10-15)` | Returns `Scheduled` | Same post-Lab 01 expectation as C02 |
| C05 | `CheckRequiredDate` on `AsOfDate` | both dates blank | `GetReviewStatus(0D, 0D)` | Errors with `DateRequiredErr` text | Expected to pass post-Lab 01; no execution recorded yet — Implementer confirms by compiling and running |
| C06 | `CheckOptionalDate` rejects closing dates | `NextReviewDate` = a closing date | `GetReviewStatus(ClosingDate, 2026-10-15)` | Errors with `ClosingDateErr` text | Expected to pass post-Lab 01; no execution recorded yet — Implementer confirms by compiling and running |
| C07 | `CheckRequiredDate` on `ReviewDate` | blank | `GetNextReviewDate(0D)` | Errors with `DateRequiredErr` text | Expected to pass post-Lab 01; no execution recorded yet — Implementer confirms by compiling and running |
| C08 | `GetNextReviewDate` +30 calendar days | `ReviewDate = 2026-10-15` | `GetNextReviewDate(2026-10-15)` | Returns `2026-11-14` | Expected to pass post-Lab 01; no execution recorded yet — Implementer confirms by compiling and running |
| C09 | Leap-year boundary | `ReviewDate = 2024-01-31` | `GetNextReviewDate(2024-01-31)` | Returns `2024-03-01` | Expected to pass post-Lab 01; no execution recorded yet — Implementer confirms by compiling and running |
| C10 | Year boundary | `ReviewDate = 2026-12-15` | `GetNextReviewDate(2026-12-15)` | Returns `2027-01-14` | Expected to pass post-Lab 01; no execution recorded yet — Implementer confirms by compiling and running |
| C11 | Idempotent repeat + field preservation on a `temporary` buffer | Temporary `Customer` (`No. = "OW-TEMP"`, `Name` set, `"OW Next Review Date" = 2026-12-31`) | `MarkReviewed(Customer, 2026-10-15)` called twice with the same date | After call 1: last = 2026-10-15, next = 2026-11-14. After call 2 (same `ReviewDate`): next stays 2026-11-14 (not recomputed forward again). `Name` unchanged throughout | Expected to remain pending until `MarkReviewed`'s body is implemented per Section 4; `cases.csv`'s `starter_expected = fail` documents that pre-Lab 01 starter state, consistent with this spec's own expectation — Implementer |
| C12 | Persistence on a real, reloaded `Customer` | New real `Customer` (synthetic `No.`, `Name` set), inserted | `MarkReviewed(Customer, 2026-10-15)`, then `.Get()` a fresh `Record Customer` by the same `No.` | Reloaded record shows last = 2026-10-15, next = 2026-11-14 | Expected to remain pending until `MarkReviewed`'s body is implemented per Section 4 (requires `Modify(true)`, not an in-memory-only assignment); `cases.csv`'s `starter_expected = fail` documents that same pre-Lab 01 starter state — Implementer |

## 8. Verification and Open Questions

| Claim / contract | Verified definition / observed behavior / pending | Source or actual result | Materiality | Missing check / owner |
| --- | --- | --- | --- | --- |
| `Table 18 "Customer"` exists with fields `No.` (Code[20]), `Name` (Text[100]) | Verified definition | AL MCP `al_get_object_definition` (`Customer`, `Table`), Base Application v29.0.54011.54125, this session | Non-blocking — confirms the underlying table `MarkReviewed`'s `var Customer` parameter targets | None — resolved |
| `GetReviewStatus`/`GetNextReviewDate` current bodies match the contract exactly as written | Verified definition (source read) | `App/src/CustomerFollowUpMgt.Codeunit.al` (read directly, quoted in Section 4) | Non-blocking for this spec (out of scope to change) | Compile/run C01–C10 to confirm the expected post-Lab 01 pass, distinct from `cases.csv`'s `starter_expected` column (which documents the pre-Lab 01 starter baseline, not an executed result) — Implementer, at compile time |
| `MarkReviewed`'s pending body, once written per Section 4, makes C11/C12 pass and does not regress C01–C10 | Pending — no code exists yet for the new body | `cases.csv` `starter_expected` column (declared expectation, not an executed result) | **Blocking for sign-off of the implementation phase**, not for this spec's approval | Compile + run all 12 tests after implementation — Implementer/reviewer |
| The demo user's existing Customer-edit role actually grants `Modify` at runtime (not just in the sandbox) | Pending (architecture Risk R-04, carried here) | `contract.es.md` "Aceptación y evidencia" — flags this as separate manual evidence | Non-blocking for spec/implementation; blocking for demo acceptance | Manual Customer Card walkthrough with the demo user — owner per contract, outside this spec's scope |

No material business decision is left open in this spec: TD-04 (integration events) was resolved by human approval at the architecture stage (2026-09-25, no events). Everything above is ordinary compiler/runtime verification owned by Implementer/Reviewer, not a business decision Spec is deferring.

## 9. Implementation Boundary

Fixed by architecture + this spec: exact signature of `MarkReviewed` (TD-01); reuse of `GetNextReviewDate` for the +30-day rule (no inline recomputation); `Modify(true)`, not `Modify(false)` (TD-02); no `Commit()` (TD-03); no chronological guard on `ReviewDate` versus the prior `Last Review Date`; no new `[InherentPermissions]` (TD-05); no integration events (TD-04, resolved).

Left to Implementer: the exact statement order and any local variable naming inside `MarkReviewed`'s body, provided the four assignments/calls above (`CheckRequiredDate` already present, two field assignments, one `Modify(true)`) are all present and the placeholder `Error(...)` is removed.

This is a LOW-complexity, single-procedure-body change with no identified HIGH transaction/concurrency/integration/performance risk — no additional state model or pseudocode is required beyond the narrative in Section 4.

## 10. AL-Go / CI Considerations

- **ID ranges**: no new object IDs requested; all five App objects (71200 family) and the Test codeunit (71300) already exist and are unchanged in range/allocation.
- **Target dependencies**: `App/app.json` — `application: 28.0.0.0` (verified by direct read); matches this spec's BCQuality selection target (`bcVersion: 28`). `Test/app.json` depends on `App` per AL-Go convention (per `al-testing.instructions.md` rule 2) — unchanged.
- **App/Test folders**: `App/src/` (implementation, this spec's only pending change target) and `Test/src/` (tests, read-only for this spec).
- **Analyzers / captions / XLF**: no new user-facing string is introduced by `MarkReviewed`'s pending body (no new `Label`, no new field caption) — existing `DateRequiredErr`/`ClosingDateErr` labels are reused unchanged, so no new XLF entry is expected.
- **Upgrade compatibility**: none needed — see Section 3 (unreleased baseline, both fields already shipped in `1.0.0.0`).
- **Downstream checks not run here**: no compile, no test execution, no code review was performed as part of writing this spec (mode constraint). These are the Implementer's/Reviewer's next steps (Section 12).

## 11. Acceptance Criteria

- **AC-01** (contract, architecture): Marking a review sets `"OW Last Review Date"` to the given `ReviewDate` and `"OW Next Review Date"` to `ReviewDate + 30` calendar days — validated by C08–C10 (helper) and C11/C12 (end-to-end via `MarkReviewed`).
- **AC-02**: Repeating the action with the same `ReviewDate` leaves both dates unchanged — validated by C11 (second `MarkReviewed` call).
- **AC-03**: The action persists to the real `Customer` record, survives a reload, and preserves all other fields (e.g. `Name`) — validated by C12 (persistence) and C11 (unrelated-field check on a temporary buffer).
- **AC-04**: No new permission is required beyond the user's existing Customer edit rights plus execute on the workshop codeunit — validated by inspection of `FollowUp.PermissionSet.al` (Section 6); demo-user walkthrough remains separate manual evidence (Section 8).
- **Negative / unchanged behavior**: `GetReviewStatus` and `GetNextReviewDate` are not touched by this spec; C01–C10 must continue to exercise exactly their current, already-implemented bodies (Section 4).

### Review criteria (BCQuality)

| Object | Knowledge path | What the reviewer checks | Layer |
|---|---|---|---|
| `codeunit 71200 "OW Customer Follow-up Mgt."` → `MarkReviewed` | `microsoft/knowledge/breaking-changes/do-not-change-published-procedure-signatures.md` | Signature (`var Customer: Record Customer; ReviewDate: Date`) is unchanged from the pre-existing stub | microsoft |
| `codeunit 71200 "OW Customer Follow-up Mgt."` → `MarkReviewed` | `microsoft/knowledge/breaking-changes/unreleased-symbol-change-is-not-a-breaking-change.md` | Confirms app.json `1.0.0.0`/no dependents context does not relax the in-repo Test/page constraint above | microsoft |
| `codeunit 71200 "OW Customer Follow-up Mgt."` → `MarkReviewed` | `microsoft/knowledge/performance/understand-implicit-transaction-boundary.md` | No explicit `Commit()` added after `Modify(true)` | microsoft |
| `permissionset 71200 "OW FOLLOWUP"` | `microsoft/knowledge/security/inherent-permissions-minimal-grant.md` | No `[InherentPermissions]`/`[InherentEntitlements]` added to `MarkReviewed` | microsoft |
| `permissionset 71200 "OW FOLLOWUP"` | `microsoft/knowledge/security/do-not-grant-rights-beyond-a-users-entitlement.md` | Permission set still grants only codeunit execute; no `TableData Customer` grant added | microsoft |
| `permissionset 71200 "OW FOLLOWUP"` | `microsoft/knowledge/appsource/permission-sets-cover-setup-and-usage-without-super.md` | Assignable permission set alone lets a non-SUPER user complete setup (none needed) and usage (the action) without `TableData Customer`, relying on the user's own role | microsoft |
| `codeunit 71200 "OW Customer Follow-up Mgt."` (no events published) | `microsoft/knowledge/events/publish-thin-onbefore-onafter-integration-events.md` | Confirms TD-04's rejected alternative was read, not silently ignored; no `OnBeforeMarkReviewed`/`OnAfterMarkReviewed` exists | microsoft |
| `tableextension 71200 "OW Customer Follow-up"` | `microsoft/knowledge/data-modeling/set-last-date-modified-in-onmodify-and-onrename.md` | `"OW Last Review Date"` is confirmed still set only by `MarkReviewed`, not wired into `OnModify`/`OnRename` | microsoft |
| `tableextension 71200 "OW Customer Follow-up"`, `Customer` (real record in C12) | `microsoft/knowledge/upgrade/unreleased-schema-change-needs-no-upgrade-path.md` | No upgrade codeunit added for the two already-shipped, unreleased fields | microsoft |
| `Test/src/FollowUpTests.Codeunit.al` (C11, `Customer: Record Customer temporary`) | `microsoft/knowledge/privacy/in-memory-data-not-a-privacy-concern.md` | Confirms the temporary Customer buffer in C11 raises no privacy finding | microsoft |
| `Test/src/FollowUpTests.Codeunit.al` (C11 variable naming) | `microsoft/knowledge/style/temporary-variable-temp-prefix.md` | Observational only (existing test file, not edited here): `Customer` in C11 is `temporary` but not `Temp`-prefixed | microsoft |
| `Test/src/FollowUpTests.Codeunit.al` (codeunit-level `TestPermissions = Disabled`) | `microsoft/knowledge/testing/permission-tests-must-lower-the-execution-context.md` | Observational only: confirms whether `Disabled` (SUPER context) versus `Restrictive` affects the AC-04 permission check's real coverage | microsoft |
| `Test/src/FollowUpTests.Codeunit.al` (C05–C07, `asserterror` + `AssertErrorText`) | `microsoft/knowledge/testing/asserterror-needs-expectederror-and-code.md` | Observational only: the custom `AssertErrorText` helper already pins the message text, partially covering this rule's intent without the `Assert.ExpectedError` API | microsoft |
| `Test/src/FollowUpTests.Codeunit.al` (C12, no `[TransactionModel]` declared) | `microsoft/knowledge/testing/transactionmodel-attribute-governs-test-transactions.md` | Confirms default `AutoRollback` is correct because neither `MarkReviewed` nor the test calls `Commit()` (TD-03) | microsoft |
| `App/src/CustomerFollowUpMgt.Codeunit.al` (`DateRequiredErr`, `ClosingDateErr`) | `microsoft/knowledge/style/labels-declared-at-object-scope.md` | Confirms object-scope `Label` declarations remain valid (no forced move to procedure scope) | microsoft |
| `App/src/CustomerFollowUpMgt.Codeunit.al` (existing `Error(DateRequiredErr)` / `Error(ClosingDateErr)` calls) | `microsoft/knowledge/style/error-passes-parameters-directly-not-strsubstno.md` | Confirms no `StrSubstNo` wrapping is introduced if `MarkReviewed`'s body needs an error call (it does not add a new one) | microsoft |
| `App/src/CustomerFollowUp.PageExt.al` (`"OW Next Review Date"` field, editable) | `microsoft/knowledge/ui/show-caption-on-editable-fields.md` | Confirms `ShowCaption` stays default/true on the editable next-review-date field (no change proposed) | microsoft |
| `App/src/CustomerFollowUp.PageExt.al` (`OWFollowUp` group fields) | `microsoft/knowledge/ui/fasttab-field-importance.md` | Observational: current fields have no explicit `Importance`; not a required change for this spec's scope | microsoft |
| all App/Test object names in scope (≤ 30 chars) | `microsoft/knowledge/style/object-name-30-char-limit.md` | Confirms `"OW Customer Follow-up Mgt."`, `"OW Customer Follow-up Card"`, `"OW Customer Follow-up"`, `"OW Review Status"`, `"OW FOLLOWUP"` all stay within the platform limit | microsoft |

Declared, not evaluated. Every path above was confirmed to exist under `../bcquality` (this session's directory listings of `microsoft/knowledge/{breaking-changes,security,appsource,events,data-modeling,upgrade,privacy,style,testing,ui,performance}`). The review phase reports these as met, unmet or not evaluated — this spec does not run BCQuality's review skill.

## 12. Human Review and Next Step

**Complete**: object inventory (no new objects), data contracts (no schema change), the full `MarkReviewed` procedure contract (inputs, persistence, idempotency, field preservation, no chronological guard), all 12 Given/When/Then test mappings, UI/permission contracts (unchanged), BCQuality review-criteria declaration (19 rows across breaking-changes, security, appsource, events, data-modeling, upgrade, privacy, style, testing, performance, ui domains — `customer-follow-up.bcq-criteria.json`).

**Unresolved material decisions**: none. TD-04 (the only open business/architecture decision) was resolved and approved at the architecture stage (2026-09-25); this spec carries that resolution forward (Sections 5, 9, 11) rather than reopening it.

**Pending, non-blocking-for-approval verification**: `cases.csv`'s `starter_expected` column documents the original starter's pre-Lab 01 baseline; it is not a currently-executed result and is not treated here as a discrepancy against this spec. This spec's own expectation, distinct from that column, is: C01–C10 pass after Lab 01 (source already implemented, per Section 4) and C11–C12 remain pending until `MarkReviewed`'s body is written (Section 4). No test has actually been executed as part of writing this spec — both the "expected to pass" and "expected to remain pending" statements in Section 7 are expectations, not observed results, and Implementer must record the actually-executed compiler/test outcome (Section 10) rather than assume it from either column. Separately, whether the demo user's real-tenant entitlement matches the sandbox assumption (Section 8, carried from architecture Risk R-04) also remains pending, unrelated to test execution.

**Affected changes since previous approval**: none — this is the spec's first revision, produced directly from the newly Approved architecture revision 1.

**Routing — ALDC general path versus this workshop's actual next step**: this requirement is classified **LOW**. ALDC's general complexity-based routing (`copilot-instructions.md`) would send a LOW requirement straight to `@AL Implementation Specialist` after spec approval, without a Conductor phase. This workshop's own path (`labs/jornada/05-incremento-implementado.md`, Lab 05) instead calls `@AL Development Conductor` directly for this LOW increment, asking it to "plan and delegate" implementation and review. **Flagging the incompatibility, not resolving it here**: my loaded mode instructions state the same LOW→Developer rule as the general routing ("MEDIUM/HIGH → Conductor; LOW → Developer... Do not implement or change Conductor's planning/approval policy"), and nothing in this spec's scope authorizes Spec to override that routing rule or to decide which agent starts next. The workshop's own routing choice is a human/lab-flow decision made outside this document (Lab 05's explicit instruction), not a technical requirement of the spec — it does not change any contract, object, or acceptance criterion above. This spec does not delegate to either agent and does not start implementation; the human proceeding to Lab 05 is choosing to invoke Conductor directly, which Conductor can still execute as a single-phase (LOW) plan.

**Approved** by the human owner on 2026-09-25, after the two corrections above. This approval covers this revision of `customer-follow-up.spec.md` only; it does not itself invoke Conductor or the Implementation Specialist — that remains the human's next explicit action (Lab 05).

