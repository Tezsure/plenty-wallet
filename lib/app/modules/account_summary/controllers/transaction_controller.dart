import 'dart:async';
import 'dart:math';

import 'package:beacon_flutter/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:plenty_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:plenty_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:plenty_wallet/app/modules/account_summary/models/token_info.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../utils/constants/path_const.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../../data/services/service_models/contact_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';
import 'history_filter_controller.dart';
import 'package:plenty_wallet/utils/utils.dart';

class TransactionController extends GetxController {
  final accController = Get.find<AccountSummaryController>();
  Rx<RefreshController> refreshController = RefreshController().obs;
  Timer? searchDebounceTimer;
  RxList<TxHistoryModel> userTransactionHistory =
      <TxHistoryModel>[].obs; // List of user transactions
  RxList<TransactionTransferModel> userTransferHistory =
      <TransactionTransferModel>[].obs; // List of user transactions
  // RxBool isTransactionPopUpOpened = false.obs; // To show popup
  // Rx<ScrollController> paginationController =
  //     ScrollController().obs; // For Transaction history lazy loading
  RxBool isFilterApplied = false.obs;

  RxList<TokenInfo> filteredTransactionList = <TokenInfo>[].obs;

  RxBool isTransactionLoading = false.obs;

  List<TokenInfo> defaultTransactionList = <TokenInfo>[];
  final Set<String> tokenTransactionID = <String>{};
  RxBool noMoreResults = false.obs;
  RxBool isScrollingUp = false.obs;

  RxList<ContactModel> contacts = <ContactModel>[].obs;
  Rx<ContactModel?>? contact;
  @override
  void onInit() {
    updateSavedContacts();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.clear();
    // refreshController.dispose();
    super.onClose();
  }

  /// Loades the user transaction history, and updates the UI after user taps on history tab
  Future<void> userTransactionLoader({bool resetController = true}) async {
    isTransactionLoading.value = true;
    if (resetController) {
      refreshController.value = RefreshController();
    }
    // refreshController.value.resetNoData();
    // refreshController.refreshToIdle();
    tokenTransactionID.clear();
    defaultTransactionList.clear();
    isScrollingUp.value = false;
    isFilterApplied.value = false;
    noMoreResults.value = false;
    if (Get.isRegistered<HistoryFilterController>()) {
      Get.find<HistoryFilterController>().clear();
    }
    userTransactionHistory.value = await fetchUserTransactionsHistory();
    final timestamp = userTransactionHistory
        .lastWhere((element) => true,
            orElse: () => TxHistoryModel(timestamp: ""))
        .timestamp;
    userTransferHistory.value =
        await fetchUserTransferHistory(timeStamp: timestamp ?? "");

    defaultTransactionList
        .addAll(_sortTransaction(userTransactionHistory, userTransferHistory));

    // defaultTransactionList = [...defaultTransactionList];
    // Lazy Loading
    // paginationController.value.addListener(() async {
    //   if (paginationController.value.position.pixels ==
    //       paginationController.value.position.maxScrollExtent) {
    //     if (Get.isRegistered<HistoryFilterController>()) {
    //       if (noMoreResults.isFalse) {
    //         await loadFilteredTransaction();
    //       }
    //     } else {
    //       if (noMoreResults.isFalse) {
    //         await loadMoreTransaction();
    //       }
    //     }
    //   }
    // });

    isTransactionLoading.value = false;
  }

