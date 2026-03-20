namespace MBS.RewardsSimple;

/// <summary>
/// Stores reward levels that can be assigned to customers,
/// each with a discount percentage and optional minimum purchase threshold.
/// </summary>
table 50000 "MBS Reward"
{
    Caption = 'Reward';
    DataClassification = CustomerContent;
    DrillDownPageId = "MBS Reward List";
    LookupPageId = "MBS Reward List";

    fields
    {
        field(1; "Reward ID"; Code[30])
        {
            Caption = 'Reward ID';
            NotBlank = true;
            ToolTip = 'Specifies the unique identifier of the reward level, for example GOLD, SILVER, or BRONZE.';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
            NotBlank = true;
            ToolTip = 'Specifies a description of the reward level.';
        }
        field(3; "Discount Percentage"; Decimal)
        {
            Caption = 'Discount Percentage';
            DecimalPlaces = 2;
            MaxValue = 100;
            MinValue = 0;
            ToolTip = 'Specifies the sales discount percentage applied to customers with this reward level.';
        }
        field(4; "Minimum Purchase"; Decimal)
        {
            Caption = 'Minimum Purchase';
            DecimalPlaces = 2;
            MinValue = 0;
            ToolTip = 'Specifies the minimum cumulative purchase amount required to qualify for this reward level.';
        }
    }

    keys
    {
        key(PK; "Reward ID")
        {
            Clustered = true;
        }
    }
}
