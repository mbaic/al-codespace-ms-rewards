namespace MBS.RewardsSimple;

using Microsoft.Sales.Customer;

/// <summary>
/// Extends the Customer List page to show the reward level column
/// and provide quick navigation to the Rewards setup page.
/// </summary>
pageextension 50000 "MBS Customer List Rewards Ext" extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("Reward ID"; Rec."Reward ID")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(OpenRewards)
            {
                ApplicationArea = All;
                Caption = 'Rewards';
                RunObject = page "MBS Reward List";
                ToolTip = 'View or edit the available reward levels you can assign to customers.';
            }
        }
    }
}
