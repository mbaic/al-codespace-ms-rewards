namespace MBS.RewardsSimple;

using Microsoft.Sales.Customer;

/// <summary>
/// Extends the Customer Card page with the Reward ID field
/// and a navigation action to the Rewards list.
/// </summary>
pageextension 50004 "MBS Customer Card Rewards Ext" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Reward ID"; Rec."Reward ID")
            {
                ApplicationArea = All;
                Lookup = true;
            }
        }
    }

    actions
    {
        addfirst(Navigation)
        {
            action(Rewards)
            {
                ApplicationArea = All;
                Caption = 'Rewards';
                RunObject = page "MBS Reward List";
                ToolTip = 'View or edit the available reward levels you can assign to customers.';
            }
        }
    }
}
