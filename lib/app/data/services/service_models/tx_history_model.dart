import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/models/token_info.dart';

import '../../../../utils/constants/path_const.dart';
import 'account_model.dart';
import 'contact_model.dart';
import 'token_price_model.dart';

extension TxChecker on TxHistoryModel {
  bool get isTezTransaction =>
      amount != null && amount! > 0 && parameter == null;
  bool get isFA1TokenTransfer => (type == "transaction" &&
      parameter != null &&
      parameter!.entrypoint == "transfer" &&
      parameter!.value is Map);

  bool get isFA2TokenTransfer => (type == "transaction" &&
      parameter != null &&
      parameter!.entrypoint == "transfer" &&
      (parameter!.value is List
      // ||
      // (parameter!.value is String &&
      //     jsonDecode(parameter!.value) is List)
      ));

  bool get isDelegate => type == "delegation";
  bool get isSwap {
    List<String> swapTypes = [
      "swap",
      "_to_",
      "xtzToTokenSwapInput",
      "tokenToXtzSwapInput",
      "tokenToTokenSwapInput",
      "routerSwap",
      'execute',
      "cashToToken",
      "tokenToCash"
    ];
    if (parameter != null &&
        (swapTypes.any(
            (element) => parameter!.entrypoint?.contains(element) ?? false))) {
      return true;
    }
    return false;
  }

  bool get isReveal => type == "reveal";
  bool isReceived(String selectedAccount) {
    return (isTezTransaction || isFA1TokenTransfer || isFA2TokenTransfer) &&
            (amount ?? 0) > 0 &&
            target?.address == selectedAccount &&
            (target != null && target!.address == selectedAccount) ||
        (isFA1TokenTransfer && parameter!.value["to"] == selectedAccount) ||
        (isFA2TokenTransfer &&
            parameter!.value[0]["txs"] is List &&
            (parameter!.value[0]["txs"] as List)
                .any((element) => element["to_"] == selectedAccount));
  }

  bool isSent(String selectedAccount) {
    return (isTezTransaction || isFA1TokenTransfer || isFA2TokenTransfer) &&
        sender!.address == selectedAccount;
  }

  String getTxType(String selectedAccount) {
    if (isReceived(selectedAccount)) return "Received";
    if (isSent(selectedAccount)) return "Sent";
    if (isReveal) return "Reveal";
    if (isDelegate) return "Delegated to ${newDelegate?.alias ?? ""}";
    if (isSwap) return "Swapped";
    return "Contract interaction";
  }

  String getTxIcon(String selectedAccount) {
    if (isReceived(selectedAccount)) return "assets/transaction/down.png";
    if (isSent(selectedAccount)) return "assets/transaction/up.png";
    if (isSwap) return "assets/transaction/swap.png";
    // if (isDelegate) return "Delegated to ${newDelegate?.alias ?? ""}";
    return "assets/transaction/contract.png";
  }

  TokenPriceModel fA1Token(
    List<TokenPriceModel> tokensList,
  ) {
    return tokensList.firstWhere(
        (p0) => (p0.tokenAddress!.contains(target!.address!)),
        orElse: () => TokenPriceModel(
            address: target!.address!,
            name: target!.alias!,
            currentPrice: 0,
            thumbnailUri:
                "https://services.tzkt.io/v1/avatars/${target?.address}",
            decimals: 0));
  }

