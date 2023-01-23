import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../data/services/data_handler_service/data_handler_service.dart';
import '../../../data/services/service_models/account_model.dart';
import '../../../data/services/service_models/nft_token_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';

class AccountSummaryController extends GetxController {
  // ! Global Variables
  final HomePageController homePageController = Get.find<HomePageController>();
  Rx<AccountModel> get selectedAccount =>
      homePageController.userAccounts.isEmpty
          ? AccountModel(isNaanAccount: false).obs
          : homePageController
              .userAccounts[homePageController.selectedIndex.value].obs;
  RxList<TokenPriceModel> tokensList = <TokenPriceModel>[].obs;

  // ! Account Related Variables
  // RxInt selectedAccountIndex = 0.obs; // The selected account index
  RxBool isAccountEditable = false.obs; // To edit account selector
  // Rx<AccountModel> userAccount =
  //     AccountModel(isNaanAccount: true).obs; // Current selected account
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

  // ! Others
  RxBool isAccountDelegated =
      false.obs; // To check if current account is delegated

  // ! Global Functions
  @override
  void onInit() async {
    // if (Get.arguments == null) {
    // if (Get.find<HomePageController>().userAccounts.isNotEmpty) {
    // userAccount.value = Get.find<HomePageController>().userAccounts[0];
    // }
    // } else {
    //   userAccount.value = Get.arguments as AccountModel;
    // }
    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback((value) {
      xtzPrice.value = value;
    });
    fetchAllTokens();
    _fetchAllNfts();
    tokensList.value =
        await DataHandlerService().renderService.getTokenPriceModel();
    selectedTokenIndexSet.clear();
    super.onInit();
  }

  /// Fetches all the user tokens
  Future<void> fetchAllTokens() async {
    userTokens.clear();
    if (homePageController.userAccounts.isEmpty) return;
    AccountTokenModel tezos = AccountTokenModel(
      name: "Tezos",
      balance: homePageController
          .userAccounts[homePageController.selectedIndex.value]
          .accountDataModel!
          .xtzBalance!,
      contractAddress: "xtz",
      symbol: "tezos",
      currentPrice: xtzPrice.value,
      tokenId: "0",
      decimals: 6,
      iconUrl: "assets/tezos_logo.png",
    );
    if ((await RpcService.getCurrentNetworkType()) == NetworkType.mainnet) {
      userTokens.addAll(await UserStorageService()
          .getUserTokens(userAddress: selectedAccount.value.publicKeyHash!));
    }
    userTokens.value = userTokens.toSet().toList();
    if (userTokens.isNotEmpty &&
        userTokens.any((element) => element.name!.toLowerCase() == "tezos")) {
      userTokens.map((element) => element.name!.toLowerCase() == "tezos"
          ? element.copyWith(
              balance: selectedAccount.value.accountDataModel!.xtzBalance!,
              currentPrice: xtzPrice.value,
            )
          : null);
    } else {
      selectedAccount.value.accountDataModel!.xtzBalance! == 0
          ? null
          : userTokens.insert(0, tezos);
    }
    _tokenSort();
    // _updateUserTokenList();
  }

  /// Fetches the user account NFTs
  Future<void> _fetchAllNfts() async {
    userNfts.clear();
    if (selectedAccount.value.publicKeyHash == null) return;
    UserStorageService()
        .getUserNfts(userAddress: selectedAccount.value.publicKeyHash!)
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
        .contains(selectedAccount.value.publicKeyHash!)) {
      selectedAccount.update((val) {
        val!.name = changedValue;
      });
    }
    isAccountEditable.value = false;
    Get
      ..back()
      ..back();
  }

  void loadUserTransaction() =>
      Get.find<TransactionController>().userTransactionLoader();

  /// Changes the current selected account from the account list
  void onAccountTap(int index) {
    if (!_isSelectedAccount(index)) {
      Get.find<AccountsWidgetController>().onPageChanged(index);
      // selectedAccountIndex.value = index;
      // selectedAccount.value = homePageController.userAccounts[index];
      fetchAllTokens();
      _fetchAllNfts();
      loadUserTransaction();
    }
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
      if (_isSelectedAccount(index)) {
        Get.find<AccountsWidgetController>().onPageChanged(index - 1);
        // selectedAccount.value = homePageController.userAccounts[index - 1];
      }
    } else {
      if (_isSelectedAccount(index)) {
        Get.find<AccountsWidgetController>().onPageChanged(index);
        // selectedAccount.value = homePageController.userAccounts[index + 1];
      }
    }
    selectedAccount.refresh();
    fetchAllTokens();
    _fetchAllNfts();
    loadUserTransaction();
    Get
      ..back()
      ..back();
    isAccountEditable.value = false;
  }

  bool _isSelectedAccount(int index) =>
      homePageController.userAccounts[index].publicKeyHash!
          .contains(selectedAccount.value.publicKeyHash!);

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
    minTokens.value = min(4, userTokens.length); // setting the default value
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
          userAddress: selectedAccount.value.publicKeyHash!,
        )
        .whenComplete(() async => userTokens.value = await UserStorageService()
            .getUserTokens(userAddress: selectedAccount.value.publicKeyHash!));
  }
}
