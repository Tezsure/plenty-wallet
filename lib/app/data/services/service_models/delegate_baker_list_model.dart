// To parse this JSON data, do
//
//     final delegateBakersListResponse = delegateBakersListResponseFromJson(jsonString);

import 'dart:convert';

List<DelegateBakerModel> delegateBakersListResponseFromJson(String str) =>
    List<DelegateBakerModel>.from(
        json.decode(str).map((x) => DelegateBakerModel.fromJson(x)));

class DelegateBakerModel {
  DelegateBakerModel({
    this.rank,
    this.logo,
    this.logoMin,
    this.name,
    this.address,
    this.fee = 0,
    this.lifetime,
    this.delegateBakersListResponseYield,
    this.efficiency,
    this.efficiencyLast10Cycle,
    this.freespace,
    this.totalPoints,
    this.deletationStatus,
    this.freespaceMin,
    this.proStatus,
  });

  int? rank;
  String? logo;
  String? logoMin;
  String? name;
  String? address;
  double fee;
  int? lifetime;
  double? delegateBakersListResponseYield;
  double? efficiency;
  double? efficiencyLast10Cycle;
  int? freespace;
  int? totalPoints;
  bool? deletationStatus;
  String? freespaceMin;
  bool? proStatus;

  DelegateBakerModel copyWith({
    int? rank,
    String? logo,
    String? logoMin,
    String? name,
    String? address,
    double? fee,
    int? lifetime,
    double? delegateBakersListResponseYield,
    double? efficiency,
    double? efficiencyLast10Cycle,
    int? freespace,
    int? totalPoints,
    bool? deletationStatus,
    String? freespaceMin,
    bool? proStatus,
  }) =>
      DelegateBakerModel(
        rank: rank ?? this.rank,
        logo: logo ?? this.logo,
        logoMin: logoMin ?? this.logoMin,
        name: name ?? this.name,
        address: address ?? this.address,
        fee: fee ?? this.fee,
        lifetime: lifetime ?? this.lifetime,
        delegateBakersListResponseYield: delegateBakersListResponseYield ??
            this.delegateBakersListResponseYield,
        efficiency: efficiency ?? this.efficiency,
        efficiencyLast10Cycle:
            efficiencyLast10Cycle ?? this.efficiencyLast10Cycle,
        freespace: freespace ?? this.freespace,
        totalPoints: totalPoints ?? this.totalPoints,
        deletationStatus: deletationStatus ?? this.deletationStatus,
        freespaceMin: freespaceMin ?? this.freespaceMin,
        proStatus: proStatus ?? this.proStatus,
      );

  factory DelegateBakerModel.fromJson(Map<String, dynamic> json) =>
      DelegateBakerModel(
        rank: json["rank"]??json["id"],
        logo: json["logo"],
        logoMin: json["logo_min"],
        name: json["name"],
        address: json["address"],
        fee: json["fee"] == 1 ? 0 : (json["fee"]?.toDouble() ?? 0),
        lifetime: json["lifetime"],
        delegateBakersListResponseYield:
            json["yield"]?.toDouble() ?? json["estimatedRoi"]?.toDouble(),
        efficiency: json["efficiency"]?.toDouble(),
        efficiencyLast10Cycle: json["efficiency_last10cycle"]?.toDouble(),
        freespace: json["freespace"] ??
            json["freeSpace"]?.toInt() ??
            json["stakingBalance"],
        totalPoints: json["total_points"],
        deletationStatus: json["deletation_status"],
        freespaceMin: json["freespace_min"] ??
            "${((json["freeSpace"] ?? json["stakingBalance"] ?? 0) / 1000).toStringAsFixed(2)}k XTZ",
        // freespaceMin: json["stakingBalance"]?.toString(),
        proStatus: json["pro_status"],
      );
}
