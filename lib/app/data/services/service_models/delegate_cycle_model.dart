// To parse this JSON data, do
//
//     final delegateCycleStatusModel = delegateCycleStatusModelFromJson(jsonString);

import 'dart:convert';

List<DelegateCycleStatusModel> delegateCycleListResponseFromJson(String str) =>
    List<DelegateCycleStatusModel>.from(
        json.decode(str).map((x) => DelegateCycleStatusModel.fromJson(x)));
DelegateCycleStatusModel delegateCycleStatusModelFromJson(String str) => DelegateCycleStatusModel.fromJson(json.decode(str));


class DelegateCycleStatusModel {
    DelegateCycleStatusModel({
        this.index,
        this.firstLevel,
        this.startTime,
        this.lastLevel,
        this.endTime,
        this.snapshotIndex,
        this.snapshotLevel,
        this.randomSeed='',
        this.totalBakers,
        this.totalStaking,
        this.totalDelegators,
        this.totalDelegated,
        this.selectedBakers,
        this.selectedStake,
        this.totalRolls,
    });

    int? index;
    int? firstLevel;
    DateTime? startTime;
    int? lastLevel;
    DateTime? endTime;
    int? snapshotIndex;
    int? snapshotLevel;
    String randomSeed;
    int? totalBakers;
    int? totalStaking;
    int? totalDelegators;
    int? totalDelegated;
    int? selectedBakers;
    int? selectedStake;
    int? totalRolls;

    factory DelegateCycleStatusModel.fromJson(Map<String, dynamic> json) => DelegateCycleStatusModel(
        index: json["index"],
        firstLevel: json["firstLevel"],
        startTime: DateTime.parse(json["startTime"]),
        lastLevel: json["lastLevel"],
        endTime: DateTime.parse(json["endTime"]),
        snapshotIndex: json["snapshotIndex"],
        snapshotLevel: json["snapshotLevel"],
        randomSeed: json["randomSeed"],
        totalBakers: json["totalBakers"],
        totalStaking: json["totalStaking"],
        totalDelegators: json["totalDelegators"],
        totalDelegated: json["totalDelegated"],
        selectedBakers: json["selectedBakers"],
        selectedStake: json["selectedStake"],
        totalRolls: json["totalRolls"],
    );

  
}
