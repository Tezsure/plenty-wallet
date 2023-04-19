import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/utils/bottom_sheet_manager.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:simple_gql/simple_gql.dart';

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
  RxBool isLoading = true.obs;
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
  List contracts = [];
  // ! NFT Related Variables
  RxMap<String, List<NftTokenModel>> userNfts =
      <String, List<NftTokenModel>>{}.obs; // List of user nfts
  RxBool isCollectibleListExpanded =
      false.obs; // false = show 3 collectibles, true = show all collectibles

  int contractOffset = 0;
  int? callbackHash;
  bool isLoadingMore = false;
  RxBool nftLoading = false.obs;
  // ! Others
  RxBool isAccountDelegated =
      false.obs; // To check if current account is delegated

  static int _pinnedTokens = 0;
  static int _hiddenTokens = 0;

/*   fetchAllNftscallback(_) {
    // print("NFT Updated");
    _fetchAllNfts();
  } */

  // ! Global Functions

  @override
  void onInit() async {
    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback((value) {
      xtzPrice.value = value;
    });

/*     callbackHash = fetchAllNftscallback.hashCode; */
    //print("acc $callbackHash");

/*     DataHandlerService()
        .renderService
        .accountNft
        .registerCallback(fetchAllNftscallback); */

    homePageController.userAccounts.listen((event) {
      fetchAllTokens();
      // _fetchAllNfts();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      fetchAllTokens();
      fetchAllNfts();
    });

    selectedTokenIndexSet.clear();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();

    /* DataHandlerService().renderService.accountNft.removeCallback(callbackHash); */
    print("Closed nft callback");
  }

  /// Fetches all the user tokens
  Future<void> fetchAllTokens() async {
    if (homePageController.userAccounts.isEmpty) return;

    isLoading.value = true;
    String tokens =
        await DataHandlerService().renderService.getTokenPriceModelString();
    await UserStorageService()
        .getUserTokensString(userAddress: selectedAccount.value.publicKeyHash!)
        .then(
      (value) async {
        //userTokens.addAll();

        List<dynamic> data = await compute(
            tokensProcess,
            [
              value,
              xtzPrice.value,
              selectedAccount.value.accountDataModel!.xtzBalance!,
              tokens
            ],
            debugLabel: "tokensProcess");
/*       userTokens,
      pinnedTokens,
      hiddenTokens,
      minTokens,
      pinnedList,
      unPinnedList */

        userTokens.clear();
        var uniqueTokens = <AccountTokenModel>[];
        for (var token in data[0]) {
          if (uniqueTokens
              .where((element) =>
                  element.contractAddress == token.contractAddress &&
                  element.tokenId == token.tokenId)
              .isEmpty) {
            uniqueTokens.add(token);
          }
        }
        if ((ServiceConfig.currentNetwork) == NetworkType.mainnet) {
          userTokens.addAll(uniqueTokens);
          userTokens.sort(tokenComparator);
          userTokens.value = userTokens.value;
          _pinnedTokens = data[1];
          _hiddenTokens = data[2];
          minTokens.value = data[3];
          pinnedList.value = data[4];
          unPinnedList.value = data[5];
          tokensList.value = data[6];
          pinnedList.refresh();
          unPinnedList.refresh();
          isLoading.value = false;
        } else {
          userTokens.addAll(uniqueTokens);
          userTokens.sort(tokenComparator);
          userTokens.removeWhere((element) =>
              element.name == null || element.name!.toLowerCase() != "tezos");
          userTokens.value = userTokens.value;
          _pinnedTokens = 1;
          _hiddenTokens = 0;
          //minTokens.value = data[3];
          pinnedList.value = data[4];
          pinnedList.removeWhere((element) =>
              element.name == null || element.name!.toLowerCase() != "tezos");
          unPinnedList.value = [];
          tokensList.value = data[6];

          pinnedList.refresh();
          unPinnedList.refresh();
          isLoading.value = false;
        }
      },
    );

/*     userTokens.sort(tokenComparator);
    _pinnedTokens = userTokens.indexWhere((element) => !element.isPinned);
    _hiddenTokens = userTokens.indexWhere((element) => element.isHidden);
    _pinnedTokens = _pinnedTokens < 0 ? userTokens.length : _pinnedTokens;
    minTokens.value = min(4, userTokens.length); // setting the default value
    minTokens.value = max<int>(_pinnedTokens,
        minTokens.value); // Either show default tokens or pinned tokens
    pinnedList.value = userTokens.sublist(0, minTokens.value);
    unPinnedList.value = userTokens.sublist(minTokens.value);
    pinnedList.refresh();
    unPinnedList.refresh(); */

    //_tokenSort();
    // _updateUserTokenList();
  }

  static List<dynamic> tokensProcess(
      /* String tokens, double xtzPrice, double xtzBalance */ List<dynamic>
          args) {
    List<AccountTokenModel> userTokens = jsonDecode(args[0])
        .map<AccountTokenModel>((e) => AccountTokenModel.fromJson(e))
        .toList();

    userTokens.removeWhere((element) =>
        element.name != null && element.name!.toLowerCase() == "tezos");

    AccountTokenModel tezos = AccountTokenModel(
      name: "Tezos",
      balance: args[2],
      contractAddress: "xtz",
      symbol: "tez",
      currentPrice: args[1],
      tokenId: "0",
      decimals: 6,
      iconUrl: "assets/tezos_logo.png",
    );
    // userTokens = [...userTokens.toSet().toList()];
    userTokens.insert(0, tezos);
    userTokens.sort((a, b) {
      if (a.isPinned || a.name?.toLowerCase() == 'tezos') {
        return -1;
      } else if (b.isPinned || b.name?.toLowerCase() == 'tezos') {
        return 1;
      } else {
        if (b.isHidden) {
          return -1;
        } else if (a.isHidden) {
          return 1;
        } else {
          if (a.balance * (a.currentPrice ?? 0 * args[1]) >
              b.balance * (b.currentPrice ?? 0 * args[1])) {
            return -1;
          } else if (a.balance * (a.currentPrice ?? 0 * args[1]) <
              b.balance * (b.currentPrice ?? 0 * args[1])) {
            return 1;
          } else {
            return 0;
          }
        }
      }
    });

    int pinnedTokens = userTokens.lastIndexWhere((element) => element.isPinned);
    int hiddenTokens = userTokens.indexWhere((element) => element.isHidden);
    pinnedTokens = _pinnedTokens < 0 ? userTokens.length : pinnedTokens;
    int minTokens = min(4, userTokens.length); // setting the default value
    minTokens = max<int>(
        pinnedTokens, minTokens); // Either show default tokens or pinned tokens
    List<AccountTokenModel> pinnedList = userTokens.sublist(0, minTokens);
    List<AccountTokenModel> unPinnedList = userTokens.sublist(minTokens);
    List<TokenPriceModel> tokensList = jsonDecode(args[3])["contracts"]
        .map<TokenPriceModel>((e) => TokenPriceModel.fromJson(e))
        .toList();
    return [
      userTokens,
      pinnedTokens,
      hiddenTokens,
      minTokens,
      pinnedList,
      unPinnedList,
      tokensList
    ];
  }

  /// Fetches the user account NFTs
  Future<void> fetchAllNfts() async {
    // userNfts.clear();
    if (selectedAccount.value.publicKeyHash == null ||
        ServiceConfig.currentNetwork == NetworkType.testnet) return;
    isLoadingMore = true;
    if (contractOffset == 0) {
      nftLoading.value = true;
    }
    UserStorageService()
        .getUserNftsString(userAddress: selectedAccount.value.publicKeyHash!)
        .then((nftList) async {
      nftList ??= "[]";
      contracts = jsonDecode(nftList);
      userNfts.value = await compute(
          nftsIsolate,
          [
            [selectedAccount.value.publicKeyHash!],
            contracts.skip(contractOffset).take(10).toList(),
            userNfts.value
          ],
          debugLabel: "getUserNft ACCOUNT SUMMARY");
      contractOffset += 10;
      isLoadingMore = false;
      nftLoading.value = false;

/*       for (var i = 0; i < nftList.length; i++) {
        userNfts[nftList[i].fa!.contract!] =
            (userNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
      } */
    });
  }

  static Future<Map<String, List<NftTokenModel>>> nftsIsolate(
      /* int offsetContract,
      List<String> publicKeyHashes, List<String> contracts */
      List data) async {
    {
      int offset = 0;
      List<NftTokenModel> nfts = [];
      while (true) {
        final response = await GQLClient(
          'https://data.objkt.com/v3/graphql',
        ).query(
          query: ServiceConfig.getNftsFromContracts,
          variables: {
            'contracts': data[1],
            'holders': data[0],
            'offset': offset,
          },
        );
        nfts = [
          ...nfts,
          ...(response.data['token'])
              .map<NftTokenModel>((e) => NftTokenModel.fromJson(e))
              .toList()
        ];
        offset += 500;
        if (response.data['token'].length != 500) {
          break;
        }
      }
      Map<String, List<NftTokenModel>> userNfts = data[2];
      for (var i = 0; i < nfts.length; i++) {
        userNfts[nfts[i].faContract!] = (userNfts[nfts[i].faContract!] ?? [])
          ..add(nfts[i]);
      }
      return userNfts;
    }
  }

