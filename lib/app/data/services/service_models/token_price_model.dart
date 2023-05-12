class TokenPriceModel {
  String? symbol;
  String? tokenAddress;
  int? decimals;
  String? name;
  String? thumbnailUri;

  String? type;
  double? currentPrice;

  String? tokenId;

  TokenPriceModel({
    this.symbol,
    this.tokenAddress,
    this.decimals,
    this.name,
    this.thumbnailUri,
    this.type,
    this.currentPrice,
    this.tokenId,
  });

  TokenPriceModel.fromJson(Map<String, dynamic> json,
      {bool isAnalytics = false, double xtzPrice = 1}) {
    if (!isAnalytics) {
      symbol = json['symbol'];
      tokenAddress = json['tokenAddress'];
      decimals = json['decimals'];
      name = json['name'];
      thumbnailUri = json['thumbnailUri'];

      type = json['type'];
      currentPrice = double.parse(json['currentPrice'].toString());

      tokenId = json['tokenId'] == null ? '0' : json['tokenId'].toString();
    } else {
      symbol = json['token'];
      tokenAddress = json['contract'];
      decimals = json['decimals'];
      name = json['name'];
      //thumbnailUri = json['thumbnailUri'];

      type = json['standard'].toString().toLowerCase();
      currentPrice = double.parse(json['price']['value'].toString()) / xtzPrice;

      tokenId = json['tokenId'] == null ? '0' : json['tokenId'].toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['tokenAddress'] = tokenAddress;
    data['decimals'] = decimals;
    data['name'] = name;
    data['thumbnailUri'] = thumbnailUri;

    data['type'] = type;
    data['currentPrice'] = currentPrice;

    data['tokenId'] = tokenId;
    return data;
  }
}
