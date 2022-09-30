// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:naan_wallet/app/data/services/enums/enums.dart';

class AccountTokenModel {
  String? name;
  String? symbol;
  String? iconUrl;
  double balance;
  double? valueInXtz;
  String contractAddress;
  String tokenId;
  int decimals;
  double? currentPrice;
  TokenStandardType? tokenStandardType;
  AccountTokenModel({
    this.name,
    this.symbol,
    this.iconUrl,
    required this.balance,
    this.valueInXtz,
    required this.contractAddress,
    required this.tokenId,
    required this.decimals,
    this.tokenStandardType,
    this.currentPrice,
  });

  AccountTokenModel copyWith({
    String? name,
    String? symbol,
    String? iconUrl,
    double? balance,
    double? valueInXtz,
    String? contractAddress,
    String? tokenId,
    int? decimals,
    TokenStandardType? tokenStandardType,
    double? currentPrice,
  }) {
    return AccountTokenModel(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      iconUrl: iconUrl ?? this.iconUrl,
      balance: balance ?? this.balance,
      valueInXtz: valueInXtz ?? this.valueInXtz,
      contractAddress: contractAddress ?? this.contractAddress,
      tokenId: tokenId ?? this.tokenId,
      decimals: decimals ?? this.decimals,
      tokenStandardType: tokenStandardType ?? this.tokenStandardType,
      currentPrice: currentPrice ?? this.currentPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'symbol': symbol,
      'iconUrl': iconUrl,
      'balance': balance,
      'valueInXtz': valueInXtz,
      'contractAddress': contractAddress,
      'tokenId': tokenId,
      'decimals': decimals,
      'tokenStandardType': tokenStandardType?.name,
      'currentPrice': currentPrice,
    };
  }

  factory AccountTokenModel.fromMap(Map<String, dynamic> map) {
    return AccountTokenModel(
      name: map['name'] != null ? map['name'] as String : null,
      symbol: map['symbol'] != null ? map['symbol'] as String : null,
      iconUrl: map['iconUrl'] != null ? map['iconUrl'] as String : null,
      balance: map['balance'] as double,
      valueInXtz:
          map['valueInXtz'] != null ? map['valueInXtz'] as double : null,
      contractAddress: map['contractAddress'] as String,
      tokenId: map['tokenId'] as String,
      decimals: map['decimals'] as int,
      tokenStandardType: map['tokenStandardType'] != null
          ? TokenStandardType.values
              .where((element) => element.name == map['tokenStandardType'])
              .toList()[0]
          : null,
      currentPrice:
          map['currentPrice'] != null ? map['currentPrice'] as double : null,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory AccountTokenModel.fromJson(Map<String, dynamic> source) =>
      AccountTokenModel.fromMap(source);

  @override
  String toString() {
    return 'AccountTokenModel(name: $name, symbol: $symbol, iconUrl: $iconUrl, balance: $balance, valueInXtz: $valueInXtz, contractAddress: $contractAddress, tokenId: $tokenId, decimals: $decimals, tokenStandardType: $tokenStandardType)';
  }

  @override
  bool operator ==(covariant AccountTokenModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.symbol == symbol &&
        other.iconUrl == iconUrl &&
        other.balance == balance &&
        other.valueInXtz == valueInXtz &&
        other.contractAddress == contractAddress &&
        other.tokenId == tokenId &&
        other.decimals == decimals &&
        other.tokenStandardType == tokenStandardType &&
        other.currentPrice == currentPrice;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        symbol.hashCode ^
        iconUrl.hashCode ^
        balance.hashCode ^
        valueInXtz.hashCode ^
        contractAddress.hashCode ^
        tokenId.hashCode ^
        decimals.hashCode ^
        tokenStandardType.hashCode ^
        currentPrice.hashCode;
  }
}
