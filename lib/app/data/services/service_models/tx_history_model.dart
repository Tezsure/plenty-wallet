import 'dart:convert';

import 'package:flutter/material.dart';

class TxHistoryModel {
  String? type;
  int? lastid;
  int? level;
  String? operationStatus;
  Parameter? parameter;
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
  bool? hasInternals;
  int? tokenTransfersCount;

  TxHistoryModel({
    this.type,
    this.lastid,
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
    this.operationStatus,
    this.hasInternals,
    this.tokenTransfersCount,
  });

  TxHistoryModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    lastid = json['id'];
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
    operationStatus = json['status'];
    hasInternals = json['hasInternals'];
    tokenTransfersCount = json['tokenTransfersCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = lastid;
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
    data['status'] = operationStatus;
    data['hasInternals'] = hasInternals;
    data['tokenTransfersCount'] = tokenTransfersCount;
    return data;
  }
}

class Sender {
  String? address;
  String? alias;

  Sender({this.address, this.alias});

  Sender.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['alias'] = alias;
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
  dynamic value;

  Parameter({this.entrypoint, this.value});

  Parameter.fromJson(Map<String, dynamic> json) {
    entrypoint = json['entrypoint'];
    try {
      if (json['value'] is List) {
        // When the transaction within the operations is more than one
        value = json['value'];
      } else if (json['value'] is Map<String, dynamic>) {
        // When the transaction within the operations is one
        value = json['value'];
      } else {
        value = json['value'];
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("$value");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entrypoint'] = entrypoint;
    if (value != null) {
      data['value'] = jsonEncode(value);
    }
    return data;
  }
}

class Initiator {
  String? alias;
  String? address;

  Initiator({this.alias, this.address});

  Initiator.fromJson(Map<String, dynamic> json) {
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
