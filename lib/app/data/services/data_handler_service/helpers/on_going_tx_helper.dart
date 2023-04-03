import 'dart:convert';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:naan_wallet/env.dart';
import 'package:http/http.dart' as http;
import '../../../../modules/settings_page/enums/network_enum.dart';
import '../../service_config/service_config.dart';

class OnGoingTxStatusHelper {
  String opHash;
  TransactionStatus status;
  String transactionAmount;
  String tezAddress;
  bool isBrowser = false;
  bool saveAddress = false;
  String senderAddress = "";
  OnGoingTxStatusHelper(
      {required this.opHash,
      required this.status,
      required this.transactionAmount,
      required this.tezAddress,
      this.isBrowser = false,
      this.saveAddress = false,
      this.senderAddress = ""});

  Future<int> getStatus() async {
    String network = "mainnet";
    network = ServiceConfig.currentNetwork == NetworkType.testnet
        ? Uri.parse(ServiceConfig.currentSelectedNode).path.replaceAll("/", "")
        : "mainnet";

    var response = await HttpService.performGetRequest(
        "https://api.$network.tzkt.io/v1/operations/$opHash");

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      var status = jsonDecode(response)[0]['status'];
      if (status == "failed" ||
          status == "backtracked" ||
          status == "skipped") {
        Get.closeAllSnackbars();
        transactionStatusSnackbar(
            status: TransactionStatus.failed,
            tezAddress: tezAddress,
            transactionAmount: transactionAmount,
            duration: const Duration(seconds: 5),
            isBrowser: isBrowser);
        return 1;
      } else if (status == "applied") {
        Get.closeAllSnackbars();
        transactionStatusSnackbar(
            status: TransactionStatus.success,
            tezAddress: tezAddress,
            transactionAmount: transactionAmount,
            duration: const Duration(seconds: 5),
            isBrowser: isBrowser);
        if (saveAddress) {
          try {
            addAddress(senderAddress);
          } catch (e) {
            print(e);
          }
        }
      }
      return 1;
    }
    return 0;
  }
}

Future<void> addAddress(String address) async {
  final response = await http.post(
    Uri.parse(ServiceConfig.springFeverApi),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $secret_token_sprint_fever',
    },
    body: jsonEncode({'address': address}),
  );

  if (response.statusCode == 201) {
    print('Address added successfully $address');
  } else {
    print('Failed to add address: ${response.body}');
  }
}