  Future<void> loadFilteredTransaction({bool isFiltered = true}) async {
    isTransactionLoading.value = true;
    isFilterApplied.value = isFiltered;
    String lastId = filteredTransactionList
        .lastWhere(
          (element) => element.lastId.isNotEmpty,
          orElse: () => TokenInfo(lastId: ""),
        )
        .lastId;
    String lastTimeStamp = filteredTransactionList
            .lastWhere(
              (element) => element.lastId.isNotEmpty,
              orElse: () => TokenInfo(timeStamp: null),
            )
            .timeStamp
            ?.toIso8601String() ??
        "";
    var loadMoreTransaction =
        await fetchUserTransactionsHistory(lastId: lastId.toString());
    userTransactionHistory.addAll(loadMoreTransaction);
    var loadMoreTransfers =
        await fetchUserTransferHistory(timeStamp: lastTimeStamp);
    userTransferHistory.addAll(loadMoreTransfers);

    loadMoreTransaction.isEmpty
        ? noMoreResults.value = true
        : noMoreResults.value = false;

    filteredTransactionList.value = [
      ..._sortTransaction(userTransactionHistory, userTransferHistory)
    ];
    List<TokenInfo> tempTransactions = [...filteredTransactionList];
    final historyController = Get.find<HistoryFilterController>();
    if (historyController.assetType.length != 2) {
      if (historyController.assetType
          .any((element) => element == AssetType.token)) {
        tempTransactions = [
          ...tempTransactions.where((e) => !e.isNft).toList()
        ];
      }
      if (historyController.assetType
          .any((element) => element == AssetType.nft)) {
        tempTransactions = [...tempTransactions.where((e) => e.isNft).toList()];
      }
    }
    filteredTransactionList.value = [...tempTransactions];
    isTransactionLoading.value = false;
  }

  Future<void> loadMoreTransaction() async {
    isTransactionLoading.value = true;
    String lastId = defaultTransactionList
        .lastWhere(
          (element) => element.lastId.isNotEmpty,
          orElse: () => TokenInfo(lastId: ""),
        )
        .lastId;
    String lastTimeStamp = defaultTransactionList
        .lastWhere(
          (element) => element.lastId.isNotEmpty,
          orElse: () => TokenInfo(timeStamp: DateTime.now()),
        )
        .timeStamp!
        .toIso8601String();

    var loadMoreTransaction =
        await fetchUserTransactionsHistory(lastId: lastId.toString());
    var loadMoreTransfer =
        await fetchUserTransferHistory(timeStamp: lastTimeStamp);
    loadMoreTransaction.isEmpty
        ? noMoreResults.value = true
        : noMoreResults.value = false;
    userTransferHistory.addAll(loadMoreTransfer);
    userTransactionHistory.addAll(loadMoreTransaction);
    defaultTransactionList = [
      ..._sortTransaction(userTransactionHistory, userTransferHistory)
    ];
    isTransactionLoading.value = false;
  }

  RxList<TokenInfo> searchTransactionList = <TokenInfo>[].obs;
  TextEditingController searchController = TextEditingController();
  Future<void> searchTransactionHistory(String searchKey) async {
    isTransactionLoading.value = true;
    isFilterApplied.value = false;

    if (Get.isRegistered<HistoryFilterController>()) {
      Get.find<HistoryFilterController>().clear();
    }
    searchTransactionList.value = defaultTransactionList
        // .where((p0) => p0.name.isCaseInsensitiveContainsAny(searchKey))
        // .where((element) => element.name.isNotEmpty && !element.isNft)
        .toList();
    while (searchTransactionList.length < 10 && noMoreResults.isFalse) {
      await loadMoreTransaction();
      searchTransactionList.value = defaultTransactionList
          // .where((p0) => p0.name.isCaseInsensitiveContainsAny(searchKey))
          // .where((element) => element.name.isNotEmpty && !element.isNft)
          .toList();
    }
    noMoreResults.value = false;
    isTransactionLoading.value = false;
  }

  Future<void> loadSearchResults(String searchName) async {
    if (noMoreResults.isTrue) return;
    isTransactionLoading.value = true;

    String lastId = searchTransactionList
        .lastWhere(
          (element) => element.lastId.isNotEmpty,
          orElse: () => TokenInfo(lastId: ""),
        )
        .lastId;
    String lastTimeStamp = searchTransactionList
        .lastWhere(
          (element) => element.lastId.isNotEmpty,
          orElse: () => TokenInfo(timeStamp: DateTime.now()),
        )
        .timeStamp!
        .toIso8601String();
    var loadMoreTransactionHistory =
        await fetchUserTransactionsHistory(lastId: lastId.toString());
    userTransactionHistory.addAll(loadMoreTransactionHistory);
    var loadMoreTransfersHistory =
        await fetchUserTransferHistory(timeStamp: lastTimeStamp);
    userTransferHistory.addAll(loadMoreTransfersHistory);
    searchTransactionList.clear();
    searchTransactionList.addAll(_sortTransaction(
            userTransactionHistory, userTransferHistory)
        // .where(
        //     (element) => element.name.isCaseInsensitiveContainsAny(searchName))
        // .where((element) => element.name.isNotEmpty && !element.isNft)
        .toList());
    while (searchTransactionList.length < 10 && noMoreResults.isFalse) {
      await loadMoreTransaction();
      searchTransactionList.value = defaultTransactionList
          // .where((p0) => p0.name.isCaseInsensitiveContainsAny(searchName))
          // .where((element) => element.name.isNotEmpty && !element.isNft)
          .toList();
    }
    isTransactionLoading.value = false;
  }

