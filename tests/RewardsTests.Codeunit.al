namespace MBS.RewardsSimple.Test;

using MBS.RewardsSimple;
using MBS.RewardsSimple.Install;
using MBS.RewardsSimple.Upgrade;
using Microsoft.Sales.Customer;

/// <summary>
/// Test codeunit for the MBS Rewards Simple extension.
/// Covers: reward table CRUD, install logic, upgrade logic,
/// and customer reward assignment with blocked validation.
/// </summary>
codeunit 50007 "MBS Rewards Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
    end;

    // --------------------------------------------------------
    // Install tests
    // --------------------------------------------------------

    [Test]
    procedure InsertDefaultRewardsWhenTableEmptyCreatesGoldSilverBronzeTest()
    var
        Reward: Record "MBS Reward";
        RewardsInstall: Codeunit "MBS Rewards Install";
    begin
        // [SCENARIO] Installing the extension on an empty Reward table creates the three default levels.

        // [GIVEN] The Reward table is empty.
        Reward.DeleteAll();

        // [WHEN] InsertDefaultRewards is called.
        RewardsInstall.InsertDefaultRewards();

        // [THEN] Exactly three rewards exist: GOLD, SILVER, BRONZE.
        AssertTrue(Reward.Get('GOLD'), 'GOLD reward should exist after default insert.');
        AssertTrue(Reward.Get('SILVER'), 'SILVER reward should exist after default insert.');
        AssertTrue(Reward.Get('BRONZE'), 'BRONZE reward should exist after default insert.');
        AssertInt(3, Reward.Count(), 'Exactly 3 reward records should exist.');
    end;

    [Test]
    procedure InsertDefaultRewardsWhenCalledTwiceDoesNotDuplicateTest()
    var
        Reward: Record "MBS Reward";
        RewardsInstall: Codeunit "MBS Rewards Install";
    begin
        // [SCENARIO] Calling InsertDefaultRewards twice does not create duplicate records (idempotent).

        // [GIVEN] The Reward table is empty.
        Reward.DeleteAll();

        // [WHEN] InsertDefaultRewards is called twice.
        RewardsInstall.InsertDefaultRewards();
        RewardsInstall.InsertDefaultRewards();

        // [THEN] Still only 3 records.
        AssertInt(3, Reward.Count(), 'Calling InsertDefaultRewards twice should still produce exactly 3 records.');
    end;

    [Test]
    procedure InsertDefaultRewardsGoldHas20PercentDiscountTest()
    var
        Reward: Record "MBS Reward";
        RewardsInstall: Codeunit "MBS Rewards Install";
    begin
        // [SCENARIO] The GOLD reward level is created with a 20% discount.

        // [GIVEN] The Reward table is empty.
        Reward.DeleteAll();

        // [WHEN] Default rewards are inserted.
        RewardsInstall.InsertDefaultRewards();

        // [THEN] GOLD has Discount Percentage = 20.
        Reward.Get('GOLD');
        AssertDecimal(20, Reward."Discount Percentage", 'GOLD discount percentage should be 20.');
    end;

    [Test]
    procedure InsertDefaultRewardsSilverHas10PercentDiscountTest()
    var
        Reward: Record "MBS Reward";
        RewardsInstall: Codeunit "MBS Rewards Install";
    begin
        // [SCENARIO] The SILVER reward level is created with a 10% discount.

        // [GIVEN] The Reward table is empty.
        Reward.DeleteAll();

        // [WHEN] Default rewards are inserted.
        RewardsInstall.InsertDefaultRewards();

        // [THEN] SILVER has Discount Percentage = 10.
        Reward.Get('SILVER');
        AssertDecimal(10, Reward."Discount Percentage", 'SILVER discount percentage should be 10.');
    end;

    [Test]
    procedure InsertDefaultRewardsBronzeHas5PercentDiscountTest()
    var
        Reward: Record "MBS Reward";
        RewardsInstall: Codeunit "MBS Rewards Install";
    begin
        // [SCENARIO] The BRONZE reward level is created with a 5% discount.

        // [GIVEN] The Reward table is empty.
        Reward.DeleteAll();

        // [WHEN] Default rewards are inserted.
        RewardsInstall.InsertDefaultRewards();

        // [THEN] BRONZE has Discount Percentage = 5.
        Reward.Get('BRONZE');
        AssertDecimal(5, Reward."Discount Percentage", 'BRONZE discount percentage should be 5.');
    end;

    // --------------------------------------------------------
    // Customer reward assignment tests
    // --------------------------------------------------------

    [Test]
    procedure BlockedCustomerCannotChangeRewardLevelTest()
    var
        Customer: Record Customer;
    begin
        // [SCENARIO] A blocked customer cannot have their reward level changed.

        // [GIVEN] GOLD and SILVER reward levels exist.
        InsertTestReward('GOLD', 'Gold Level', 20, 1000);
        InsertTestReward('SILVER', 'Silver Level', 10, 500);

        // [GIVEN] A customer that is blocked (All) with GOLD reward.
        Customer.Init();
        Customer."No." := 'MBSTC001';
        Customer.Name := 'Blocked Test Customer';
        Customer.Blocked := "Customer Blocked"::All;
        Customer."Reward ID" := 'GOLD';
        Customer.Insert();
        Customer.Get('MBSTC001'); // Re-read so xRec is populated from database.

        // [WHEN] Attempting to change the reward to SILVER on a blocked customer.
        // [THEN] An error should be raised.
        asserterror Customer.Validate("Reward ID", 'SILVER');

        // Cleanup
        Customer.Delete();
        CleanupTestRewards();
    end;

    [Test]
    procedure ActiveCustomerCanReceiveRewardAssignmentTest()
    var
        Customer: Record Customer;
    begin
        // [SCENARIO] An active (non-blocked) customer can be assigned a reward level.

        // [GIVEN] GOLD reward exists.
        InsertTestReward('GOLD', 'Gold Level', 20, 1000);

        // [GIVEN] An active customer with no reward.
        Customer.Init();
        Customer."No." := 'MBSTC002';
        Customer.Name := 'Active Test Customer';
        Customer.Blocked := "Customer Blocked"::" ";
        Customer.Insert();
        Customer.Get('MBSTC002');

        // [WHEN] Assigning the GOLD reward.
        Customer.Validate("Reward ID", 'GOLD');
        Customer.Modify();

        // [THEN] The reward is stored correctly.
        Customer.Get('MBSTC002');
        AssertTrue(Customer."Reward ID" = 'GOLD', 'Reward ID should be GOLD for the active customer.');

        // Cleanup
        Customer.Delete();
        CleanupTestRewards();
    end;

    [Test]
    procedure ActiveCustomerCanClearRewardAssignmentTest()
    var
        Customer: Record Customer;
    begin
        // [SCENARIO] A customer reward level can be cleared (set to blank).

        // [GIVEN] GOLD reward exists and customer has it assigned.
        InsertTestReward('GOLD', 'Gold Level', 20, 1000);

        Customer.Init();
        Customer."No." := 'MBSTC003';
        Customer.Name := 'Clear Reward Test Customer';
        Customer.Blocked := "Customer Blocked"::" ";
        Customer."Reward ID" := 'GOLD';
        Customer.Insert();
        Customer.Get('MBSTC003');

        // [WHEN] Clearing the reward level.
        Customer.Validate("Reward ID", '');
        Customer.Modify();

        // [THEN] The reward is blank.
        Customer.Get('MBSTC003');
        AssertTrue(Customer."Reward ID" = '', 'Reward ID should be empty after clearing.');

        // Cleanup
        Customer.Delete();
        CleanupTestRewards();
    end;

    // --------------------------------------------------------
    // Reward table validation tests
    // --------------------------------------------------------

    [Test]
    procedure RewardDiscountPercentageStoresCorrectlyTest()
    var
        Reward: Record "MBS Reward";
    begin
        // [SCENARIO] Discount percentage is stored and retrieved correctly.

        // [GIVEN/WHEN] A reward with 75% discount is created.
        Reward.Init();
        Reward."Reward ID" := 'TESTDISC';
        Reward.Description := 'Discount Test Reward';
        Reward."Discount Percentage" := 75;
        Reward.Insert();

        // [THEN] The value is persisted correctly.
        Reward.Get('TESTDISC');
        AssertDecimal(75, Reward."Discount Percentage", 'Discount Percentage should be 75.');

        // Cleanup
        Reward.Delete();
    end;

    [Test]
    procedure RewardMinimumPurchaseStoresCorrectlyTest()
    var
        Reward: Record "MBS Reward";
    begin
        // [SCENARIO] Minimum purchase amount is stored and retrieved correctly.

        // [GIVEN/WHEN] A reward with minimum purchase of 250 is created.
        Reward.Init();
        Reward."Reward ID" := 'TESTMINP';
        Reward.Description := 'Min Purchase Test';
        Reward."Minimum Purchase" := 250;
        Reward.Insert();

        // [THEN] The value is persisted correctly.
        Reward.Get('TESTMINP');
        AssertDecimal(250, Reward."Minimum Purchase", 'Minimum Purchase should be 250.');

        // Cleanup
        Reward.Delete();
    end;

    [Test]
    procedure RewardDescriptionCanBeUpdatedTest()
    var
        Reward: Record "MBS Reward";
    begin
        // [SCENARIO] Reward description can be modified after creation.

        // [GIVEN] An existing reward.
        Reward.Init();
        Reward."Reward ID" := 'TESTUPD';
        Reward.Description := 'Original Description';
        Reward.Insert();

        // [WHEN] The description is updated.
        Reward.Get('TESTUPD');
        Reward.Description := 'Updated Description';
        Reward.Modify();

        // [THEN] The new description is stored.
        Reward.Get('TESTUPD');
        AssertTrue(Reward.Description = 'Updated Description', 'Description should reflect the updated value.');

        // Cleanup
        Reward.Delete();
    end;

    // --------------------------------------------------------
    // Upgrade tests
    // --------------------------------------------------------

    [Test]
    procedure UpgradeBronzeToAluminumChangesKeyAndDescriptionTest()
    var
        Reward: Record "MBS Reward";
        RewardsUpgrade: Codeunit "MBS Rewards Upgrade";
    begin
        // [SCENARIO] The upgrade procedure renames BRONZE to ALUMINUM and updates the description.

        // [GIVEN] BRONZE reward exists.
        Reward.DeleteAll();
        InsertTestReward('BRONZE', 'Bronze Level', 5, 100);

        // [WHEN] The upgrade logic is executed.
        RewardsUpgrade.UpgradeBronzeToAluminum();

        // [THEN] ALUMINUM reward exists with the updated description.
        AssertTrue(Reward.Get('ALUMINUM'), 'ALUMINUM reward should exist after upgrade.');
        AssertTrue(Reward.Description = 'Aluminum Level', 'Description should be ''Aluminum Level'' after upgrade.');

        // [THEN] BRONZE reward no longer exists.
        AssertTrue(not Reward.Get('BRONZE'), 'BRONZE reward should not exist after upgrade.');

        // Cleanup
        if Reward.Get('ALUMINUM') then
            Reward.Delete();
    end;

    [Test]
    procedure UpgradeBronzeToAluminumWhenBronzeAbsentExitsGracefullyTest()
    var
        Reward: Record "MBS Reward";
        RewardsUpgrade: Codeunit "MBS Rewards Upgrade";
    begin
        // [SCENARIO] If BRONZE does not exist, the upgrade logic exits without error.

        // [GIVEN] BRONZE reward does not exist.
        if Reward.Get('BRONZE') then
            Reward.Delete();

        // [WHEN/THEN] Upgrade does not throw.
        RewardsUpgrade.UpgradeBronzeToAluminum();
    end;

    // --------------------------------------------------------
    // Helper procedures
    // --------------------------------------------------------

    local procedure InsertTestReward(ID: Code[30]; Description: Text[250]; Discount: Decimal; MinPurchase: Decimal)
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

    local procedure CleanupTestRewards()
    var
        Reward: Record "MBS Reward";
    begin
        if Reward.Get('GOLD') then Reward.Delete();
        if Reward.Get('SILVER') then Reward.Delete();
        if Reward.Get('BRONZE') then Reward.Delete();
        if Reward.Get('ALUMINUM') then Reward.Delete();
    end;

    local procedure AssertTrue(Condition: Boolean; FailMessage: Text)
    begin
        if not Condition then
            Error(FailMessage);
    end;

    local procedure AssertInt(Expected: Integer; Actual: Integer; FailMessage: Text)
    begin
        if Expected <> Actual then
            Error('Expected: %1, Actual: %2. %3', Expected, Actual, FailMessage);
    end;

    local procedure AssertDecimal(Expected: Decimal; Actual: Decimal; FailMessage: Text)
    begin
        if Expected <> Actual then
            Error('Expected: %1, Actual: %2. %3', Expected, Actual, FailMessage);
    end;
}
