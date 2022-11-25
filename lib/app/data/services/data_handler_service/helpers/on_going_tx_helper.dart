import 'dart:convert';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';

class OnGoingTxStatusHelper {
  String opHash;
  TransactionStatus status;
  String transactionAmount;
  String tezAddress;

  OnGoingTxStatusHelper({
    required this.opHash,
    required this.status,
    required this.transactionAmount,
    required this.tezAddress,
  });

  Future<int> getStatus() async {
    var response = await HttpService.performGetRequest(
        "https://api.tzkt.io/v1/operations/$opHash");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      var status = jsonDecode(response)[0]['status'];
      if (status == "failed") {
        Get.closeAllSnackbars();
        transactionStatusSnackbar(
          status: TransactionStatus.failed,
          tezAddress: tezAddress,
          transactionAmount: transactionAmount,
          duration: const Duration(seconds: 5),
        );
        return 1;
      } else if (status == "applied") {
        Get.closeAllSnackbars();
        transactionStatusSnackbar(
          status: TransactionStatus.success,
          tezAddress: tezAddress,
          transactionAmount: transactionAmount,
          duration: const Duration(seconds: 5),
        );
        return 1;
      }
    }
    return 0;
  }
}
