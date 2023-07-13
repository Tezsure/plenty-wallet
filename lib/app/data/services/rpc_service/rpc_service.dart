import 'dart:convert';
import 'dart:developer';

import 'package:dartez/dartez.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/rpc_node_model.dart';
import 'package:plenty_wallet/app/modules/settings_page/enums/network_enum.dart';

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
    try {
      return (await ServiceConfig.localStorage
          .read(key: ServiceConfig.nodeStorage));
    } catch (e) {
      return null;
    }
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
    String network = "mainnet.";

    if (rpc != "" && Uri.parse(rpc).path.isNotEmpty) {
      network = "${Uri.parse(rpc).path.replaceAll("/", "")}.";
    }
    try {
      var tokenList = jsonDecode(await HttpService.performGetRequest(
              ServiceConfig.tzktApiForToken(address, network),
              callSetupTimer: true))
          .map<AccountTokenModel>((e) => parseAccountModel(e))
          .toList();

      // Remove duplicate token based on contract address and token id
      var uniqueTokens = <AccountTokenModel>[];
      for (var token in tokenList) {
        if (uniqueTokens
            .where((element) =>
                element.contractAddress == token.contractAddress &&
                element.tokenId == token.tokenId)
            .isEmpty) {
          uniqueTokens.add(token);
        }
      }
      return uniqueTokens;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  AccountTokenModel parseAccountModel(e) {
    if (e['token']['metadata']['0'] != null) {
      e['token']['metadata'] = e['token']['metadata']['0']['metadata'];
    }
    double balance = 0.0;
    try {
      balance = (BigInt.parse(e['balance']) /
              BigInt.parse(1
                  .toStringAsFixed(int.tryParse(
                          e['token']['metadata']?['decimals'] ?? "0") ??
                      0)
                  .replaceAll(".", "")))
          .toDouble();
    } catch (e) {}
    return AccountTokenModel(
        balance: balance,
        name: e['token']['metadata']['name'] ?? 'N/A',
        symbol: e['token']['metadata']['symbol'] ?? 'N/A',
        contractAddress: e['token']['contract']['address'],
        tokenId: e['token']['tokenId'] ?? '0',
        currentPrice: 0.0,
        valueInXtz: 0.0,
        iconUrl: _getTokenURL(e['token']['metadata']),
        decimals: int.parse(e['token']['metadata']?['decimals'] ?? "0"));
  }

  String? _getTokenURL(e) {
    String? url;
    if (e['artifactUri'] != null) {
      url = e['artifactUri'];
    } else if (e['displayUri'] != null) {
      url = e['displayUri'];
    } else if (e['thumbnailUri'] != null) {
      url = e['thumbnailUri'];
    }

    if (url != null && url.startsWith("ipfs://")) {
      url = "https://cloudflare-ipfs.com/ipfs/${url.replaceAll("ipfs://", "")}";
    }
    return url;
  }

  static Future<String> getIpfsUrl() async {
    return await HttpService.performGetRequest(ServiceConfig.ipfsUrlApi);
  }
}
