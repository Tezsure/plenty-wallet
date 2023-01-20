import 'dart:convert';

import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';

class DataHandlerRenderService {
  late DataVariable<double> xtzPriceUpdater;

  late DataVariable<List<AccountModel>> accountUpdater;

  /// specific account nft based if tz1 address provided on registervar or callback
  late DataVariable<Map<String, List<NftTokenModel>>> accountNft;

  DataHandlerRenderService() {
    xtzPriceUpdater = DataVariable<double>(updateProcess: _updateXtzPrice);
    accountUpdater = DataVariable<List<AccountModel>>(
        updateProcess: _updateAccountXtzBalances);
    accountNft = DataVariable<Map<String, List<NftTokenModel>>>(
        updateProcess: _updateNftsAccount);
  }

  /// update all the ui registerd values
  Future<void> updateUi() async {
    if (accountUpdater.callbacks.isNotEmpty) {
      await _updateAccountXtzBalances();
    }
  }

  /// read from store and update xtzPrice
  Future<void> _updateXtzPrice([double? xtzPrice]) async {
    if (xtzPrice != null) {
      xtzPriceUpdater.value = xtzPrice;
      return;
    }

    xtzPriceUpdater.value = double.parse(await ServiceConfig.localStorage
            .read(key: ServiceConfig.xtzPriceStorage) ??
        "0.0");
  }

  /// read from store and update account xtz value
  Future<void> _updateAccountXtzBalances([List<AccountModel>? accounts]) async {
    if (accounts != null) {
      accountUpdater.value = accounts;
      return;
    }
    accountUpdater.value =
        await UserStorageService().getAllAccount(watchAccountsList: true);
  }

  /// read from store and update based on tz1 address or all if not provided
  Future<void> _updateNftsAccount([String? address]) async {
    List<String> addressList = <String>[];
    if (address == null) {
      addressList = (await UserStorageService().getAllAccount())
          .map<String>((e) => e.publicKeyHash!)
          .toList();
    } else {
      addressList.add(address);
    }

    accountNft.value = <String, List<NftTokenModel>>{
      for (String tz1 in addressList)
        tz1: jsonDecode(
          (await ServiceConfig.localStorage
                  .read(key: "${ServiceConfig.nftStorage}_$tz1") ??
              "[]"),
        ).map<NftTokenModel>((e) => NftTokenModel.fromJson(e)).toList()
    };
  }

  Future<List<TokenPriceModel>> getTokenPriceModel(
      [List<String>? contractAddress]) async {
    String? tokensPrice = await ServiceConfig.localStorage
        .read(key: ServiceConfig.tokenPricesStorage);
    if (tokensPrice != null && contractAddress != null) {
      return jsonDecode(tokensPrice)['contracts']
          .map<TokenPriceModel>((e) => TokenPriceModel.fromJson(e))
          .toList()
          .where((e) => contractAddress.contains(e.tokenAddress.toString()))
          .toList();
    } else if (tokensPrice != null) {
      return jsonDecode(tokensPrice)["contracts"]
          .map<TokenPriceModel>((e) => TokenPriceModel.fromJson(e))
          .toList();
    } else {
      return [];
    }
  }

  Future<List<TokenPriceModel>> getTokenPriceModels() async {
    var tokensPrice = await ServiceConfig.localStorage
        .read(key: ServiceConfig.tokenPricesStorage);
    if (tokensPrice != null) {
      return jsonDecode(tokensPrice)["contracts"]
          .map<TokenPriceModel>((e) => TokenPriceModel.fromJson(e))
          .toList()
          .toList();
    }
    return [];
  }
}

class DataVariable<T> {
  // ignore: prefer_typing_uninitialized_variables
  var updateProcess;

  DataVariable({required this.updateProcess});
  List<dynamic> callbacks = [];
  List<dynamic> registerVariabls = [];

  int _value = 0;

  set value(T? value) {
    if (value.toString().hashCode != _value) {
      for (int i = 0; i < callbacks.length; i++) {
        callbacks[i](value);
      }
      for (int i = 0; i < registerVariabls.length; i++) {
        registerVariabls[i].value = value;
      }
      _value = value.toString().hashCode;
    }
  }

  void registerCallback(callback, [extraParams]) {
    callbacks.add(callback);
    _value = 0;
    extraParams == null ? updateProcess() : updateProcess(extraParams);
  }

  void registerVariable(rxVar) {
    registerVariabls.add(rxVar);
    _value = 0;
    updateProcess();
  }
}
