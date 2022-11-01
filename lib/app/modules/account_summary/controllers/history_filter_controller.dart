import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';

import '../../../data/services/service_models/tx_history_model.dart';

class HistoryFilterController extends GetxController {
  final accountController = Get.find<TransactionController>();

  Rx<AssetType> assetType = AssetType.token.obs;
  Rx<TransactionType> transactionType = TransactionType.delegation.obs;
  Rx<DateType> dateType = DateType.none.obs;

  Rx<DateTime> fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  Rx<DateTime> toDate = DateTime.now().obs;

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
    accountController.filteredTokenList.clear();
    assetType.value = AssetType.all;
    transactionType.value = TransactionType.all;
    dateType.value = DateType.none;
    accountController.userTransactionHistory.value =
        await accountController.fetchUserTransactionsHistory();
    accountController.userTransactionHistory.refresh();
    accountController.isFilterApplied.value = false;
    Get.back();
  }

  void apply() async {
    accountController.isFilterApplied.value = true;
    DateTime time = DateTime.now();
    List<TokenInfo> filteredList = accountController.tokenTransactionList;
    switch (dateType.value) {
      case DateType.today:
        filteredList = filteredList
            .where((e) =>
                (DateTime(
                    e.timeStamp!.year, e.timeStamp!.month, e.timeStamp!.day)) ==
                (DateTime(time.year, time.month, time.day)))
            .toList();
        break;
      case DateType.currentMonth:
        filteredList = filteredList
            .where((e) =>
                (DateTime.now().month == e.timeStamp!.month) &&
                (DateTime.now().year == e.timeStamp!.year) &&
                (e.timeStamp!.day <= 31))
            .toList();
        break;
      case DateType.last3Months:
        filteredList = filteredList
            .where((e) =>
                (DateTime.now().month - 3 <= e.timeStamp!.month) &&
                (DateTime.now().year == e.timeStamp!.year) &&
                (e.timeStamp!.day <= 31))
            .toList();
        break;
      case DateType.customDate:
        filteredList = filteredList
            .where((e) =>
                (e.timeStamp!.isAfter(fromDate.value)) &&
                (e.timeStamp!.isBefore(toDate.value)))
            .toList();
        break;
      default:
        break;
    }
    switch (transactionType.value) {
      case TransactionType.delegation:
        filteredList = filteredList.where((e) => e.isDelegated).toList();
        break;
      case TransactionType.receive:
        filteredList = filteredList.where((e) => !e.isSent).toList();
        break;
      case TransactionType.send:
        filteredList = filteredList.where((e) => e.isSent).toList();
        break;
      default:
    }
    switch (assetType.value) {
      case AssetType.token:
        filteredList = filteredList.where((e) => !e.isNft).toList();
        break;
      case AssetType.nft:
        filteredList = filteredList.where((e) => e.isNft).toList();
        break;
      default:
    }
    accountController.filteredTokenList.value = filteredList;
    accountController.filteredTokenList.refresh();
    // accountController.userTransactionHistory.value =
    //     await accountController.fetchUserTransactionsHistory(
    //   limit: 200,
    // );

    Get.back();
  }

  Future<List<TxHistoryModel>> fetchFilteredList(
      {required List<TxHistoryModel> nextHistoryList}) async {
    if (accountController.isFilterApplied.isTrue) {
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
        nextHistoryList
            .where((element) => element.type!.contains("Delegation"))
            .toList();
      } else if (transactionType.value == TransactionType.receive) {
        nextHistoryList = nextHistoryList
            .where((element) => !element.sender!.address!.contains(
                accountController
                    .accController.userAccount.value.publicKeyHash!))
            .toList();
      } else if (transactionType.value == TransactionType.send) {
        nextHistoryList = nextHistoryList
            .where((element) => element.sender!.address!.contains(
                accountController
                    .accController.userAccount.value.publicKeyHash!))
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

enum AssetType { token, nft, all }

enum TransactionType { delegation, send, receive, all }

enum DateType { today, currentMonth, last3Months, customDate, none }
