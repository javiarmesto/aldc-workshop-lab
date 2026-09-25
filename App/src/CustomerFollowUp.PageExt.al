namespace OctoberWorkshops.FollowUp;
using Microsoft.Sales.Customer;

pageextension 71200 "OW Customer Follow-up Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            group(OWFollowUp)
            {
                Caption = 'Customer follow-up';
                field(OWLastReviewDate; Rec."OW Last Review Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(OWNextReviewDate; Rec."OW Next Review Date")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        UpdateReviewStatus();
                    end;
                }
                field(OWReviewStatus; ReviewStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Review status';
                    ToolTip = 'Shows the review status relative to the current session work date.';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(OWMarkReviewed)
            {
                ApplicationArea = All;
                Caption = 'Mark as reviewed';
                ToolTip = 'Records the work date and schedules the next review in 30 calendar days.';
                Image = Approve;
                trigger OnAction()
                begin
                    CurrPage.SaveRecord();
                    ReviewMgt.MarkReviewed(Rec, WorkDate());
                    UpdateReviewStatus();
                    CurrPage.Update(false);
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        UpdateReviewStatus();
    end;

    local procedure UpdateReviewStatus()
    begin
        ReviewStatus := ReviewMgt.GetReviewStatus(Rec."OW Next Review Date", WorkDate());
    end;

    var
        ReviewMgt: Codeunit "OW Customer Follow-up Mgt.";
        ReviewStatus: Enum "OW Review Status";
}

