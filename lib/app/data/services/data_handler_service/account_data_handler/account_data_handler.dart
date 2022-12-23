import 'dart:convert';
import 'dart:isolate';

import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_render_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';

class AccountDataHandler {
  DataHandlerRenderService dataHandlerRenderService;
  AccountDataHandler(this.dataHandlerRenderService);

  static Future<void> _isolateProcess(List<dynamic> args) async {
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
    args[0].send([
      // account balances as Map<String(address),double(xtzAmount)>
      <String, double>{
        for (int i = 0; i < accountAddress.length; i++)
          accountAddress[i]: tempAccountBalances[i]
      },
      // tokens as Map<String(address),List<AccountTokenModel>>
      <String, List<AccountTokenModel>>{
        for (int i = 0; i < accountAddress.length; i++)
          accountAddress[i]: tempAccountTokenModels[i]
      },
    ]);
  }

  /// Get&Store all accounts balances, tokens data and nfts
  Future<void> executeProcess({required Function postProcess}) async {
    ReceivePort receivePort = ReceivePort();

    List<AccountModel> accountModels =
        await UserStorageService().getAllAccount();

    List<AccountModel> watchAccountModels =
        await UserStorageService().getAllAccount(
      watchAccountsList: true,
    );

    await Isolate.spawn(
      _isolateProcess,
      <dynamic>[
        receivePort.sendPort,
        accountModels.map<String>((e) => e.publicKeyHash!),
        watchAccountModels.map<String>((e) => e.publicKeyHash!),
        ServiceConfig.currentSelectedNode,
      ],
      debugName: "accounts xtz, tokens & nfts",
    );
    receivePort.asBroadcastStream().listen((data) async {
      await _storeData(data, accountModels, watchAccountModels, postProcess);
    });
  }

  Future<void> _storeData(List data, List<AccountModel> accountList,
      List<AccountModel> watchAccountModels, var postProcess) async {
    List<TokenPriceModel> tokenPrices = await dataHandlerRenderService
        .getTokenPriceModel((data[1] as Map<String, List<AccountTokenModel>>)
            .values
            .fold<List<String>>(
                <String>[],
                (previousValue, element) => previousValue
                  ..addAll(
                      element.map<String>((e) => e.contractAddress).toList()))
            .toSet()
            .toList());
    // if (tokenPrices.isEmpty) {
    //   return;
    // }

    List<String> supportedTokens =
        tokenPrices.map<String>((e) => e.tokenAddress!).toList();

    (data[1] as Map<String, List<AccountTokenModel>>).forEach((key, value) {
      data[1][key] = value
        ..removeWhere(
            (element) => !supportedTokens.contains(element.contractAddress));
    });

    data[1] = parseAccountTokenModelUsingTokenPrices(data[1], tokenPrices);

    // save account xtz balances
    accountList = accountList
        .map<AccountModel>(
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

    watchAccountModels = watchAccountModels
        .map<AccountModel>(
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

    // fetches the stored token list if any and updates the respective token values
    (data[1] as Map<String, List<AccountTokenModel>>)
        .forEach((key, value) async {
      await UserStorageService()
          .getUserTokens(userAddress: key)
          .then((tokenList) {
        if (tokenList.isNotEmpty) {
          List<String> updateTokenAddresses = value
              .map<String>((e) => e.contractAddress)
              .toList(); // get all the token addresses which are updated
          (data[1] as Map<String, List<AccountTokenModel>>).update(
            key,
            (tokens) => tokenList.map<AccountTokenModel>((e) {
              AccountTokenModel updatedToken;
              tokens
                      .where(
                        (element) =>
                            element.contractAddress == e.contractAddress,
                      )
                      .isNotEmpty
                  ? updatedToken = tokens.firstWhere(
                      (element) => element.contractAddress == e.contractAddress,
                    )
                  : updatedToken = e;
              return updateTokenAddresses.contains(e.contractAddress)
                  ? e.copyWith(
                      balance: updatedToken.balance,
                      currentPrice: updatedToken.currentPrice,
                      decimals: updatedToken.decimals,
                      iconUrl: updatedToken.iconUrl,
                      name: updatedToken.name,
                      symbol: updatedToken.symbol,
                      valueInXtz: updatedToken.valueInXtz,
                      tokenId: updatedToken.tokenId,
                      tokenStandardType: updatedToken.tokenStandardType,
                    )
                  : e;
            }).toList(),
          );
        }
      });
    });

    // update account list before write data into localStorage
    if (accountList.isNotEmpty || watchAccountModels.isNotEmpty) {
      if (accountList.isNotEmpty) {
        accountList.first.isAccountPrimary = true;
      }
      await postProcess([...accountList, ...watchAccountModels]);
    }

    // save accounts data
    await ServiceConfig.localStorage.write(
        key: ServiceConfig.accountsStorage, value: jsonEncode(accountList));

    // save watch accounts data
    await ServiceConfig.localStorage.write(
        key: ServiceConfig.watchAccountsStorage,
        value: jsonEncode(watchAccountModels));

    // save all tokens separate based on publicKeyHash of the account
    for (String key in data[1].keys) {
      await ServiceConfig.localStorage.write(
          key: "${ServiceConfig.accountTokensStorage}_$key",
          value: jsonEncode(data[1][key]));
    }
  }

  Map<String, List<AccountTokenModel>> parseAccountTokenModelUsingTokenPrices(
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
                e.iconUrl = token.thumbnailUri;
                e.symbol = token.symbol;
                e.tokenStandardType = token.type == "fa2"
                    ? TokenStandardType.fa2
                    : TokenStandardType.fa1;
                e.valueInXtz = token.currentPrice! * e.balance;
                e.currentPrice = token.currentPrice;
                return e;
              },
            )
            .toList()
            .where((element) => element.name != null)
            .toList()));
  }
}
