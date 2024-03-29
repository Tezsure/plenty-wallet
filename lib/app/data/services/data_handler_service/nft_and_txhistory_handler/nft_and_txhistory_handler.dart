import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_render_service.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:simple_gql/simple_gql.dart';

enum ProcessStatus { inProgress, done }

class NftAndTxHistoryHandler {
  DataHandlerRenderService dataHandlerRenderService;
  NftAndTxHistoryHandler(this.dataHandlerRenderService);

  static Future<void> _isolateProcess(List<dynamic> args) async {
    try {
      List<String> accountAddress = args[1][0].toList();
      List<String> allAccounts = [...accountAddress, ...args[1][1].toList()];
      String rpc = args[1][2];

      // call get nft for batch for 3 accounts in for loop
      for (int i = 0; i < allAccounts.length; i++) {
        args[0].send([
          ProcessStatus.inProgress,
          allAccounts[i],
          await ObjktNftApiService().getNftsContract(allAccounts[i])
        ]);
      }

      // List<String> accountsNft = await Future.wait(
      //   [...accountAddress, ...watchAccountAddress].map<Future<String>>(
      //     (e) => ObjktNftApiService().getNfts(e),
      //   ),
      // );

      List<List<TxHistoryModel>> accountsTxHistory =
          await Future.wait(allAccounts.map<Future<List<TxHistoryModel>>>(
        (e) => TzktTxHistoryApiService(e, rpc).getTxHistory(),
      ));

      // send data back
      args[0].send([
        // account nfts as Map<String(address),List<dynamic>>
        ProcessStatus.done,
        // account tx history as Map<String(address),List<TxHistoryModel>>
        <String, String>{
          for (int i = 0; i < accountAddress.length; i++)
            accountAddress[i]: jsonEncode(accountsTxHistory[i])
        },
      ]);
    } catch (e) {
      debugPrint(e.toString());

      DataHandlerService().setUpTimer();
    }
  }

  /// Get&Store teztool price apis for tokens price
  Future<void> executeProcess(
      {required Function postProcess, required Function onDone}) async {
    ReceivePort receivePort = ReceivePort();
    var isolate = await Isolate.spawn(
      _isolateProcess,
      <dynamic>[
        receivePort.sendPort,
        [
          (await UserStorageService().getAllAccount())
              .map<String>((e) => e.publicKeyHash!)
              .toList(),
          (await UserStorageService().getAllAccount(
            watchAccountsList: true,
          ))
              .map<String>((e) => e.publicKeyHash!)
              .toList(),
          ServiceConfig.currentNetwork == NetworkType.mainnet
              ? ""
              : ServiceConfig.currentSelectedNode,
        ],
      ],
      debugName: "nft & tx-history",
    );

    receivePort.asBroadcastStream().listen((data) async {
      if (data[0] is ProcessStatus && data[0] == ProcessStatus.done) {
        // debugPrint("nft & tx-history process done");
        receivePort.close();
        isolate.kill(priority: Isolate.immediate);
        onDone();
        await postProcess();
      }
      await _storeData(data);
    });
  }

  void nftStore(String key, String value) => ServiceConfig.hiveStorage
      .write(key: "${ServiceConfig.nftStorage}_$key", value: value);

  Future<void> _storeData(List data) async {
    if (data[0] is ProcessStatus && data[0] == ProcessStatus.inProgress) {
      await ServiceConfig.hiveStorage
          .write(key: "${ServiceConfig.nftStorage}_${data[1]}", value: data[2]);
    } else {
      for (var key in data[1].keys) {
        await ServiceConfig.hiveStorage.write(
            key: "${ServiceConfig.txHistoryStorage}_$key", value: data[1][key]);
      }
    }
  }
}

class ObjktNftApiService {
  Future<String> getNfts(String pkH) async {
    try {
      final response = await GQLClient(
        'https://data.objkt.com/v3/graphql',
      ).query(
        query: ServiceConfig.gQuery,
        variables: {'address': pkH},
      );

      return jsonEncode(
          response.data['token'].where((e) => e['token_id'] != "").toList());
    } catch (e) {
      debugPrint(" gql error $e");
      return "[]";
    }
  }

  Future<String> getNftsFast(String pkH, int offset) async {
    try {
      final response = await GQLClient(
        'https://data.objkt.com/v3/graphql',
      ).query(
        query: ServiceConfig.gQueryFast,
        variables: {'address': pkH, 'offset': offset},
      );

      return jsonEncode(
          response.data['token'].where((e) => e['token_id'] != "").toList());
    } catch (e) {
      debugPrint(" gql error $e");
      return "[]";
    }
  }

  Future<String> getNftsContract(String pkH) async {
    try {
      int offset = 0;
      List<String> contracts = [];
      while (true) {
        final response = await GQLClient(
          'https://data.objkt.com/v3/graphql',
        ).query(
          query: ServiceConfig.getContractQuery,
          variables: {'address': pkH, 'offset': offset},
        );
        contracts = [
          ...contracts,
          ...response.data['token'].map((e) => e['fa_contract']).toList()
        ];
        offset += 500;
        if (response.data['token'].length != 500) {
          break;
        }
      }
      return jsonEncode(contracts);
    } catch (e) {
      debugPrint(" gql error $e");
      return "[]";
    }
  }

  Future<NftTokenModel> getTransactionNFT(
      String contractAddress, String tokenId) async {
    try {
      final response =
          await GQLClient("https://data.objkt.com/v3/graphql").query(
        query: ServiceConfig.nftQuery,
        variables: {'address': contractAddress, 'token_id': tokenId},
      );

      return NftTokenModel.fromJson(response.data['token'][0]);
    } catch (e) {
      return NftTokenModel();
    }
  }
}

/// Transaction History Api Service usng tzkt.io
class TzktTxHistoryApiService {
  String pkH;
  String rpc;

  TzktTxHistoryApiService(this.pkH, this.rpc);

  /// Get transaction history for a given account recent 20 transactions
  Future<List<TxHistoryModel>> getTxHistory(
      {int limit = 30,
      String lastId = "",
      String? sortBy = "Descending",
      String? query}) async {
    String network = "";
    if (Uri.parse(rpc).path.isNotEmpty) {
      network = "${Uri.parse(rpc).path.replaceAll("/", "")}.";
    }
    var url = ServiceConfig.tzktApiForAccountTxs(pkH,
        limit: limit,
        lastId: lastId,
        sort: sortBy ?? "Descending",
        network: network.contains("ak-csrjehxhpw0dl3") ? "" : network,
        query: query);
    debugPrint(url);
    var response =
        await HttpService.performGetRequest(url, callSetupTimer: true);

    /// if response is empty return empty list of tx history
    /// else return list of tx history model
    return response.isEmpty
        ? <TxHistoryModel>[]
        : jsonDecode(response)
            .map<TxHistoryModel>((e) => TxHistoryModel.fromJson(e))
            .toList();
  }
}
