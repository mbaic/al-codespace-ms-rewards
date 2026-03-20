namespace MBS.RewardsSimple;

using MBS.RewardsSimple;
using MBS.RewardsSimple.Install;
using MBS.RewardsSimple.Test;
using MBS.RewardsSimple.Upgrade;

permissionset 50000 "MBS All Users"
{
    Access = Internal;
    Assignable = true;
    Caption = 'All users', Locked = true;

    Permissions = tabledata "MBS Reward" = RIMD,
        table "MBS Reward" = X,
        codeunit "MBS Rewards Install" = X,
        codeunit "MBS Rewards Tests" = X,
        codeunit "MBS Rewards Upgrade" = X,
        page "MBS Reward Card" = X,
        page "MBS Reward List" = X;
}