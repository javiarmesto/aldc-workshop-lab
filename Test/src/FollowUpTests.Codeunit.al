namespace OctoberWorkshops.FollowUp.Tests;
using Microsoft.Sales.Customer;
using OctoberWorkshops.FollowUp;

codeunit 71300 "OW Follow-up Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    [Test]
    procedure C01_BlankDateIsUnscheduled()
    begin
        AssertStatus(0D, 20261015D, "OW Review Status"::Unscheduled);
    end;

    [Test]
    procedure C02_YesterdayIsOverdue()
    begin
        AssertStatus(20261014D, 20261015D, "OW Review Status"::Overdue);
    end;

    [Test]
    procedure C03_SameDateIsDueToday()
    begin
        AssertStatus(20261015D, 20261015D, "OW Review Status"::DueToday);
    end;

    [Test]
    procedure C04_TomorrowIsScheduled()
    begin
        AssertStatus(20261016D, 20261015D, "OW Review Status"::Scheduled);
    end;

    [Test]
    procedure C05_BlankReferenceDateIsRejected()
    begin
        asserterror ReviewMgt.GetReviewStatus(0D, 0D);
        AssertErrorText('A nonblank reference date is required.');
    end;

    [Test]
    procedure C06_ClosingDateIsRejected()
    begin
        asserterror ReviewMgt.GetReviewStatus(ClosingDate(20261015D), 20261015D);
        AssertErrorText('Use a normal calendar date, not a closing date.');
    end;

    [Test]
    procedure C07_BlankReviewDateIsRejected()
    begin
        asserterror ReviewMgt.GetNextReviewDate(0D);
        AssertErrorText('A nonblank reference date is required.');
    end;

    [Test]
    procedure C08_ThirtyCalendarDays()
    begin
        AssertDate(20261114D, ReviewMgt.GetNextReviewDate(20261015D));
    end;

    [Test]
    procedure C09_LeapYearBoundary()
    begin
        AssertDate(20240301D, ReviewMgt.GetNextReviewDate(20240131D));
    end;

    [Test]
    procedure C10_YearBoundary()
    begin
        AssertDate(20270114D, ReviewMgt.GetNextReviewDate(20261215D));
    end;

    [Test]
    procedure C11_RepeatReviewDoesNotMoveDateAgain()
    var
        Customer: Record Customer temporary;
    begin
        Customer."No." := 'OW-TEMP';
        Customer.Name := 'Workshop temporary customer';
        Customer."OW Next Review Date" := 20261231D;
        Customer.Insert(false);
        ReviewMgt.MarkReviewed(Customer, 20261015D);
        AssertDate(20261015D, Customer."OW Last Review Date");
        AssertDate(20261114D, Customer."OW Next Review Date");
        ReviewMgt.MarkReviewed(Customer, 20261015D);
        AssertDate(20261114D, Customer."OW Next Review Date");
        if Customer.Name <> 'Workshop temporary customer' then
            Error('The review action changed an unrelated customer field.');
    end;

    [Test]
    procedure C12_ReviewPersistsOnCustomer()
    var
        Customer: Record Customer;
        ReloadedCustomer: Record Customer;
    begin
        Customer."No." := CopyStr(DelChr(Format(CreateGuid()), '=', '{}-'), 1, MaxStrLen(Customer."No."));
        Customer.Name := 'Workshop synthetic customer';
        Customer.Insert(false);
        ReviewMgt.MarkReviewed(Customer, 20261015D);
        ReloadedCustomer.Get(Customer."No.");
        AssertDate(20261015D, ReloadedCustomer."OW Last Review Date");
        AssertDate(20261114D, ReloadedCustomer."OW Next Review Date");
        Customer.Delete(false);
    end;

    local procedure AssertStatus(NextDate: Date; ReferenceDate: Date; Expected: Enum "OW Review Status")
    var
        Actual: Enum "OW Review Status";
    begin
        Actual := ReviewMgt.GetReviewStatus(NextDate, ReferenceDate);
        if Actual <> Expected then
            Error('Expected status %1, got %2.', Expected, Actual);
    end;

    local procedure AssertDate(Expected: Date; Actual: Date)
    begin
        if Actual <> Expected then
            Error('Expected date %1, got %2.', Expected, Actual);
    end;

    local procedure AssertErrorText(Expected: Text)
    begin
        if GetLastErrorText() <> Expected then
            Error('Unexpected diagnostic: %1', GetLastErrorText());
    end;

    var
        ReviewMgt: Codeunit "OW Customer Follow-up Mgt.";
}
