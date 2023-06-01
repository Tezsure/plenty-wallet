import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../utils/constants/path_const.dart';
import 'account_model.dart';
import 'contact_model.dart';
import 'token_price_model.dart';

extension TxTransferChecker on TransactionTransferModel {
  TransactionInterface transactionInterface(
    List<TokenPriceModel> tokensList,
  ) {
    if (token?.standard == "fa1.2") {
      final tk = fA1Token(tokensList, token!.contract!);
      return TransactionInterface(
        name: token!.metadata?.name ?? "",
        entrypoint: '',
        symbol: token!.metadata?.symbol ?? "",
        imageUrl: token!.metadata?.thumbnailUri,
        tokenID: token!.tokenId,
        rate: tk.currentPrice!,
      );
    }
    if (token?.standard == "fa2") {
      if (token?.metadata?.decimals != null) {
        final tk = tokensList.firstWhere(
            (p0) => (p0.tokenAddress!.contains(token!.contract!.address!)),
            orElse: () => TokenPriceModel(
                name: token!.contract!.alias ?? "",
                symbol: token!.metadata!.symbol,
                currentPrice: 0,
                thumbnailUri:
                    "https://services.tzkt.io/v1/avatars/${token!.contract!.address!}",
                decimals: 0));
        return TransactionInterface(
          name: token!.metadata?.name ?? "",
          entrypoint: '',
          symbol: token!.metadata?.symbol ?? "",
          imageUrl: token!.metadata?.thumbnailUri,
          tokenID: token!.tokenId,
          rate: tk.currentPrice!,
        );
      }
      return TransactionInterface(
        name: token!.metadata?.name ?? "",
        entrypoint: '',
        symbol: token!.metadata?.symbol ?? "",
        imageUrl: token!.metadata?.thumbnailUri,
        tokenID: token!.tokenId,
      );
    }
    return TransactionInterface(
      name: "",
      entrypoint: '',
      symbol: '',
    );
  }
}

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
        (swapTypes.any((element) =>
            parameter!.entrypoint
                ?.toLowerCase()
                .contains(element.toLowerCase()) ??
            false))) {
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
    if (isReveal) return "Reveal";
    if (isDelegate) {
      return newDelegate?.address == null
          ? "Delegate failed"
          : "Delegated to ${newDelegate?.alias ?? ""}";
    }
    if (isSwap) return "Swapped";
    if (isReceived(selectedAccount)) return "Received";
    if (isSent(selectedAccount)) return "Sent";

    return "Contract interaction";
  }

  String getTxIcon(String selectedAccount) {
    if (isReceived(selectedAccount)) return "assets/transaction/down.png";
    if (isSent(selectedAccount)) return "assets/transaction/up.png";
    if (isSwap) return "assets/transaction/swap.png";
    // if (isDelegate) return "Delegated to ${newDelegate?.alias ?? ""}";
    return "assets/transaction/contract.png";
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
      final token = fA1Token(tokensList, target);
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
      final token = fA1Token(tokensList, target);
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

  AliasAddress source(
          {List<AccountModel> userAccounts = const [],
          List<ContactModel> contacts = const []}) =>
      getAddressAlias(sender!, userAccounts: userAccounts, contacts: contacts);
  AliasAddress destination({
    List<AccountModel> userAccounts = const [],
    List<ContactModel> contacts = const [],
  }) {
    if (isDelegate) {
      return newDelegate ?? prevDelegate ?? AliasAddress();
    }
    if (isFA2TokenTransfer) {
      return getAddressAlias(
          AliasAddress(
              address: (parameter?.value is List)
                  ? parameter?.value?[0]?["txs"]?[0]?["to_"]
                  : parameter?.value?["txs"]?[0]?["to_"]),
          userAccounts: userAccounts,
          contacts: contacts);
    }
    if (isFA1TokenTransfer) {
      return getAddressAlias(AliasAddress(address: parameter?.value?["to"]),
          userAccounts: userAccounts, contacts: contacts);
    }
    if (target != null) {
      return getAddressAlias(target!,
          userAccounts: userAccounts, contacts: contacts);
    }
    return AliasAddress();
  }
}

AliasAddress getAddressAlias(AliasAddress address,
    {List<AccountModel> userAccounts = const [],
    List<ContactModel> contacts = const []}) {
  if (address.address?.isEmpty ?? true) return address;
  if (contacts.any((element) => element.address.contains(address.address!))) {
    final contact = contacts
        .firstWhere((element) => element.address.contains(address.address!));
    return AliasAddress(address: contact.address, alias: contact.name);
  } else if (userAccounts
      .any((element) => element.publicKeyHash!.contains(address.address!))) {
    final account = userAccounts.firstWhere(
        (element) => element.publicKeyHash!.contains(address.address!));
    return AliasAddress(address: account.publicKeyHash, alias: account.name);
  }
  return address;
}

