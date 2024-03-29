import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_render_service.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/settings_page/enums/network_enum.dart';

import '../../rpc_service/http_service.dart';

class AccountDataHandler {
  DataHandlerRenderService dataHandlerRenderService;
  AccountDataHandler(this.dataHandlerRenderService);

  // delay duration

  static Future<void> _isolateProcess(List<dynamic> args) async {
    try {
      List<String> accountAddress = [...args[1].toList(), ...args[2].toList()];

      String rpc = args[3] as String;

      // fecth xtz balance
      List<double> tempAccountBalances = await Future.wait(accountAddress
          .map((e) => RpcService().getUserBalanceInTezos(e, rpc))
          .toList());

      // fetch token balances
      List<List<AccountTokenModel>> tempAccountTokenModels = await Future.wait(
          accountAddress
              .map((e) => RpcService().getUserTokenBalances(e, rpc))
              .toList());

      // send data back
      List<dynamic> data = <dynamic>[
        <String, double>{
          for (int i = 0; i < accountAddress.length; i++)
            accountAddress[i]: tempAccountBalances[i]
        },
        <String, List<AccountTokenModel>>{
          for (int i = 0; i < accountAddress.length; i++)
            accountAddress[i]: tempAccountTokenModels[i]
        },
      ];
      Future<List<TokenPriceModel>> getTokenPriceModel(
          [List<String>? contractAddress]) async {
        if (args[4] != null && contractAddress != null) {
          List<TokenPriceModel> tokensList = jsonDecode(args[4])['contracts']
              .map<TokenPriceModel>((e) => TokenPriceModel.fromJson(e))
              .toList();
          // List<TokenPriceModel> tokensListAnalytics = jsonDecode(args[8])
          //     .map<TokenPriceModel>((e) =>
          //         TokenPriceModel.fromJson(e, isAnalytics: true, xtzPrice: 1))
          //     .toList();
          // tokensListAnalytics.forEach((element) {
          //   if (tokensList
          //       .where((e) =>
          //           e.tokenAddress == element.tokenAddress &&
          //           e.tokenId == element.tokenId)
          //       .isEmpty) {
          //     tokensList.add(element);
          //   }
          // });
          return tokensList
              .where((e) => contractAddress.contains(e.tokenAddress.toString()))
              .toList();
        } else if (args[4] != null) {
          List<TokenPriceModel> tokensList = jsonDecode(args[4])["contracts"]
              .map<TokenPriceModel>((e) => TokenPriceModel.fromJson(e))
              .toList();
          // List<TokenPriceModel> tokensListAnalytics = jsonDecode(args[8])
          //     .map<TokenPriceModel>((e) =>
          //         TokenPriceModel.fromJson(e, isAnalytics: true, xtzPrice: 1))
          //     .toList();

          // tokensListAnalytics.forEach((element) {
          //   if (tokensList
          //       .where((e) =>
          //           e.tokenAddress == element.tokenAddress &&
          //           e.tokenId == element.tokenId)
          //       .isEmpty) {
          //     tokensList.add(element);
          //   }
          // });
          return tokensList;
        } else {
          return [];
        }
      }

      String xtzPrice = jsonDecode(await HttpService.performGetRequest(
          ServiceConfig.xtzPriceApi,
          callSetupTimer: true))[0]['price']['value'];

      Map<String, List<AccountTokenModel>>
          parseAccountTokenModelUsingTokenPrices(
              Map<String, List<AccountTokenModel>> data,
              List<TokenPriceModel> tokenPrices) {
        return data.map((key, value) => MapEntry(
            key,
            value
                .map(
                  (e) {
                    var tokenList = tokenPrices
                        .where((element) =>
                            e.contractAddress == element.tokenAddress &&
                            (element.type == "fa2"
                                ? e.tokenId == element.tokenId
                                : true))
                        .toList();

                    if (tokenList.isEmpty) {
                      return e..name = null;
                    }
                    var token = tokenList.first;
                    e.name = token.name;

                    e.symbol = token.symbol;
                    e.tokenStandardType = token.type == "fa2"
                        ? TokenStandardType.fa2
                        : TokenStandardType.fa1;
                    e.valueInXtz = token.currentPrice! *
                        e.balance /
                        double.parse(xtzPrice);
                    e.currentPrice =
                        token.currentPrice! / double.parse(xtzPrice);
                    return e;
                  },
                )
                .toList()
                .where((element) => element.name != null)
                .toList()));
      }

      List<TokenPriceModel> tokenPrices = await getTokenPriceModel(
          (data[1] as Map<String, List<AccountTokenModel>>)
              .values
              .fold<List<String>>(
                  <String>[],
                  (previousValue, element) => previousValue
                    ..addAll(
                        element.map<String>((e) => e.contractAddress).toList()))
              .toSet()
              .toList());

      List<String> supportedTokens =
          tokenPrices.map<String>((e) => e.tokenAddress!).toList();

      Map<String, List<AccountTokenModel>> unsupportedTokens =
          (data[1] as Map<String, List<AccountTokenModel>>)
              .map<String, List<AccountTokenModel>>((key, value) {
        return MapEntry(
            key,
            value
                .where((element) =>
                    !supportedTokens.contains(element.contractAddress))
                .toList());
      });

      (data[1] as Map<String, List<AccountTokenModel>>).forEach((key, value) {
        data[1][key] = value
          ..removeWhere(
              (element) => !supportedTokens.contains(element.contractAddress));
      });

      data[1] = parseAccountTokenModelUsingTokenPrices(data[1], tokenPrices);

      // save account xtz balances
      args[5] = args[5]
          .map(
            ((e) => e.copyWith(
                  accountDataModel: e.accountDataModel!.copyWith(
                    xtzBalance: data[0][e.publicKeyHash!],
                    tokenXtzBalance: data[0][e.publicKeyHash!] +
                        (data[1].containsKey(e.publicKeyHash)
                            ? (data[1][e.publicKeyHash]
                                    as List<AccountTokenModel>)
                                .fold<double>(
                                    0.0,
                                    (previousValue, element) =>
                                        previousValue + element.valueInXtz!)
                            : 0.0),
                  ),
                )),
          )
          .toList();

      args[6] = args[6]
          .map(
            ((e) => e.copyWith(
                  accountDataModel: e.accountDataModel!.copyWith(
                    xtzBalance: data[0][e.publicKeyHash!],
                    tokenXtzBalance: data[0][e.publicKeyHash!] +
                        (data[1].containsKey(e.publicKeyHash)
                            ? (data[1][e.publicKeyHash]
                                    as List<AccountTokenModel>)
                                .fold<double>(
                                    0.0,
                                    (previousValue, element) =>
                                        previousValue + element.valueInXtz!)
                            : 0.0),
                  ),
                )),
          )
          .toList();

      List<AccountTokenModel> getVal(String address) {
        return jsonDecode(args[7][address])
            .map<AccountTokenModel>((e) => AccountTokenModel.fromJson(e))
            .toList();
      }

      // fetches the stored token list if any and updates the respective token values
      (data[1] as Map<String, List<AccountTokenModel>>)
          .forEach((key, value) async {
        List<AccountTokenModel> tokenList = getVal(key);

        if (tokenList.isNotEmpty) {
          // remove unsupported tokens
          if (unsupportedTokens.containsKey(key)) {
            tokenList.removeWhere((element) => unsupportedTokens[key]!
                .map<String>((e) => e.contractAddress)
                .toList()
                .contains(element.contractAddress));
          }
          List<String> updateTokenAddresses = value
              .map<String>((e) => e.contractAddress)
              .toList(); // get all the token addresses which are updated

          (data[1] as Map<String, List<AccountTokenModel>>).update(
              key,
              (tokens) => tokens.map((e) {
                    var oldToken = tokenList.firstWhere(
                        (element) =>
                            element.contractAddress == e.contractAddress &&
                            element.tokenId == e.tokenId, orElse: () {
                      return AccountTokenModel(
                          balance: -1,
                          contractAddress: "contractAddress",
                          tokenId: "tokenId",
                          decimals: 1);
                    });

                    if (oldToken.balance == -1) {
                      return e;
                    } else {
                      return e.copyWith(
                        isHidden: oldToken.isHidden,
                        isPinned: oldToken.isPinned,
                        isSelected: oldToken.isSelected,
                      );
                    }
                  }).toList()

              /*           tokenList.map((e) {
              AccountTokenModel updatedToken = tokens
                      .where(
                        (element) =>
                            element.contractAddress == e.contractAddress &&
                            element.tokenId == e.tokenId,
                      )
                      .isNotEmpty
                  ? tokens.firstWhere(
                      (element) =>
                          element.contractAddress == e.contractAddress &&
                          element.tokenId == e.tokenId,
                    )
                  : e;
              return updateTokenAddresses.contains(e.contractAddress)
                  ? e.copyWith(
                      balance: updatedToken.balance,
                      currentPrice: updatedToken.currentPrice,
                      decimals: updatedToken.decimals,
                      iconUrl: updatedToken.iconUrl,
                      // name: updatedToken.name,
                      // symbol: updatedToken.symbol,
                      valueInXtz: updatedToken.valueInXtz,
                      // tokenId: updatedToken.tokenId,
                      // tokenStandardType: updatedToken.tokenStandardType,
                    )
                  : e;
            }).toList(), */
              );
        }
      });

      // update account list before write data into localStorage
      if (args[5].isNotEmpty || args[6].isNotEmpty) {
        if (args[5].isNotEmpty) {
          args[5].first.isAccountPrimary = true;
        }
      }

      var userTokenList = {
        for (var item in data[1].keys)
          item:
              jsonEncode([...data[1][item], ...(unsupportedTokens[item] ?? [])])
      };

      args[0].send([
        args[5],
        args[6],
        userTokenList
        // tokens as Map<String(address),List<AccountTokenModel>>
      ]);
    } catch (e) {
      debugPrint("yoooo $e");
    }

  }

