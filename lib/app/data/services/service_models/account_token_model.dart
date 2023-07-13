import 'package:plenty_wallet/app/data/services/enums/enums.dart';

import 'token_price_model.dart';

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
  bool isPinned;
  bool isHidden;
  bool isSelected;
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
    this.isPinned = false,
    this.isHidden = false,
    this.isSelected = false,
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
    bool? isPinned,
    bool? isHidden,
    bool? isSelected,
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
      isPinned: isPinned ?? this.isPinned,
      isHidden: isHidden ?? this.isHidden,
      isSelected: isSelected ?? this.isSelected,
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
      'isPinned': isPinned,
      'isHidden': isHidden,
      'isSelected': isSelected,
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
      isPinned: map['isPinned'] as bool,
      isHidden: map['isHidden'] as bool,
      isSelected: map['isSelected'] as bool,
    );
  }
  TokenPriceModel convert() {
    return TokenPriceModel(
      name: name,
      symbol: symbol,
      decimals: decimals,
      currentPrice: currentPrice,
      thumbnailUri: iconUrl,
      tokenAddress: contractAddress,
      tokenId: tokenId,
      type: tokenStandardType?.name,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory AccountTokenModel.fromJson(Map<String, dynamic> source) =>
      AccountTokenModel.fromMap(source);

  @override
  String toString() {
    return 'AccountTokenModel(name: $name, symbol: $symbol, iconUrl: $iconUrl, balance: $balance, valueInXtz: $valueInXtz, contractAddress: $contractAddress, tokenId: $tokenId, decimals: $decimals, tokenStandardType: $tokenStandardType, currentPrice: $currentPrice, isPinned: $isPinned, isHidden: $isHidden, isSelected: $isSelected)';
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
        other.currentPrice == currentPrice &&
        other.isPinned == isPinned &&
        other.isHidden == isHidden &&
        other.isSelected == isSelected;
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
        currentPrice.hashCode ^
        isPinned.hashCode ^
        isHidden.hashCode ^
        isSelected.hashCode;
  }
}
