namespace Directions.FollowUp.Tests;
using Directions.FollowUp;
codeunit 71302 "DR Inject History Failure"
{
    EventSubscriberInstance = Manual;
    [EventSubscriber(ObjectType::Table, Database::"DR Review Entry", 'OnBeforeInsertEvent', '', false, false)]
    local procedure FailInsert(var Rec: Record "DR Review Entry"; RunTrigger: Boolean)
    begin
        Error('DR injected history failure');
    end;
}
