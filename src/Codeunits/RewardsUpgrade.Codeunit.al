namespace MBS.RewardsSimple.Upgrade;

using MBS.RewardsSimple;

/// <summary>
/// Handles data migration when upgrading the extension from v1 to v2.
/// Changes the BRONZE reward level to ALUMINUM.
/// </summary>
codeunit 50006 "MBS Rewards Upgrade"
{
    Access = Internal;
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        Module: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Module);
        if Module.DataVersion.Major = 1 then
            UpgradeBronzeToAluminum();
    end;

    /// <summary>
    /// Renames BRONZE reward to ALUMINUM and updates its description.
    /// Exits silently if BRONZE does not exist.
    /// </summary>
    internal procedure UpgradeBronzeToAluminum()
    var
        Reward: Record "MBS Reward";
    begin
        if not Reward.Get('BRONZE') then
            exit;

        Reward.Rename('ALUMINUM');
        Reward.Description := 'Aluminum Level';
        Reward.Modify(true);
    end;
}
