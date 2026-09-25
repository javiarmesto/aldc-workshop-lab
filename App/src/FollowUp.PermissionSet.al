namespace OctoberWorkshops.FollowUp;

permissionset 71200 "OW FOLLOWUP"
{
    Assignable = true;
    Caption = 'Workshop customer follow-up';
    Permissions = codeunit "OW Customer Follow-up Mgt." = X;
    // Standard Customer read/modify and Customer Card access come from the user's existing role.
}
