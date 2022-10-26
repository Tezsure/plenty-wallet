import 'dart:convert';

import 'package:get/get.dart';

import '../../../data/services/service_models/tx_history_model.dart';
import 'account_summary_controller.dart';

class HistoryFilterController extends GetxController {
  final accountController = Get.find<AccountSummaryController>();

  Rx<AssetType> assetType = AssetType.token.obs;
  Rx<TransactionType> transactionType = TransactionType.delegation.obs;
  Rx<DateType> dateType = DateType.today.obs;

  Rx<DateTime> fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxBool isFilterApplied = false.obs;

  void setDate(DateType type, {DateTime? from, DateTime? to}) {
    dateType.value = type;
    if (type == DateType.today) {
      fromDate.value = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      toDate.value = DateTime.now();
    } else if (type == DateType.currentMonth) {
      fromDate.value = DateTime(
        DateTime.now().year,
        DateTime.now().month,
      );
      toDate.value = DateTime.now();
    } else if (type == DateType.last3Months) {
      fromDate.value = DateTime(
        DateTime.now().year,
        DateTime.now().month - 3,
      );
      toDate = DateTime.now().obs;
    } else {
      fromDate.value = from!;
      toDate.value = to!;
    }
  }

  Future<void> clear() async {
    assetType.value = AssetType.token;
    transactionType.value = TransactionType.delegation;
    setDate(DateType.today);
    accountController.userTransactionHistory.value =
        await accountController.fetchUserTransactionsHistory();
    accountController.userTransactionHistory.refresh();
    isFilterApplied.value = false;
    Get.back();
  }

  Future<void> apply() async {
    isFilterApplied.value = true;
    accountController.userTransactionHistory.value =
        await accountController.fetchUserTransactionsHistory(limit: 300);
    if (dateType.value == DateType.today) {
      accountController.userTransactionHistory.value =
          accountController.userTransactionHistory.where((element) {
        DateTime elementTime = DateTime.parse(element.timestamp!);
        return (DateTime(
                elementTime.year, elementTime.month, elementTime.day)) ==
            (DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day));
      }).toList();
      accountController.userTransactionHistory.refresh();
    } else if (dateType.value == DateType.currentMonth) {
      accountController.userTransactionHistory.value =
          accountController.userTransactionHistory.where((element) {
        DateTime elementTime = DateTime.parse(element.timestamp!);
        return (DateTime.now().month == elementTime.month) &&
            (DateTime.now().year == elementTime.year) &&
            (elementTime.day <= 31);
      }).toList();
      accountController.userTransactionHistory.refresh();
    } else if (dateType.value == DateType.last3Months) {
      accountController.userTransactionHistory.value =
          accountController.userTransactionHistory.where((element) {
        DateTime elementTime = DateTime.parse(element.timestamp!);
        return (DateTime.now().month - 3 <= elementTime.month) &&
            (DateTime.now().year == elementTime.year) &&
            (elementTime.day <= 31);
      }).toList();
      accountController.userTransactionHistory.refresh();
    } else if (dateType.value == DateType.customDate) {
      accountController.userTransactionHistory.value =
          await accountController.fetchUserTransactionsHistory(limit: 300);

      accountController.userTransactionHistory.value =
          accountController.userTransactionHistory.where((element) {
        DateTime elementTime = DateTime.parse(element.timestamp!);

        return elementTime.isAfter(fromDate.value) &&
            elementTime.isBefore(toDate.value);
      }).toList();
      accountController.userTransactionHistory.refresh();
    }

    // Filter the transaction list based on the selected transaction type
    if (transactionType.value == TransactionType.delegation) {
    } else if (transactionType.value == TransactionType.receive) {
      accountController.userTransactionHistory.value =
          accountController.userTransactionHistory.where((element) {
        return !element.sender!.address!
            .contains(accountController.userAccount.value.publicKeyHash!);
      }).toList();
      accountController.userTransactionHistory.refresh();
    } else if (transactionType.value == TransactionType.send) {
      accountController.userTransactionHistory.value =
          accountController.userTransactionHistory.where((element) {
        return element.sender!.address!
            .contains(accountController.userAccount.value.publicKeyHash!);
      }).toList();
      accountController.userTransactionHistory.refresh();
    }

