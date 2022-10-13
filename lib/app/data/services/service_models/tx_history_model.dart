class TxHistoryModel {
  String? type;
  int? id;
  int? level;
  String? timestamp;
  String? block;
  String? hash;
  int? counter;
  Sender? sender;
  int? gasLimit;
  int? gasUsed;
  int? storageLimit;
  int? storageUsed;
  int? bakerFee;
  int? storageFee;
  int? allocationFee;
  Target? target;
  int? targetCodeHash;
  int? amount;
  Parameter? parameter;
  String? status;
  bool? hasInternals;
  int? tokenTransfersCount;

  TxHistoryModel(
      {this.type,
      this.id,
      this.level,
      this.timestamp,
      this.block,
      this.hash,
      this.counter,
      this.sender,
      this.gasLimit,
      this.gasUsed,
      this.storageLimit,
      this.storageUsed,
      this.bakerFee,
      this.storageFee,
      this.allocationFee,
      this.target,
      this.targetCodeHash,
      this.amount,
      this.parameter,
      this.status,
      this.hasInternals,
      this.tokenTransfersCount});

  TxHistoryModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    level = json['level'];
    timestamp = json['timestamp'];
    block = json['block'];
    hash = json['hash'];
    counter = json['counter'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    gasLimit = json['gasLimit'];
    gasUsed = json['gasUsed'];
    storageLimit = json['storageLimit'];
    storageUsed = json['storageUsed'];
    bakerFee = json['bakerFee'];
    storageFee = json['storageFee'];
    allocationFee = json['allocationFee'];
    target = json['target'] != null ? Target.fromJson(json['target']) : null;
    targetCodeHash = json['targetCodeHash'];
    amount = json['amount'];
    parameter = json['parameter'] != null
        ? Parameter.fromJson(json['parameter'])
        : null;
    status = json['status'];
    hasInternals = json['hasInternals'];
    tokenTransfersCount = json['tokenTransfersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['level'] = level;
    data['timestamp'] = timestamp;
    data['block'] = block;
    data['hash'] = hash;
    data['counter'] = counter;
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    data['gasLimit'] = gasLimit;
    data['gasUsed'] = gasUsed;
    data['storageLimit'] = storageLimit;
    data['storageUsed'] = storageUsed;
    data['bakerFee'] = bakerFee;
    data['storageFee'] = storageFee;
    data['allocationFee'] = allocationFee;
    if (target != null) {
      data['target'] = target!.toJson();
    }
    data['targetCodeHash'] = targetCodeHash;
    data['amount'] = amount;
    if (parameter != null) {
      data['parameter'] = parameter!.toJson();
    }
    data['status'] = status;
    data['hasInternals'] = hasInternals;
    data['tokenTransfersCount'] = tokenTransfersCount;
    return data;
  }
}

class Sender {
  String? address;

  Sender({this.address});

  Sender.fromJson(Map<String, dynamic> json) {
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    return data;
  }
}

class Target {
  String? alias;
  String? address;

  Target({this.alias, this.address});

  Target.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alias'] = alias;
    data['address'] = address;
    return data;
  }
}

class Parameter {
  String? entrypoint;
  Value? value;

  Parameter({this.entrypoint, this.value});

  Parameter.fromJson(Map<String, dynamic> json) {
    entrypoint = json['entrypoint'];
    try {
      value = json['value'] != null ? Value.fromJson(json['value']) : null;
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entrypoint'] = entrypoint;
    if (value != null) {
      data['value'] = value!.toJson();
    }
    return data;
  }
}

class Value {
  String? to;
  String? from;
  String? value;

  Value({this.to, this.from, this.value});

  Value.fromJson(Map<String, dynamic> json) {
    to = json['to'];
    from = json['from'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['to'] = to;
    data['from'] = from;
    data['value'] = value;
    return data;
  }
}
