import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/models/token_info.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';

import '../../../../utils/constants/path_const.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../../data/services/service_models/contact_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';
import 'history_filter_controller.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:http/http.dart' as http;

class TransactionController extends GetxController {
  final accController = Get.find<AccountSummaryController>();

  RxList<TxHistoryModel> userTransactionHistory =
      <TxHistoryModel>[].obs; // List of user transactions
  RxBool isTransactionPopUpOpened = false.obs; // To show popup
  Rx<ScrollController> paginationController =
      ScrollController().obs; // For Transaction history lazy loading
  RxBool isFilterApplied = false.obs;
  Timer? searchDebounceTimer;
  Set<String> tokenTransactionID = <String>{};
  RxList<TokenInfo> filteredTransactionList = <TokenInfo>[].obs;

  @override
  void onInit() {
    updateSavedContacts();
    super.onInit();
  }

  @override
  void onClose() {
    paginationController.value.dispose();
    super.onClose();
  }

  RxBool isTransactionLoading = false.obs;
  List<TokenInfo> defaultTransactionList = <TokenInfo>[];
  static final Set<String> _tokenTransactionID = <String>{};

  /// Loades the user transaction history, and updates the UI after user taps on history tab
  Future<void> userTransactionLoader() async {
    defaultTransactionList.clear();
    _tokenTransactionID.clear();
    paginationController.value.removeListener(() {});
    userTransactionHistory.value = await fetchUserTransactionsHistory();
    isFilterApplied.value = false;
    if (Get.isRegistered<HistoryFilterController>()) {
      Get.find<HistoryFilterController>().clear();
    }
    defaultTransactionList
        .addAll(await _sortTransaction(userTransactionHistory));
    // Lazy Loading
    paginationController.value.addListener(() async {
      if (paginationController.value.position.pixels ==
          paginationController.value.position.maxScrollExtent) {
        if (Get.isRegistered<HistoryFilterController>()) {
          if (noMoreResults.isFalse) {
            await loadFilteredTransaction();
          }
        } else {
          if (noMoreResults.isFalse) {
            await loadMoreTransaction();
          }
        }
      }
    });
  }

  RxList<TokenInfo> searchTransactionList = <TokenInfo>[].obs;
  Future<void> loadSearchResults(String searchName) async {
    var loadMoreTransaction = await fetchUserTransactionsHistory(
        lastId: searchTransactionList.last.token!.lastid.toString());
    searchTransactionList.addAll((await _sortTransaction(loadMoreTransaction))
        .where(
            (element) => element.name.isCaseInsensitiveContainsAny(searchName))
        .toList());
  }

  Future<void> loadFilteredTransaction() async {
    var historyFilterController = Get.find<HistoryFilterController>();
    isTransactionLoading.value = true;

    var loadMoreTransaction = filteredTransactionList.isNotEmpty
        ? await fetchUserTransactionsHistory(
            lastId: filteredTransactionList.last.token!.lastid.toString())
        : <TxHistoryModel>[];
    loadMoreTransaction.isEmpty
        ? noMoreResults.value = true
        : noMoreResults.value = false;
    filteredTransactionList.addAll(historyFilterController.fetchFilteredList(
        nextHistoryList: await _sortTransaction(loadMoreTransaction)));
    isTransactionLoading.value = false;
  }

  Future<void> loadMoreTransaction() async {
    isTransactionLoading.value = true;
    var loadMoreTransaction = await fetchUserTransactionsHistory(
        lastId: userTransactionHistory.last.lastid.toString());
    loadMoreTransaction.isEmpty
        ? noMoreResults.value = true
        : noMoreResults.value = false;
    userTransactionHistory.addAll(loadMoreTransaction);
    defaultTransactionList.addAll(await _sortTransaction(loadMoreTransaction));
    isTransactionLoading.value = false;
  }

  RxBool noMoreResults = false.obs;

