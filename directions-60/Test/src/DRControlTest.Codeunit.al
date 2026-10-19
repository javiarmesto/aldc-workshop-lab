namespace Directions.FollowUp.Tests;
codeunit 71300 "DR Control Test"
{
    Subtype = Test;
    [Test]
    procedure ControlArithmetic()
    begin
        if 2 + 2 <> 4 then
            Error('Control failed.');
    end;
}
