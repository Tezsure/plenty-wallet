import 'package:flutter/foundation.dart';

/// type:
///  banner
///  dappList
///  category
class DappBannerModel {
  String? name;
  String? title;
  String? type;
  List<String>? dapps;
  String? tag;
  String? description;
  String? bannerImage;
  DappBannerModel({
    this.name,
    this.title,
    this.type,
    this.dapps,
    this.tag,
    this.description,
    this.bannerImage,
  });

  DappBannerModel copyWith({
    String? name,
    String? title,
    String? type,
    List<String>? dapps,
    String? tag,
    String? description,
    String? bannerImage,
  }) {
    return DappBannerModel(
      name: name ?? this.name,
      title: title ?? this.title,
      type: type ?? this.type,
      dapps: dapps ?? this.dapps,
      tag: tag ?? this.tag,
      description: description ?? this.description,
      bannerImage: bannerImage ?? this.bannerImage,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'title': title,
      'type': type,
      'dapps': dapps,
      'tag': tag,
      'description': description,
      'bannerImage': bannerImage,
    };
  }

  factory DappBannerModel.fromJson(Map<String, dynamic> map) {
    return DappBannerModel(
      name: map['name'] != null ? map['name'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      dapps: map['dapps'].map<String>((json) => json as String).toList(),
      tag: map['tag'] != null ? map['tag'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      bannerImage:
          map['bannerImage'] != null ? map['bannerImage'] as String : null,
    );
  }

  @override
  String toString() {
    return 'DappBannerModel(name: $name, title: $title, type: $type, dapps: $dapps, tag: $tag, description: $description, bannerImage: $bannerImage)';
  }

  @override
  bool operator ==(covariant DappBannerModel other) {
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
