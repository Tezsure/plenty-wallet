import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';

import '../../../../utils/constants/path_const.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../../data/services/service_models/contact_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';
import 'history_filter_controller.dart';

class TransactionController extends GetxController {
  final accController = Get.find<AccountSummaryController>();
  RxList<TokenInfo> tokenInfoList = <TokenInfo>[].obs;

  RxList<TxHistoryModel> userTransactionHistory =
      <TxHistoryModel>[].obs; // List of user transactions
  RxBool isTransactionPopUpOpened = false.obs; // To show popup
  Rx<ScrollController> paginationController =
      ScrollController().obs; // For Transaction history lazy loading
  RxBool isFilterApplied = false.obs;
  Timer? searchDebounceTimer;
  Set<String> tokenTransactionID = <String>{};
  RxList<TokenInfo> filteredTokenList = <TokenInfo>[].obs;

  @override
  void onInit() {
    tokenInfoList.clear();
    updateSavedContacts();
    super.onInit();
  }

  @override
  void onClose() {
    paginationController.value.dispose();
    super.onClose();
  }

  List<TokenInfo> tokenTransactionList = <TokenInfo>[];
  static final Set<String> _tokenTransactionID = <String>{};

  /// Loades the user transaction history, and updates the UI after user taps on history tab
  Future<void> userTransactionLoader() async {
    late TokenInfo tokenInfo;
    String? isHashSame;
    HistoryFilterController? historyFilterController;
    tokenTransactionList.clear();
    _tokenTransactionID.clear();
    paginationController.value.removeListener(() {});
    userTransactionHistory.value =
        await fetchUserTransactionsHistory(limit: 40);
    for (var tx in userTransactionHistory) {
      tokenInfo = TokenInfo(
        isHashSame: isHashSame == null ? false : tx.hash!.contains(isHashSame),
        token: tx,
        timeStamp: DateTime.parse(tx.timestamp!),
        isSent: tx.sender!.address!
            .contains(accController.userAccount.value.publicKeyHash!),
      );
      isHashSame = tx.hash!;
      // For tezos transaction
      if (tx.isTezosTransaction) {
        tokenInfo = tokenInfo.copyWith(
          token: tx,
          tokenSymbol: "tez",
          tokenAmount: tx.amount! / 1e6,
          dollarAmount: (tx.amount! / 1e6) * accController.xtzPrice.value,
        );
      }
      // For normal transaction
      else if (tx.isAnyTokenOrNFTTransaction) {
        if (tx.isFa2Token) {
          if (tx.isNft) {
            tokenInfo = tokenInfo.copyWith(
              isNft: true,
              nftContractAddress: tx.target!.address!,
              nftTokenId: tx.nftTokenId,
            );
          } else {
            TokenPriceModel token = tx.getFa2TokenName;
            String amount = tx.fa2TokenAmount;
            tokenInfo = tokenInfo.copyWith(
                name: token.name!,
                imageUrl: token.thumbnailUri!,
                tokenSymbol: token.symbol!,
                tokenAmount: double.parse(amount) / pow(10, token.decimals!),
                dollarAmount: double.parse(amount) /
                    pow(10, token.decimals!) *
                    accController.xtzPrice.value);
          }
        } else {
          if (tx.isFa1Token) {
            TokenPriceModel token = tx.getFa1TokenName;
            String amount = tx.fa1TokenAmount;
            tokenInfo = tokenInfo.copyWith(
                token: tx,
                name: token.name!,
                imageUrl: token.thumbnailUri!,
                tokenSymbol: token.symbol!,
                tokenAmount: double.parse(amount) / pow(10, token.decimals!),
                dollarAmount: double.parse(amount) /
                    pow(10, token.decimals!) *
                    accController.xtzPrice.value);
          } else {
            tokenInfo = tokenInfo.copyWith(skip: true);
          }
        }
      }
      // For delegation transaction
      else if (tx.type!.toLowerCase().contains("delegation")) {
        tokenInfo = tokenInfo.copyWith(isDelegated: true, token: tx);
      } else {
        tokenInfo = tokenInfo.copyWith(skip: true);
      }
      tokenTransactionList.addIf(
          !_tokenTransactionID.contains(tx.lastid.toString()), tokenInfo);
      _tokenTransactionID.add(tx.lastid.toString());
    }

    // Lazy Loading
    paginationController.value.addListener(() async {
      if (paginationController.value.position.pixels ==
          paginationController.value.position.maxScrollExtent) {
        if (Get.isRegistered<HistoryFilterController>()) {
          historyFilterController = Get.find<HistoryFilterController>();
          userTransactionHistory.addAll(await historyFilterController!
              .fetchFilteredList(
                  nextHistoryList: await fetchUserTransactionsHistory(
                      lastId: userTransactionHistory.last.lastid.toString())));
        } else {
          userTransactionHistory.addAll(await fetchUserTransactionsHistory(
              lastId: userTransactionHistory.last.lastid.toString()));
        }
      }
    });
  }

  // ! Transaction History Related Functions

  /// Fetches user account transaction history
  Future<List<TxHistoryModel>> fetchUserTransactionsHistory(
          {String? lastId, int? limit}) async =>
      await UserStorageService().getAccountTransactionHistory(
          accountAddress: accController.userAccount.value.publicKeyHash!,
          lastId: lastId,
          limit: limit);

