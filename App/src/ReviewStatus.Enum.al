namespace OctoberWorkshops.FollowUp;

enum 71200 "OW Review Status"
{
    Extensible = false;
    value(0; Unscheduled) { Caption = 'Unscheduled'; }
    value(1; Overdue) { Caption = 'Overdue'; }
    value(2; DueToday) { Caption = 'Due today'; }
    value(3; Scheduled) { Caption = 'Scheduled'; }
}
