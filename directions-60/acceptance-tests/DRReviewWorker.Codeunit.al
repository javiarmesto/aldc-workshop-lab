namespace Directions.FollowUp.Tests;
using Directions.FollowUp;
using Microsoft.Sales.Customer;
codeunit 71303 "DR Review Worker"
{
    TableNo = Customer;
    trigger OnRun()
    var
        Mgt: Codeunit "DR Review Mgt.";
    begin
        Mgt.MarkReviewed(Rec, 20261015D);
    end;
}