  List<TokenInfo?> searchTransactionHistory(String searchKey) =>
      tokenTransactionList
          .where((p0) => p0.name.isCaseInsensitiveContainsAny(searchKey))
          .toList();

  RxList<ContactModel> contacts = <ContactModel>[].obs;
  Rx<ContactModel?>? contact;

  Future<void> updateSavedContacts() async {
    contacts.value = await UserStorageService().getAllSavedContacts();
  }

  ContactModel? getContact(String address) {
    return contacts.firstWhereOrNull((element) => element.address == address);
  }

  void onAddContact(
    String address,
    String name,
  ) {
    contacts.add(ContactModel(
        name: name,
        address: address,
        imagePath: ServiceConfig.allAssetsProfileImages[Random().nextInt(
          ServiceConfig.allAssetsProfileImages.length - 1,
        )]));
  }
}

class TokenInfo {
  final String name;
  final String imageUrl;
  final bool isNft;
  final bool skip;
  final double tokenAmount;
  final double dollarAmount;
  final String tokenSymbol;
  final String lastId;
  final bool isSent;
  final TxHistoryModel? token;
  final bool isDelegated;
  final String? nftContractAddress;
  final String? nftTokenId;
  final bool? isHashSame;
  final DateTime? timeStamp;

  TokenInfo({
    this.name = "Tezos",
    this.imageUrl = "${PathConst.ASSETS}tezos_logo.png",
    this.isNft = false,
    this.skip = false,
    this.dollarAmount = 0,
    this.tokenSymbol = "tez",
    this.tokenAmount = 0,
    this.lastId = "",
    this.token,
    this.isDelegated = false,
    this.nftContractAddress,
    this.nftTokenId,
    this.isSent = false,
    this.isHashSame = false,
    this.timeStamp,
  });

  TokenInfo copyWith({
    String? name,
    String? imageUrl,
    bool? isNft,
    bool? skip,
    double? tokenAmount,
    double? dollarAmount,
    String? tokenSymbol,
    String? lastId,
    bool? isReceived,
    TxHistoryModel? token,
    bool? isDelegated,
    String? nftContractAddress,
    String? nftTokenId,
    bool? isHashSame = false,
    DateTime? timeStamp,
  }) {
    return TokenInfo(
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        isNft: isNft ?? this.isNft,
        skip: skip ?? this.skip,
        tokenAmount: tokenAmount ?? this.tokenAmount,
        dollarAmount: dollarAmount ?? this.dollarAmount,
        tokenSymbol: tokenSymbol ?? this.tokenSymbol,
        lastId: lastId ?? this.lastId,
        isSent: isReceived ?? isSent,
        token: token ?? this.token,
        isDelegated: isDelegated ?? this.isDelegated,
        nftContractAddress: nftContractAddress ?? this.nftContractAddress,
        nftTokenId: nftTokenId ?? this.nftTokenId,
        isHashSame: isHashSame ?? this.isHashSame,
        timeStamp: timeStamp ?? this.timeStamp);
  }
}

extension TransactionChecker on TxHistoryModel {
  bool get isTezosTransaction =>
      amount != null && amount! > 0 && parameter == null;
  bool get isAnyTokenOrNFTTransaction =>
      parameter != null && parameter?.entrypoint == "transfer";
  bool get isFa2Token {
    if (parameter!.value is Map) {
      return false;
    } else if (parameter!.value is List) {
      return true;
    } else if (parameter!.value is String) {
      var decodedString = jsonDecode(parameter!.value);
      if (decodedString is List) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool get isNft => Get.find<AccountSummaryController>()
      .tokensList
      .where((p0) => (p0.tokenAddress!.contains(target!.address!) &&
          p0.tokenId!.contains(parameter!.value is List
              ? parameter?.value[0]["txs"][0]["token_id"]
              : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"])))
      .isEmpty;

  bool get isFa1Token => Get.find<AccountSummaryController>()
      .tokensList
      .where((p0) => (p0.tokenAddress!.contains(target!.address!)))
      .isNotEmpty;

  String get fa2TokenAmount => parameter?.value is List
      ? parameter?.value[0]["txs"][0]["amount"]
      : jsonDecode(parameter!.value)[0]["txs"][0]["amount"];

  String get nftTokenId {
    if (parameter?.value is String) {
      var decodedString = jsonDecode(parameter!.value);
      return decodedString is Map
          ? decodedString["txs"][0]["token_id"]
          : decodedString[0]["txs"][0]["token_id"];
    } else if (parameter?.value is Map) {
      return parameter?.value["txs"][0]["token_id"];
    } else if (parameter?.value is List) {
      return parameter?.value[0]["txs"][0]["token_id"];
    } else {
      return "";
    }
  }

  String get fa1TokenAmount => parameter?.value is Map
      ? parameter!.value['value']
      : jsonDecode(parameter!.value)['value'];

  TokenPriceModel get getFa1TokenName => Get.find<AccountSummaryController>()
      .tokensList
      .firstWhere((p0) => (p0.tokenAddress!.contains(target!.address!)));

  TokenPriceModel get getFa2TokenName => Get.find<AccountSummaryController>()
      .tokensList
      .firstWhere((p0) => (p0.tokenAddress!.contains(target!.address!) &&
          p0.tokenId!.contains(parameter!.value is List
              ? parameter?.value[0]["txs"][0]["token_id"]
              : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"])));
}

extension DateOnlyCompare on DateTime {
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }
}
