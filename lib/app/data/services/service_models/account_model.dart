// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:naan_wallet/app/data/services/enums/enums.dart';

class AccountModel {
  String? name;
  int? derivationPathIndex;
  String? publicKeyHash;
  AccountProfileImageType? imageType;
  String? profileImage;
  bool isNaanAccount = false;
  String? tezosDomainName = "";
  bool? isWatchOnly = false;
  AccountDataModel? accountDataModel;
  AccountSecretModel? accountSecretModel;
  bool? isAccountPrimary = false;
  bool? isAccountHidden = false;

  AccountModel({
    this.name,
    this.derivationPathIndex,
    this.publicKeyHash,
    this.imageType,
    this.profileImage,
    required this.isNaanAccount,
    this.tezosDomainName,
    this.isWatchOnly = false,
    this.accountDataModel,
    this.isAccountPrimary = false,
    this.isAccountHidden = false,
  }) {
    accountDataModel = accountDataModel ?? AccountDataModel();
  }

  AccountModel copyWith(
      {String? name,
      int? derivationPathIndex,
      String? publicKeyHash,
      AccountProfileImageType? imageType,
      String? profileImage,
      bool? isNaanAccount,
      String? tezosDomainName,
      bool? isWatchOnly,
      AccountDataModel? accountDataModel,
      bool? isAccountPrimary = false,
      bool? isAccountHidden = false}) {
    return AccountModel(
      name: name ?? this.name,
      derivationPathIndex: derivationPathIndex ?? this.derivationPathIndex,
      publicKeyHash: publicKeyHash ?? this.publicKeyHash,
      imageType: imageType ?? this.imageType,
      profileImage: profileImage ?? this.profileImage,
      isNaanAccount: isNaanAccount ?? this.isNaanAccount,
      tezosDomainName: tezosDomainName ?? this.tezosDomainName,
      isWatchOnly: isWatchOnly ?? this.isWatchOnly,
      accountDataModel: accountDataModel ?? this.accountDataModel,
      isAccountPrimary: isAccountPrimary ?? this.isAccountPrimary,
      isAccountHidden: isAccountHidden ?? this.isAccountHidden,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'derivationPathIndex': derivationPathIndex,
      'publicKeyHash': publicKeyHash,
      'imageType': imageType?.name,
      'profileImage': profileImage,
      'isNaanAccount': isNaanAccount,
      'tezosDomainName': tezosDomainName,
      'isWatchOnly': isWatchOnly,
      'accountDataModel': accountDataModel,
      'isAccountPrimary': isAccountPrimary,
      'isAccountHidden': isAccountHidden,
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      name: map['name'] != null ? map['name'] as String : null,
      derivationPathIndex: map['derivationPathIndex'] != null
          ? map['derivationPathIndex'] as int
          : null,
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
      accountDataModel: map['accountDataModel'] != null
          ? AccountDataModel.fromJson(map['accountDataModel'])
          : null,
      isAccountPrimary: map['isAccountPrimary'] ?? false,
      isAccountHidden: map['isAccountHidden'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory AccountModel.fromJson(Map<String, dynamic> source) =>
      AccountModel.fromMap(source);

  @override
  String toString() {
    return 'AccountModel(name: $name, derivationPathIndex: $derivationPathIndex, publicKeyHash: $publicKeyHash, imageType: $imageType, profileImage: $profileImage, isNaanAccount: $isNaanAccount, tezosDomainName: $tezosDomainName, isWatchOnly: $isWatchOnly, accountDataModel: $accountDataModel, isAccountPrimary: $isAccountPrimary, isAccountHidden: $isAccountHidden)';
  }

  @override
  bool operator ==(covariant AccountModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.derivationPathIndex == derivationPathIndex &&
        other.publicKeyHash == publicKeyHash &&
        other.imageType == imageType &&
        other.profileImage == profileImage &&
        other.isNaanAccount == isNaanAccount &&
        other.tezosDomainName == tezosDomainName &&
        other.isWatchOnly == isWatchOnly &&
        other.accountDataModel == accountDataModel &&
        other.isAccountPrimary == isAccountPrimary &&
        other.isAccountHidden == isAccountHidden;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        derivationPathIndex.hashCode ^
        publicKeyHash.hashCode ^
        imageType.hashCode ^
        profileImage.hashCode ^
        isNaanAccount.hashCode ^
        tezosDomainName.hashCode ^
        isWatchOnly.hashCode ^
        accountDataModel.hashCode ^
        isAccountPrimary.hashCode ^
        isAccountHidden.hashCode;
  }
}

class AccountDataModel {
  double? xtzBalance;

  /// total value xtz + tokensValueInxtz
  double? totalBalance;
  AccountDataModel({
    this.xtzBalance,
    this.totalBalance,
  });

  AccountDataModel copyWith({
    double? xtzBalance,
    double? tokenXtzBalance,
  }) {
    return AccountDataModel(
      xtzBalance: xtzBalance ?? this.xtzBalance,
      totalBalance: tokenXtzBalance ?? totalBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'xtzBalance': xtzBalance,
      'totalBalance': totalBalance,
    };
  }

  factory AccountDataModel.fromMap(Map<String, dynamic> map) {
    return AccountDataModel(
      xtzBalance: map['xtzBalance'] != null ? map['xtzBalance'] as double : 0.0,
      totalBalance:
          map['totalBalance'] != null ? map['totalBalance'] as double : 0.0,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory AccountDataModel.fromJson(Map<String, dynamic> source) =>
      AccountDataModel.fromMap(source);

  @override
  String toString() =>
      'AccountDataModel(xtzBalance: $xtzBalance, totalBalance: $totalBalance)';

  @override
  bool operator ==(covariant AccountDataModel other) {
    if (identical(this, other)) return true;

    return other.xtzBalance == xtzBalance && other.totalBalance == totalBalance;
  }

  @override
  int get hashCode => xtzBalance.hashCode ^ totalBalance.hashCode;
}

class AccountSecretModel {
  String? seedPhrase;
  int? derivationPathIndex;
  String? publicKey;
  String? secretKey;
  String? publicKeyHash;
  AccountSecretModel({
    this.seedPhrase,
    this.derivationPathIndex,
    this.publicKey,
    this.secretKey,
    this.publicKeyHash,
  });

  AccountSecretModel copyWith({
    String? seedPhrase,
    int? derivationPathIndex,
    String? publicKey,
    String? secretKey,
    String? publicKeyHash,
  }) {
    return AccountSecretModel(
      seedPhrase: seedPhrase ?? this.seedPhrase,
      derivationPathIndex: derivationPathIndex ?? this.derivationPathIndex,
      publicKey: publicKey ?? this.publicKey,
      secretKey: secretKey ?? this.secretKey,
      publicKeyHash: publicKeyHash ?? this.publicKeyHash,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'seedPhrase': seedPhrase,
      'derivationPathIndex': derivationPathIndex,
      'publicKey': publicKey,
      'secretKey': secretKey,
      'publicKeyHash': publicKeyHash,
    };
  }

  factory AccountSecretModel.fromMap(Map<String, dynamic> map) {
    return AccountSecretModel(
      seedPhrase:
          map['seedPhrase'] != null ? map['seedPhrase'] as String : null,
      derivationPathIndex: map['derivationPathIndex'] != null
          ? map['derivationPathIndex'] as int
          : null,
      publicKey: map['publicKey'] != null ? map['publicKey'] as String : null,
      secretKey: map['secretKey'] != null ? map['secretKey'] as String : null,
      publicKeyHash:
          map['publicKeyHash'] != null ? map['publicKeyHash'] as String : null,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory AccountSecretModel.fromJson(Map<String, dynamic> source) =>
      AccountSecretModel.fromMap(source);

  @override
  String toString() {
    return 'AccountSecretModel(seedPhrase: $seedPhrase, derivationPathIndex: $derivationPathIndex, publicKey: $publicKey, secretKey: $secretKey, publicKeyHash: $publicKeyHash)';
  }

  @override
  bool operator ==(covariant AccountSecretModel other) {
    if (identical(this, other)) return true;

    return other.seedPhrase == seedPhrase &&
        other.derivationPathIndex == derivationPathIndex &&
        other.publicKey == publicKey &&
        other.secretKey == secretKey &&
        other.publicKeyHash == publicKeyHash;
  }

  @override
  int get hashCode {
    return seedPhrase.hashCode ^
        derivationPathIndex.hashCode ^
        publicKey.hashCode ^
        secretKey.hashCode ^
        publicKeyHash.hashCode;
  }
}
