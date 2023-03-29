// To parse this JSON data, do
//
//     final delegateRewardModel = delegateRewardModelFromJson(jsonString);

import 'dart:convert';

import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';

List<DelegateRewardModel> delegateRewardListResponseFromJson(String str) =>
    List<DelegateRewardModel>.from(
        json.decode(str).map((x) => DelegateRewardModel.fromJson(x)));
DelegateRewardModel delegateRewardModelFromJson(String str) =>
    DelegateRewardModel.fromJson(json.decode(str));

class DelegateRewardModel {
  DelegateRewardModel(
      {this.cycle,
      this.balance = 0,
      this.baker,
      this.stakingBalance,
      this.activeStake = 0,
      this.selectedStake,
      this.expectedBlocks,
      this.expectedEndorsements = 0,
      this.futureBlocks,
      this.futureBlockRewards = 0,
      this.blocks,
      this.blockRewards = 0,
      this.missedBlocks,
      this.missedBlockRewards,
      this.futureEndorsements,
      this.futureEndorsementRewards = 0,
      this.endorsements,
      this.endorsementRewards = 0,
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
      this.extraBlockRewards = 0,
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
      this.bakerDetail,
      this.status});

  int? cycle;
  double balance;
  Baker? baker;
  double? stakingBalance;
  double activeStake;
  double? selectedStake;
  double? expectedBlocks;
  double expectedEndorsements;
  double? futureBlocks;
  double futureBlockRewards;
  double? blocks;
  double blockRewards;
  double? missedBlocks;
  double? missedBlockRewards;
  double? futureEndorsements;
  double futureEndorsementRewards;
  double? endorsements;
  double endorsementRewards;
  double? missedEndorsements;
  double? missedEndorsementRewards;
  double? blockFees;
  double? missedBlockFees;
  double? doubleBakingRewards;
  double? doubleBakingLosses;
  double? doubleEndorsingRewards;
  double? doubleEndorsingLosses;
  double? doublePreendorsingRewards;
  double? doublePreendorsingLosses;
  double? revelationRewards;
  double? revelationLosses;
  double? ownBlocks;
  double? extraBlocks;
  double? missedOwnBlocks;
  double? missedExtraBlocks;
  double? uncoveredOwnBlocks;
  double? uncoveredExtraBlocks;
  double? uncoveredEndorsements;
  double? ownBlockRewards;
  double extraBlockRewards;
  double? missedOwnBlockRewards;
  double? missedExtraBlockRewards;
  double? uncoveredOwnBlockRewards;
  double? uncoveredExtraBlockRewards;
  double? uncoveredEndorsementRewards;
  double? ownBlockFees;
  double? extraBlockFees;
  double? missedOwnBlockFees;
  double? missedExtraBlockFees;
  double? uncoveredOwnBlockFees;
  double? uncoveredExtraBlockFees;
  double? doubleBakingLostDeposits;
  double? doubleBakingLostRewards;
  double? doubleBakingLostFees;
  double? doubleEndorsingLostDeposits;
  double? doubleEndorsingLostRewards;
  double? doubleEndorsingLostFees;
  double? revelationLostRewards;
  double? revelationLostFees;
  String? status;
  DelegateBakerModel? bakerDetail;