  List<TokenPriceModel> get tokensList => [
        ...Get.find<AccountSummaryController>().tokensList,
        ...Get.find<AccountSummaryController>()
            .userTokens
            .map((element) => element.convert())
            .toList()
      ];
  List<TokenInfo> _sortTransaction(List<TxHistoryModel> transactionList,
      List<TransactionTransferModel> transferlist) {
    List<TokenInfo> sortedTransactionList = <TokenInfo>[];
    late TokenInfo tokenInfo;
    String? isHashSame;
    tokenTransactionID.clear();
    // List<TokenPriceModel> tokensList = [
    //   ...Get.find<AccountSummaryController>().tokensList,
    //   ...Get.find<AccountSummaryController>()
    //       .userTokens
    //       .map((element) => element.convert())
    //       .toList()
    // ];
    final selectedAccount = Get.find<HomePageController>()
        .userAccounts[Get.find<HomePageController>().selectedIndex.value]
        .publicKeyHash!;
    // operation filter
    for (int i = transactionList.length - 1; i >= 0; i--) {
      var tx = transactionList[i];
      tokenInfo = TokenInfo(
        hash: tx.hash,
        isHashSame: isHashSame == null ? false : tx.hash!.contains(isHashSame),
        token: tx,
        lastId: tx.lastid?.toString() ?? "",
        timeStamp: tx.timestamp == null
            ? DateTime.now()
            : DateTime.parse(tx.timestamp!),
        isSent: tx.sender!.address!
            .contains(accController.selectedAccount.value.publicKeyHash!),
      );
      isHashSame = tx.hash!;
      // For tezos transaction
      if (tx.isTezTransaction) {
        tokenInfo = tokenInfo.copyWith(
          token: tx,
          tokenSymbol: "tez",
          tokenAmount: tx.amount! / 1e6,
          dollarAmount: (tx.amount! / 1e6) * accController.xtzPrice.value,
        );
      }
      // For normal transaction
      else if (!tx.isTezTransaction) {
        if (tx.isFA2TokenTransfer) {
          if (tx.isNFTTx(tokensList)) {
            tokenInfo = tokenInfo.copyWith(isNft: true);
          } else {
            TokenPriceModel token = fA1Token(tokensList, tx.target);
            double amount = tx.getAmount(tokensList, selectedAccount);
            tokenInfo = tokenInfo.copyWith(
                name: token.name ?? token.tokenAddress?.tz1Short() ?? "",
                imageUrl:
                    token.thumbnailUri ?? "${PathConst.EMPTY_STATES}token.svg",
                tokenSymbol: token.symbol!,
                tokenAmount: amount / pow(10, token.decimals!),
                dollarAmount: amount /
                    pow(10, token.decimals!) *
                    accController.xtzPrice.value);
          }
        } else {
          if (tx.isFA1TokenTransfer) {
            TokenPriceModel token = fA1Token(tokensList, tx.target);
            double amount = tx.getAmount(tokensList, selectedAccount);
            tokenInfo = tokenInfo.copyWith(
                token: tx,
                name: token.name!,
                imageUrl: token.thumbnailUri!,
                tokenSymbol: token.symbol!,
                tokenAmount: amount / pow(10, token.decimals!),
                dollarAmount: amount /
                    pow(10, token.decimals!) *
                    accController.xtzPrice.value);
          } else {
            tokenInfo = tokenInfo.copyWith(skip: true);
          }
        }
      }
      // For delegation transaction
      else if (tx.type!.toLowerCase().contains("delegation")) {
        tokenInfo = tokenInfo.copyWith(
          isDelegated: true,
          token: tx,
          name: tx.newDelegate!.alias!,
          address: tx.newDelegate!.address!,
        );
      } else {
        tokenInfo = tokenInfo.copyWith(skip: true);
      }
      tokenInfo = tokenInfo.copyWith(
        lastId: tokenInfo.token!.lastid.toString(),
        source: tokenInfo.token!.source(
          userAccounts: Get.find<HomePageController>().userAccounts,
          contacts: contacts,
        ),
        destination: tokenInfo.token!.destination(
          userAccounts: Get.find<HomePageController>().userAccounts,
          contacts: contacts,
        ),
      );

      // sortedTransactionList.add(tokenInfo);
      sortedTransactionList.addIf(
          !tokenTransactionID.contains(tx.lastid.toString()), tokenInfo);
      tokenTransactionID.add(tx.lastid.toString());
    }
    List<TokenInfo> temp = [];
    for (var i = 0; i < sortedTransactionList.length; i++) {
      if (sortedTransactionList[i].isHashSame ?? false) {
        if (temp.isNotEmpty) {
          temp.last = temp.last.copyWith(internalOperation: [
            ...temp.last.internalOperation,
            sortedTransactionList[i]
          ]);
        }
      } else {
        temp.add(sortedTransactionList[i]);
      }
    }
    sortedTransactionList = [...temp];
// transfer
    for (var i = 0; i < transferlist.length; i++) {
      final transfer = transferlist[i];
      final interface = transfer.transactionInterface(tokensList);
      tokenInfo = TokenInfo(
        isNft: transfer.token!.metadata?.decimals == null ||
            transfer.token!.metadata?.decimals == "0",
        name: interface.name,
        source: transfer.from == null
            ? null
            : getAddressAlias(transfer.from!,
                contacts: contacts,
                userAccounts: Get.find<HomePageController>().userAccounts),
        destination: transfer.to == null
            ? null
            : getAddressAlias(transfer.to!,
                contacts: contacts,
                userAccounts: Get.find<HomePageController>().userAccounts),
        tokenSymbol: interface.symbol,
        imageUrl: interface.imageUrl ?? "",
        lastId: transfer.transactionId?.toString() ?? "",
        tokenAmount: double.parse(transfer.amount!) /
            pow(10, int.parse(transfer.token?.metadata?.decimals ?? "1")),
        nftTokenId: transfer.token!.tokenId,
        nftContractAddress: transfer.token!.contract?.address,
        internalOperation: [],
        dollarAmount: (double.parse(transfer.amount!) /
                pow(10, int.parse(transfer.token?.metadata?.decimals ?? "1"))) *
            interface.rate! *
            accController.xtzPrice.value,
        isHashSame: false,
        timeStamp:
            transfer.timestamp == null ? DateTime.now() : transfer.timestamp!,
        isSent: transfer.from?.address!
                .contains(accController.selectedAccount.value.publicKeyHash!) ??
            false,
      );
      sortedTransactionList.addIf(
          !tokenTransactionID.contains(transfer.transactionId.toString()),
          tokenInfo);
      tokenTransactionID.add(transfer.transactionId.toString());
    }
    sortedTransactionList.sort(
      (a, b) {
        return a.timeStamp!.microsecondsSinceEpoch -
            b.timeStamp!.microsecondsSinceEpoch;
      },
    );
    temp = [...sortedTransactionList];
    if (isFilterApplied.isTrue &&
        Get.isRegistered<HistoryFilterController>() &&
        Get.find<HistoryFilterController>()
            .transactionType
            .any((element) => element.index == TransactionType.send.index)) {
      temp = temp
          .where((element) =>
              (element.destination?.address?.startsWith("tz1") ?? true) ||
              (element.destination?.address?.startsWith("tz2") ?? true))
          .toList();
    }
    sortedTransactionList = [...temp].reversed.toList();
    return sortedTransactionList;
  }

