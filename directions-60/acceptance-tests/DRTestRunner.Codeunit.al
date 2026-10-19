namespace Directions.FollowUp.Tests;
codeunit 71304 "DR Test Runner"
{
    Subtype = TestRunner;
    TestIsolation = Function;
    trigger OnRun()
    begin
        Codeunit.Run(Codeunit::"DR Control Test");
        Codeunit.Run(Codeunit::"DR Acceptance Tests");
    end;
}