  TokenPriceModel fA2Token(
    List<TokenPriceModel> tokensList,
  ) =>
      tokensList.firstWhere((p0) =>
          (p0.tokenAddress!.contains(target!.address!) &&
              p0.tokenId!.contains(parameter!.value is List
                  ? parameter?.value[0]["txs"][0]["token_id"]
                  : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"])));

  double getAmount(List<TokenPriceModel> tokensList, String selectedAccount) {
    // if (isTezTransaction) return amount! / 1e6;
    if (isFA1TokenTransfer) {
      final token = fA1Token(tokensList);
      String value = "0.0";
      try {
        value = (parameter?.value is Map
                ? parameter!.value['value']
                : jsonDecode(parameter!.value)['value'])
            .toString();
      } catch (e) {}
      return double.parse(value) / pow(10, token.decimals!);
    }
    if (isFA2TokenTransfer) {
      if (isNFTTx(tokensList)) {
        return double.parse(parameter!.value[0]["txs"][0]["amount"]);
      }
      TokenPriceModel token = fA2Token(tokensList);
      if (isReceived(selectedAccount)) {
        double amt = 0.0;
        for (var element in (parameter?.value[0]["txs"] as List)) {
          if (element["to_"] == selectedAccount) {
            amt = amt +
                (double.parse(element["amount"]) / pow(10, token.decimals!));
          }
        }
        return amt;
      }
      if (isSent(selectedAccount)) {
        double amt = 0.0;
        for (var element in (parameter?.value[0]["txs"] as List)) {
          amt = amt +
              (double.parse(element["amount"]) / pow(10, token.decimals!));
        }
        return amt;
      }
    }
    return (amount ?? 0) / 1e6;
  }

  bool isNFTTx(List<TokenPriceModel> tokensList) =>
      isFA2TokenTransfer &&
      (tokensList
          .where((p0) => (p0.tokenAddress!.contains(target!.address!) &&
              p0.tokenId!.contains(parameter!.value is List
                  ? parameter?.value[0]["txs"][0]["token_id"]
                  : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"])))
          .isEmpty);

  TransactionInterface transactionInterface(
    List<TokenPriceModel> tokensList,
  ) {
    if (isTezTransaction) {
      return TransactionInterface(
          name: "Tezos",
          rate: 1,
          symbol: "tez",
          imageUrl: "${PathConst.ASSETS}tezos_logo.png",
          entrypoint: "");
    }
    if (isFA1TokenTransfer) {
      final token = fA1Token(tokensList);
      return TransactionInterface(
          rate: token.currentPrice,
          name: token.name ?? "",
          symbol: token.symbol ?? "",
          imageUrl: token.thumbnailUri,
          entrypoint: "transfer");
    }
    if (isFA2TokenTransfer) {
      if (isNFTTx(tokensList)) {
        return TransactionInterface(
            name: "",
            symbol: "",
            rate: 0,
            tokenID: parameter?.value[0]["txs"][0]["token_id"],
            contractAddress: target?.address,
            imageUrl: "",
            entrypoint: "transfer");
      } else {
        TokenPriceModel token = fA2Token(tokensList);
        return TransactionInterface(
            rate: token.currentPrice,
            name: token.name ?? "",
            symbol: token.symbol ?? "",
            imageUrl: token.thumbnailUri,
            entrypoint: "transfer");
      }
    }
    if (isReveal) {
      return TransactionInterface(
          name: "Reveal",
          symbol: "",
          imageUrl: "${PathConst.ASSETS}tezos_logo.png",
          entrypoint: "");
    }
    if (isDelegate) {
      return TransactionInterface(
          name: newDelegate?.alias ?? "",
          symbol: "tez",
          imageUrl:
              "https://services.tzkt.io/v1/avatars/${newDelegate?.address!}",
          entrypoint: "");
    }
    return TransactionInterface(
        name: (parameter?.entrypoint ?? target?.alias ?? ""),
        symbol: "",
        imageUrl: "https://services.tzkt.io/v1/avatars/${target?.address}",
        entrypoint: parameter?.entrypoint ?? "");
  }

  AliasAddress reciever(
      {List<AccountModel> userAccounts = const [],
      List<ContactModel> contacts = const []}) {
    if (isDelegate) {
      return newDelegate!;
    }
    if (isFA2TokenTransfer) {
      return getAddressAlias(
          AliasAddress(address: parameter?.value?["txs"]?[0]?["to_"]));
    }
    if (isFA1TokenTransfer) {
      return getAddressAlias(AliasAddress(address: parameter?.value?["to"]));
    }
    return getAddressAlias(target!);
  }

  AliasAddress getAddressAlias(AliasAddress address,
      {List<AccountModel> userAccounts = const [],
      List<ContactModel> contacts = const []}) {
    if (userAccounts
        .any((element) => element.publicKeyHash!.contains(address.address!))) {
      final account = userAccounts.firstWhere(
          (element) => element.publicKeyHash!.contains(address.address!));
      return AliasAddress(address: account.publicKeyHash, alias: account.name);
    } else if (contacts
        .any((element) => element.address.contains(address.address!))) {
      final contact = contacts
          .firstWhere((element) => element.address.contains(address.address!));
      return AliasAddress(address: contact.address, alias: contact.name);
    }
    return address;
  }
}

class TransactionInterface {
  final String name;
  final String symbol;

  final String? imageUrl;
  final String? contractAddress;
  final String? tokenID;
  final String entrypoint;
  final double? rate;

  TransactionInterface(
      {required this.name,
      required this.symbol,
      this.imageUrl = "${PathConst.EMPTY_STATES}token.svg",
      required this.entrypoint,
      this.contractAddress,
      this.tokenID,
      this.rate = 1});
}

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
  AliasAddress? sender;
  int? gasLimit;
  int? gasUsed;
  int? storageLimit;
  int? storageUsed;
  int? bakerFee;
  int? storageFee;
  int? allocationFee;
  AliasAddress? target;
  int? targetCodeHash;
  int? amount;
  bool? hasInternals;
  int? tokenTransfersCount;
  AliasAddress? prevDelegate;
  AliasAddress? newDelegate;

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
    this.prevDelegate,
    this.newDelegate,
  });

  TxHistoryModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    lastid = json['id'];
    level = json['level'];
    timestamp = json['timestamp'];
    block = json['block'];
    hash = json['hash'];
    counter = json['counter'];
    sender =
        json['sender'] != null ? AliasAddress.fromJson(json['sender']) : null;
    gasLimit = json['gasLimit'];
    gasUsed = json['gasUsed'];
    storageLimit = json['storageLimit'];
    storageUsed = json['storageUsed'];
    bakerFee = json['bakerFee'];
    storageFee = json['storageFee'];
    allocationFee = json['allocationFee'];
    target =
        json['target'] != null ? AliasAddress.fromJson(json['target']) : null;
    targetCodeHash = json['targetCodeHash'];
    amount = json['amount'];
    parameter = json['parameter'] != null
        ? Parameter.fromJson(json['parameter'])
        : null;
    operationStatus = json['status'];
    hasInternals = json['hasInternals'];
    tokenTransfersCount = json['tokenTransfersCount'];
    prevDelegate = json['prevDelegate'] != null
        ? AliasAddress.fromJson(json['prevDelegate'])
        : null;
    newDelegate = json['newDelegate'] != null
        ? AliasAddress.fromJson(json['newDelegate'])
        : null;
    if (parameter?.value != null && parameter!.value is String) {
      try {
        parameter!.value = jsonDecode(parameter!.value);
      } catch (e) {}
    }
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
    if (prevDelegate != null) {
      data['prevDelegate'] = prevDelegate!.toJson();
    }
    if (newDelegate != null) {
      data['newDelegate'] = newDelegate!.toJson();
    }
    return data;
  }
}

class AliasAddress {
  String? address;
  String? alias;

  AliasAddress({this.address, this.alias});

  AliasAddress.fromJson(Map<String, dynamic> json) {
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
