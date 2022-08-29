// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:naan_wallet/app/data/services/enums/enums.dart';

class AccountModel {
  String? name;
  String? seedPhrase;
  int? derivationPathIndex;
  String? publicKey;
  String? secretKey;
  String? publicKeyHash;
  AccountProfileImageType? imageType;
  String? profileImage;
  bool isNaanAccount = false;
  String? tezosDomainName = "";
  bool? isWatchOnly = false;
  AccountModel({
    this.name,
    this.seedPhrase,
    this.derivationPathIndex,
    this.publicKey,
    this.secretKey,
    this.publicKeyHash,
    this.imageType,
    this.profileImage,
    required this.isNaanAccount,
    this.tezosDomainName,
    this.isWatchOnly = false,
  });

  AccountModel copyWith({
    String? name,
    String? seedPhrase,
    int? derivationPathIndex,
    String? publicKey,
    String? secretKey,
    String? publicKeyHash,
    AccountProfileImageType? imageType,
    String? profileImage,
    bool? isNaanAccount,
    String? tezosDomainName,
    bool? isWatchOnly,
  }) {
    return AccountModel(
      name: name ?? this.name,
      seedPhrase: seedPhrase ?? this.seedPhrase,
      derivationPathIndex: derivationPathIndex ?? this.derivationPathIndex,
      publicKey: publicKey ?? this.publicKey,
      secretKey: secretKey ?? this.secretKey,
      publicKeyHash: publicKeyHash ?? this.publicKeyHash,
      imageType: imageType ?? this.imageType,
      profileImage: profileImage ?? this.profileImage,
      isNaanAccount: isNaanAccount ?? this.isNaanAccount,
      tezosDomainName: tezosDomainName ?? this.tezosDomainName,
      isWatchOnly: isWatchOnly ?? this.isWatchOnly,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'seedPhrase': seedPhrase,
      'derivationPathIndex': derivationPathIndex,
      'publicKey': publicKey,
      'secretKey': secretKey,
      'publicKeyHash': publicKeyHash,
      'imageType': imageType?.name,
      'profileImage': profileImage,
      'isNaanAccount': isNaanAccount,
      'tezosDomainName': tezosDomainName,
      'isWatchOnly': isWatchOnly,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      name: map['name'] != null ? map['name'] as String : null,
      seedPhrase:
          map['seedPhrase'] != null ? map['seedPhrase'] as String : null,
      derivationPathIndex: map['derivationPathIndex'] != null
          ? map['derivationPathIndex'] as int
          : null,
      publicKey: map['publicKey'] != null ? map['publicKey'] as String : null,
      secretKey: map['secretKey'] != null ? map['secretKey'] as String : null,
      publicKeyHash:
          map['publicKeyHash'] != null ? map['publicKeyHash'] as String : null,
      imageType: map['imageType'] != null
          ? AccountProfileImageType.values
              .where((element) => element.name == map['imageType'])
              .toList()[0]
          : null,
      profileImage:
          map['profileImage'] != null ? map['profileImage'] as String : null,
      isNaanAccount: map['isNaanAccount'] as bool,
      tezosDomainName: map['tezosDomainName'] != null
          ? map['tezosDomainName'] as String
          : null,
      isWatchOnly: map['isWatchOnly'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory AccountModel.fromJson(Map<String, dynamic> source) =>
      AccountModel.fromMap(source);

  @override
  String toString() {
    return 'AccountModel(name: $name, seedPhrase: $seedPhrase, derivationPathIndex: $derivationPathIndex, publicKey: $publicKey, secretKey: $secretKey, publicKeyHash: $publicKeyHash, imageType: $imageType, profileImage: $profileImage, isNaanAccount: $isNaanAccount, tezosDomainName: $tezosDomainName, isWatchOnly: $isWatchOnly)';
  }

  @override
  bool operator ==(covariant AccountModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.seedPhrase == seedPhrase &&
        other.derivationPathIndex == derivationPathIndex &&
        other.publicKey == publicKey &&
        other.secretKey == secretKey &&
        other.publicKeyHash == publicKeyHash &&
        other.imageType == imageType &&
        other.profileImage == profileImage &&
        other.isNaanAccount == isNaanAccount &&
        other.tezosDomainName == tezosDomainName &&
        other.isWatchOnly == isWatchOnly;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        seedPhrase.hashCode ^
        derivationPathIndex.hashCode ^
        publicKey.hashCode ^
        secretKey.hashCode ^
        publicKeyHash.hashCode ^
        imageType.hashCode ^
        profileImage.hashCode ^
        isNaanAccount.hashCode ^
        tezosDomainName.hashCode ^
        isWatchOnly.hashCode;
  }
}
