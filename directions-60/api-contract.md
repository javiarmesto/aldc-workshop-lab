# Fixed interfaces for the supplied acceptance tests

Keep these names and signatures. Internal implementation remains your design decision.

| Object | ID | Required API |
|---|---|---|
| Enum `DR Review Status` | 71200 | Unscheduled=0, Overdue=1, DueToday=2, Scheduled=3 |
| Customer table extension | 71200 | field 71200 `DR Last Review Date`: Date; field 71201 `DR Next Review Date`: Date |
| Table `DR Review Entry` | 71201 | `Customer No.` Code[20], `Review Date` Date, `Next Review Date` Date; primary key Customer No., Review Date |
| Codeunit `DR Review Mgt.` | 71200 | `GetReviewStatus(NextDate: Date; ReferenceDate: Date): Enum "DR Review Status"` |
| Same codeunit | 71200 | `MarkReviewed(var Customer: Record Customer; ReviewDate: Date)` |
| Page `DR Review History` | 71201 | Read-only list of DR Review Entry |
| Customer Card extension | 71200 | Dates, status, Mark as reviewed, filtered history |
| Permission set `DR REVIEW` | 71200 | Customer read/modify, history read/insert and executable objects; evaluate with actual user permissions |

Application namespace: `Directions.FollowUp`. Tests use `Directions.FollowUp.Tests` and Microsoft.Sales.Customer.
The management operation rejects invalid review/reference dates with messages containing `required` (blank), `normal calendar` (closing) and `older` (new older review). These are explicit test interface requirements.

## Activate tests
After creating the types and signatures, run from the directions-60 folder:

```powershell
./tools/Enable-AcceptanceTests.ps1
```

Compile App first; publish it. Download symbols into Test (or provide the compiled App package in its cache), then compile/publish Test. Run `DR Test Runner` 71304 using your verified AL test route. It isolates each method. A12 uses a manually bound subscriber to inject an insertion failure and Boolean Codeunit.Run to observe transaction rollback. RequiredTestIsolation=Function protects synthetic fixtures, including explicitly committed test setup.

Test entry IDs: 71300 control, 71301 acceptance, 71302 failure injector, 71303 worker, 71304 runner. Do not run these test helpers as business functions. A14 remains manual.

If the API has only stubs, record an actual functional test failure before claiming test-first red/green. A missing object or compiler error is not that evidence.
