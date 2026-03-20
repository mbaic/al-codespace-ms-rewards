namespace MBS.RewardsSimple;

using Microsoft.Sales.Customer;

/// <summary>
/// Extends the Customer table with a Reward ID field.
/// A blocked customer cannot have their reward level changed.
/// </summary>
tableextension 50003 "MBS Customer Rewards Ext" extends Customer
{
    fields
    {
        field(50000; "Reward ID"; Code[30])
        {
            Caption = 'Reward ID';
            DataClassification = CustomerContent;
            TableRelation = "MBS Reward"."Reward ID";
            ToolTip = 'Specifies the reward level assigned to this customer.';
            ValidateTableRelation = true;

            trigger OnValidate()
            var
                BlockedCustomerRewardErr: Label 'Cannot update the reward level of a blocked customer.';
            begin
                if (Rec."Reward ID" <> xRec."Reward ID") and (Rec.Blocked <> "Customer Blocked"::" ") then
                    Error(BlockedCustomerRewardErr);
            end;
        }
    }
}
