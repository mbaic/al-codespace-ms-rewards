namespace MBS.RewardsSimple.Install;

using MBS.RewardsSimple;

/// <summary>
/// Initializes the Reward table with default reward levels on first install.
/// </summary>
codeunit 50005 "MBS Rewards Install"
{
    Subtype = Install;
    Access = Internal;

    trigger OnInstallAppPerCompany()
    var
        Reward: Record "MBS Reward";
    begin
        if Reward.IsEmpty() then
            InsertDefaultRewards();
    end;

    /// <summary>
    /// Inserts the default GOLD, SILVER, and BRONZE reward levels.
    /// Safe to call multiple times - existing records are skipped.
    /// </summary>
    internal procedure InsertDefaultRewards()
    begin
        InsertRewardLevel('GOLD', 'Gold Level', 20, 1000);
        InsertRewardLevel('SILVER', 'Silver Level', 10, 500);
        InsertRewardLevel('BRONZE', 'Bronze Level', 5, 100);
    end;

    local procedure InsertRewardLevel(ID: Code[30]; Description: Text[250]; Discount: Decimal; MinPurchase: Decimal)
    var
        Reward: Record "MBS Reward";
    begin
        if Reward.Get(ID) then
            exit;

        Reward.Init();
        Reward."Reward ID" := ID;
        Reward.Description := Description;
        Reward."Discount Percentage" := Discount;
        Reward."Minimum Purchase" := MinPurchase;
        Reward.Insert();
    end;
}