    // Filter the list depending on the selected asset type
    if (assetType.value == AssetType.nft) {
      accountController.userTransactionHistory.value =
          accountController.userTransactionHistory.where((element) {
        if (element.parameter != null &&
            element.parameter?.entrypoint == "transfer") {
          if (element.parameter?.value is Map) {
            return false;
          } else {
            if (element.parameter?.value is List) {
              if (accountController.tokensList
                  .where((p0) =>
                      (p0.tokenAddress!.contains(element.target!.address!)) &&
                      p0.tokenId!.contains(
                          element.parameter?.value[0]["txs"][0]["token_id"]))
                  .isEmpty) {
                return true;
              } else {
                return false;
              }
            } else if (element.parameter?.value is String) {
              var decodedString = jsonDecode(element.parameter!.value);
              if (decodedString is List) {
                if (accountController.tokensList
                    .where((p0) =>
                        (p0.tokenAddress!.contains(element.target!.address!)) &&
                        p0.tokenId!.contains(
                            jsonDecode(element.parameter!.value)[0]["txs"][0]
                                ["token_id"]))
                    .isEmpty) {
                  return true;
                } else {
                  return false;
                }
              } else {
                return false;
              }
            } else {
              return false;
            }
          }
        } else {
          return false;
        }
      }).toList();
      accountController.userTransactionHistory.refresh();
    } else if (assetType.value == AssetType.token) {
      accountController.userTransactionHistory.value =
          accountController.userTransactionHistory.where((element) {
        if (element.amount != null &&
            element.amount! > 0 &&
            element.parameter == null) {
          return true;
        } else if (element.parameter != null &&
            element.parameter?.entrypoint == "transfer") {
          if (element.parameter?.value is Map) {
            return true;
          } else {
            if (element.parameter?.value is List) {
              if (accountController.tokensList
                  .where((p0) =>
                      (p0.tokenAddress!.contains(element.target!.address!)) &&
                      p0.tokenId!.contains(
                          element.parameter?.value[0]["txs"][0]["token_id"]))
                  .isEmpty) {
                return false;
              } else {
                return true;
              }
            } else if (element.parameter?.value is String) {
              var decodedString = jsonDecode(element.parameter!.value);
              if (decodedString is List) {
                if (accountController.tokensList
                    .where((p0) =>
                        (p0.tokenAddress!.contains(element.target!.address!)) &&
                        p0.tokenId!.contains(
                            jsonDecode(element.parameter!.value)[0]["txs"][0]
                                ["token_id"]))
                    .isEmpty) {
                  return false;
                } else {
                  return true;
                }
              } else {
                return true;
              }
            } else {
              return false;
            }
          }
        } else {
          return false;
        }
      }).toList();
      accountController.userTransactionHistory.refresh();
    }
    Get.back();
  }

  Future<List<TxHistoryModel>> fetchFilteredList(
      {required List<TxHistoryModel> nextHistoryList}) async {
    if (isFilterApplied.isTrue) {
      if (dateType.value == DateType.today) {
        nextHistoryList = nextHistoryList.where((element) {
          DateTime elementTime = DateTime.parse(element.timestamp!);
          return (DateTime(
                  elementTime.year, elementTime.month, elementTime.day)) ==
              (DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day));
        }).toList();
      } else if (dateType.value == DateType.currentMonth) {
        nextHistoryList = nextHistoryList.where((element) {
          DateTime elementTime = DateTime.parse(element.timestamp!);
          return (DateTime.now().month == elementTime.month) &&
              (DateTime.now().year == elementTime.year) &&
              (elementTime.day <= 31);
        }).toList();
      } else if (dateType.value == DateType.last3Months) {
        nextHistoryList = nextHistoryList.where((element) {
          DateTime elementTime = DateTime.parse(element.timestamp!);
          return (DateTime.now().month - 3 <= elementTime.month) &&
              (DateTime.now().year == elementTime.year) &&
              (elementTime.day <= 31);
        }).toList();
      } else if (dateType.value == DateType.customDate) {
        nextHistoryList = nextHistoryList.where((element) {
          DateTime elementTime = DateTime.parse(element.timestamp!);
          return (elementTime.day >= fromDate.value.day) &&
              (elementTime.month >= fromDate.value.month) &&
              (elementTime.year >= fromDate.value.year) &&
              (elementTime.day <= toDate.value.day) &&
              (elementTime.month <= toDate.value.month) &&
              (elementTime.year <= toDate.value.year);
        }).toList();
      }
      // Filter the transaction list based on the selected transaction type
      if (transactionType.value == TransactionType.delegation) {
      } else if (transactionType.value == TransactionType.receive) {
        nextHistoryList = nextHistoryList
            .where((element) => !element.sender!.address!
                .contains(accountController.userAccount.value.publicKeyHash!))
            .toList();
      } else if (transactionType.value == TransactionType.send) {
        nextHistoryList = nextHistoryList
            .where((element) => element.sender!.address!
                .contains(accountController.userAccount.value.publicKeyHash!))
            .toList();
      }

      // Filter the list depending on the selected asset type
      if (assetType.value == AssetType.nft) {
      } else if (assetType.value == AssetType.token) {}
      return nextHistoryList;
    } else {
      return nextHistoryList;
    }
  }
}

enum AssetType { token, nft }

enum TransactionType { delegation, send, receive }

enum DateType { today, currentMonth, last3Months, customDate }
