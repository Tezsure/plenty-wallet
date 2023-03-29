class TokenPriceModel {
  String? symbol;
  String? tokenAddress;
  int? decimals;
  String? name;
  String? thumbnailUri;
  String? address;
  double? tezPool;
  double? tokenPool;
  String? type;
  double? currentPrice;
  String? timestamp;
  String? tokenId;

  TokenPriceModel({
    this.symbol,
    this.tokenAddress,
    this.decimals,
    this.name,
    this.thumbnailUri,
    this.address,
    this.tezPool,
    this.tokenPool,
    this.type,
    this.currentPrice,
    this.timestamp,
    this.tokenId,
  });

  TokenPriceModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    tokenAddress = json['tokenAddress'];
    decimals = json['decimals'];
    name = json['name'];
    thumbnailUri = json['thumbnailUri'];
    address = json['address'];
    tezPool = double.parse(json['tezPool'].toString());
    tokenPool = double.parse(json['tokenPool'].toString());
    type = json['type'];
    currentPrice = double.parse(json['currentPrice'].toString());
    timestamp = json['timestamp'];
    tokenId = json['tokenId'] == null ? '0' : json['tokenId'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['tokenAddress'] = tokenAddress;
    data['decimals'] = decimals;
    data['name'] = name;
    data['thumbnailUri'] = thumbnailUri;
    data['address'] = address;
    data['tezPool'] = tezPool;
    data['tokenPool'] = tokenPool;
    data['type'] = type;
    data['currentPrice'] = currentPrice;
    data['timestamp'] = timestamp;
    data['tokenId'] = tokenId;
    return data;
  }
}
