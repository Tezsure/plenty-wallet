// To parse this JSON data, do
//
//     final delegateRewardModel = delegateRewardModelFromJson(jsonString);

import 'dart:convert';

List<DelegateRewardModel> delegateRewardListResponseFromJson(String str) =>
    List<DelegateRewardModel>.from(
        json.decode(str).map((x) => DelegateRewardModel.fromJson(x)));
DelegateRewardModel delegateRewardModelFromJson(String str) =>
    DelegateRewardModel.fromJson(json.decode(str));

class DelegateRewardModel {
  DelegateRewardModel({
    this.cycle,
    this.balance,
    this.baker,
    this.stakingBalance,
    this.activeStake,
    this.selectedStake,
    this.expectedBlocks,
    this.expectedEndorsements,
    this.futureBlocks,
    this.futureBlockRewards,
    this.blocks,
    this.blockRewards,
    this.missedBlocks,
    this.missedBlockRewards,
    this.futureEndorsements,
    this.futureEndorsementRewards,
    this.endorsements,
    this.endorsementRewards,
    this.missedEndorsements,
    this.missedEndorsementRewards,
    this.blockFees,
    this.missedBlockFees,
    this.doubleBakingRewards,
    this.doubleBakingLosses,
    this.doubleEndorsingRewards,
    this.doubleEndorsingLosses,
    this.doublePreendorsingRewards,
    this.doublePreendorsingLosses,
    this.revelationRewards,
    this.revelationLosses,
    this.ownBlocks,
    this.extraBlocks,
    this.missedOwnBlocks,
    this.missedExtraBlocks,
    this.uncoveredOwnBlocks,
    this.uncoveredExtraBlocks,
    this.uncoveredEndorsements,
    this.ownBlockRewards,
    this.extraBlockRewards,
    this.missedOwnBlockRewards,
    this.missedExtraBlockRewards,
    this.uncoveredOwnBlockRewards,
    this.uncoveredExtraBlockRewards,
    this.uncoveredEndorsementRewards,
    this.ownBlockFees,
    this.extraBlockFees,
    this.missedOwnBlockFees,
    this.missedExtraBlockFees,
    this.uncoveredOwnBlockFees,
    this.uncoveredExtraBlockFees,
    this.doubleBakingLostDeposits,
    this.doubleBakingLostRewards,
    this.doubleBakingLostFees,
    this.doubleEndorsingLostDeposits,
    this.doubleEndorsingLostRewards,
    this.doubleEndorsingLostFees,
    this.revelationLostRewards,
    this.revelationLostFees,
  });

  int? cycle;
  int? balance;
  Baker? baker;
  int? stakingBalance;
  int? activeStake;
  int? selectedStake;
  int? expectedBlocks;
  int? expectedEndorsements;
  int? futureBlocks;
  int? futureBlockRewards;
  int? blocks;
  int? blockRewards;
  int? missedBlocks;
  int? missedBlockRewards;
  int? futureEndorsements;
  int? futureEndorsementRewards;
  int? endorsements;
  int? endorsementRewards;
  int? missedEndorsements;
  int? missedEndorsementRewards;
  int? blockFees;
  int? missedBlockFees;
  int? doubleBakingRewards;
  int? doubleBakingLosses;
  int? doubleEndorsingRewards;
  int? doubleEndorsingLosses;
  int? doublePreendorsingRewards;
  int? doublePreendorsingLosses;
  int? revelationRewards;
  int? revelationLosses;
  int? ownBlocks;
  int? extraBlocks;
  int? missedOwnBlocks;
  int? missedExtraBlocks;
  int? uncoveredOwnBlocks;
  int? uncoveredExtraBlocks;
  int? uncoveredEndorsements;
  int? ownBlockRewards;
  int? extraBlockRewards;
  int? missedOwnBlockRewards;
  int? missedExtraBlockRewards;
  int? uncoveredOwnBlockRewards;
  int? uncoveredExtraBlockRewards;
  int? uncoveredEndorsementRewards;
  int? ownBlockFees;
  int? extraBlockFees;
  int? missedOwnBlockFees;
  int? missedExtraBlockFees;
  int? uncoveredOwnBlockFees;
  int? uncoveredExtraBlockFees;
  int? doubleBakingLostDeposits;
  int? doubleBakingLostRewards;
  int? doubleBakingLostFees;
  int? doubleEndorsingLostDeposits;
  int? doubleEndorsingLostRewards;
  int? doubleEndorsingLostFees;
  int? revelationLostRewards;
  int? revelationLostFees;

