import 'dart:convert';
import 'dart:isolate';

import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_render_service.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';

/// Fetch, modify and store the token prices and xtz price
class TokenAndXtzPriceHandler {
  DataHandlerRenderService dataHandlerRenderService;
  TokenAndXtzPriceHandler(this.dataHandlerRenderService);

  static Future<void> _isolateProcess(List<dynamic> args) async {
    // fetch xtz price using coingecko
    Map<String, dynamic> xtzPriceResponse = jsonDecode(
        await HttpService.performGetRequest(ServiceConfig.coingeckoApi));
    double xtzPrice = xtzPriceResponse['tezos']['usd'] as double;

    // fetch token prices using teztools api
    String tokenPricesResponse =
        await HttpService.performGetRequest(ServiceConfig.tezToolsApi);

    List<TokenPriceModel> tokenPriceModels =
        jsonDecode(tokenPricesResponse)['contracts']
            .map<TokenPriceModel>((e) => TokenPriceModel.fromJson(e))
            .toList();

    args[0].send({
      "xtzPrice": xtzPrice.toString(),
      "tokenPrices": jsonEncode(tokenPriceModels),
    });
  }

  /// Get&Store teztool price apis for tokens price
  Future<void> executeProcess({required Function postProcess}) async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(
      _isolateProcess,
      <dynamic>[
        receivePort.sendPort,
      ],
      debugName: "xtz & tokenPrices",
    );
    receivePort.asBroadcastStream().listen((data) async {
      await _storeData(data, postProcess);
    });
  }

  Future<void> _storeData(Map<String, String> data, postProcess) async {
    postProcess(double.parse(data['xtzPrice'].toString()));
    // store xtz and token prices into local

    await ServiceConfig.localStorage
        .write(key: ServiceConfig.xtzPriceStorage, value: data['xtzPrice']);
    await ServiceConfig.localStorage.write(
        key: ServiceConfig.tokenPricesStorage, value: data['tokenPrices']);
  }
}