  Future<List<TokenInfo>> _sortTransaction(
      List<TxHistoryModel> transactionList) async {
    List<TokenInfo> sortedTransactionList = <TokenInfo>[];
    late TokenInfo tokenInfo;
    String? isHashSame;
    final tokensList = Get.find<AccountSummaryController>().tokensList;
    final selectedAccount = Get.find<HomePageController>()
        .userAccounts[Get.find<HomePageController>().selectedIndex.value]
        .publicKeyHash!;
    for (int i = transactionList.length - 1; i >= 0; i--) {
      var tx = transactionList[i];
      tokenInfo = TokenInfo(
        isHashSame: isHashSame == null ? false : tx.hash!.contains(isHashSame),
        token: tx,
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
            // checking if it works or not //   WORKING
            // var transfer = await getTransfer(id: tx.lastid!);
            // tokenInfo = tokenInfo.copyWith(
            //   isNft: true,
            //   address: tx.target!.address!,
            //   nftTokenId: tx.parameter?.value[0]["txs"][0]["token_id"],
            // );
            // tokenInfo = tokenInfo.copyWith(
            //     isNft: true,
            // address: tx.target!.address!,
            // nftTokenId: tx.nftTokenId,
            //     tokenSymbol: transfer["token"]["metadata"]?["name"] ?? "",
            //     name: transfer["token"]["metadata"]?["name"] ?? "",
            //     tokenAmount: double.parse(transfer["amount"] ?? "0"),
            //     isReceived: accController.selectedAccount.value.publicKeyHash!
            //         .contains(transfer["to"]["address"]),
            //     isSent: accController.selectedAccount.value.publicKeyHash!
            //         .contains(transfer["from"]["address"]),
            //     dollarAmount: 0.0,
            //     imageUrl: transfer["token"]["metadata"]?["thumbnailUri"]);
          } else {
            TokenPriceModel token = tx.fA1Token(tokensList);
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
            TokenPriceModel token = tx.fA1Token(tokensList);
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
      sortedTransactionList.addIf(
          !_tokenTransactionID.contains(tx.lastid.toString()), tokenInfo);
      _tokenTransactionID.add(tx.lastid.toString());
    }
    List<TokenInfo> temp = [];
    for (var i = 0; i < sortedTransactionList.length; i++) {
      if (sortedTransactionList[i].isHashSame ?? false) {
        temp.last = temp.last.copyWith(internalOperation: [
          ...temp.last.internalOperation,
          sortedTransactionList[i]
        ]);
      } else {
        temp.add(sortedTransactionList[i]);
      }
    }
    sortedTransactionList = [...temp].reversed.toList();
    return sortedTransactionList;
  }

  /// Fetches user account transaction history
  Future<List<TxHistoryModel>> fetchUserTransactionsHistory(
          {String? lastId, int? limit}) async =>
      await UserStorageService().getAccountTransactionHistory(
          accountAddress: accController.selectedAccount.value.publicKeyHash!,
          lastId: lastId,
          limit: limit);

  Future<void> searchTransactionHistory(String searchKey) async {
    searchTransactionList.value = defaultTransactionList
        .where((p0) => p0.name.isCaseInsensitiveContainsAny(searchKey))
        .toList();
    while (searchTransactionList.length < 10 && noMoreResults.isFalse) {
      await loadMoreTransaction();
      searchTransactionList.value = defaultTransactionList
          .where((p0) => p0.name.isCaseInsensitiveContainsAny(searchKey))
          .toList();
    }
    noMoreResults.value = false;
  }

  RxList<ContactModel> contacts = <ContactModel>[].obs;
  Rx<ContactModel?>? contact;

  Future<void> updateSavedContacts() async {
    contacts.value = await UserStorageService().getAllSavedContacts();
    if (Get.isRegistered<SendPageController>()) {
      Get.find<SendPageController>().contacts.value = contacts.value;
    }
  }

  ContactModel? getContact(String address) {
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

  getTransfer({required int id}) async {
    var url = ServiceConfig.tzktApiForTransfers(id: id.toString());
    print(url);
    var response =
        await HttpService.performGetRequest(url, callSetupTimer: true);

    return jsonDecode(response)[0];
  }
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
//     print("hash: $hash");
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
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
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
