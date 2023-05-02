import 'package:flutter/foundation.dart';

/// type:
///  banner
///  dappList
///  category
// To parse this JSON data, do
//
//     final dappBannerModel = dappBannerModelFromJson(jsonString);

import 'dart:convert';

DappBannerModel dappBannerModelFromJson(String str) => DappBannerModel.fromJson(json.decode(str));

String dappBannerModelToJson(DappBannerModel data) => json.encode(data.toJson());

class DappBannerModel {
    List<DappBannerDatum> data;

    DappBannerModel({
        required this.data,
    });

    DappBannerModel copyWith({
        List<DappBannerDatum>? data,
    }) => 
        DappBannerModel(
            data: data ?? this.data,
        );

    factory DappBannerModel.fromJson(Map<String, dynamic> json) => DappBannerModel(
        data: List<DappBannerDatum>.from(json["data"].map((x) => DappBannerDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class DappBannerDatum {
    String? name;
    String? title;
    String? type;
    List<String>? dapps;
    String? tag;
    String? description;
    String? bannerImage;
    List<Banner>? banners;
    List<String>? types;

    DappBannerDatum({
        this.name,
        this.title,
        required this.type,
        this.dapps,
        required this.tag,
        this.description,
        this.bannerImage,
        this.banners,
        this.types,
    });

    DappBannerDatum copyWith({
        String? name,
        String? title,
        String? type,
        List<String>? dapps,
        String? tag,
        String? description,
        String? bannerImage,
        List<Banner>? banners,
        List<String>? types,
    }) => 
        DappBannerDatum(
            name: name ?? this.name,
            title: title ?? this.title,
            type: type ?? this.type,
            dapps: dapps ?? this.dapps,
            tag: tag ?? this.tag,
            description: description ?? this.description,
            bannerImage: bannerImage ?? this.bannerImage,
            banners: banners ?? this.banners,
            types: types ?? this.types,
        );

    factory DappBannerDatum.fromJson(Map<String, dynamic> json) => DappBannerDatum(
        name: json["name"],
        title: json["title"],
        type: json["type"],
        dapps: json["dapps"] == null ? [] : List<String>.from(json["dapps"]!.map((x) => x)),
        tag: json["tag"],
        description: json["description"],
        bannerImage: json["bannerImage"],
        banners: json["banners"] == null ? [] : List<Banner>.from(json["banners"]!.map((x) => Banner.fromJson(x))),
        types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "type": type,
        "dapps": dapps == null ? [] : List<dynamic>.from(dapps!.map((x) => x)),
        "tag": tag,
        "description": description,
        "bannerImage": bannerImage,
        "banners": banners == null ? [] : List<dynamic>.from(banners!.map((x) => x.toJson())),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
     @override
  String toString() {
    return 'DappBannerModel(name: $name, title: $title, type: $type, dapps: $dapps, tag: $tag, description: $description, bannerImage: $bannerImage)';
  }

  @override
  bool operator ==(covariant DappBannerDatum other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.title == title &&
        other.type == type &&
        listEquals(other.dapps, dapps) &&
        other.tag == tag &&
        other.description == description &&
        other.bannerImage == bannerImage;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        title.hashCode ^
        type.hashCode ^
        dapps.hashCode ^
        tag.hashCode ^
        description.hashCode ^
        bannerImage.hashCode;
  }

}

class Banner {
    String name;
    String? title;
    String? description;
    String? bannerImage;
    String dapp;

    Banner({
        required this.name,
        required this.title,
        required this.description,
        required this.bannerImage,
        required this.dapp,
    });

    Banner copyWith({
        String? name,
        String? title,
        String? description,
        String? bannerImage,
        String? dapp,
    }) => 
        Banner(
            name: name ?? this.name,
            title: title ?? this.title,
            description: description ?? this.description,
            bannerImage: bannerImage ?? this.bannerImage,
            dapp: dapp ?? this.dapp,
        );

    factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        name: json["name"],
        title: json["title"],
        description: json["description"],
        bannerImage: json["bannerImage"],
        dapp: json["dapp"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "description": description,
        "bannerImage": bannerImage,
        "dapp": dapp,
    };
}


 

class DappModel {
  String? name;
  String? logo;
  String? url;
  String? backgroundImage;
  String? description;
  String? discord;
  String? twitter;
  String? telegram;
  String? type;
  String? favoriteLogo;
  bool? isFavorite;

  DappModel(
      {this.name,
      this.logo,
      this.url,
      this.backgroundImage,
      this.description,
      this.discord,
      this.type="",
      this.favoriteLogo,
      this.isFavorite = false,
      this.twitter,
      this.telegram});

  DappModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    logo = json['logo'];
    favoriteLogo = json['favoriteLogo'] ?? logo;
    url = json['url'];
    type = json['type']??"";
    backgroundImage = json['backgroundImage'];
    description = json['description'];
    discord = json['discord'];
    twitter = json['twitter'];
    telegram = json['telegram'];
    isFavorite = json['isFavorite'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['logo'] = logo;
    data['url'] = url;
    data['favoriteLogo'] = favoriteLogo;
    data['backgroundImage'] = backgroundImage;
    data['description'] = description;
    data['discord'] = discord;
    data['twitter'] = twitter;
    data['telegram'] = telegram;
    data['type'] = type;
    data['isFavorite'] = isFavorite;
    return data;
  }

  @override
  String toString() {
    return 'DappModel(name: $name, logo: $logo, url: $url, backgroundImage: $backgroundImage, description: $description, discord: $discord, twitter: $twitter, telegram: $telegram, isFavorite: $isFavorite, type: $type, favoriteLogo: $favoriteLogo  )';
  }
}
