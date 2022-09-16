import 'dart:convert';
import 'dart:isolate';

import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_render_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:simple_gql/simple_gql.dart';

class NftAndTxHistoryHandler {
  DataHandlerRenderService dataHandlerRenderService;
  NftAndTxHistoryHandler(this.dataHandlerRenderService);

  static Future<void> _isolateProcess(List<dynamic> args) async {
    List<String> accountAddress = args[1].toList();
    List<List<NftTokenModel>> accountsNft = await Future.wait(
      accountAddress.map<Future<List<NftTokenModel>>>(
        (e) => _ObjktNftApiService(e).getNfts(),
      ),
    );

    // send data back
    args[0].send([
      // account nfts as Map<String(address),List<NftTokenModel>>
      <String, List<NftTokenModel>>{
        for (int i = 0; i < accountAddress.length; i++)
          accountAddress[i]: accountsNft[i]
      },
    ]);
  }

  /// Get&Store teztool price apis for tokens price
  Future<void> executeProcess({required Function postProcess}) async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(
      _isolateProcess,
      <dynamic>[
        receivePort.sendPort,
        (await UserStorageService().getAllAccount())
            .map<String>((e) => e.publicKeyHash!)
            .toList(),
      ],
      debugName: "nft & tx-history",
    );
    receivePort.asBroadcastStream().listen((data) async {
      await _storeData(data);
      // await postProcess();
    });
  }

  Future<void> _storeData(List data) async {
    // store nfts

    for (var key in data[0].keys) {
      await ServiceConfig.localStorage.write(
          key: "${ServiceConfig.nftStorage}_$key",
          value: jsonEncode(data[0][key]));
    }
  }
}

class _ObjktNftApiService {
  String pkH;

  _ObjktNftApiService(this.pkH);

  Future<List<NftTokenModel>> getNfts() async {
    try {
      final response = await GQLClient(
        'https://data.objkt.com/v2/graphql',
      ).query(
        query: ServiceConfig.gQuery,
        variables: {'address': pkH},
      );
      return response.data['token']
          .map<NftTokenModel>((e) => NftTokenModel.fromJson(e))
          .toList()
          .where((e) => e.holders.length > 0 && e.tokenId.isNotEmpty)
          .toList();
    } catch (e) {
      return <NftTokenModel>[];
    }
  }
}
