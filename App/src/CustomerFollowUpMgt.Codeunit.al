namespace OctoberWorkshops.FollowUp;
using Microsoft.Sales.Customer;

codeunit 71200 "OW Customer Follow-up Mgt."
{
    procedure GetReviewStatus(NextReviewDate: Date; AsOfDate: Date): Enum "OW Review Status"
    begin
        CheckRequiredDate(AsOfDate);
        CheckOptionalDate(NextReviewDate);
        // TODO (full day Lab 01 / Directions Lab 1): implement the four states in contract.md.
        exit("OW Review Status"::Unscheduled);
    end;

    procedure GetNextReviewDate(ReviewDate: Date): Date
    begin
        CheckRequiredDate(ReviewDate);
        exit(ReviewDate + 30);
    end;

    procedure MarkReviewed(var Customer: Record Customer; ReviewDate: Date)
    begin
        CheckRequiredDate(ReviewDate);
        // TODO (full day Lab 05 / Directions Lab 2): persist the review using the approved contract.
        Error('Workshop action pending implementation.');
    end;

    procedure CheckOptionalDate(Value: Date)
    begin
        if Value = 0D then
            exit;
        if Value <> NormalDate(Value) then
            Error(ClosingDateErr);
    end;

    local procedure CheckRequiredDate(Value: Date)
    begin
        if Value = 0D then
            Error(DateRequiredErr);
        CheckOptionalDate(Value);
    end;

    var
        DateRequiredErr: Label 'A nonblank reference date is required.';
        ClosingDateErr: Label 'Use a normal calendar date, not a closing date.';
}

