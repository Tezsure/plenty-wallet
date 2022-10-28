import 'dart:async';
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
  Set<String> pinTokenSet = {}, // Set of pinned accounts
      hideTokenSet = {}, // Set of hidden accounts
      selectedTokenSet = {}; // Set of selected accounts

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
    fetchAllTokens();
    fetchAllNfts();
    tokensList.value =
        await DataHandlerService().renderService.getTokenPriceModel();
    updateSavedContacts();
    super.onInit();
  }

  @override
  void onClose() {
    paginationController.value.dispose();
    super.onClose();
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
    fetchAllTokens();
    fetchAllNfts();
    userTransactionLoader();
    updatePinHideTokenSet();
  }

  /// Remove account from the account list
  void removeAccount(int index) {
    // Check whether deleted account was selected account and last in the list, then assign the second last element to current account
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
    fetchAllTokens();
    fetchAllNfts();
    updatePinHideTokenSet();
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

  /// Fetches all the user tokens
  Future<void> fetchAllTokens() async {
    userTokens.clear();
    userTokens.addAll(await UserStorageService()
        .getUserTokens(userAddress: userAccount.value.publicKeyHash!));
    if (userTokens.isEmpty) {
      userTokens.add(AccountTokenModel(
        name: "Tezos",
        balance: userAccount.value.accountDataModel!.xtzBalance!,
        contractAddress: "xtz",
        symbol: "Tezos",
        currentPrice: xtzPrice.value,
        tokenId: "0",
        decimals: 6,
        iconUrl: "assets/tezos_logo.png",
      ));
    } else {
      if (userTokens.any((element) => element.name!.contains("Tezos"))) {
        userTokens.map((element) => element.name!.contains("Tezos")
            ? element.copyWith(
                balance: userAccount.value.accountDataModel!.xtzBalance!,
                currentPrice: xtzPrice.value,
              )
            : null);
      } else {
        userTokens.insert(
            0,
            AccountTokenModel(
              name: "Tezos",
              balance: userAccount.value.accountDataModel!.xtzBalance!,
              contractAddress: "xtz",
              symbol: "Tezos",
              currentPrice: xtzPrice.value,
              tokenId: "0",
              decimals: 6,
              iconUrl: "assets/tezos_logo.png",
            ));
      }
    }
    updatePinHideTokenSet();
    _updateUserTokenList();
  }

  bool get hideButtonColor => selectedTokenSet.isEmpty ? false : true;

  bool get pinButtonColor => selectedTokenSet.isEmpty ? false : true;

  bool get onPinTokenClick {
    if (selectedTokenSet.isEmpty) {
      return true;
    } else if (pinTokenSet.containsAll(selectedTokenSet)) {
      return false;
    } else {
      return true;
    }
  }

  bool get onHideTokenClick {
    if (selectedTokenSet.isEmpty) {
      return true;
    } else if (hideTokenSet.containsAll(selectedTokenSet)) {
      return false;
    } else {
      return true;
    }
  }

  void updatePinHideTokenSet() {
    isEditable.value = false;
    selectedTokenSet.clear();
    pinTokenSet.clear();
    hideTokenSet.clear();
    pinTokenSet.addAll(// ? This is for pinned accounts
        userTokens.where((p) => p.isPinned).map((e) => e.name!).toList());
    hideTokenSet.addAll(// ? This is for hidden accounts
        userTokens.where((p) => p.isHidden).map((e) => e.name!).toList());
  }

  void onEditTap() {
    isEditable.value = !isEditable.value;
    for (var element in userTokens) {
      if (pinTokenSet.contains(element.name)) {
        element
          ..isPinned = true
          ..isSelected = false;
      } else if (hideTokenSet.contains(element.name)) {
        element
          ..isHidden = true
          ..isSelected = false;
      } else {
        element
          ..isPinned = false
          ..isHidden = false
          ..isSelected = false;
      }
    }
    selectedTokenSet.clear();
    userTokens.refresh();
    _updateUserTokenList();
  }

  /// Move the selected indexes on top of the list when pin is clicked
  void onPinToken() {
    //? If tokens are selected
    if (selectedTokenSet.isNotEmpty) {
      //? If new tokens are selected, pin them to the top, and if hidden remove from hide list
      if (pinTokenSet.isEmpty) {
        for (var name in selectedTokenSet) {
          int index = userTokens.indexWhere((element) => element.name == name);
          AccountTokenModel token = userTokens[index]
            ..isPinned = true
            ..isHidden = false;
          userTokens[index] = token;
          hideTokenSet.remove(name);
          pinTokenSet.add(name);
        }
      } else if (pinTokenSet.containsAll(selectedTokenSet)) {
        //? If tokens are already pinned and are in pinnedTokenSet, unpin them and remove from the set
        for (var name in selectedTokenSet) {
          int index = userTokens.indexWhere((element) => element.name == name);
          AccountTokenModel token = userTokens[index]
            ..isPinned = false
            ..isHidden = false
            ..isSelected = false;

          userTokens[index] = token;
        }
        pinTokenSet.removeAll(selectedTokenSet);
      } else {
        //? If both the selected and pinned tokens are present, pin both the tokens
        for (var name in selectedTokenSet) {
          int index = userTokens.indexWhere((element) => element.name == name);
          AccountTokenModel token = userTokens[index]
            ..isPinned = true
            ..isHidden = false;
          if (pinTokenSet.contains(name)) {
            userTokens[index] = token;
          } else {
            userTokens
              ..insert(index, token)
              ..removeAt(index);
          }
          hideTokenSet.remove(name);
          pinTokenSet.add(token.name!);
        }
      }
    }
    if (pinTokenSet.length < 5) {
      for (var element in userTokens) {
        if (element.isPinned) {
          userTokens.remove(element);
          userTokens.insert(0, element);
        }
      }
    }

    selectedTokenSet.clear();
    userTokens.refresh();
    isEditable.value = false;
    _updateUserTokenList();
  }

  /// Move the tokens to the end of the list when hide is clicked
  void onHideToken() {
    //? If tokens are selected
    if (selectedTokenSet.isNotEmpty) {
      //? If new tokens are selected, hide them to the bottom
      if (hideTokenSet.isEmpty) {
        for (var name in selectedTokenSet) {
          int index = userTokens.indexWhere((element) => element.name == name);
          AccountTokenModel token = userTokens[index]
            ..isHidden = true
            ..isPinned = false;
          userTokens
            ..add(token)
            ..removeAt(index);
          hideTokenSet.add(token.name!);
          pinTokenSet.remove(name);
        }
      } else if (hideTokenSet.containsAll(selectedTokenSet)) {
        //? If tokens are already hidden and are in hideAccountSet, unhide them and remove from the set
        for (var name in selectedTokenSet) {
          int index = userTokens.indexWhere((element) => element.name == name);
          AccountTokenModel token = userTokens[index]
            ..isPinned = false
            ..isHidden = false
            ..isSelected = false;
          userTokens[index] = token;
          pinTokenSet.remove(name);
        }
        hideTokenSet.removeAll(selectedTokenSet);
        for (var element in userTokens) {
          if (element.isHidden) {
            userTokens.remove(element);
            userTokens.add(element);
          }
        }
      } else {
        //? If both the selected and hide tokens are present, hide both the tokens
        for (var name in selectedTokenSet) {
          int index = userTokens.indexWhere((element) => element.name == name);
          AccountTokenModel token = userTokens[index]
            ..isPinned = false
            ..isHidden = true;
          if (hideTokenSet.contains(name)) {
            userTokens[index] = token;
          } else {
            userTokens
              ..removeAt(index)
              ..add(token);
          }
          pinTokenSet.remove(name);
          hideTokenSet.add(token.name!);
        }
      }
    }
    isEditable.value = false;
    selectedTokenSet.clear();
    userTokens.refresh();
    _updateUserTokenList();
  }

  void onCheckBoxTap(int index) {
    //? If no tokens is selected
    if (selectedTokenSet.isEmpty) {
      selectedTokenSet.add(userTokens[index].name!);
      userTokens[index].isSelected = true;
    } else {
      //? If tokens are selected
      if (selectedTokenSet.contains(userTokens[index].name)) {
        //? If tokens were pinned previously, revert to default
        if (pinTokenSet.contains(userTokens[index].name)) {
          userTokens[index]
            ..isPinned = !userTokens[index].isPinned
            ..isSelected = false;
          selectedTokenSet.remove(userTokens[index].name);
        } else if (hideTokenSet.contains(userTokens[index].name)) {
          //? If tokens were hidden previously, revert to default
          userTokens[index]
            ..isHidden = !userTokens[index].isHidden
            ..isSelected = false;
          selectedTokenSet.remove(userTokens[index].name);
        } else {
          //? If tokens were selected previously,
          selectedTokenSet.remove(userTokens[index].name);
          userTokens[index].isSelected = !userTokens[index].isSelected;
        }
      } else {
        //? If tokens were not selected previously
        selectedTokenSet.add(userTokens[index].name!);
        userTokens[index].isSelected = true;
      }
    }
    userTokens.refresh();
  }

  void isPinTapped(int index) {
    //? If token is pinned, remove from pinned token set and add to selected account set
    if (userTokens[index].isPinned == true) {
      userTokens[index]
        ..isPinned = !userTokens[index].isPinned
        ..isSelected = true;
      userTokens.refresh();
      selectedTokenSet.add(userTokens[index].name!);
    }
  }

  void isHideTapped(int index) {
    //? If token is hidden, remove from hidden token set and add to selected account set
    if (userTokens[index].isHidden == true) {
      userTokens[index]
        ..isHidden = !userTokens[index].isHidden
        ..isSelected = true;
      selectedTokenSet.add(userTokens[index].name!);
      userTokens.refresh();
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

  /// Fetches the user account NFTs
  Future<void> fetchAllNfts() async {
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
