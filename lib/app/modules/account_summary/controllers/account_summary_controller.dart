import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../data/services/data_handler_service/data_handler_service.dart';
import '../../../data/services/service_models/account_model.dart';
import '../../../data/services/service_models/nft_token_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';

class AccountSummaryController extends GetxController {
  // ! Global Variables

  final HomePageController homePageController = Get.find<HomePageController>();
  Rx<ScrollController> paginationController =
      ScrollController().obs; // For Transaction history lazy loading

  // ! Account Related Variables

  RxInt selectedAccountIndex = 0.obs; // The selected account index
  RxBool isAccountEditable = false.obs; // To edit account selector
  Rx<AccountModel> userAccount =
      AccountModel(isNaanAccount: true).obs; // Current selected account

  // ! Token Related Variables

  RxBool isEditable = false.obs; // for token edit mode
  RxBool expandTokenList =
      false.obs; // false = show 3 tokens, true = show all tokens
  RxDouble xtzPrice = 0.0.obs; // Current xtz price
  RxList<AccountTokenModel> userTokens =
      <AccountTokenModel>[].obs; // List of user tokens

  // ! NFT Related Variables

  RxMap<String, List<NftTokenModel>> userNfts =
      <String, List<NftTokenModel>>{}.obs; // List of user nfts
  RxBool isCollectibleListExpanded =
      false.obs; // false = show 3 collectibles, true = show all collectibles

  // ! Transaction Related Variables

  RxList<TxHistoryModel> userTransactionHistory =
      <TxHistoryModel>[].obs; // List of user transactions

  // ! Others
  RxBool isAccountDelegated =
      false.obs; // To check if current account is delegated

  @override
  void onInit() {
    userAccount.value = Get.arguments as AccountModel;
    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback((value) {
      xtzPrice.value = value;
    });
    fetchAllTokens();
    fetchAllNfts();
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
    } else if (homePageController.userAccounts[index].publicKeyHash!
            .contains(userAccount.value.publicKeyHash!) &&
        index == homePageController.userAccounts.length - 1) {
      userAccount.value = homePageController.userAccounts[index - 1];
      selectedAccountIndex.value = index - 1;
    } else if (index == homePageController.userAccounts.length - 1) {
      userAccount.value = homePageController.userAccounts[index - 1];
      selectedAccountIndex.value = index - 1;
    } else {
      userAccount.value = homePageController.userAccounts[index];
      selectedAccountIndex.value = index;
    }
    fetchAllTokens();
    fetchAllNfts();
    Get
      ..back()
      ..back();
    isAccountEditable.value = false;
  }

  /// Turns the edit mode on or off
  void editAccount() {
    isAccountEditable.value = !isAccountEditable.value;
  }

  // ! Token Related Functions

  /// Move the selected indexes on top of the list when pin is clicked
  void onPinToken() {
    userTokens
      ..where((token) => token.isSelected && !token.isHidden)
          .toList()
          .forEach((element) {
        element.isPinned = true;
        userTokens.remove(element);
        userTokens.insert(0, element);
      })
      ..refresh();
    isEditable.value = false;
    expandTokenList.value = false;
    _updateUserTokenList();
  }

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
    _updateUserTokenList();
  }

  /// Move the tokens to the end of the list when hide is clicked
  void onHideToken() {
    userTokens
      ..where((token) => token.isSelected && !token.isPinned)
          .toList()
          .forEach((element) {
        element.isHidden = true;
        userTokens.remove(element);
        userTokens.add(element);
      })
      ..refresh();
    isEditable.value = false;
    expandTokenList.value = false;
    _updateUserTokenList();
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

  /// Number of pinned tokens in the user token list
  int checkPinHideTokenList() =>
      userTokens.where((e) => e.isPinned == true).toList().length;

  /// Loades the user transaction history, and updates the UI after user taps on history tab
  Future<void> userTransactionLoader() async {
    paginationController.value.removeListener(() {});
    userTransactionHistory.value = await fetchUserTransactionsHistory();
    paginationController.value.addListener(() async {
      if (paginationController.value.position.pixels ==
          paginationController.value.position.maxScrollExtent) {
        userTransactionHistory.addAll(await fetchUserTransactionsHistory(
            lastId: userTransactionHistory.last.id.toString()));
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

  // ! NFT Related Functions

  /// Fetches the user account NFTs
  Future<void> fetchAllNfts() async {
    userNfts.clear();
    UserStorageService()
        .getUserNfts(userAddress: userAccount.value.publicKeyHash!)
        .then((nftList) {
      for (int i = 0; i < nftList.length; i++) {
        userNfts[nftList[i].fa!.contract!] =
            (userNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
      }
    });
  }
}
