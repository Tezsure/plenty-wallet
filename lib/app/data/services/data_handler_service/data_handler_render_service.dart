import 'dart:convert';

import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';

class DataHandlerRenderService {
  late DataVariable<List<AccountModel>> accountUpdater;

  DataHandlerRenderService() {
    accountUpdater = DataVariable<List<AccountModel>>(
        updateProcess: _updateAccountXtzBalances);
  }

  /// update all the ui registerd values
  Future<void> updateUi() async {
    if (accountUpdater.callbacks.isNotEmpty) {
      await _updateAccountXtzBalances();
    }
  }

  /// read from store and update account xtz value
  Future<void> _updateAccountXtzBalances([List<AccountModel>? accounts]) async {
    if (accounts != null) {
      accountUpdater.value = accounts;
      return;
    }
    accountUpdater.value = await UserStorageService().getAllAccount();
  }

  Future<List<TokenPriceModel>> getTokenPriceModel(
      [List<String>? contractAddress]) async {
    var tokensPrice =
        await ServiceConfig.localStorage.read(key: ServiceConfig.tokenPrices);
    if (tokensPrice != null) {
      return jsonDecode(tokensPrice)
          .map<TokenPriceModel>((e) => TokenPriceModel.fromJson(e))
          .toList()
          .where((e) => contractAddress!.contains(e.tokenAddress.toString()))
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
      for (var i = 0; i < callbacks.length; i++) {
        callbacks[i](value);
      }
      for (var i = 0; i < registerVariabls.length; i++) {
        registerVariabls[i].value = value;
      }
      _value = value.toString().hashCode;
    }
  }

  void registerCallback(callback) {
    callbacks.add(callback);
    _value = 0;
    updateProcess();
  }

  void registerVariable(rxVar) {
    registerVariabls.add(rxVar);
    _value = 0;
    updateProcess();
  }
}
