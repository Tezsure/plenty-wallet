import 'dart:convert';

import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';

/// Handle read and write user data
class UserStorageService {
  /// Write new account into storage
  /// if isWatchAddress is true then it will get stored in watchAddressList otherwise normal wallet account list
  Future<void> writeNewAccount(List<AccountModel> accountList,
      [bool isWatchAddress = false]) async {
    var accountReadKey = isWatchAddress
        ? ServiceConfig.watchAccountsStorage
        : ServiceConfig.accountsStorage;
    var accounts = await ServiceConfig.localStorage.read(key: accountReadKey);
    if (accounts == null) {
      accounts = jsonEncode(accountList);
    } else {
      List<AccountModel> tempAccounts = jsonDecode(accounts)
          .map<AccountModel>((e) => AccountModel.fromJson(e))
          .toList();
      accounts = jsonEncode(tempAccounts..addAll(accountList));
    }
    await ServiceConfig.localStorage
        .write(key: accountReadKey, value: accounts);
    await DataHandlerService().forcedUpdateData();
  }

  /// Get all accounts in storage <br>
  /// If onlyNaanAccount is true then returns the account list which is created on naan<br>
  /// Else returns all the available accounts in storage<br>
  Future<List<AccountModel>> getAllAccount(
      {bool onlyNaanAccount = false, bool watchAccountsList = false}) async {
    var accountReadKey = watchAccountsList
        ? ServiceConfig.watchAccountsStorage
        : ServiceConfig.accountsStorage;
    var accounts = await ServiceConfig.localStorage.read(key: accountReadKey);
    if (accounts == null) return <AccountModel>[];
    return onlyNaanAccount
        ? jsonDecode(accounts)
            .map<AccountModel>((e) => AccountModel.fromJson(e))
            .toList()
            .where((element) => element.isNaanAccount)
            .toList()
        : jsonDecode(accounts)
            .map<AccountModel>((e) => AccountModel.fromJson(e))
            .toList();
  }
}
