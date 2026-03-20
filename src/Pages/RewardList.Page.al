namespace MBS.RewardsSimple;

/// <summary>
/// List page for browsing and managing reward levels.
/// </summary>
page 50002 "MBS Reward List"
{
    ApplicationArea = All;
    Caption = 'Rewards';
    CardPageId = "MBS Reward Card";
    ContextSensitiveHelpPage = 'rewards';
    PageType = List;
    SourceTable = "MBS Reward";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Rewards)
            {
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
