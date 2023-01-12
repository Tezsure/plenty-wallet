import 'dart:convert';

import 'package:dartez/dartez.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/rpc_node_model.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';

class RpcService {
  static Future<NetworkType> getCurrentNetworkType() async {
    final String? networkString = await ServiceConfig.localStorage
        .read(key: ServiceConfig.networkStorage);
    switch (networkString) {
      case "mainnet":
        return NetworkType.mainnet;
      case "testnet":
        return NetworkType.testnet;
      default:
        return NetworkType.mainnet;
    }
  }

  static Future<void> setNetworkType(NetworkType networkType) async {
    await ServiceConfig.localStorage
        .write(key: ServiceConfig.networkStorage, value: networkType.name);
  }

  static Future<String?> getCurrentNode() async {
    return (await ServiceConfig.localStorage
        .read(key: ServiceConfig.nodeStorage));
  }

  static Future<void> setNode(String url) async {
    await ServiceConfig.localStorage
        .write(key: ServiceConfig.nodeStorage, value: url);
  }

  static Future<List<NodeModel>> getCustomNode() async {
    final json = (await ServiceConfig.localStorage
        .read(key: ServiceConfig.customRpcStorage));
    if (json == null) return [];
    final customNodes = List<NodeModel>.from(jsonDecode(json)
        .entries
        .map((k) => NodeModel(name: k.key, url: k.value))
        .toList());
    return customNodes;
  }

  static Future<void> setCustomNode(List<NodeModel> node) async {
    Map<String, String> map = {};
    node.forEach((e) {
      map.addAll(e.toJson());
    });
    await ServiceConfig.localStorage
        .write(key: ServiceConfig.customRpcStorage, value: jsonEncode(map));
  }

  Future<double> getUserBalanceInTezos(String address, [String? rpc]) async {
    try {
      var balance = await Dartez.getBalance(
          address,
          rpc == ""
              ? ServiceConfig.currentSelectedNode
              : rpc ?? ServiceConfig.currentSelectedNode);
      if (balance == "0") return 0.0;
      return (int.parse(balance) / 1e6);
    } catch (e) {
      return 0.0;
    }
  }

  Future<List<AccountTokenModel>> getUserTokenBalances(
      String address, String rpc) async {
    String network = "${ServiceConfig.currentNetwork.name}.";
    if (network == "testnet." && Uri.parse(rpc).path.isNotEmpty) {
      network = "${Uri.parse(rpc).path.replaceAll("/", "")}.";
    }
    try {
      return jsonDecode(await HttpService.performGetRequest(
              ServiceConfig.tzktApiForToken(address, network)))
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
