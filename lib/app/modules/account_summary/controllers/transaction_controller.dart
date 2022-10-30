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

  /// Loades the user transaction history, and updates the UI after user taps on history tab
  Future<void> userTransactionLoader() async {
    HistoryFilterController? historyFilterController;
    paginationController.value.removeListener(() {});
    userTransactionHistory.value = await fetchUserTransactionsHistory();
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

  List<TxHistoryModel?> searchTransactionHistory(String searchKey) {
    List<TxHistoryModel?> searchResult = [];
    if (searchKey.isCaseInsensitiveContainsAny("tezos")) {
      searchResult.addAll(userTransactionHistory
          .where((element) =>
              element.amount != null &&
              element.amount! > 0 &&
              element.parameter == null)
          .toList());
    } else {
      for (var element in tokenInfoList) {
        if (element.name.isCaseInsensitiveContainsAny(searchKey)) {
          searchResult.add(element.token);
        }
      }
    }
    return searchResult.isNotEmpty ? searchResult : [];
  }

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

  bool isSameTimeStamp(int index) =>
      DateTime.parse(userTransactionHistory[index].timestamp!).isSameDate(
          DateTime.parse(
              userTransactionHistory[index == 0 ? 0 : index - 1].timestamp!));

  bool isTezosTransaction(int index) =>
      userTransactionHistory[index].amount != null &&
      userTransactionHistory[index].amount! > 0 &&
      userTransactionHistory[index].parameter == null;
  bool isAnyTokenOrNFTTransaction(int index) =>
      userTransactionHistory[index].parameter != null &&
      userTransactionHistory[index].parameter?.entrypoint == "transfer";
  bool isFa2Token(int index) {
    if (userTransactionHistory[index].parameter!.value is Map) {
      return false;
    } else if (userTransactionHistory[index].parameter!.value is List) {
      return true;
    } else if (userTransactionHistory[index].parameter!.value is String) {
      var decodedString =
          jsonDecode(userTransactionHistory[index].parameter!.value);
      if (decodedString is List) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool isFa2TokenListEmpty(int index) => accController.tokensList
      .where((p0) =>
          (p0.tokenAddress!
              .contains(userTransactionHistory[index].target!.address!)) &&
          p0.tokenId!.contains(userTransactionHistory[index].parameter!.value
                  is List
              ? userTransactionHistory[index].parameter?.value[0]["txs"][0]
                  ["token_id"]
              : jsonDecode(userTransactionHistory[index].parameter!.value)[0]
                  ["txs"][0]["token_id"]))
      .isEmpty;

  String getImageUrl(int index) => accController.tokensList
      .where((p0) => p0.tokenAddress!
          .contains(userTransactionHistory[index].target!.address!))
      .first
      .thumbnailUri!;
  TokenPriceModel fa2TokenName(int index) => accController.tokensList
      .firstWhere((p0) =>
          (p0.tokenAddress!.contains(
              userTransactionHistory[index].target!.address!)) &&
          p0.tokenId!.contains(userTransactionHistory[index].parameter!.value
                  is List
              ? userTransactionHistory[index].parameter?.value[0]["txs"][0]
                  ["token_id"]
              : jsonDecode(userTransactionHistory[index].parameter!.value)[0]
                  ["txs"][0]["token_id"]));

  TokenPriceModel fa1TokenName(int index) => accController.tokensList
      .where((p0) => (p0.tokenAddress!
          .contains(userTransactionHistory[index].target!.address!)))
      .first;

  bool isFa1TokenEmpty(int index) => accController.tokensList
      .where((p0) => (p0.tokenAddress!
          .contains(userTransactionHistory[index].target!.address!)))
      .isEmpty;
  bool isHashSame(int index) =>
      userTransactionHistory[index]
          .hash!
          .contains(userTransactionHistory[index - 1].hash!) &&
      userTransactionHistory[index].hash!.contains(userTransactionHistory[
              userTransactionHistory.length - 1 == index ? index : index + 1]
          .hash!);
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class TokenInfo {
  final String name;
  final String imageUrl;
  final bool isNft;
  final bool skip;
  final int index;
  final double tokenAmount;
  final double dollarAmount;
  final String tokenSymbol;
  final String id;
  final TxHistoryModel? token;

  TokenInfo(
      {this.name = "Tezos",
      this.imageUrl = "${PathConst.ASSETS}tezos_logo.png",
      this.isNft = false,
      this.skip = false,
      this.dollarAmount = 0,
      this.tokenSymbol = "tez",
      this.tokenAmount = 0,
      this.id = "",
      this.token,
      required this.index});
}
