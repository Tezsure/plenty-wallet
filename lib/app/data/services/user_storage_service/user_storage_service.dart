import 'dart:convert';
import 'dart:developer';

import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';

enum NftState { processing, empty, done }

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
  Future<void> updateAccounts(List<AccountModel> accountList) async {
    await ServiceConfig.localStorage.write(
        key: ServiceConfig.accountsStorage,
        value: jsonEncode(
          accountList.where((element) => !element.isWatchOnly).toList(),
        ));
    await ServiceConfig.localStorage.write(
        key: ServiceConfig.watchAccountsStorage,
        value: jsonEncode(
          accountList.where((element) => element.isWatchOnly).toList(),
        ));
  }

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

  /// update saved contact list
  Future<void> updateContactList(List<ContactModel> contactModelList) async =>
      await ServiceConfig.localStorage.write(
          key: ServiceConfig.contactStorage,
          value: jsonEncode((contactModelList)));

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

  Future<String> getUserTokensString({required String userAddress}) async =>
      await ServiceConfig.localStorage
          .read(key: "${ServiceConfig.accountTokensStorage}_$userAddress") ??
      "[]";

  /// update userTokenList
  Future<void> updateUserTokens(
      {required String userAddress,
      required List<AccountTokenModel> accountTokenList}) async {
    List<AccountTokenModel> userTokens =
        await getUserTokens(userAddress: userAddress);
    List<String> updateTokenAddresses = accountTokenList
        .map<String>((e) => e.contractAddress)
        .toList(); // get all the token addresses which are updated
    userTokens = userTokens.map((e) {
      if (updateTokenAddresses.contains(e.contractAddress)) {
        AccountTokenModel token = accountTokenList
            .where((element) => element.contractAddress == e.contractAddress)
            .toList()[0];
        return e.copyWith(
            isHidden: token.isHidden,
            isPinned: token.isPinned,
            isSelected: token.isSelected);
      }
      return e;
    }).toList();
    await ServiceConfig.localStorage.write(
        key: "${ServiceConfig.accountTokensStorage}_$userAddress",
        value: jsonEncode(accountTokenList));
  }

  /// read user nft using user address
  Future<List<NftTokenModel>> getUserNfts(
          {required String userAddress}) async =>
      jsonDecode(await ServiceConfig.localStorage
                  .read(key: "${ServiceConfig.nftStorage}_$userAddress") ??
              "[]")
          .map<NftTokenModel>((e) => NftTokenModel.fromJson(e))
          .toList();

  /// read user nft using user address RETURN STRING
  Future<String?> getUserNftsString({required String userAddress}) async =>
      await ServiceConfig.localStorage
          .read(key: "${ServiceConfig.nftStorage}_$userAddress");

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

  /// get stored account transaction history
  /// @param accountAddress account address
  /// @param lastId last transaction id
  /// @param limit limit of transaction to fetch
  /// returns list of transaction history model
  Future<List<TxHistoryModel>> getAccountTransactionHistory(
      {required String accountAddress, String? lastId, int? limit}) async {
    List<TxHistoryModel> transactionHistoryList = <TxHistoryModel>[];
    String? transactionHistory = await ServiceConfig.localStorage
        .read(key: "${ServiceConfig.txHistoryStorage}_$accountAddress");

    if (transactionHistory == null) {
      return await TzktTxHistoryApiService(
              accountAddress,
              ServiceConfig.currentNetwork == NetworkType.mainnet
                  ? ""
                  : ServiceConfig.currentSelectedNode)
          .getTxHistory();
    }

    if (lastId == null && limit == null) {
      transactionHistoryList = jsonDecode(transactionHistory)
          .map<TxHistoryModel>((e) => TxHistoryModel.fromJson(e))
          .toList();
    } else if (lastId == null) {
      transactionHistoryList = await TzktTxHistoryApiService(
              accountAddress,
              ServiceConfig.currentNetwork == NetworkType.mainnet
                  ? ""
                  : ServiceConfig.currentSelectedNode)
          .getTxHistory(limit: limit ?? 20);
    } else {
      transactionHistoryList = await TzktTxHistoryApiService(
              accountAddress,
              ServiceConfig.currentNetwork == NetworkType.mainnet
                  ? ""
                  : ServiceConfig.currentSelectedNode)
          .getTxHistory(lastId: lastId, limit: limit ?? 20);
    }

    return transactionHistoryList;
  }

  /// create new gallery model and save it in storage
  /// @param galleryModel GalleryModel
  /// @return Future<void>
  Future<void> writeNewGallery(NftGalleryModel galleryModel) async {
    List<NftGalleryModel> galleryList = await getAllGallery();

    bool exist = galleryList.any((element) =>
        element.name!.toLowerCase() == galleryModel.name!.toLowerCase());
    bool sameAddressesExists = galleryList
        .where((element) =>
            element.publicKeyHashs!.length ==
            galleryModel.publicKeyHashs!.length)
        .where((element1) => element1.publicKeyHashs!.every((element2) =>
            galleryModel.publicKeyHashs!.any((element3) =>
                element3.toLowerCase() == element2.toLowerCase())))
        .isNotEmpty;
    if (sameAddressesExists) {
      throw Exception("Gallery with same address already exist");
    }
    if (exist) {
      throw Exception("Gallery with same name already exist");
    } else {
      galleryList.add(galleryModel);

      await ServiceConfig.localStorage.write(
          key: ServiceConfig.galleryStorage, value: jsonEncode(galleryList));
    }
  }

  /// remove  gallery model from storage
  /// @param gallery index
  /// @return Future<void>
  Future<void> removeGallery(int galleryIndex) async =>
      await ServiceConfig.localStorage.write(
          key: ServiceConfig.galleryStorage,
          value: jsonEncode((await getAllGallery())..removeAt(galleryIndex)));

  Future<void> editGallery(
      NftGalleryModel galleryModel, int galleryIndex) async {
    List<NftGalleryModel> galleryList = await getAllGallery();
    galleryList.removeAt(galleryIndex);
    galleryList.insert(galleryIndex, galleryModel);

    await ServiceConfig.localStorage.write(
        key: ServiceConfig.galleryStorage, value: jsonEncode(galleryList));
  }

  /// get all saved gallery
  /// @return Future<List<NftGalleryModel>>
  Future<List<NftGalleryModel>> getAllGallery() async =>
      jsonDecode(await ServiceConfig.localStorage
                  .read(key: ServiceConfig.galleryStorage) ??
              "[]")
          .map<NftGalleryModel>((e) => NftGalleryModel.fromJson(e))
          .toList();
}
