namespace OctoberWorkshops.FollowUp;
using Microsoft.Sales.Customer;

tableextension 71200 "OW Customer Follow-up" extends Customer
{
    fields
    {
        field(71200; "OW Last Review Date"; Date)
        {
            Caption = 'Last review date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the date recorded by the latest review action.';
        }
        field(71201; "OW Next Review Date"; Date)
        {
            Caption = 'Next review date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies when to review the customer. A blank date means no review is scheduled.';
            trigger OnValidate()
            var
                ReviewMgt: Codeunit "OW Customer Follow-up Mgt.";
            begin
                ReviewMgt.CheckOptionalDate("OW Next Review Date");
            end;
        }
    }
}
