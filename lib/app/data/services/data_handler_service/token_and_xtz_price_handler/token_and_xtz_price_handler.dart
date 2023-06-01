import 'dart:convert';
import 'dart:isolate';

import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_render_service.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';

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
    try {
      tokenPrices = await HttpService.performGetRequest(
          ServiceConfig.tezToolsApi,
          callSetupTimer: true);
      tokenPricesAnalytics = await HttpService.performGetRequest(
          ServiceConfig.plentyAnalytics,
          callSetupTimer: true);
    } catch (e) {
      print(e);
    }
    args[0].send({
      "xtzPrice": await HttpService.performGetRequest(ServiceConfig.xtzPriceApi,
          callSetupTimer: true),
      "tokenPrices": tokenPrices,
      "tokenPricesAnalytics": tokenPricesAnalytics,
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
      await ServiceConfig.localStorage.write(
          key: ServiceConfig.xtzPriceStorage,
          value: jsonDecode(data['xtzPrice']!)[0]['price']['value'].toString());
      await ServiceConfig.localStorage.write(
          key: ServiceConfig.dayChangeStorage,
          value: jsonDecode(data['xtzPrice']!)[0]['price']['change24H']
              .toString());
    }
    if (data['tokenPrices']!.isNotEmpty) {
      await ServiceConfig.localStorage.write(
          key: ServiceConfig.tokenPricesStorage, value: data['tokenPrices']);
    }
    if (data['tokenPricesAnalytics']!.isNotEmpty) {
      await ServiceConfig.localStorage.write(
          key: ServiceConfig.tokenPricesAnalyticsStorage,
          value: data['tokenPricesAnalytics']);
    }
  }
}
