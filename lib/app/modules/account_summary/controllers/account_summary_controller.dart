import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/history_filter_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/pages/history_tab.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../data/services/data_handler_service/data_handler_service.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../../data/services/service_models/account_model.dart';
import '../../../data/services/service_models/contact_model.dart';
import '../../../data/services/service_models/nft_token_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';

class AccountSummaryController extends GetxController {
  // ! Global Variables

  final HomePageController homePageController = Get.find<HomePageController>();
  Rx<ScrollController> paginationController =
      ScrollController().obs; // For Transaction history lazy loading

  RxList<TokenPriceModel> tokensList = <TokenPriceModel>[].obs;
  Timer? searchDebounceTimer;
  RxList<TokenInfo> tokenInfoList = <TokenInfo>[].obs;
  Set<String> tokenTransactionID = <String>{};
  RxBool isFilterApplied = false.obs;

  // ! Account Related Variables

  RxInt selectedAccountIndex = 0.obs; // The selected account index
  RxBool isAccountEditable = false.obs; // To edit account selector
  Rx<AccountModel> userAccount =
      AccountModel(isNaanAccount: true).obs; // Current selected account
  RxBool isPopupVisible = false.obs; // To show popup
  RxInt popupIndex = 0.obs; // To show popup

  // ! Token Related Variables

  RxBool isEditable = false.obs; // for token edit mode
  RxBool expandTokenList =
      false.obs; // false = show 3 tokens, true = show all tokens
  RxDouble xtzPrice = 0.0.obs; // Current xtz price
  RxList<AccountTokenModel> userTokens =
      <AccountTokenModel>[].obs; // List of user tokens
  SplayTreeSet<int> selectedTokenIndexSet =
      SplayTreeSet(); // Set of selected accounts index
  RxInt minTokens = 4.obs;
  RxList<AccountTokenModel> pinnedList = <AccountTokenModel>[].obs;
  RxList<AccountTokenModel> unPinnedList = <AccountTokenModel>[].obs;

  // ! NFT Related Variables

  RxMap<String, List<NftTokenModel>> userNfts =
      <String, List<NftTokenModel>>{}.obs; // List of user nfts
  RxBool isCollectibleListExpanded =
      false.obs; // false = show 3 collectibles, true = show all collectibles

  // ! Transaction Related Variables

  RxList<TxHistoryModel> userTransactionHistory =
      <TxHistoryModel>[].obs; // List of user transactions
  RxBool isTransactionPopUpOpened = false.obs; // To show popup

  // ! Others
  RxBool isAccountDelegated =
      false.obs; // To check if current account is delegated

  // ! Global Functions
  @override
  void onInit() async {
    tokenInfoList.clear();
    userAccount.value = Get.arguments as AccountModel;
    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback((value) {
      xtzPrice.value = value;
    });
    _fetchAllTokens();
    _fetchAllNfts();
    tokensList.value =
        await DataHandlerService().renderService.getTokenPriceModel();
    selectedTokenIndexSet.clear();
    updateSavedContacts();
    super.onInit();
  }

  @override
  void onClose() {
    paginationController.value.dispose();
    super.onClose();
  }

  /// Fetches all the user tokens
  Future<void> _fetchAllTokens() async {
    userTokens.clear();
    AccountTokenModel tezos = AccountTokenModel(
      name: "Tezos",
      balance: userAccount.value.accountDataModel!.xtzBalance!,
      contractAddress: "xtz",
      symbol: "Tezos",
      currentPrice: xtzPrice.value,
      tokenId: "0",
      decimals: 6,
      iconUrl: "assets/tezos_logo.png",
    );
    userTokens.addAll(await UserStorageService()
        .getUserTokens(userAddress: userAccount.value.publicKeyHash!));
    if (userTokens.isEmpty) {
      userTokens.add(tezos);
    } else {
      if (userTokens.any((element) => element.name!.contains("Tezos"))) {
        userTokens.map((element) => element.name!.contains("Tezos")
            ? element.copyWith(
                balance: userAccount.value.accountDataModel!.xtzBalance!,
                currentPrice: xtzPrice.value,
              )
            : null);
      } else {
        userTokens.insert(0, tezos);
      }
    }
    _tokenSort();

    _updateUserTokenList();
  }

