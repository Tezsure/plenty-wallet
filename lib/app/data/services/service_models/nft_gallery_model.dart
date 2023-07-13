// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:simple_gql/simple_gql.dart';

import '../service_config/service_config.dart';

class NftGalleryModel {
  String? name;
  List<String>? publicKeyHashs;
  AccountProfileImageType? imageType;
  String? profileImage;
  NftTokenModel? nftTokenModel;

  NftGalleryModel({
    this.name,
    this.publicKeyHashs,
    this.imageType,
    this.profileImage,
  });

  Future<void> randomNft() async {
    var addresses = await getValidPublicKeyHashes(publicKeyHashs!);
    String randomAddress = addresses[
        addresses.length == 1 ? 0 : Random().nextInt(addresses.length)];
    var nfts =
        await UserStorageService().getUserNfts(userAddress: randomAddress);
    int random = Random().nextInt(nfts.length);
    String randomFa = nfts[random];
    final response = await GQLClient(
      'https://data.objkt.com/v3/graphql',
    ).query(
      query: ServiceConfig.randomNfts,
      variables: {
        'contracts': [randomFa],
        'holders': [randomAddress],
      },
    );
    List<NftTokenModel> nftsData = response.data['token']
        .map<NftTokenModel>((e) => NftTokenModel.fromJson(e))
        .toList();

    nftTokenModel = nftsData[Random().nextInt(nftsData.length)];
  }

  Future<List<String>> getValidPublicKeyHashes(
      List<String> publicKeyHashs) async {
    List<String> addresses = publicKeyHashs;
    for (int j = 0; j < publicKeyHashs.length; j++) {
      if ((await UserStorageService()
              .getUserNfts(userAddress: publicKeyHashs[j]))
          .isEmpty) {
        addresses.removeAt(j);
      }
    }
    return addresses;
  }

  NftGalleryModel copyWith({
    String? name,
    List<String>? publicKeyHashs,
    AccountProfileImageType? imageType,
    String? profileImage,
  }) {
    return NftGalleryModel(
      name: name ?? this.name,
      publicKeyHashs: publicKeyHashs ?? this.publicKeyHashs,
      imageType: imageType ?? this.imageType,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'publicKeyHashs': publicKeyHashs,
      'imageType': imageType?.name,
      'profileImage': profileImage,
    };
  }

  factory NftGalleryModel.fromMap(Map<String, dynamic> map) => NftGalleryModel(
        name: map['name'] != null ? map['name'] as String : null,
        // ignore: prefer_null_aware_operators
        publicKeyHashs: map['publicKeyHashs'] != null
            ? map['publicKeyHashs']
                .map<String>((dynamic e) => e as String)
                .toList()
            : null,
        imageType: map['imageType'] != null
            ? AccountProfileImageType.values
                .where((element) => element.name == map['imageType'])
                .toList()[0]
            : null,
        profileImage:
            map['profileImage'] != null ? map['profileImage'] as String : null,
      );

  Map<String, dynamic> toJson() => toMap();

  factory NftGalleryModel.fromJson(Map<String, dynamic> source) =>
      NftGalleryModel.fromMap(source);

  @override
  String toString() {
    return 'NftGalleryModel(name: $name, publicKeyHashs: $publicKeyHashs, imageType: $imageType, profileImage: $profileImage)';
  }

  @override
  bool operator ==(covariant NftGalleryModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        listEquals(other.publicKeyHashs, publicKeyHashs) &&
        other.imageType == imageType &&
        other.profileImage == profileImage;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        publicKeyHashs.hashCode ^
        imageType.hashCode ^
        profileImage.hashCode;
  }
}
