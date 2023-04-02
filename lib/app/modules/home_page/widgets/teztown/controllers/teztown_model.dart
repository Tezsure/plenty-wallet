// To parse this JSON data, do
//
//     final teztownModel = teztownModelFromJson(jsonString);

import 'dart:convert';

TeztownModel teztownModelFromJson(String str) =>
    TeztownModel.fromJson(json.decode(str));

String teztownModelToJson(TeztownModel data) => json.encode(data.toJson());

class TeztownModel {
  TeztownModel({
    this.detailItems = const [],
    this.burnWebsite,
    this.galleryAddress,
    this.nftPk,
  });

  List<DetailItem>? detailItems;
  String? burnWebsite;
  String? galleryAddress;
  int? nftPk;

  factory TeztownModel.fromJson(Map<String, dynamic> json) => TeztownModel(
        detailItems: List<DetailItem>.from(
            json["detail_items"].map((x) => DetailItem.fromJson(x))),
        burnWebsite: json["burn_website"],
        galleryAddress: json["gallery_address"],
        nftPk: json["nftPk"],
      );

  Map<String, dynamic> toJson() => {
        "detail_items":
            List<dynamic>.from(detailItems?.map((x) => x.toJson()) ?? []),
        "burn_website": burnWebsite,
        "gallery_address": galleryAddress,
        "nftPk": nftPk,
      };
}

class DetailItem {
  DetailItem({
    required this.title,
    required this.description,
    required this.image,
  });

  String title;
  String description;
  String image;

  factory DetailItem.fromJson(Map<String, dynamic> json) => DetailItem(
        title: json["title"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
      };
}
