namespace MBS.RewardsSimple;

/// <summary>
/// Card page for viewing and editing a single reward level.
/// </summary>
page 50001 "MBS Reward Card"
{
    Caption = 'Reward Card';
    ContextSensitiveHelpPage = 'rewards';
    PageType = Card;
    SourceTable = "MBS Reward";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Reward ID"; Rec."Reward ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Discount Percentage"; Rec."Discount Percentage")
                {
                    ApplicationArea = All;
                }
                field("Minimum Purchase"; Rec."Minimum Purchase")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
