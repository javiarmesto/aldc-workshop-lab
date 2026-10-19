# Customer Review with History · frozen learning contract v1

A sales team wants to see when each customer needs a review and retain the reviews already completed.

1. Store Last Review Date and Next Review Date on Customer. A blank Next Review Date means Unscheduled.
2. Against an explicit normal reference date: past = Overdue, equal = DueToday, future = Scheduled. Reject a blank or closing reference date and a closing next date.
3. `MarkReviewed` takes a persisted customer and an explicit normal review date. The Customer Card action supplies the session WorkDate(). Temporary customers are outside this API.
4. Store that review date and schedule the next review exactly 30 calendar days later.
5. Insert history containing Customer No., Review Date and the resulting Next Review Date. Customer/date is unique.
6. Repeating an existing customer/date is a no-op: neither stored dates nor history changes. Check duplication BEFORE rejecting an older date. An older duplicate remains valid after a later review.
7. Reject a first-time date earlier than Last Review Date. Reject blank and closing review dates. Rejection changes no data.
8. Customer update and history insert are one transaction. No explicit Commit in application code. A failure must roll back both.
9. Customer Card shows read-only dates and calculated status, offers Mark as reviewed and opens read-only history filtered to that customer. Save the page before calling management; reload persisted Customer state in management.
10. Reopening Customer and history preserves the result. Unrelated persisted Customer fields remain unchanged.

## Fixed decisions
Namespace `Directions.FollowUp`; App objects 71200–71249; Test 71300–71349. Separate app IDs from Companial, but overlapping object ranges: use a clean sandbox or remove the earlier workshop apps after preserving any wanted data. Do not install both editions together.
BC application target 28.0, runtime 16.0. Symbols used for local verification: BC28.2. Do not raise the target only because your sandbox runs BC29.

## Scope boundary
No jobs, reminders, configurable intervals, APIs, posting, external systems, AI calls in BC or APM installation. Sequential user flow only; production concurrency, customer rename/deletion and retention need a separate design. Read-only UI is not an authorization boundary for privileged code. TestPermissions Disabled does not validate user permissions.

## Acceptance
A01–A13 cover statuses, dates, history, duplicate/older/invalid dates, rollback and unrelated fields. A11 has two automated cases. A14 is a manual UI check. A15/A16 add leap-year and year-boundary coverage. There are 16 functional automated methods plus a separate control test. Passing counts must come from the sandbox, not this catalogue.