/*   static Map<String, List<NftTokenModel>> getUserNft(String nfts) {
    List<NftTokenModel> nftList = jsonDecode(nfts)
        .map<NftTokenModel>((e) => NftTokenModel.fromJson(e))
        .toList();
    Map<String, List<NftTokenModel>> userNfts = <String, List<NftTokenModel>>{};
    for (var i = 0; i < nftList.length; i++) {
      userNfts[nftList[i].fa!.contract!] =
          (userNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
    }
    return userNfts;
  } */

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
      Get.back();
      Get.find<AccountsWidgetController>().onPageChanged(index);
      Get.find<HomePageController>().changeSelectedAccount(index);
      //selectedAccountIndex.value = index;
      selectedAccount.value = homePageController.userAccounts[index];
      contracts.clear();
      contractOffset = 0;
      userNfts.clear();
      fetchAllTokens();
      fetchAllNfts();
      loadUserTransaction();
    }
  }

  Future<void> refreshTokens() async {
    await DataHandlerService().updateTokens();
    await fetchAllTokens();
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
/*     fetchAllTokens();
    _fetchAllNfts(); */
    loadUserTransaction();
    contracts.clear();
    userNfts.clear();
    contractOffset = 0;
    fetchAllNfts();
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
    HomePageController homePageController = Get.find<HomePageController>();
    if (a.isPinned || a.name?.toLowerCase() == 'tezos') {
      return -1;
    } else if (b.isPinned || b.name?.toLowerCase() == 'tezos') {
      return 1;
    } else {
      if (b.isHidden) {
        return -1;
      } else if (a.isHidden) {
        return 1;
      } else {
        if (a.balance *
                (a.currentPrice ?? 0 * homePageController.xtzPrice.value) >
            b.balance *
                (b.currentPrice ?? 0 * homePageController.xtzPrice.value)) {
          return -1;
        } else if (a.balance *
                (a.currentPrice ?? 0 * homePageController.xtzPrice.value) <
            b.balance *
                (b.currentPrice ?? 0 * homePageController.xtzPrice.value)) {
          return 1;
        } else {
          return 0;
        }
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

  bool get showPinButton {
    if (selectedTokenIndexSet.isEmpty) {
      return true;
    }

    bool anySelectedTokenIsPinned = selectedTokenIndexSet
        .any((index) => index > 0 && index < _pinnedTokens + 1);

    // If any selected token (other than the default one) is pinned, return false.
    if (anySelectedTokenIsPinned) {
      return false;
    }

    // Otherwise, return true if all selected tokens are in the same list (pinned or unpinned).
    return (selectedTokenIndexSet.first <= _pinnedTokens + 1 &&
            selectedTokenIndexSet.last < _pinnedTokens + 1) ||
        (selectedTokenIndexSet.first >= _pinnedTokens + 1 &&
            selectedTokenIndexSet.last >= _pinnedTokens + 1);
  }

  bool get showHideButton =>
      selectedTokenIndexSet.isEmpty ||
      selectedTokenIndexSet.first < _hiddenTokens ||
      _pinnedTokens == userTokens.length ||
      _hiddenTokens == -1;

  bool get pinAll {
    if (selectedTokenIndexSet.isEmpty) {
      return false;
    }

    return selectedTokenIndexSet.every((index) => index < _pinnedTokens + 1);
  }

  void onPinToken() {
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

    _tokenSort();
    selectedTokenIndexSet.clear();
    isEditable.value = false;
    _updateUserTokenList();
    fetchAllTokens();
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
    fetchAllTokens();
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
