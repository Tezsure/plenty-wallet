import 'dart:convert';

import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';

/// Handle read and write user data
class UserStorageService {
  /// Write new account into storage
  /// if isWatchAddress is true then it will get stored in watchAddressList otherwise normal wallet account list
  Future<void> writeNewAccount(List<AccountModel> accountList,
      [bool isWatchAddress = false,
      bool isAccountSecretsProvided = false]) async {
    String accountReadKey = isWatchAddress
        ? ServiceConfig.watchAccountsStorage
        : ServiceConfig.accountsStorage;
    String? accounts =
        await ServiceConfig.localStorage.read(key: accountReadKey);
    if (accounts == null ||
        accounts == "" ||
        accounts == "[]" ||
        accounts.isEmpty) {
      accounts = jsonEncode(accountList);
    } else {
      List<AccountModel> tempAccounts = jsonDecode(accounts)
          .map<AccountModel>((e) => AccountModel.fromJson(e))
          .toList();
      accounts = jsonEncode(tempAccounts..addAll(accountList));
    }
    await ServiceConfig.localStorage
        .write(key: accountReadKey, value: accounts);

    if (isAccountSecretsProvided) {
      for (AccountModel account in accountList) {
        if (account.accountSecretModel != null) {
          await writeNewAccountSecrets(account.accountSecretModel!);
        }
      }
    }

    await DataHandlerService().forcedUpdateData();
  }

  /// update accountList
  Future<void> updateAccounts(List<AccountModel> accountList) async =>
      await ServiceConfig.localStorage.write(
          key: ServiceConfig.accountsStorage, value: jsonEncode(accountList));

  /// Get all accounts in storage <br>
  /// If onlyNaanAccount is true then returns the account list which is created on naan<br>
  /// Else returns all the available accounts in storage<br>
  Future<List<AccountModel>> getAllAccount({
    bool onlyNaanAccount = false,
    bool watchAccountsList = false,
    bool isSecretDataRequired = false,
    bool showHideAccounts = false,
  }) async {
    var accountReadKey = watchAccountsList
        ? ServiceConfig.watchAccountsStorage
        : ServiceConfig.accountsStorage;
    var accounts = await ServiceConfig.localStorage.read(key: accountReadKey);
    if (accounts == null) return <AccountModel>[];
    return onlyNaanAccount
        ? jsonDecode(accounts)
            .map<AccountModel>((e) => AccountModel.fromJson(e))
            .toList()
            .where((element) => element.isNaanAccount == true)
            .toList()
        : jsonDecode(accounts)
            .map<AccountModel>((e) => AccountModel.fromJson(e))
            .toList()
            .where(
              (e) => showHideAccounts ? (e.isAccountHidden == false) : true,
            )
            .toList();
  }

  /// get all saved contact
  Future<List<ContactModel>> getAllSavedContacts() async =>
      jsonDecode(await ServiceConfig.localStorage
                  .read(key: ServiceConfig.contactStorage) ??
              "[]")
          .map<ContactModel>((e) => ContactModel.fromJson(e))
          .toList();

  /// write new contact in storage
  Future<void> writeNewContact(ContactModel contactModel) async =>
      await ServiceConfig.localStorage.write(
          key: ServiceConfig.contactStorage,
          value: jsonEncode((await getAllSavedContacts())..add(contactModel)));

  /// read user tokens using user address
  Future<List<AccountTokenModel>> getUserTokens(
          {required String userAddress}) async =>
      jsonDecode(await ServiceConfig.localStorage.read(
                  key: "${ServiceConfig.accountTokensStorage}_$userAddress") ??
              "[]")
          .map<AccountTokenModel>((e) => AccountTokenModel.fromJson(e))
          .toList();

  /// update userTokenList
  Future<void> updateUserTokens(
          {required String userAddress,
          required List<AccountTokenModel> accountTokenList}) async =>
      await ServiceConfig.localStorage.write(
          key: "${ServiceConfig.accountTokensStorage}_$userAddress",
          value: jsonEncode(accountTokenList));

  /// read user nft using user address
  Future<List<NftTokenModel>> getUserNfts(
          {required String userAddress}) async =>
      jsonDecode(await ServiceConfig.localStorage
                  .read(key: "${ServiceConfig.nftStorage}_$userAddress") ??
              "[]")
          .map<NftTokenModel>((e) => NftTokenModel.fromJson(e))
          .toList();

  Future<void> writeNewAccountSecrets(
          AccountSecretModel accountSecretModel) async =>
      await ServiceConfig.localStorage.write(
          key:
              "${ServiceConfig.accountsSecretStorage}_${accountSecretModel.publicKeyHash}",
          value: jsonEncode(accountSecretModel));

  Future<AccountSecretModel?> readAccountSecrets(String pkH) async {
    String? accountSecrets = await ServiceConfig.localStorage
        .read(key: "${ServiceConfig.accountsSecretStorage}_$pkH");
    return accountSecrets != null
        ? AccountSecretModel.fromJson(jsonDecode(accountSecrets))
        : null;
  }
}
