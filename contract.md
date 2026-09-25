# Customer Follow-up · teaching contract v1

Coauthors: Roberto Corella and Javier Armesto. Original workshop case.

## Business requirement

The sales team wants to know which customers need a review. Customer Card must show the last review date, an editable next review date, a calculated status and a Mark as reviewed action.

## Approved base scope

- Store OW Last Review Date and OW Next Review Date on Customer. Show the last date as read-only on the card. A blank next date is allowed.
- GetReviewStatus(NextReviewDate, AsOfDate) is a pure function. The UI passes the session WorkDate; tests pass explicit fixed dates. The function does not read Today/WorkDate or write data.
- Blank next date (0D): Unscheduled. Earlier than the reference: Overdue. Same date: DueToday. Later: Scheduled. The reference/review date must be nonblank. Accounting closing dates are excluded. Validation helpers are supplied.
- Calculate status on opening/refreshing the card, changing the next date and executing the action. Do not store the status.
- MarkReviewed(Customer, ReviewDate) sets last review to ReviewDate and next review to ReviewDate + 30 calendar days, counted from this review rather than the previous planned date. Calendar days are not business days or months.
- Early reviews are allowed. Repeating the action with the same review date leaves the same dates. An earlier session work date is recorded as explicitly supplied; chronological ordering against the last action is outside this teaching scope.
- Persist both dates and preserve unrelated Customer fields. Use the user's existing Customer edit permissions. Do not elevate permissions.
- History, email, background jobs, blocking rules and sales documents are outside the base increment.

## Acceptance example

Reference date: 2026-10-15. Blank next date is Unscheduled; 2026-10-14 is Overdue; 2026-10-15 is DueToday; 2026-10-16 is Scheduled. Marking reviewed on 2026-10-15 stores last 2026-10-15 and next 2026-11-14. Repeating that day keeps 2026-11-14.

## Supplied scaffold and participant task

The starter supplies the fields, enum, card extension, permission set, date-validation/30-day helpers and 12 AL tests. Complete two TODOs in CustomerFollowUpMgt.Codeunit.al: status selection and persistent Customer update. Preserve public signatures used by the card and tests.

cases.csv defines C01–C12. Expected starter failures: C02, C03, C04, C11 and C12. The reference should pass all 12. These are acceptance expectations, not observed runtime results. Browser behavior and user permissions also need manual checks. Compilation and sandbox execution must be recorded during rehearsal.

Technical references: [WorkDate](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/system/system-workdate-method), [AL Date](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/date/date-data-type). Business rules above are workshop design decisions.