  /// Fetches user account transaction history
  Future<List<TxHistoryModel>> fetchUserTransactionsHistory({
    String? lastId,
    int? limit,
  }) async {
    try {
      String query = "";
      if (isFilterApplied.value &&
          Get.isRegistered<HistoryFilterController>()) {
        // Get.find<HistoryFilterController>().apply();
        final tempQuery = Map.from(Get.find<HistoryFilterController>().query);
        if (tempQuery["type"] == "delegation") {
          tempQuery.remove("sender.ne");
          tempQuery.remove("sender");
        }
        tempQuery.forEach((key, value) {
          query = "$query&$key=$value";
        });
      }
      return
          // userTransactionHistory.isNotEmpty
          //     ?
          (await TzktTxHistoryApiService(
                  accController.selectedAccount.value.publicKeyHash!,
                  ServiceConfig.currentNetwork == NetworkType.mainnet
                      ? ""
                      : ServiceConfig.currentSelectedNode)
              .getTxHistory(
        lastId: lastId ?? "",
        limit: limit ?? 20,
        query: query,
      ));
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
    // : await UserStorageService().getAccountTransactionHistory(
    //     accountAddress: accController.selectedAccount.value.publicKeyHash!,
    //     lastId: lastId,
    //     limit: limit);
  }

  Future<void> updateSavedContacts() async {
    contacts.value = await UserStorageService().getAllSavedContacts();
    if (Get.isRegistered<SendPageController>()) {
      Get.find<SendPageController>().contacts.value = contacts.value;
    }
  }

  ContactModel? getContact(String address) {
    updateSavedContacts();
    return contacts.firstWhereOrNull((element) => element.address == address);
  }

  void onAddContact(String address, String name, String? imagePath) {
    contacts.add(ContactModel(
        name: name,
        address: address,
        imagePath: imagePath ??
            ServiceConfig.allAssetsProfileImages[Random().nextInt(
              ServiceConfig.allAssetsProfileImages.length - 1,
            )]));
  }

  Future<List<TransactionTransferModel>> fetchUserTransferHistory(
      {required String timeStamp}) async {
    /*  try{ */
    String query = "";
    final HistoryFilterController controller =
        Get.put(HistoryFilterController());
    if (isFilterApplied.value && Get.isRegistered<HistoryFilterController>()) {
      // Get.find<HistoryFilterController>().apply();
      controller.query.forEach((key, value) {
        query = "$query&$key=$value";
      });
    }
    if (controller.transactionType.every(
        (element) => element.index == TransactionType.delegation.index)) {
      return <TransactionTransferModel>[];
    }
    String rpc = ServiceConfig.currentNetwork == NetworkType.mainnet
        ? "mainnet"
        : ServiceConfig.currentSelectedNode;
    String network = "";
    if (Uri.parse(rpc).path.isNotEmpty) {
      network = "${Uri.parse(rpc).path.replaceAll("/", "")}.";
    }
    var url = ServiceConfig.tzktApiForTransfers(
        network: network.contains("ak-csrjehxhpw0dl3") ? "mainnet" : network,
        timeStamp: timeStamp,
        address: accController.selectedAccount.value.publicKeyHash!,
        query: query);
    debugPrint(url);
    var response =
        await HttpService.performGetRequest(url, callSetupTimer: true);

    return transactionTransferModelFromJson(response);
  } /* catch (e) {
      debugPrint(e.toString());
      return [];
    }
  } */
}

// extension TransactionChecker on TxHistoryModel {
//   bool get isTezosTransaction => amount != null && amount! > 0;
//   bool get isAnyTokenOrNFTTransaction =>
//       parameter != null && parameter?.entrypoint == "transfer";
//   bool get isFa2Token {
//     if (parameter!.value is Map) {
//       return false;
//     } else if (parameter!.value is List) {
//       return true;
//     } else if (parameter!.value is String) {
//       var decodedString = jsonDecode(parameter!.value);
//       if (decodedString is List) {
//         return true;
//       } else {
//         return false;
//       }
//     } else {
//       return false;
//     }
//   }

//   bool get isNft => Get.find<AccountSummaryController>()
//       .tokensList
//       .where((p0) => (p0.tokenAddress!.contains(target!.address!) &&
//           p0.tokenId!.contains(parameter!.value is List
//               ? parameter?.value[0]["txs"][0]["token_id"]
//               : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"])))
//       .isEmpty;

//   bool get isFa1Token => Get.find<AccountSummaryController>()
//       .tokensList
//       .where((p0) => (p0.tokenAddress!.contains(target!.address!)))
//       .isNotEmpty;

//   String get fa2TokenAmount => parameter?.value is List
//       ? parameter?.value[0]["txs"][0]["amount"]
//       : jsonDecode(parameter!.value)[0]["txs"][0]["amount"];

//   String get nftTokenId {
//     if (parameter?.value is String) {
//       var decodedString;
//       try {
//         decodedString = jsonDecode(parameter!.value);
//       } catch (e) {
//         return "";
//       }

//       if (decodedString is Map && decodedString["value"] is String) {
//         return decodedString["value"];
//       }
//       parameter?.value = decodedString;
//       // return decodedString is Map
//       //     ? decodedString["txs"] == null
//       //         ? ""
//       //         : decodedString["txs"][0]["token_id"]
//       //     : decodedString[0]["txs"][0]["token_id"];
//     }
//     if (parameter?.value is Map && parameter?.value["txs"] != null) {
//       return parameter?.value["txs"][0]["token_id"];
//     }
//     if (parameter?.value is List && parameter?.value[0]["txs"] != null) {
//       return parameter?.value[0]["txs"][0]["token_id"];
//     }
//     if (parameter?.value is List && parameter?.value[0]["request"] != null) {
//       return parameter?.value[0]["request"]["token_id"];
//     }

//     return "";
//   }

//   String get fa1TokenAmount {
//     try {
//       return parameter?.value is Map
//           ? parameter!.value['value']
//           : jsonDecode(parameter!.value)['value'];
//     } catch (e) {
//       return "0";
//     }
//   }

//   AliasAddress get send {
//     return getAddressAlias(sender!);
//   }

//   AliasAddress get reciever {
//     debugPrint("hash: $hash");
//     if (parameter != null &&
//         parameter?.value is Map<String, List> &&
//         parameter?.value?["txs"]?[0]?["to_"] != null) {
//       return getAddressAlias(
//           AliasAddress(address: parameter?.value?["txs"]?[0]?["to_"]));
//     }
//     if (target != null) return getAddressAlias(target!);
//     return getAddressAlias(sender!);
//   }

//   AliasAddress getAddressAlias(AliasAddress address) {
//     final homeController = Get.find<HomePageController>();
//     final transactionController = Get.find<TransactionController>();
//     if (homeController.userAccounts
//         .any((element) => element.publicKeyHash!.contains(address.address!))) {
//       final account = homeController.userAccounts.firstWhere(
//           (element) => element.publicKeyHash!.contains(address.address!));
//       return AliasAddress(address: account.publicKeyHash, alias: account.name);
//     } else if (transactionController.contacts
//         .any((element) => element.address.contains(address.address!))) {
//       final contact = transactionController.contacts
//           .firstWhere((element) => element.address.contains(address.address!));
//       return AliasAddress(address: contact.address, alias: contact.name);
//     }
//     return address;
//   }

//   // String get actionType {
//   //   final homeController = Get.find<HomePageController>();

//   //   if (newDelegate != null) {
//   //     return "Delegated to ${newDelegate!.alias ?? newDelegate!.address!.tz1Short()}";
//   //   }
//   //   // if (homeController.userAccounts
//   //   //     .any((element) => element.publicKeyHash!.contains(sender!.address!))) {
//   //   //   return "Sent";
//   //   // }
//   //   // if (target != null &&
//   //   //     homeController.userAccounts.any(
//   //   //         (element) => element.publicKeyHash!.contains(target!.address!))) {
//   //   //   return "Received";
//   //   // }
//   //   if (type == "transaction") {
//   //     List<String> swapTypes = [
//   //       "swap",
//   //       "_to_",
//   //       "xtzToTokenSwapInput",
//   //       "tokenToXtzSwapInput",
//   //       "tokenToTokenSwapInput"
//   //     ];

//   //     ///Check Swap
//   //     if (parameter != null) {
//   //       if ((swapTypes.any(
//   //           (element) => parameter!.entrypoint?.contains(element) ?? false))) {
//   //         return "Swapped";
//   //       }
//   //       if (parameter!.entrypoint == "offer") {
//   //         return "Offer in ${target?.alias ?? target?.address?.tz1Short()} ";
//   //       }
//   //     }
//   //   }
//   //   if (homeController
//   //       .userAccounts[homeController.selectedIndex.value].publicKeyHash!
//   //       .contains(sender!.address!)) {
//   //     return "Sent";
//   //   } else {
//   //     return target?.alias ?? "Received";
//   //   }
//   //   if (target != null) {
//   //     return target!.alias ?? "Contract interaction";
//   //   }

//   //   return type?.capitalizeFirst ?? "";
//   // }

//   TokenPriceModel get getFa1TokenName => Get.find<AccountSummaryController>()
//       .tokensList
//       .firstWhere((p0) => (p0.tokenAddress!.contains(target!.address!)));

//   TokenPriceModel get getFa2TokenName => Get.find<AccountSummaryController>()
//       .tokensList
//       .firstWhere((p0) => (p0.tokenAddress!.contains(target!.address!) &&
//           p0.tokenId!.contains(parameter!.value is List
//               ? parameter?.value[0]["txs"][0]["token_id"]
//               : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"])));

//   // TxInterface mapOperationsToActivities() {
//   //   TxInterface data = TxInterface();
//   //   final homeController = Get.find<HomePageController>();
//   //   final selectedAccount =
//   //       homeController.userAccounts[homeController.selectedIndex.value];
//   //   data.source = getAddressAlias(sender!);
//   //   switch (type) {
//   //     case "transaction":
//   //       data.destination = target != null ? getAddressAlias(target!) : null;
//   //       data.amount = amount?.toString();
//   //       final fa2Parameter = parameter;
//   //       final fa12Parameter = parameter;
//   //       final bakingParameter = parameter;
//   //       if (fa2Parameter != null &&
//   //           fa2Parameter.value is List &&
//   //           fa2Parameter.value.length > 0 &&
//   //           fa2Parameter.value[0]["txs"] != null) {
//   //         data.contractAddress = target?.address;
//   //         bool isUserSenderOrReceiverOfFa2Operation = false;
//   //         if (fa2Parameter.value[0]["from_"] == selectedAccount.publicKeyHash) {
//   //           data.amount = (fa2Parameter.value[0]["txs"] as List)
//   //               .reduce(
//   //                 (acc, tx) => acc + (tx.amount),
//   //               )
//   //               .toString();
//   //           data.source = AliasAddress(
//   //               address: selectedAccount.publicKeyHash,
//   //               alias: selectedAccount.name);
//   //           isUserSenderOrReceiverOfFa2Operation = true;
//   //           data.tokenId = fa2Parameter.value[0]["txs"][0]["token_id"];
//   //         }
//   //         for (final param in fa2Parameter.value) {
//   //           final val = (param["txs"] as List).firstWhere((tx) {
//   //             data.amount = tx["amount"];
//   //             return tx["to_"] == selectedAccount.publicKeyHash;
//   //           }, orElse: () => null);
//   //           if (val != null) {
//   //             isUserSenderOrReceiverOfFa2Operation = true;
//   //             data.amount = val["amount"];
//   //             data.tokenId = val["token_id"];
//   //           }
//   //         }
//   //         if (!isUserSenderOrReceiverOfFa2Operation) {
//   //           break;
//   //         }
//   //       } else if (fa12Parameter != null &&
//   //           fa12Parameter.value is Map &&
//   //           fa12Parameter.value["value"] != null) {
//   //         if (fa12Parameter.entrypoint == 'approve') {
//   //           break;
//   //         }
//   //         if (fa12Parameter.value["from"] != null ||
//   //             fa12Parameter.value["to"] != null) {
//   //           if (fa12Parameter.value["from"] == selectedAccount.publicKeyHash) {
//   //             data.source = AliasAddress(
//   //                 address: selectedAccount.publicKeyHash,
//   //                 alias: selectedAccount.name);
//   //           } else if (fa12Parameter.value["to"] ==
//   //               selectedAccount.publicKeyHash) {
//   //             data.source!.address = fa12Parameter.value["from"];
//   //           } else {
//   //             break;
//   //           }
//   //         }
//   //         data.contractAddress = target!.address;
//   //         data.amount = fa12Parameter.value["value"];
//   //       } else if (bakingParameter != null &&
//   //           bakingParameter.value is Map &&
//   //           bakingParameter.value["quantity"] != null) {
//   //         data.contractAddress = target!.address;
//   //         final tokenOrTezAmount =
//   //             parameter != null && (parameter!.value["value"])
//   //                 ? parameter!.value["value"]
//   //                 : amount.toString();
//   //         data.amount = (parameter != null) && (parameter!.value["quantity"])
//   //             ? (parameter)!.value["quantity"]
//   //             : target!.address == selectedAccount.publicKeyHash ||
//   //                     ((parameter != null) &&
//   //                         (parameter)!.value["to"] ==
//   //                             selectedAccount.publicKeyHash)
//   //                 ? tokenOrTezAmount
//   //                 : '-$tokenOrTezAmount';
//   //       }
//   //       break;
//   //     case "delegation":
//   //       if (selectedAccount.publicKeyHash != data.source!.address) {
//   //         break;
//   //       }
//   //       if (prevDelegate != null) {
//   //         (data.destination = getAddressAlias(prevDelegate!));
//   //       }
//   //       if (newDelegate != null) {
//   //         (data.destination = getAddressAlias(newDelegate!));
//   //       }
//   //       break;

//   //     // case "origination":
//   //     //   if(originatedContract!=null)  (data.destination = originatedContract);
//   //     //   if(contractBalance!=null)  (data.amount = contractBalance.toString());
//   //     //   break;
//   //     default:
//   //   }
//   //   data.tokenId = data.tokenId ?? (nftTokenId.isEmpty ? null : nftTokenId);
//   //   data.amount = data.source!.address == selectedAccount.publicKeyHash
//   //       ? "-${data.amount}"
//   //       : data.amount;
//   //   data.source = getAddressAlias(data.source!);
//   //   data.destination =
//   //       data.destination != null ? getAddressAlias(data.destination!) : null;
//   //   return data;
//   // }

// }

extension DateOnlyCompare on DateTime {
  bool displayDate(
    DateTime other,
  ) {
    final now = DateTime.now();
    if (year == other.year && month == other.month && day == other.day) {
      return false;
    }
    // Today
    if (year == now.year && month == now.month && day == now.day) {
      return true;
    }
    // Yesterday
    if (year == now.year && month == now.month && (day - now.day).abs() == 1) {
      return true;
    }
    // Day before yesterday to display This Month
    if (year == now.year &&
        month == now.month &&
        now.year == other.year &&
        now.month == other.month &&
        day != other.day &&
        ((now.day - other.day).abs() == 1 || now.day == other.day)) {
      return true;
    }

    if (year == other.year && month != other.month) return true;
    return false;
  }

  String relativeDate() {
    final now = DateTime.now();
    Duration diff = now.difference(this);
    if (year == now.year && month == now.month && day == now.day) {
      return "Today";
    }
    if (year == now.year && month == now.month && (day - now.day).abs() == 1) {
      return "Yesterday";
    }

    if (month == now.month && year == now.year) {
      return "This Month";
    }
    if (year == now.year && month != now.month) {
      ///APRIL
      return DateFormat.MMMM().format(this);
    }
    if (year != now.year) {
      ///2022, NOV
      return DateFormat.yMMM().format(this);
    }

    return "";
  }
}

class TxInterface {
  String? type;
  String? status;
  String? hash;
  String? amount;
  String? address;
  double? id;
  String? tokenId;
  String? contractAddress;
  int? timeStamp;
  String? entrypoint;
  AliasAddress? source;
  AliasAddress? destination;
  int? lebel;
}