TokenPriceModel fA1Token(
    List<TokenPriceModel> tokensList, AliasAddress? target) {
  return tokensList.firstWhere(
      (p0) => (p0.tokenAddress!.contains(target!.address!)),
      orElse: () => TokenPriceModel(
          name: target!.alias!,
          symbol: target.alias?.split(" ").last,
          currentPrice: 0,
          thumbnailUri: "https://services.tzkt.io/v1/avatars/${target.address}",
          decimals: 0));
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

// To parse this JSON data, do
//
//     final transactionTransferModel = transactionTransferModelFromJson(jsonString);

List<TransactionTransferModel> transactionTransferModelFromJson(String str) =>
    List<TransactionTransferModel>.from(
        json.decode(str).map((x) => TransactionTransferModel.fromJson(x)));

String transactionTransferModelToJson(List<TransactionTransferModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionTransferModel {
  TransactionTransferModel({
    this.id,
    this.level,
    this.timestamp,
    this.token,
    this.from,
    this.to,
    this.amount,
    this.transactionId,
  });

  int? id;
  int? level;
  DateTime? timestamp;
  Token? token;
  AliasAddress? from;
  AliasAddress? to;
  String? amount;
  int? transactionId;

  TransactionTransferModel copyWith({
    int? id,
    int? level,
    DateTime? timestamp,
    Token? token,
    AliasAddress? from,
    AliasAddress? to,
    String? amount,
    int? transactionId,
  }) =>
      TransactionTransferModel(
        id: id ?? this.id,
        level: level ?? this.level,
        timestamp: timestamp ?? this.timestamp,
        token: token ?? this.token,
        from: from ?? this.from,
        to: to ?? this.to,
        amount: amount ?? this.amount,
        transactionId: transactionId ?? this.transactionId,
      );

  factory TransactionTransferModel.fromJson(Map<String, dynamic> json) =>
      TransactionTransferModel(
        id: json["id"],
        level: json["level"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        token: json["token"] == null ? null : Token.fromJson(json["token"]),
        from: json["from"] == null ? null : AliasAddress.fromJson(json["from"]),
        to: json["to"] == null ? null : AliasAddress.fromJson(json["to"]),
        amount: json["amount"],
        transactionId: json["transactionId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "level": level,
        "timestamp": timestamp?.toIso8601String(),
        "token": token?.toJson(),
        "from": from?.toJson(),
        "to": to?.toJson(),
        "amount": amount,
        "transactionId": transactionId,
      };
}

class Token {
  Token({
    this.id,
    this.contract,
    this.tokenId,
    this.standard,
    this.totalSupply,
    this.metadata,
  });

  int? id;
  AliasAddress? contract;
  String? tokenId;
  String? standard;
  String? totalSupply;
  Metadata? metadata;

  Token copyWith({
    int? id,
    AliasAddress? contract,
    String? tokenId,
    String? standard,
    String? totalSupply,
    Metadata? metadata,
  }) =>
      Token(
        id: id ?? this.id,
        contract: contract ?? this.contract,
        tokenId: tokenId ?? this.tokenId,
        standard: standard ?? this.standard,
        totalSupply: totalSupply ?? this.totalSupply,
        metadata: metadata ?? this.metadata,
      );

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        id: json["id"],
        contract: json["contract"] == null
            ? null
            : AliasAddress.fromJson(json["contract"]),
        tokenId: json["tokenId"],
        standard: json["standard"],
        totalSupply: json["totalSupply"],
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contract": contract?.toJson(),
        "tokenId": tokenId,
        "standard": standard,
        "totalSupply": totalSupply,
        "metadata": metadata?.toJson(),
      };
}

class Metadata {
  Metadata({
    this.name,
    this.symbol,
    this.decimals,
    this.thumbnailUri,
    this.icon,
    this.tags,
    this.formats,
    this.creators,
    this.displayUri,
    this.artifactUri,
    this.description,
    this.isBooleanAmount,
    this.shouldPreferSymbol,
    this.version,
    this.attributes,
    this.generatorUri,
    this.iterationHash,
    this.authenticityHash,
    this.date,
    this.image,
    this.minter,
    this.rights,
    this.royalties,
    this.mintingTool,
  });

  String? name;
  String? symbol;
  String? decimals;
  String? thumbnailUri;
  String? icon;
  List<String>? tags;
  List<Format>? formats;
  List<String>? creators;
  String? displayUri;
  String? artifactUri;
  String? description;
  bool? isBooleanAmount;
  dynamic shouldPreferSymbol;
  String? version;
  List<Attribute>? attributes;
  String? generatorUri;
  String? iterationHash;
  String? authenticityHash;
  DateTime? date;
  String? image;
  String? minter;
  String? rights;
  Royalties? royalties;
  String? mintingTool;

  Metadata copyWith({
    String? name,
    String? symbol,
    String? decimals,
    String? thumbnailUri,
    String? icon,
    List<String>? tags,
    List<Format>? formats,
    List<String>? creators,
    String? displayUri,
    String? artifactUri,
    String? description,
    bool? isBooleanAmount,
    dynamic shouldPreferSymbol,
    String? version,
    List<Attribute>? attributes,
    String? generatorUri,
    String? iterationHash,
    String? authenticityHash,
    DateTime? date,
    String? image,
    String? minter,
    String? rights,
    Royalties? royalties,
    String? mintingTool,
  }) =>
      Metadata(
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        decimals: decimals ?? this.decimals,
        thumbnailUri: thumbnailUri ?? this.thumbnailUri,
        icon: icon ?? this.icon,
        tags: tags ?? this.tags,
        formats: formats ?? this.formats,
        creators: creators ?? this.creators,
        displayUri: displayUri ?? this.displayUri,
        artifactUri: artifactUri ?? this.artifactUri,
        description: description ?? this.description,
        isBooleanAmount: isBooleanAmount ?? this.isBooleanAmount,
        shouldPreferSymbol: shouldPreferSymbol ?? this.shouldPreferSymbol,
        version: version ?? this.version,
        attributes: attributes ?? this.attributes,
        generatorUri: generatorUri ?? this.generatorUri,
        iterationHash: iterationHash ?? this.iterationHash,
        authenticityHash: authenticityHash ?? this.authenticityHash,
        date: date ?? this.date,
        image: image ?? this.image,
        minter: minter ?? this.minter,
        rights: rights ?? this.rights,
        royalties: royalties ?? this.royalties,
        mintingTool: mintingTool ?? this.mintingTool,
      );

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        name: json["name"],
        symbol: json["symbol"],
        decimals: json["decimals"],
        thumbnailUri: json["thumbnailUri"],
        icon: json["icon"],
        tags: json["tags"] == null
            ? []
            : List<String>.from(json["tags"]!.map((x) => x)),
        formats: json["formats"] == null
            ? []
            : List<Format>.from(
                json["formats"]!.map((x) => Format.fromJson(x))),
        creators: json["creators"] == null
            ? []
            : List<String>.from(json["creators"]!.map((x) => x)),
        displayUri: json["displayUri"],
        artifactUri: json["artifactUri"],
        description: json["description"],
        isBooleanAmount: json["isBooleanAmount"],
        shouldPreferSymbol: json["shouldPreferSymbol"],
        version: json["version"],
        attributes: json["attributes"] == null || (json["attributes"] is! List)
            ? []
            : List<Attribute>.from(
                json["attributes"]!.map((x) => Attribute.fromJson(x))),
        generatorUri: json["generatorUri"],
        iterationHash: json["iterationHash"],
        authenticityHash: json["authenticityHash"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        image: json["image"],
        minter: json["minter"],
        rights: json["rights"],
        royalties: json["royalties"] == null
            ? null
            : Royalties.fromJson(json["royalties"]),
        mintingTool: json["mintingTool"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "symbol": symbol,
        "decimals": decimals,
        "thumbnailUri": thumbnailUri,
        "icon": icon,
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "formats": formats == null
            ? []
            : List<dynamic>.from(formats!.map((x) => x.toJson())),
        "creators":
            creators == null ? [] : List<dynamic>.from(creators!.map((x) => x)),
        "displayUri": displayUri,
        "artifactUri": artifactUri,
        "description": description,
        "isBooleanAmount": isBooleanAmount,
        "shouldPreferSymbol": shouldPreferSymbol,
        "version": version,
        "attributes": attributes == null
            ? []
            : List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "generatorUri": generatorUri,
        "iterationHash": iterationHash,
        "authenticityHash": authenticityHash,
        "date": date?.toIso8601String(),
        "image": image,
        "minter": minter,
        "rights": rights,
        "royalties": royalties?.toJson(),
        "mintingTool": mintingTool,
      };
}

class Attribute {
  Attribute({
    this.name,
    this.value,
  });

  String? name;
  String? value;

  Attribute copyWith({
    String? name,
    String? value,
  }) =>
      Attribute(
        name: name ?? this.name,
        value: value ?? this.value,
      );

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        name: json["name"],
        value: json["value"] is String ? json["value"] : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
      };
}

class Format {
  Format({
    this.uri,
    this.mimeType,
    this.fileName,
    this.fileSize,
    this.dimensions,
  });

  String? uri;
  String? mimeType;
  String? fileName;
  String? fileSize;
  Dimensions? dimensions;

  Format copyWith({
    String? uri,
    String? mimeType,
    String? fileName,
    String? fileSize,
    Dimensions? dimensions,
  }) =>
      Format(
        uri: uri ?? this.uri,
        mimeType: mimeType ?? this.mimeType,
        fileName: fileName ?? this.fileName,
        fileSize: fileSize ?? this.fileSize,
        dimensions: dimensions ?? this.dimensions,
      );

  factory Format.fromJson(Map<String, dynamic> json) => Format(
        uri: json["uri"],
        mimeType: json["mimeType"],
        fileName: json["fileName"],
        fileSize: json["fileSize"],
        dimensions: json["dimensions"] == null
            ? null
            : Dimensions.fromJson(json["dimensions"]),
      );

  Map<String, dynamic> toJson() => {
        "uri": uri,
        "mimeType": mimeType,
        "fileName": fileName,
        "fileSize": fileSize,
        "dimensions": dimensions?.toJson(),
      };
}

class Dimensions {
  Dimensions({
    this.unit,
    this.value,
  });

  String? unit;
  String? value;

  Dimensions copyWith({
    String? unit,
    String? value,
  }) =>
      Dimensions(
        unit: unit ?? this.unit,
        value: value ?? this.value,
      );

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        unit: json["unit"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "unit": unit,
        "value": value,
      };
}

class Royalties {
  Royalties({
    this.shares,
    this.decimals,
  });

  Shares? shares;
  String? decimals;

  Royalties copyWith({
    Shares? shares,
    String? decimals,
  }) =>
      Royalties(
        shares: shares ?? this.shares,
        decimals: decimals ?? this.decimals,
      );

  factory Royalties.fromJson(Map<String, dynamic> json) => Royalties(
        shares: json["shares"] == null ? null : Shares.fromJson(json["shares"]),
        decimals: json["decimals"],
      );

  Map<String, dynamic> toJson() => {
        "shares": shares?.toJson(),
        "decimals": decimals,
      };
}

class Shares {
  Shares({
    this.tz1NcuhmDakffJjPfNBzhoV8FYpCvPtdEjfa,
    this.tz1EL7CuBohL1ZCis7PFffrNd6Ad5UqHdYfC,
  });

  String? tz1NcuhmDakffJjPfNBzhoV8FYpCvPtdEjfa;
  String? tz1EL7CuBohL1ZCis7PFffrNd6Ad5UqHdYfC;

  Shares copyWith({
    String? tz1NcuhmDakffJjPfNBzhoV8FYpCvPtdEjfa,
    String? tz1EL7CuBohL1ZCis7PFffrNd6Ad5UqHdYfC,
  }) =>
      Shares(
        tz1NcuhmDakffJjPfNBzhoV8FYpCvPtdEjfa:
            tz1NcuhmDakffJjPfNBzhoV8FYpCvPtdEjfa ??
                this.tz1NcuhmDakffJjPfNBzhoV8FYpCvPtdEjfa,
        tz1EL7CuBohL1ZCis7PFffrNd6Ad5UqHdYfC:
            tz1EL7CuBohL1ZCis7PFffrNd6Ad5UqHdYfC ??
                this.tz1EL7CuBohL1ZCis7PFffrNd6Ad5UqHdYfC,
      );

  factory Shares.fromJson(Map<String, dynamic> json) => Shares(
        tz1NcuhmDakffJjPfNBzhoV8FYpCvPtdEjfa:
            json["tz1NCUHMDakffJJPfNBzhoV8FYpCvPTDEjfa"],
        tz1EL7CuBohL1ZCis7PFffrNd6Ad5UqHdYfC:
            json["tz1eL7CUBohL1ZCis7pFffrNd6Ad5uqHdYfC"],
      );

  Map<String, dynamic> toJson() => {
        "tz1NCUHMDakffJJPfNBzhoV8FYpCvPTDEjfa":
            tz1NcuhmDakffJjPfNBzhoV8FYpCvPtdEjfa,
        "tz1eL7CUBohL1ZCis7pFffrNd6Ad5uqHdYfC":
            tz1EL7CuBohL1ZCis7PFffrNd6Ad5UqHdYfC,
      };
}