  /// Fetches the user account NFTs
  Future<void> _fetchAllNfts() async {
    userNfts.clear();
    UserStorageService()
        .getUserNfts(userAddress: userAccount.value.publicKeyHash!)
        .then((nftList) {
      for (var i = 0; i < nftList.length; i++) {
        userNfts[nftList[i].fa!.contract!] =
            (userNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
      }
    });
  }

  // ! Account Related Functions

  /// Change Selected Account Name
  void changeSelectedAccountName(
      {required int accountIndex, required String changedValue}) {
    if (homePageController.userAccounts[accountIndex].publicKeyHash!
        .contains(userAccount.value.publicKeyHash!)) {
      userAccount.update((val) {
        val!.name = changedValue;
      });
    }
    isAccountEditable.value = false;
    Get
      ..back()
      ..back();
  }

  /// Changes the current selected account from the account list
  void onAccountTap(int index) {
    selectedAccountIndex.value = index;
    userAccount.value = homePageController.userAccounts[index];
    _fetchAllTokens();

    _fetchAllNfts();
    userTransactionLoader();
  }

  /// Remove account from the account list
  void removeAccount(int index) {
    // Check whether deleted account was selected account and last in the list,
    //then assign the second last element to current account
    if (index == 0 && homePageController.userAccounts.length == 1) {
      Get.rawSnackbar(
        message: "Can't delete only account",
        shouldIconPulse: true,
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: 0.9.width,
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        duration: const Duration(milliseconds: 1000),
      );
      return;
    } else if (index == homePageController.userAccounts.length - 1) {
      // When the last index is selected
      if (isSelectedAccount(index)) {
        selectedAccountIndex.value = index - 1;
        userAccount.value = homePageController.userAccounts[index - 1];
      }
    } else {
      if (isSelectedAccount(index)) {
        selectedAccountIndex.value = index;
        userAccount.value = homePageController.userAccounts[index + 1];
      }
    }
    userAccount.refresh();
    _fetchAllTokens();
    _fetchAllNfts();
    Get
      ..back()
      ..back();
    isAccountEditable.value = false;
  }

  bool isSelectedAccount(int index) =>
      homePageController.userAccounts[index].publicKeyHash!
          .contains(userAccount.value.publicKeyHash!);

  /// Turns the edit mode on or off
  void editAccount() {
    isAccountEditable.value = !isAccountEditable.value;
  }

  // ! Token Related Functions

  Comparator<AccountTokenModel> tokenComparator = (a, b) {
    a.isSelected = false;
    b.isSelected = false;
    if (a.isPinned) {
      return -1;
    } else if (b.isPinned) {
      return 1;
    } else {
      if (b.isHidden) {
        return -1;
      } else if (a.isHidden) {
        return 1;
      } else {
        return 0;
      }
    }
  };

  void _tokenSort() {
    userTokens.sort(tokenComparator);
    _pinnedTokens = userTokens.indexWhere((element) => !element.isPinned);
    _hiddenTokens = userTokens.indexWhere((element) => element.isHidden);
    _pinnedTokens = _pinnedTokens < 0 ? userTokens.length : _pinnedTokens;
    minTokens.value = min(4, userTokens.length);
    minTokens.value = max<int>(_pinnedTokens,
        minTokens.value); // Either show default tokens or pinned tokens
    pinnedList.value = userTokens.sublist(0, minTokens.value);
    unPinnedList.value = userTokens.sublist(minTokens.value);
    pinnedList.refresh();
    unPinnedList.refresh();
  }

  void onEditTap() {
    isEditable.value = !isEditable.value;
    for (var element in selectedTokenIndexSet) {
      if (element < minTokens.value) {
        pinnedList[element].isSelected = false;
      } else {
        unPinnedList[element - minTokens.value].isSelected = false;
      }
      userTokens[element].isSelected = false;
    }
    selectedTokenIndexSet.clear();
    pinnedList.refresh();
    unPinnedList.refresh();
    _updateUserTokenList();
  }

  static int _pinnedTokens = 0;
  static int _hiddenTokens = 0;

  bool get showPinButton =>
      selectedTokenIndexSet.isEmpty ||
      (selectedTokenIndexSet.first < _pinnedTokens &&
          selectedTokenIndexSet.last >= _pinnedTokens) ||
      selectedTokenIndexSet.first >= _pinnedTokens;

  bool get showHideButton =>
      selectedTokenIndexSet.isEmpty ||
      selectedTokenIndexSet.first < _hiddenTokens ||
      _pinnedTokens == userTokens.length ||
      _hiddenTokens == -1;

  bool get pinAll =>
      selectedTokenIndexSet.isNotEmpty &&
      selectedTokenIndexSet.first < _pinnedTokens &&
      selectedTokenIndexSet.last >= _pinnedTokens;

  void onPinToken() {
    if (pinAll) {
      for (var i in selectedTokenIndexSet) {
        if (userTokens[i].isPinned) {
          --_pinnedTokens;
        }
        userTokens[i]
          ..isPinned = true
          ..isSelected = false
          ..isHidden = false;
        if (userTokens[i].isPinned) {
          ++_pinnedTokens;
        } else {
          --_pinnedTokens;
        }
      }
    } else {
      for (var i in selectedTokenIndexSet) {
        userTokens[i]
          ..isPinned = !userTokens[i].isPinned
          ..isSelected = false
          ..isHidden = false;
        if (userTokens[i].isPinned) {
          ++_pinnedTokens;
        } else {
          --_pinnedTokens;
        }
      }
    }
    _tokenSort();
    selectedTokenIndexSet.clear();
    isEditable.value = false;
    _updateUserTokenList();
  }

  void onHideToken() {
    if (showHideButton) {
      for (var i in selectedTokenIndexSet) {
        userTokens[i]
          ..isPinned = false
          ..isSelected = false
          ..isHidden = true;
      }
    } else {
      for (var i in selectedTokenIndexSet) {
        userTokens[i]
          ..isHidden = !userTokens[i].isHidden
          ..isSelected = false
          ..isPinned = false;
      }
    }
    _tokenSort();
    selectedTokenIndexSet.clear();
    isEditable.value = false;
    _updateUserTokenList();
  }

  void onCheckBoxTap(bool isPinnedList, int index) {
    if (isPinnedList) {
      pinnedList[index].isSelected = !pinnedList[index].isSelected;
      pinnedList.refresh();
    } else {
      unPinnedList[index].isSelected = !unPinnedList[index].isSelected;
      unPinnedList.refresh();
      index += minTokens.value;
    }
    userTokens[index].isSelected = !userTokens[index].isSelected;
    if (userTokens[index].isSelected) {
      selectedTokenIndexSet.add(index);
    } else {
      selectedTokenIndexSet.remove(index);
    }
  }

  /// Updates the user token list and stores it in the local storage
  Future<void> _updateUserTokenList() async {
    await UserStorageService()
        .updateUserTokens(
          accountTokenList: userTokens,
          userAddress: userAccount.value.publicKeyHash!,
        )
        .whenComplete(() async => userTokens.value = await UserStorageService()
            .getUserTokens(userAddress: userAccount.value.publicKeyHash!));
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
          accountAddress: userAccount.value.publicKeyHash!,
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

  // ! NFT Related Functions

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

  bool isFa2TokenListEmpty(int index) => tokensList
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

  String getImageUrl(int index) => tokensList
      .where((p0) => p0.tokenAddress!
          .contains(userTransactionHistory[index].target!.address!))
      .first
      .thumbnailUri!;
  TokenPriceModel fa2TokenName(int index) => tokensList.firstWhere((p0) =>
      (p0.tokenAddress!
          .contains(userTransactionHistory[index].target!.address!)) &&
      p0.tokenId!.contains(userTransactionHistory[index].parameter!.value
              is List
          ? userTransactionHistory[index].parameter?.value[0]["txs"][0]
              ["token_id"]
          : jsonDecode(userTransactionHistory[index].parameter!.value)[0]["txs"]
              [0]["token_id"]));

  TokenPriceModel fa1TokenName(int index) => tokensList
      .where((p0) => (p0.tokenAddress!
          .contains(userTransactionHistory[index].target!.address!)))
      .first;

  bool isFa1TokenEmpty(int index) => tokensList
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