  factory DelegateRewardModel.fromJson(Map<String, dynamic> json) =>
      DelegateRewardModel(
        cycle: json["cycle"]?.toInt(),
        balance: json["balance"].toInt(),
        baker: json["baker"] == null ? null : Baker.fromJson(json["baker"]),
        stakingBalance: json["stakingBalance"].toInt(),
        activeStake: json["activeStake"].toInt(),
        selectedStake: json["selectedStake"].toInt(),
        expectedBlocks: json["expectedBlocks"].toInt(),
        expectedEndorsements: json["expectedEndorsements"].toInt(),
        futureBlocks: json["futureBlocks"].toInt(),
        futureBlockRewards: json["futureBlockRewards"].toInt(),
        blocks: json["blocks"].toInt(),
        blockRewards: json["blockRewards"].toInt(),
        missedBlocks: json["missedBlocks"].toInt(),
        missedBlockRewards: json["missedBlockRewards"].toInt(),
        futureEndorsements: json["futureEndorsements"].toInt(),
        futureEndorsementRewards: json["futureEndorsementRewards"].toInt(),
        endorsements: json["endorsements"].toInt(),
        endorsementRewards: json["endorsementRewards"].toInt(),
        missedEndorsements: json["missedEndorsements"].toInt(),
        missedEndorsementRewards: json["missedEndorsementRewards"].toInt(),
        blockFees: json["blockFees"].toInt(),
        missedBlockFees: json["missedBlockFees"].toInt(),
        doubleBakingRewards: json["doubleBakingRewards"].toInt(),
        doubleBakingLosses: json["doubleBakingLosses"].toInt(),
        doubleEndorsingRewards: json["doubleEndorsingRewards"].toInt(),
        doubleEndorsingLosses: json["doubleEndorsingLosses"].toInt(),
        doublePreendorsingRewards: json["doublePreendorsingRewards"].toInt(),
        doublePreendorsingLosses: json["doublePreendorsingLosses"].toInt(),
        revelationRewards: json["revelationRewards"].toInt(),
        revelationLosses: json["revelationLosses"].toInt(),
        ownBlocks: json["ownBlocks"].toInt(),
        extraBlocks: json["extraBlocks"].toInt(),
        missedOwnBlocks: json["missedOwnBlocks"].toInt(),
        missedExtraBlocks: json["missedExtraBlocks"].toInt(),
        uncoveredOwnBlocks: json["uncoveredOwnBlocks"].toInt(),
        uncoveredExtraBlocks: json["uncoveredExtraBlocks"].toInt(),
        uncoveredEndorsements: json["uncoveredEndorsements"].toInt(),
        ownBlockRewards: json["ownBlockRewards"].toInt(),
        extraBlockRewards: json["extraBlockRewards"].toInt(),
        missedOwnBlockRewards: json["missedOwnBlockRewards"].toInt(),
        missedExtraBlockRewards: json["missedExtraBlockRewards"].toInt(),
        uncoveredOwnBlockRewards: json["uncoveredOwnBlockRewards"].toInt(),
        uncoveredExtraBlockRewards: json["uncoveredExtraBlockRewards"].toInt(),
        uncoveredEndorsementRewards:
            json["uncoveredEndorsementRewards"].toInt(),
        ownBlockFees: json["ownBlockFees"].toInt(),
        extraBlockFees: json["extraBlockFees"].toInt(),
        missedOwnBlockFees: json["missedOwnBlockFees"].toInt(),
        missedExtraBlockFees: json["missedExtraBlockFees"].toInt(),
        uncoveredOwnBlockFees: json["uncoveredOwnBlockFees"].toInt(),
        uncoveredExtraBlockFees: json["uncoveredExtraBlockFees"].toInt(),
        doubleBakingLostDeposits: json["doubleBakingLostDeposits"].toInt(),
        doubleBakingLostRewards: json["doubleBakingLostRewards"].toInt(),
        doubleBakingLostFees: json["doubleBakingLostFees"].toInt(),
        doubleEndorsingLostDeposits:
            json["doubleEndorsingLostDeposits"].toInt(),
        doubleEndorsingLostRewards: json["doubleEndorsingLostRewards"].toInt(),
        doubleEndorsingLostFees: json["doubleEndorsingLostFees"].toInt(),
        revelationLostRewards: json["revelationLostRewards"].toInt(),
        revelationLostFees: json["revelationLostFees"].toInt(),
      );
}

class Baker {
  Baker({
    this.alias,
    this.address,
  });

  String? alias;
  String? address;

  factory Baker.fromJson(Map<String, dynamic> json) => Baker(
        alias: json["alias"],
        address: json["address"],
      );
}
