namespace Directions.FollowUp.Tests;
using Directions.FollowUp;
using Microsoft.Sales.Customer;
codeunit 71301 "DR Acceptance Tests"
{
    // [FEATURE] Customer review with persistent history
    Subtype = Test;
    TestPermissions = Disabled;
    RequiredTestIsolation = Function;

    [Test]
    // [SCENARIO] A blank next review date is unscheduled.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A01_Unscheduled()
    begin
        if Mgt.GetReviewStatus(0D, 20261015D) <> "DR Review Status"::Unscheduled then
            Error('Wrong review status.');
    end;

    [Test]
    // [SCENARIO] A past next date is overdue.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A02_Overdue()
    begin
        if Mgt.GetReviewStatus(20261014D, 20261015D) <> "DR Review Status"::Overdue then
            Error('Wrong review status.');
    end;

    [Test]
    // [SCENARIO] The reference date is due today.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A03_DueToday()
    begin
        if Mgt.GetReviewStatus(20261015D, 20261015D) <> "DR Review Status"::DueToday then
            Error('Wrong review status.');
    end;

    [Test]
    // [SCENARIO] A future next date is scheduled.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A04_Scheduled()
    begin
        if Mgt.GetReviewStatus(20261016D, 20261015D) <> "DR Review Status"::Scheduled then
            Error('Wrong review status.');
    end;

    [Test]
    // [SCENARIO] A review persists its date and schedules 30 calendar days.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A05_Dates()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Mgt.MarkReviewed(Customer, 20261015D);
        Customer.Get(Customer."No.");
        AssertDate(20261015D, Customer."DR Last Review Date");
        AssertDate(20261114D, Customer."DR Next Review Date");
    end;

    [Test]
    // [SCENARIO] The first review creates one matching history entry.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A06_History()
    var
        Customer: Record Customer;
        Entry: Record "DR Review Entry";
    begin
        CreateCustomer(Customer);
        Mgt.MarkReviewed(Customer, 20261015D);
        Entry.Get(Customer."No.", 20261015D);
        AssertDate(20261114D, Entry."Next Review Date");
        AssertCount(Customer."No.", 1);
    end;

    [Test]
    // [SCENARIO] Repeating the same date preserves dates and history count.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A07_RepeatIsNoOp()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Mgt.MarkReviewed(Customer, 20261015D);
        Mgt.MarkReviewed(Customer, 20261015D);
        AssertCount(Customer."No.", 1);
        Customer.Get(Customer."No.");
        AssertDate(20261015D, Customer."DR Last Review Date");
        AssertDate(20261114D, Customer."DR Next Review Date");
    end;

    [Test]
    // [SCENARIO] A later review adds history and advances both customer dates.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A08_LaterReview()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Mgt.MarkReviewed(Customer, 20261015D);
        Mgt.MarkReviewed(Customer, 20261020D);
        AssertCount(Customer."No.", 2);
        Customer.Get(Customer."No.");
        AssertDate(20261020D, Customer."DR Last Review Date");
        AssertDate(20261119D, Customer."DR Next Review Date");
    end;

    [Test]
    // [SCENARIO] An older duplicate remains a no-op after a later review.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A09_OlderDuplicate()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Mgt.MarkReviewed(Customer, 20261015D);
        Mgt.MarkReviewed(Customer, 20261020D);
        Mgt.MarkReviewed(Customer, 20261015D);
        AssertCount(Customer."No.", 2);
        Customer.Get(Customer."No.");
        AssertDate(20261020D, Customer."DR Last Review Date");
        AssertDate(20261119D, Customer."DR Next Review Date");
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoCommit)]
    // [SCENARIO] A new older date fails and preserves persisted state.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A10_OlderNewDateRejected()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Mgt.MarkReviewed(Customer, 20261015D);
        Commit(); // Fixture only. RequiredTestIsolation rolls it back after this test.
        asserterror Mgt.MarkReviewed(Customer, 20261014D);
        if StrPos(GetLastErrorText(), 'older') = 0 then
            Error('Expected the older-date validation error.');
        Customer.Get(Customer."No.");
        AssertDate(20261015D, Customer."DR Last Review Date");
        AssertDate(20261114D, Customer."DR Next Review Date");
        AssertCount(Customer."No.", 1);
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoCommit)]
    // [SCENARIO] A blank review date fails without writes.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A11_BlankRejected()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Commit();
        asserterror Mgt.MarkReviewed(Customer, 0D);
        if StrPos(GetLastErrorText(), 'required') = 0 then
            Error('Unexpected validation error.');
        Customer.Get(Customer."No.");
        AssertDate(0D, Customer."DR Last Review Date");
        AssertDate(0D, Customer."DR Next Review Date");
        AssertCount(Customer."No.", 0);
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoCommit)]
    // [SCENARIO] A closing review date fails without writes.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A11_ClosingRejected()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Commit();
        asserterror Mgt.MarkReviewed(Customer, ClosingDate(20261015D));
        if StrPos(GetLastErrorText(), 'normal calendar') = 0 then
            Error('Unexpected validation error.');
        Customer.Get(Customer."No.");
        AssertDate(0D, Customer."DR Last Review Date");
        AssertDate(0D, Customer."DR Next Review Date");
        AssertCount(Customer."No.", 0);
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoCommit)]
    // [SCENARIO] A history insertion failure rolls back the earlier customer modification.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A12_RollbackOnHistoryFailure()
    var
        Customer: Record Customer;
        Failure: Codeunit "DR Inject History Failure";
        Succeeded: Boolean;
        FailureText: Text;
    begin
        CreateCustomer(Customer);
        Commit(); // Starts a separate transaction for Boolean Codeunit.Run below.
        BindSubscription(Failure);
        ClearLastError();
        Succeeded := Codeunit.Run(Codeunit::"DR Review Worker", Customer);
        FailureText := GetLastErrorText();
        UnbindSubscription(Failure);
        if Succeeded then
            Error('The injected failure did not run.');
        if StrPos(FailureText, 'DR injected history failure') = 0 then
            Error('Unexpected failure: %1', FailureText);
        Customer.Get(Customer."No.");
        AssertDate(0D, Customer."DR Last Review Date");
        AssertDate(0D, Customer."DR Next Review Date");
        AssertCount(Customer."No.", 0);
    end;

    [Test]
    // [SCENARIO] Reviewing leaves persisted name and city unchanged.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A13_UnrelatedFields()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Mgt.MarkReviewed(Customer, 20261015D);
        Customer.Get(Customer."No.");
        if (Customer.Name <> 'Directions synthetic customer') or (Customer.City <> 'Sevilla') then
            Error('An unrelated customer field changed.');
    end;

    [Test]
    // [SCENARIO] Calendar-day arithmetic crosses February in a leap year.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A15_LeapYear()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Mgt.MarkReviewed(Customer, 20240131D);
        AssertDate(20240301D, Customer."DR Next Review Date");
    end;

    [Test]
    // [SCENARIO] Calendar-day arithmetic crosses the end of the year.
    // [GIVEN] Fixed dates and a synthetic isolated sandbox fixture where needed.
    // [WHEN] The review API is called with the inputs in this case.
    // [THEN] Assert the specified outcome and reread persisted state where applicable.
    procedure A16_YearBoundary()
    var
        Customer: Record Customer;
    begin
        CreateCustomer(Customer);
        Mgt.MarkReviewed(Customer, 20261215D);
        AssertDate(20270114D, Customer."DR Next Review Date");
    end;

    local procedure CreateCustomer(var Customer: Record Customer)
    begin
        Customer.Init();
        Customer."No." := CopyStr(DelChr(Format(CreateGuid()), '=', '{}-'), 1, 20);
        Customer.Name := 'Directions synthetic customer';
        Customer.City := 'Sevilla';
        Customer.Insert(false);
    end;
    local procedure AssertDate(Expected: Date; Actual: Date)
    begin
        if Expected <> Actual then
            Error('Expected date %1; actual %2.', Expected, Actual);
    end;
    local procedure AssertCount(CustomerNo: Code[20]; Expected: Integer)
    var
        Entry: Record "DR Review Entry";
    begin
        Entry.SetRange("Customer No.", CustomerNo);
        if Entry.Count() <> Expected then
            Error('Expected %1 history entries; actual %2.', Expected, Entry.Count());
    end;
    var
        Mgt: Codeunit "DR Review Mgt.";
}
