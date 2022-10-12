import 'package:get/get.dart';

class HistoryFilterController extends GetxController {
  Rx<AssetType> assetType = AssetType.token.obs;
  Rx<TransactionType> transactionType = TransactionType.delegation.obs;
  Rx<DateType> dateType = DateType.today.obs;

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

  void clear() {
    assetType.value = AssetType.token;
    transactionType.value = TransactionType.delegation;
    setDate(DateType.today);
  }
}

enum AssetType { token, nft }

enum TransactionType { delegation, send, receive }

enum DateType { today, currentMonth, last3Months, customDate }
