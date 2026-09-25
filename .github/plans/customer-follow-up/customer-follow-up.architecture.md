> Recovery copy from the approved rehearsal on 2026-09-25. “This session” and tool/source readings below refer to that historical session, not your current environment. See `evidence/checkpoint-source.md` for provenance, editorial corrections and setup requirements.

# Architecture: Customer Follow-up — Mark Reviewed

**Date**: 2026-09-25
**Revision**: 1 (initial)
**Complexity**: LOW
**Author**: al-architect
**Status**: Approved

> **Skills applied**: skill-events (integration-event publisher pattern, used to assess the rejected alternative in TD-04; no other domain skill needed for this increment)
> **BCQuality**: loaded · bcq@07e324d · 8 articles (0 house rules) · selection: manual

---

## 1. Executive Summary

`GetReviewStatus` was completed in Lab 01 and is not touched here. The only remaining gap is the body of `MarkReviewed(var Customer: Record Customer; ReviewDate: Date)` in `CustomerFollowUpMgt.Codeunit.al`, which today just raises a placeholder error. All supporting objects — the two Customer fields, the enum, the page extension, the permission set, and the date-validation/30-day helpers — already exist and match the contract. This document scopes the remaining work to that single procedure body, confirms no new object is required, and separates the fixed interface contract (already consumed by the page and by the 12 tests) from the implementation decisions resolved below.

## 2. Business Context

### Problem Statement

Commercial users need to record, from the Customer Card, that a review took place: capture the work date as the last review date and reschedule the next review 30 calendar days out, without touching any other Customer field or elevating permissions.

### Success Criteria

| ID | Criterion | Observable |
|----|-----------|------------|
| AC-01 | Marking a review sets `OW Last Review Date` to the given `ReviewDate` and `OW Next Review Date` to `ReviewDate + 30` calendar days | C08–C10 (via the shared `GetNextReviewDate` helper) and C11/C12 |
| AC-02 | Repeating the action with the same `ReviewDate` leaves both dates unchanged (idempotent) | C11 |
| AC-03 | The action persists to the real Customer record and survives a reload; all other fields (e.g. `Name`) are preserved | C12 (persistence), C11 (unrelated-field check) |
| AC-04 | The action requires no new permissions beyond the user's existing Customer edit rights plus execute on the workshop codeunit | Existing `FollowUp.PermissionSet.al`, unchanged |

## 3. Solution Architecture

No new pattern is introduced. `MarkReviewed` stays a plain procedure call from the page action — there is no document workflow, no posting routine, and (per scope) no history/notification/job-queue consumer that would justify an event-driven redesign. The procedure becomes a thin orchestrator over already-implemented helpers (`CheckRequiredDate`, `GetNextReviewDate`) plus one `Modify`.

```mermaid
flowchart TD
    A["Customer Card: OWMarkReviewed action"] -->|"WorkDate() at the UI edge"| B["MarkReviewed(var Customer, ReviewDate)"]
    B --> C["CheckRequiredDate(ReviewDate) — existing"]
    C --> D["Customer.\"OW Last Review Date\" := ReviewDate"]
    C --> E["Customer.\"OW Next Review Date\" := GetNextReviewDate(ReviewDate) — existing, +30 calendar days"]
    D --> F["Customer.Modify(true)"]
    E --> F
    F --> G[(Customer record: real or temporary)]
    A -->|"after action: UpdateReviewStatus()"| H["GetReviewStatus(NextReviewDate, WorkDate()) — existing, Lab 01"]
    H --> G
```

Only the `MarkReviewed` body (nodes C–F) is new work; everything else in the diagram already exists and is unchanged.

## 4. Data Model

No new tables, fields, or enums. All objects already exist in `App/src` and are reused as-is.

| Object | Type | Purpose | Notes |
|--------|------|---------|-------|
| `tableextension 71200 "OW Customer Follow-up"` extends Customer | Table Extension | Adds `OW Last Review Date` (read-only in UI) and `OW Next Review Date` (editable, validated) | Existing; `OnValidate` on the next-date field already calls `CheckOptionalDate` |
| `enum 71200 "OW Review Status"` | Enum | `Unscheduled` / `Overdue` / `DueToday` / `Scheduled` | Existing; `Extensible = false` per contract's closed 4-value set |
| `codeunit 71200 "OW Customer Follow-up Mgt."` | Codeunit | Status calculation, 30-day scheduling, review persistence | `MarkReviewed` body is the only pending piece |

## 5. Business Logic

