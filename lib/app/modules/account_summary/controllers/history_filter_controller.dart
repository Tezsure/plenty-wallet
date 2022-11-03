import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';

import '../models/token_info.dart';

class HistoryFilterController extends GetxController {
  final accountController = Get.find<TransactionController>();

  Rx<AssetType> assetType = AssetType.all.obs;
  Rx<TransactionType> transactionType = TransactionType.all.obs;
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
    accountController.filteredTransactionList.clear();
    assetType.value = AssetType.all;
    transactionType.value = TransactionType.all;
    dateType.value = DateType.none;
    accountController.noMoreResults.value = false;
    accountController.isFilterApplied.value = false;
    Get.back();
  }

  List<TokenInfo> _applyFilter(List<TokenInfo> transactions) {
    DateTime time = DateTime.now();
    switch (dateType.value) {
      case DateType.today:
        transactions = transactions
            .where((e) =>
                (DateTime(
                    e.timeStamp!.year, e.timeStamp!.month, e.timeStamp!.day)) ==
                (DateTime(time.year, time.month, time.day)))
            .toList();
        break;
      case DateType.currentMonth:
        transactions = transactions
            .where((e) =>
                (DateTime.now().month == e.timeStamp!.month) &&
                (DateTime.now().year == e.timeStamp!.year) &&
                (e.timeStamp!.day <= 31))
            .toList();
        break;
      case DateType.last3Months:
        transactions = transactions
            .where((e) =>
                (DateTime.now().month - 3 <= e.timeStamp!.month) &&
                (DateTime.now().year == e.timeStamp!.year) &&
                (e.timeStamp!.day <= 31))
            .toList();
        break;
      case DateType.customDate:
        transactions = transactions
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
        transactions = transactions.where((e) => e.isDelegated).toList();
        break;
      case TransactionType.receive:
        transactions = transactions.where((e) => !e.isSent).toList();
        break;
      case TransactionType.send:
        transactions = transactions.where((e) => e.isSent).toList();
        break;
      default:
    }
    switch (assetType.value) {
      case AssetType.token:
        transactions = transactions.where((e) => !e.isNft).toList();
        break;
      case AssetType.nft:
        transactions = transactions.where((e) => e.isNft).toList();
        break;
      default:
    }
    return transactions;
  }

  void apply() async {
    accountController.isFilterApplied.value = true;
    accountController.filteredTransactionList.value =
        _applyFilter(accountController.defaultTransactionList);
    accountController.filteredTransactionList.refresh();
    Get.back();
  }

  List<TokenInfo> fetchFilteredList(
          {required List<TokenInfo> nextHistoryList}) =>
      _applyFilter(nextHistoryList);
}

enum AssetType { token, nft, all }

enum TransactionType { delegation, send, receive, all }

enum DateType { today, currentMonth, last3Months, customDate, none }