  factory DelegateRewardModel.fromJson(Map<String, dynamic> json) =>
      DelegateRewardModel(
        cycle: json["cycle"]?.toInt(),
        balance: json["balance"].toDouble(),
        baker: json["baker"] == null ? null : Baker.fromJson(json["baker"]),
        stakingBalance: json["stakingBalance"].toDouble(),
        activeStake: json["activeStake"].toDouble(),
        selectedStake: json["selectedStake"].toDouble(),
        expectedBlocks: json["expectedBlocks"].toDouble(),
        expectedEndorsements: json["expectedEndorsements"].toDouble(),
        futureBlocks: json["futureBlocks"].toDouble(),
        futureBlockRewards: json["futureBlockRewards"].toDouble(),
        blocks: json["blocks"].toDouble(),
        blockRewards: json["blockRewards"].toDouble(),
        missedBlocks: json["missedBlocks"].toDouble(),
        missedBlockRewards: json["missedBlockRewards"].toDouble(),
        futureEndorsements: json["futureEndorsements"].toDouble(),
        futureEndorsementRewards: json["futureEndorsementRewards"].toDouble(),
        endorsements: json["endorsements"].toDouble(),
        endorsementRewards: json["endorsementRewards"].toDouble(),
        missedEndorsements: json["missedEndorsements"].toDouble(),
        missedEndorsementRewards: json["missedEndorsementRewards"].toDouble(),
        blockFees: json["blockFees"].toDouble(),
        missedBlockFees: json["missedBlockFees"].toDouble(),
        doubleBakingRewards: json["doubleBakingRewards"].toDouble(),
        doubleBakingLosses: json["doubleBakingLosses"].toDouble(),
        doubleEndorsingRewards: json["doubleEndorsingRewards"].toDouble(),
        doubleEndorsingLosses: json["doubleEndorsingLosses"].toDouble(),
        doublePreendorsingRewards: json["doublePreendorsingRewards"].toDouble(),
        doublePreendorsingLosses: json["doublePreendorsingLosses"].toDouble(),
        revelationRewards: json["revelationRewards"].toDouble(),
        revelationLosses: json["revelationLosses"].toDouble(),
        ownBlocks: json["ownBlocks"].toDouble(),
        extraBlocks: json["extraBlocks"].toDouble(),
        missedOwnBlocks: json["missedOwnBlocks"].toDouble(),
        missedExtraBlocks: json["missedExtraBlocks"].toDouble(),
        uncoveredOwnBlocks: json["uncoveredOwnBlocks"].toDouble(),
        uncoveredExtraBlocks: json["uncoveredExtraBlocks"].toDouble(),
        uncoveredEndorsements: json["uncoveredEndorsements"].toDouble(),
        ownBlockRewards: json["ownBlockRewards"].toDouble(),
        extraBlockRewards: json["extraBlockRewards"].toDouble(),
        missedOwnBlockRewards: json["missedOwnBlockRewards"].toDouble(),
        missedExtraBlockRewards: json["missedExtraBlockRewards"].toDouble(),
        uncoveredOwnBlockRewards: json["uncoveredOwnBlockRewards"].toDouble(),
        uncoveredExtraBlockRewards:
            json["uncoveredExtraBlockRewards"].toDouble(),
        uncoveredEndorsementRewards:
            json["uncoveredEndorsementRewards"].toDouble(),
        ownBlockFees: json["ownBlockFees"].toDouble(),
        extraBlockFees: json["extraBlockFees"].toDouble(),
        missedOwnBlockFees: json["missedOwnBlockFees"].toDouble(),
        missedExtraBlockFees: json["missedExtraBlockFees"].toDouble(),
        uncoveredOwnBlockFees: json["uncoveredOwnBlockFees"].toDouble(),
        uncoveredExtraBlockFees: json["uncoveredExtraBlockFees"].toDouble(),
        doubleBakingLostDeposits: json["doubleBakingLostDeposits"].toDouble(),
        doubleBakingLostRewards: json["doubleBakingLostRewards"].toDouble(),
        doubleBakingLostFees: json["doubleBakingLostFees"].toDouble(),
        doubleEndorsingLostDeposits:
            json["doubleEndorsingLostDeposits"].toDouble(),
        doubleEndorsingLostRewards:
            json["doubleEndorsingLostRewards"].toDouble(),
        doubleEndorsingLostFees: json["doubleEndorsingLostFees"].toDouble(),
        revelationLostRewards: json["revelationLostRewards"].toDouble(),
        revelationLostFees: json["revelationLostFees"].toDouble(),
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