| Procedure | Visibility | Responsibility | Status |
|-----------|-----------|----------------|--------|
| `GetReviewStatus(NextReviewDate: Date; AsOfDate: Date): Enum "OW Review Status"` | public | Pure status calculation from an explicit reference date | Done (Lab 01) — unchanged |
| `GetNextReviewDate(ReviewDate: Date): Date` | public | Returns `ReviewDate + 30` calendar days | Done (Lab 01) — reused by `MarkReviewed`, not reimplemented |
| `MarkReviewed(var Customer: Record Customer; ReviewDate: Date)` | public | Sets last/next review date on the given Customer (real or temporary) and persists | **Pending** — this is the scope of this increment |
| `CheckOptionalDate(Value: Date)` | public | Rejects closing dates; allows `0D` | Done — called by the table field's `OnValidate` and internally |
| `CheckRequiredDate(Value: Date)` | local | Rejects `0D` and closing dates | Done — already called at the top of the `MarkReviewed` stub |

`MarkReviewed`'s pending body, narratively (no AL here — see the future `.spec.md`):
1. Keep the existing `CheckRequiredDate(ReviewDate)` call (already present) as the single validation gate — do not duplicate closing-date/blank checks inline.
2. Assign `"OW Last Review Date" := ReviewDate`.
3. Assign `"OW Next Review Date" := GetNextReviewDate(ReviewDate)` — reuse the Lab 01 helper so the "+30 calendar days" rule has exactly one implementation (avoids C08–C10 and C11/C12 drifting apart).
4. Persist with `Customer.Modify(true)` (see TD-02) and remove the placeholder `Error('Workshop action pending implementation.')`.
5. Do not touch any other field — the `var Customer` in/out contract already guarantees the rest of the record is preserved, since the procedure only assigns the two review-date fields.

This must work identically whether `Customer` is the real table (C12, reload from DB) or a `temporary` buffer (C11) — nothing in the above depends on the record's temporary/permanent nature.

## 6. User Interface

No change. `CustomerFollowUp.PageExt.al` already: calls `CurrPage.SaveRecord()` before invoking `MarkReviewed(Rec, WorkDate())`, re-derives `ReviewStatus` via `UpdateReviewStatus()` afterward, and calls `CurrPage.Update(false)`. `WorkDate()` stays at the UI edge; the codeunit keeps receiving an explicit `Date` parameter, never reading the clock itself.

## 7. Integration Points

