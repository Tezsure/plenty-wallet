import 'dart:convert';

import 'package:dartez/dartez.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';

class RpcService {
  Future<double> getUserBalanceInTezos(String address, [String? rpc]) async {
    try {
      var balance = await Dartez.getBalance(
          address, rpc ?? ServiceConfig.currentSelectedNode);
      if (balance == "0") return 0.0;
      return (int.parse(balance) / 1e6);
    } catch (e) {
      return 0.0;
    }
  }

  Future<List<AccountTokenModel>> getUserTokenBalances(String address) async {
    try {
      return jsonDecode(await HttpService.performGetRequest(
              ServiceConfig.tzktApiForToken(address)))
          .map<AccountTokenModel>((e) => parseAccountModel(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  AccountTokenModel parseAccountModel(e) {
    var balance = (BigInt.parse(e['balance']) /
            BigInt.parse(1
                .toStringAsFixed(int.parse(e['token']['metadata']['decimals']))
                .replaceAll(".", "")))
        .toDouble();
    return AccountTokenModel(
        balance: balance,
        contractAddress: e['token']['contract']['address'],
        tokenId: e['token']['tokenId'] ?? '0',
        decimals: int.parse(e['token']['metadata']['decimals']));
  }
}
