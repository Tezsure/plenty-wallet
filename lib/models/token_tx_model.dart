class TokenTxModel {
  String? operationHash;
  String? tokenName;
  String? label;
  String? status;
  int? indexedTime;
  String? network;
  String? contract;
  String? initiator;
  String? hash;
  String? timestamp;
  int? level;
  String? from;
  String? to;
  int? tokenId;
  var amount;
  int? counter;
  Token? token;
  String? alias;
  int? decimals;
  bool? isSender;

  TokenTxModel(
      {this.operationHash,
      this.tokenName,
      this.label,
      this.status,
      this.indexedTime,
      this.network,
      this.contract,
      this.initiator,
      this.hash,
      this.timestamp,
      this.level,
      this.decimals,
      this.from,
      this.to,
      this.tokenId,
      this.amount,
      this.counter,
      this.token,
      this.alias,
      this.isSender});

  TokenTxModel.fromJson(Map<String, dynamic> json) {
    operationHash = json['operationHash'];
    tokenName = json['tokenName'];
    label = json['label'];
    status = json['status'];
    indexedTime = json['indexed_time'];
    network = json['network'];
    contract = json['contract'];
    initiator = json['initiator'];
    hash = json['hash'];
    timestamp = json['timestamp'];
    level = json['level'];
    decimals = json['decimals'] ?? 0;
    from = json['from'];
    to = json['to'];
    tokenId = json['token_id'];
    amount = json['amount'];
    counter = json['counter'];
    token = json['token'] != null ? Token.fromJson(json['token']) : null;
    alias = json['alias'];
    isSender = json['isSender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operationHash'] = operationHash;
    data['tokenName'] = tokenName;
    data['label'] = label;
    data['status'] = status;
    data['indexed_time'] = indexedTime;
    data['network'] = network;
    data['contract'] = contract;
    data['initiator'] = initiator;
    data['hash'] = hash;
    data['timestamp'] = timestamp;
    data['level'] = level;
    data['from'] = from;
    data['to'] = to;
    data['token_id'] = tokenId;
    data['amount'] = amount;
    data['counter'] = counter;
    if (token != null) {
      data['token'] = token?.toJson();
    }
    data['alias'] = alias;
    data['isSender'] = isSender;
    return data;
  }
}

class Token {
  String? contract;
  String? network;
  int? tokenId;
  String? symbol;
  String? name;
  int? decimals;

  Token(
      {this.contract,
      this.network,
      this.tokenId,
      this.symbol,
      this.name,
      this.decimals});

  Token.fromJson(Map<String, dynamic> json) {
    contract = json['contract'];
    network = json['network'];
    tokenId = json['token_id'];
    symbol = json['symbol'];
    name = json['name'];
    decimals = json['decimals'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contract'] = contract;
    data['network'] = network;
    data['token_id'] = tokenId;
    data['symbol'] = symbol;
    data['name'] = name;
    data['decimals'] = decimals;
    return data;
  }
}
