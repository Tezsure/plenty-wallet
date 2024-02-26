import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_render_service.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';

/// Fetch, modify and store the token prices and xtz price
class TokenAndXtzPriceHandler {
  DataHandlerRenderService dataHandlerRenderService;
  TokenAndXtzPriceHandler(this.dataHandlerRenderService);

  static Future<void> _isolateProcess(List<dynamic> args) async {
    // fetch xtz price using coingecko
    // var xtzPriceResponse = ;

    // double xtzPrice = xtzPriceResponse['tezos']['usd'] as double;
    String tokenPrices = "";
    String tokenPricesAnalytics = "";

    String xtzPrice = await HttpService.performGetRequest(
        ServiceConfig.xtzPriceApi,
        callSetupTimer: true);

    try {
      tokenPricesAnalytics = await HttpService.performGetRequest(
          ServiceConfig.plentyAnalytics,
          callSetupTimer: true);

      var thumbnailUris = jsonDecode(await HttpService.performGetRequest(
          ServiceConfig.thumbnailUris,
          callSetupTimer: true));

      var modifyTokenPrices =
          (jsonDecode(tokenPricesAnalytics) as List).map((e) {
        var thumbnailUri = thumbnailUris[e['token']] ?? "";

        if (thumbnailUri.isNotEmpty) {
          thumbnailUri = thumbnailUri['thumbnailUri'] ?? "";
        }

        if (thumbnailUri.isNotEmpty) {
          thumbnailUri = thumbnailUri.replaceAll(
              "ipfs://", "https://cloudflare-ipfs.com/ipfs/");
        }

        return {
          "symbol": e['token'],
          "tokenAddress": e['contract'],
          "decimals": e['decimals'],
          "name": e['name'],
          "type": e['standard'].toString().toLowerCase(),
          "currentPrice": double.parse(e['price']['value'].toString()),
          "tokenId": e['tokenId'] == null ? '0' : e['tokenId'].toString(),
          "thumbnailUri": thumbnailUri,
        };
      }).toList();

      tokenPrices = jsonEncode({
        "contracts": modifyTokenPrices.toList(),
      });

      // tokenPrices = await HttpService.performGetRequest(
      //     ServiceConfig.tezToolsApi,
      //     callSetupTimer: true);
    } catch (e) {
      debugPrint(e.toString());
    }
    args[0].send({
      "xtzPrice": xtzPrice,
      "tokenPrices": tokenPrices,
      // "tokenPricesAnalytics": tokenPricesAnalytics,
    });
  }

  /// Get&Store teztool price apis for tokens price
  Future<void> executeProcess(
      {required Function postProcess, required Function onDone}) async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _isolateProcess,
      <dynamic>[
        receivePort.sendPort,
      ],
      debugName: "xtz & tokenPrices",
    );
    receivePort.asBroadcastStream().take(1).listen((data) async {
      onDone();
      await _storeData(data, postProcess);
      receivePort.close();

      isolate.kill(priority: Isolate.immediate);
    });
  }

  Future<void> _storeData(Map<String, String> data, postProcess) async {
    if (jsonDecode(data['xtzPrice']!) != null) {
      postProcess(jsonDecode(data['xtzPrice']!)[0]['price']);
      await ServiceConfig.hiveStorage.write(
          key: ServiceConfig.xtzPriceStorage,
          value: jsonDecode(data['xtzPrice']!)[0]['price']['value'].toString());
      await ServiceConfig.hiveStorage.write(
          key: ServiceConfig.dayChangeStorage,
          value: jsonDecode(data['xtzPrice']!)[0]['price']['change24H']
              .toString());
    }
    if (data['tokenPrices']!.isNotEmpty) {
      await ServiceConfig.hiveStorage.write(
          key: ServiceConfig.tokenPricesStorage, value: data['tokenPrices']);
    }
  }
}