  /// Get&Store all accounts balances, tokens data and nfts
  Future<void> executeProcess(
      {required Function postProcess, required Function onDone}) async {
    ReceivePort receivePort = ReceivePort();

    List<AccountModel> accountModels =
        await UserStorageService().getAllAccount();

    List<AccountModel> watchAccountModels =
        await UserStorageService().getAllAccount(
      watchAccountsList: true,
    );
/*     var x =       await Future.wait(
            [...accountModels, ...watchAccountModels].map((element) async {
          return {
            element.publicKeyHash: 
          };
        }));

 */
    var isolate = await Isolate.spawn(
      _isolateProcess,
      <dynamic>[
        receivePort.sendPort,
        accountModels.map<String>((e) => e.publicKeyHash!),
        watchAccountModels.map<String>((e) => e.publicKeyHash!),
        ServiceConfig.currentNetwork == NetworkType.mainnet
            ? ""
            : ServiceConfig.currentSelectedNode,
        await dataHandlerRenderService.getTokenPrice(),
        accountModels,
        watchAccountModels,
        {
          for (var e in [...accountModels, ...watchAccountModels])
            e.publicKeyHash: (await ServiceConfig.hiveStorage.read(
                    key:
                        "${ServiceConfig.accountTokensStorage}_${e.publicKeyHash}") ??
                "[]")
        },
        // await dataHandlerRenderService.getTokenPriceModelAnalyticsString(),
      ],
      debugName: "accounts xtz, tokens & nfts",
    );
    receivePort.asBroadcastStream().listen((data) async {
      await ServiceConfig.secureLocalStorage.write(
          key: ServiceConfig.accountsStorage, value: jsonEncode(data[0]));

      // save watch accounts data
      await ServiceConfig.secureLocalStorage.write(
          key: ServiceConfig.watchAccountsStorage, value: jsonEncode(data[1]));

      // save all tokens separate based on publicKeyHash of the account
      for (String key in data[2].keys) {
        await ServiceConfig.hiveStorage.write(
            key: "${ServiceConfig.accountTokensStorage}_$key",
            value: data[2][key]);
      }
      await postProcess([...data[0], ...data[1]].cast<AccountModel>());
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
      onDone();
      //await _storeData(data, accountModels, watchAccountModels, postProcess);
    });
  }
}
