import 'dart:convert';
import 'dart:developer';

import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';

class IAFService {
  Future<bool> checkEmailStatus(String email, String address) async {
    var response = await HttpService.performPostRequest(
        "https://api.naan.app/api/v1/emailVerification",
        body: {"email": email, "userAddress": address});

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      if (jsonDecode(response)['status'] == null) {
        transactionStatusSnackbar(
          duration: const Duration(seconds: 2),
          status: TransactionStatus.error,
          tezAddress: jsonDecode(response)['message'] ?? 'Invalid email',
          transactionAmount: 'Cannot claim',
        );
      } else {
        return jsonDecode(response)['status'] == "success";
      }
    }
    return false;
  }

  Future<bool> claimNFT(String email, String address) async {
    var response = await HttpService.performPostRequest(
        "https://api.naan.app/api/v1/claimNft",
        body: {"emailAddress": email, "userAddress": address});

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      if (jsonDecode(response)['status'] == null) {
        transactionStatusSnackbar(
          duration: const Duration(seconds: 2),
          status: TransactionStatus.error,
          tezAddress: jsonDecode(response)['message'] ??
              'You have already claimed an NFT',
          transactionAmount: 'Cannot claim',
        );
      } else {
        return jsonDecode(response)['status'] == "success";
      }
    }
    return false;
  }
}