- **Inbound**: none. No standard BC event is subscribed.
- **Outbound**: none today. No `OnBeforeMarkReviewed`/`OnAfterMarkReviewed` integration events will be added — TD-04 is resolved below. Out of scope regardless: history, email notices, scheduled tasks, blocking rules, and sales documents (per the requirement's explicit exclusions).
- **API**: none; this is a Customer Card interaction only.

## 8. Security Model

Unchanged. `permissionset 71200 "OW FOLLOWUP"` grants only `codeunit "OW Customer Follow-up Mgt." = X`; it deliberately does not grant `TableData Customer`, relying on the user's existing Customer edit role (contract: "no eleva permisos"). No `[InherentPermissions]`/`[InherentEntitlements]` attribute is used or needed on `MarkReviewed` — see TD-05.

| Object | DataClassification | Permission |
|--------|-------------------|------------|
| `Customer."OW Last Review Date"` | CustomerContent (existing) | Modify via user's own Customer role |
| `Customer."OW Next Review Date"` | CustomerContent (existing) | Modify via user's own Customer role |
| `codeunit "OW Customer Follow-up Mgt."` | n/a | Execute via `OW FOLLOWUP` permission set |

## 9. Performance Considerations

Single-record scope: one `Get`-ed Customer, two field assignments, one `Modify`. No loop, no set-based operation, no FlowField, no table volume concern — the performance domain in BCQuality is essentially non-applicable here beyond one confirmation (TD-03): let the runtime's implicit transaction boundary close the write; do not add an explicit `Commit()` inside `MarkReviewed`.

## 10. Technical Decisions

### TD-01: Preserve the existing `MarkReviewed` signature exactly

- **Problem**: The procedure is already called, with this exact signature, by `CustomerFollowUp.PageExt.al` and by tests C11/C12. Any reshaping (adding a parameter, changing `var`, etc.) forces synchronized edits to files this increment is not allowed to touch (tests) or that are already correct (the page).
- **Decision**: Keep `MarkReviewed(var Customer: Record Customer; ReviewDate: Date)` unchanged; implement only the body.
- **Alternatives rejected**: Adding an overload with more parameters (e.g. a reason code) — no requirement calls for it, and it would be unused dead surface.
- **Rationale**: BCQuality `microsoft/knowledge/breaking-changes/do-not-change-published-procedure-signatures.md` — signature changes ripple to every caller. `microsoft/knowledge/breaking-changes/unreleased-symbol-change-is-not-a-breaking-change.md` adds nuance: `app.json` is `1.0.0.0` with no released baseline and no dependents (`dependencies: []`), so a signature change here would not be a *breaking change* in the strict cross-extension sense — but it would still break the in-repo Test app and the page, which the workshop rules explicitly forbid touching. The practical constraint is the same either way: don't change it.

### TD-02: Persist with `Customer.Modify(true)`, not `Modify(false)`

- **Problem**: Whether to run the Customer table's own `OnModify` trigger and standard field validation when persisting the two review-date fields.
- **Decision**: Use `Modify(true)`.
- **Alternatives rejected**: `Modify(false)` (skip triggers) — would silently bypass any base/extension logic hooked into Customer's `OnModify` (e.g. other extensions' subscribers, audit stamps), for no stated benefit.
- **Rationale**: Nothing in the contract asks to bypass standard table behavior, and skipping triggers is normally reserved for bulk/migration scenarios (BCQuality's upgrade domain), not an interactive single-record UI action. This also does not conflict with `data-modeling/set-last-date-modified-in-onmodify-and-onrename.md` (see excluded context below) since `OW Last Review Date` is not a generic audit field maintained by table triggers — it is set explicitly, once, by this procedure.

### TD-03: No explicit `Commit()` inside `MarkReviewed`

- **Problem**: Whether the procedure needs to force-persist before returning to the page.
- **Decision**: No explicit `Commit()`. The page action is the outermost execution boundary; the runtime commits automatically when it completes without error.
- **Alternatives rejected**: `Commit()` right after `Modify` — would only shorten the rollback window for no documented reason.
- **Rationale**: BCQuality `microsoft/knowledge/performance/understand-implicit-transaction-boundary.md` — "AL auto-commits when code execution completes"; explicit `Commit()` is for splitting a long batch into checkpoints, which does not apply to one record.

### TD-04 (RESOLVED): `MarkReviewed` will not publish `OnBeforeMarkReviewed`/`OnAfterMarkReviewed`

- **Problem**: The contract's base scope excludes history/notifications/job queues, but says nothing about whether the action should expose an extension point for a *future* consumer (e.g. a later lab or a partner extension reacting to a completed review).
- **Options considered**:
  - (a) No events now — smallest possible surface for a workshop increment; add later if a real consumer appears.
  - (b) Add a thin `OnBeforeMarkReviewed(var Customer; var ReviewDate; var IsHandled)` / `OnAfterMarkReviewed(Customer; ReviewDate)` pair now, following the standard thin-publisher shape.
- **Decision**: (a) — no `OnBeforeMarkReviewed`/`OnAfterMarkReviewed` events in this increment. Approved by the human owner on 2026-09-25 explicitly to close this open question without adding event surface.
- **Rationale**: No acceptance criterion or test (C01–C12) exercises an event, and adding unused public surface is scope creep the contract does not ask for.
- **Origin**: BCQuality `microsoft/knowledge/events/publish-thin-onbefore-onafter-integration-events.md` (thin-publisher shape, the option that was rejected) and `skill-events` (`.github/skills/skill-events/SKILL.md`, Pattern 3) — retained here only as the rejected-alternative reference, not as an instruction to implement it later.

### TD-05: No `[InherentPermissions]`/`[InherentEntitlements]` elevation on `MarkReviewed`

- **Problem**: Whether the procedure needs an inherent-permission attribute to modify Customer even when the caller's permission set does not otherwise allow it.
- **Decision**: None. The design deliberately relies on the caller already holding Customer modify rights through their own role; `OW FOLLOWUP` only grants codeunit execute (see Section 8).
- **Alternatives rejected**: `[InherentPermissions(PermissionObjectType::TableData, Database::Customer, 'M')]` on `MarkReviewed` — would let the action modify Customer even for a user who lacks that right elsewhere, contradicting the contract's "no eleva permisos".
- **Rationale**: BCQuality `microsoft/knowledge/security/inherent-permissions-minimal-grant.md` (confirms: if an elevation attribute were used, it would have to be scoped to exactly this operation — reinforcing why *not* using one here is the narrower, correct choice) and `microsoft/knowledge/security/do-not-grant-rights-beyond-a-users-entitlement.md` (the assumption "the user's normal role already grants Customer modify" should be validated against real tenant entitlements at demo time, not just in the sandbox — recorded as a risk in Section 12).

## 11. Implementation Phases

Single phase — this is a LOW-complexity, one-procedure-body change with no new objects.

### Phase 1 — Implement `MarkReviewed`

| ID | Object | Type |
|----|--------|------|
| P1-01 | `codeunit 71200 "OW Customer Follow-up Mgt."` → `MarkReviewed` | Existing procedure, pending body only |

**Prerequisite for**: none (last remaining gap for this requirement).
**Exit criterion**: C08–C12 pass against a real compile/test run (currently `starter_expected = fail` for C11/C12 per `cases.csv`); C01–C07 continue to pass unchanged.

## 12. Risks & Mitigations

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|-----------|--------|------------|
| R-01 | Implementation recomputes "+30 days" inline instead of calling `GetNextReviewDate`, letting the two rules drift apart over time | Medium | Medium | TD's Section 5 step 3 mandates reusing the existing helper; call this out explicitly in the spec |
| R-02 | An implementer adds an unrequested chronological guard ("reject ReviewDate earlier than the current Last Review Date"), breaking the contract's explicit allowance for an anticipated/earlier review | Medium | High (would fail a currently-passing-by-contract behavior, though no dedicated test covers an earlier-date repeat) | Spec must state explicitly: no chronological check in this scope |
| R-03 | `Customer."OW Next Review Date"` still carries `OnValidate → CheckOptionalDate`; direct field assignment (not `Validate()`) does not re-trigger it, but a future refactor that switches to `Validate()` would re-run closing-date validation unexpectedly for a value already computed as `ReviewDate + 30` (never a closing date) | Low | Low | Keep plain field assignment, as already implied by the existing stub; no `Validate()` call needed here |
| R-04 | Production entitlement tiers may not grant Customer modify to all intended users even though the sandbox does | Low | Medium | Contract already flags demo-user permission verification as separate acceptance evidence (see `contract.es.md`, Aceptación y evidencia); keep `OW FOLLOWUP` scoped to execute-only as designed |

## 13. Deployment Plan

### Pre-deploy

- [ ] Confirm no schema change is needed (fields/enum already shipped in the current `.app`)

### Post-deploy

- [ ] Compile and run C01–C12; confirm C11/C12 move from `fail` to pass without regressing C01–C10
- [ ] Manual Customer Card walkthrough with the demo user, per `contract.es.md`'s acceptance note

### Rollback

No data migration risk: the two fields and the enum already exist and are unaffected by this change. Reverting to the placeholder `Error(...)` body simply restores the current (pending) behavior; no upgrade codeunit is needed since no schema changes.

## 14. Spec Decomposition

**single-spec.** One cohesive, reviewable capability: the Customer Follow-up review workflow (status + mark-reviewed), matching the lab's own request to specify both `GetReviewStatus` and `MarkReviewed` together even though only the latter has pending code. There is no independent second capability to split off — history/notifications/job-queue/blocking/sales-document concerns are explicitly out of scope, not deferred sub-specs.

### Units and ownership

| Spec ID / name | Objective and acceptance | Scope in / out | Output .spec.md | Architecture decisions / proof obligations | Contracts provided / consumed |
| --- | --- | --- | --- | --- | --- |
| SPEC-01 / customer-follow-up | Document `GetReviewStatus` (already implemented, Lab 01) and `MarkReviewed` (pending) against C01–C12 | In: both procedures, the table extension fields, the page extension, the permission set. Out: history, email, scheduled tasks, blocking, sales documents | `.github/plans/customer-follow-up/customer-follow-up.spec.md` | TD-01 through TD-05 (TD-04 resolved: no integration events) | None consumed; this is the first (and only) unit for this requirement |

### Dependencies and stable shared contracts

None. Single unit, no predecessor.

### Shared resources and authoring groups

| Resource | Affected units | Owner / non-overlapping allocation | Coordination / unresolved conflict |
| --- | --- | --- | --- |
| `codeunit 71200 "OW Customer Follow-up Mgt."` (existing, no new IDs) | SPEC-01 | SPEC-01 only | None — no other unit touches this codeunit |

| Authoring group | Spec IDs | Required predecessor contracts | Parallel eligibility and reason / unresolved issue |
| --- | --- | --- | --- |
| G1 | SPEC-01 | None | N/A — single unit, nothing to parallelize |

### Joint consistency review and corrections

Not applicable — single-spec requirement, no sibling specs to cross-check.

---

## Sources consulted and access limitations

- **Read directly**: `contract.es.md`, `cases.csv`, `App/app.json`, `App/src/CustomerFollowUpMgt.Codeunit.al`, `App/src/CustomerFollowUp.TableExt.al`, `App/src/CustomerFollowUp.PageExt.al`, `App/src/ReviewStatus.Enum.al`, `App/src/FollowUp.PermissionSet.al`, `Test/src/FollowUpTests.Codeunit.al`, `.github/plans/memory.md`, `evidence/lab03-before-after.md`, `docs/agenda.md`, `labs/jornada/04-requisito-a-especificacion.md`.
- **BCQuality corpus**: mounted at `../bcquality` (`external.bcquality.home`), pinned commit `07e324ddbc42597c479e041e06a7833740e05d0f` matches the clone's actual `HEAD`. Two distinct layers, not to be conflated: **(1) local house rules** — `custom/knowledge/` contains only `.gitkeep`, so **0 house rules** exist in this fork today (an empty local layer, not a failed lookup or a skipped check); **(2) consulted platform knowledge** — the 8 selected `microsoft/knowledge/` articles listed with exact paths in Section 10 and in `customer-follow-up.bcq-selection.json`, read via directory listing (filenames as index) + frontmatter/Description/Best Practice/Anti Pattern. `knowledge-index.json` was not needed (candidates were unambiguous from filenames). No `community/knowledge/` article matched (that layer only has `agents/` and `appsource/`). All Section 10 citations trace to layer (2); layer (1) contributed nothing to review because it currently holds no content, not because it was excluded from consideration.
- **Excluded context** (read, considered, not applied):
  - `microsoft/knowledge/data-modeling/set-last-date-modified-in-onmodify-and-onrename.md` — describes a generic `Last Date Modified` audit field maintained by table triggers. `OW Last Review Date` is a business field set explicitly by `MarkReviewed`, not a trigger-maintained audit stamp; wiring it into `OnModify`/`OnRename` would set it to `Today()` on any unrelated Customer edit, which contradicts the contract (last review date changes only via the review action).
  - `microsoft/knowledge/interfaces/prefer-interface-over-case-branching.md` — considered for `GetReviewStatus`'s four mutually-exclusive date comparisons. Rejected: this is a fixed, closed 4-branch date comparison (`Extensible = false` on the enum by design), not an open variant set that benefits from interface dispatch; already implemented this way in Lab 01 and not being revisited here.
- **AL MCP symbol check (compiled dependency symbols)**: AL MCP tools were confirmed available in this session. `mcp_al-mcp-server_al_packages` (`action="load"`, `path="App"`) loaded the compiled packages from `App/.alpackages` (Application, Business Foundation, System Application, Base Application, System — 10,161 objects). `mcp_al-mcp-server_al_get_object_definition` (`objectName="Customer"`, `objectType="Table"`, `summaryMode=true`, `fieldLimit=10`) then resolved `Table 18 "Customer"` from `Sales/Customer/Customer.Table.al` (Base Application v29.0.54011.54125), confirming `DataClassification = CustomerContent`, `DrillDownPageID = Customer List`, `LookupPageID = Customer Lookup`, and fields `1 "No." (Code[20])` / `2 "Name" (Text[100])` / `3 "Search Name"`. This supersedes the earlier "not found available" limitation recorded for this session: a query of compiled dependency symbols against the standard `Customer` table is possible once `App`'s packages are loaded, and was performed as evidence before this document's approval. Object/procedure/signature facts specific to the workshop's own objects (`OW Customer Follow-up Mgt.`, table extension, enum, page extension, permission set) still come from direct source reads of `App/src/*.al` and `Test/src/*.al`, since those are workspace source files, not compiled dependency packages.
- No build, compile, test run, or symbol rename was performed or requested, per this mode's constraints. Package loading for the MCP symbol check above is a read-only indexing step, not a build.

## Approval Record

- **Approved by**: human owner (workshop), 2026-09-25.
- **Scope of approval**: this architecture as revised, including TD-04 resolved to "no `OnBefore`/`OnAfter` events" (see TD-04) and the AL MCP `Customer` symbol evidence above replacing the prior tooling-availability limitation.
- **Next step**: `@workspace use al-spec.create` to produce `customer-follow-up.spec.md` (SPEC-01, single-spec per Section 14). No code implementation has been done under this approval.

