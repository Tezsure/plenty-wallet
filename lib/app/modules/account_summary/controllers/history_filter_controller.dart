import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';


class HistoryFilterController extends GetxController {
  final accountController = Get.find<TransactionController>();

  RxList<AssetType> assetType = AssetType.values.obs;
  RxList<TransactionType> transactionType = TransactionType.values.obs;
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
    assetType.value = [...AssetType.values];
    transactionType.value = [...TransactionType.values];
    dateType.value = DateType.none;
    accountController.noMoreResults.value = false;
    accountController.isFilterApplied.value = false;
    query = {};
    apply();
  }

  Map<String, String> query = {};
  void applyFilter() {
    DateTime time = DateTime.now();
    query = {};
    //print(transactions);
    switch (dateType.value) {
      case DateType.today:
        final now = DateTime.now();
        query.addAll({
          "timestamp.ge":
              DateTime(now.year, now.month, now.day).toIso8601String()
        });
        break;
      case DateType.currentMonth:
        final now = DateTime.now();
        query.addAll({
          "timestamp.ge": DateTime(now.year, now.month, 1).toIso8601String()
        });
        break;
      case DateType.last3Months:
        final now = DateTime.now().subtract(const Duration(days: 90));
        query.addAll({
          "timestamp.ge": DateTime(now.year, now.month, 1).toIso8601String()
        });
        // transactions = transactions
        //     .where((e) =>
        //         (DateTime.now().month - 3 <= e.timeStamp!.month) &&
        //         (DateTime.now().year == e.timeStamp!.year) &&
        //         (e.timeStamp!.day <= 31))
        //     .toList();
        break;
      case DateType.customDate:
        query.addAll({
          "timestamp.in":
              "${DateFormat("yyyy-MM-dd").format(fromDate.value)},${DateFormat("yyyy-MM-dd").format(toDate.value)}"
        });

        break;
      default:
        break;
    }

    if (transactionType.any((element) => element == TransactionType.receive)) {
      // if (query["type"] == "delegation") {
      //   query.remove("type");
      // } else {
      //   query["type"] = "transaction";
      // }
      query.addAll({
        "sender.ne":
            accountController.accController.selectedAccount.value.publicKeyHash!
      });
    }
    if (transactionType.any((element) => element == TransactionType.send)) {
      // if (query["type"] == "delegation") {
      //   query.remove("type");
      // } else if (query["type"] != null) {
      //   query["type"] = "transaction";
      // }

      if (query["sender.ne"] != null) {
        query.remove("sender.ne");
      } else {
        query.addAll({
          "sender": accountController
              .accController.selectedAccount.value.publicKeyHash!
        });
      }
    }

    if (transactionType
        .every((element) => element == TransactionType.delegation)) {
      query.addAll({"type": "delegation"});
    } else {
      if (transactionType.length == 2 &&
          transactionType
              .any((element) => element == TransactionType.delegation)) {
        query.addAll({"type": "delegation"});
      }
    }
    // if (assetType.length != 2) {
    //   if (assetType.any((element) => element == AssetType.token)) {
    //     tempTransactions = [
    //       ...tempTransactions.where((e) => !e.isNft).toList()
    //     ];
    //   }
    //   if (assetType.any((element) => element == AssetType.nft)) {
    //     tempTransactions = [...tempTransactions.where((e) => e.isNft).toList()];
    //   }
    // }

    //print(tempTransactions);
    // transactions = tempTransactions.toSet().toList();

    // print(transactions);
    // switch (assetType.value) {
    //   case AssetType.token:
    //     transactions = transactions.where((e) => !e.isNft).toList();
    //     break;
    //   case AssetType.nft:
    //     transactions = transactions.where((e) => e.isNft).toList();
    //     break;
    //   default:
    // }
    // return transactions;
  }

  Future<void> apply() async {
    accountController.isFilterApplied.value = true;
    accountController.filteredTransactionList.clear();
    accountController.defaultTransactionList.clear();
    accountController.userTransactionHistory.clear();
    accountController.userTransferHistory.clear();
    accountController.tokenTransactionID.clear();

    // accountController.filteredTransactionList.value =
    applyFilter();

    await accountController.loadFilteredTransaction();
    // List<TokenInfo> tempTransactions = [
    //   ...accountController.filteredTransactionList
    // ];
    // if (assetType.length != 2) {
    //   if (assetType.any((element) => element == AssetType.token)) {
    //     tempTransactions = [
    //       ...tempTransactions.where((e) => !e.isNft).toList()
    //     ];
    //   }
    //   if (assetType.any((element) => element == AssetType.nft)) {
    //     tempTransactions = [...tempTransactions.where((e) => e.isNft).toList()];
    //   }
    // }
    // accountController.filteredTransactionList.value = [...tempTransactions];
    // accountController.filteredTransactionList.refresh();
  }
}

enum AssetType {
  token,
  nft,
}

enum TransactionType {
  delegation,
  send,
  receive,
}

enum DateType { today, currentMonth, last3Months, customDate, none }
