import 'dart:math';

// ignore: implementation_imports
import 'package:dartez/src/soft-signer/soft_signer.dart' show SignerCurve;

import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/modules/send_page/views/widgets/transaction_status.dart';

class WalletService {
  WalletService();

  /// At start derivation index will be one and every naan crated account will have tag isNaanAccount=true
  /// If there is no naan created account then it will gen new mnemonic with derivation index 0
  /// and after that it use the same mnemonic to create account but derivationIndex+1
  /// Default derivation Path = m/44'/1729'/0'/0'
  /// Returns new AccountModel of newly created account
  Future<AccountModel?> createNewAccount(
      String name, AccountProfileImageType imageType, String image) async {
    try {
      UserStorageService userStorageService = UserStorageService();
      AccountModel accountModel;
      var storedAccounts =
          await userStorageService.getAllAccount(onlyNaanAccount: true);
      int derivationIndex = storedAccounts.isEmpty
          ? 0
          : (storedAccounts.last.derivationPathIndex! + 1);
      var derivationPath = "m/44'/1729'/$derivationIndex'/0'";

      AccountSecretModel? accountSecretModel = storedAccounts.isEmpty
          ? null
          : await userStorageService
              .readAccountSecrets(storedAccounts.last.publicKeyHash!);

      var mnemonic = storedAccounts.isEmpty
          ? Dartez.generateMnemonic(strength: 128)
          : accountSecretModel != null
              ? accountSecretModel.seedPhrase
              : Dartez.generateMnemonic(strength: 128);

      var keyStore = await Dartez.restoreIdentityFromDerivationPath(
        derivationPath,
        mnemonic!,
        signerCurve: accountSecretModel != null
            ? accountSecretModel.publicKeyHash!.startsWith("tz1")
                ? SignerCurve.ED25519
                : SignerCurve.SECP256K1
            : SignerCurve.SECP256K1,
      );
      accountSecretModel = AccountSecretModel(
        seedPhrase: mnemonic,
        secretKey: keyStore.secretKey!,
        publicKey: keyStore.publicKey!,
        derivationPathIndex: derivationIndex,
        publicKeyHash: keyStore.publicKeyHash,
      );
      accountModel = AccountModel(
        isNaanAccount: true,
        isWalletBackedUp: false,
        derivationPathIndex: derivationIndex,
        name: name,
        importedAt: DateTime.now(),
        imageType: imageType,
        profileImage: image,
        publicKeyHash: keyStore.publicKeyHash,
      );
      NaanAnalytics.logEvent(NaanAnalyticsEvents.CREATE_NEW_ACCOUNT,
          param: {"address": accountModel.publicKeyHash});

      accountModel.accountSecretModel = accountSecretModel;

      // write new account in storage and return the newly created account
      try {
        await userStorageService
            .writeNewAccount(<AccountModel>[accountModel], false, true);
      } catch (e) {
        debugPrint(e.toString());
      }

      // write new account secrets in storage
      return accountModel;
    } on Exception catch (e) {
      transactionStatusSnackbar(
        duration: const Duration(seconds: 2),
        status: TransactionStatus.error,
        tezAddress: e.toString(),
        transactionAmount: 'Something went wrong!',
      );
      return null;
    }
  }

  /// import wallet using private ket
  Future<AccountModel> importWalletUsingPrivateKey(String privateKey,
      String name, AccountProfileImageType imageType, String image) async {
    UserStorageService userStorageService = UserStorageService();
    AccountModel accountModel;

    var keyStore = Dartez.getKeysFromSecretKey(privateKey);
    var accountSecretModel = AccountSecretModel(
      seedPhrase: "",
      secretKey: keyStore.secretKey!,
      publicKey: keyStore.publicKey!,
      derivationPathIndex: 0,
      publicKeyHash: keyStore.publicKeyHash,
    );
    accountModel = AccountModel(
      isWalletBackedUp: true,
      isNaanAccount: false,
      derivationPathIndex: 0,
      name: name,
      importedAt: DateTime.now(),
      imageType: imageType,
      profileImage: image,
      publicKeyHash: keyStore.publicKeyHash,
    );

    accountModel.accountSecretModel = accountSecretModel;
    NaanAnalytics.logEvent(NaanAnalyticsEvents.ALREADY_HAVE_ACCOUNT, param: {
      "address": accountModel.publicKeyHash,
      "import_type": "private_key"
    });

    // write new account in storage and return the newly created account
    await userStorageService
        .writeNewAccount(<AccountModel>[accountModel], false, true);

    return accountModel;
  }

  /// gen account using mnemonic
  /// startIndex is the starting of derivation index and size is account return list size
  Future<AccountModel?> genAccountFromMnemonic(String mnemonic, int index,
      [bool isTz2Address = false]) async {
    // var tempAccount = <AccountModel>[];
    // "m/44'/1729'/$derivationIndex'/0'"
    try {
      var keyStore = await Dartez.restoreIdentityFromDerivationPath(
          "m/44'/1729'/$index'/0'", mnemonic,
          signerCurve:
              isTz2Address ? SignerCurve.SECP256K1 : SignerCurve.ED25519);
      NaanAnalytics.logEvent(NaanAnalyticsEvents.ALREADY_HAVE_ACCOUNT, param: {
        "address": keyStore.publicKeyHash,
        "import_type": "mnemonic"
      });
      return AccountModel(
        isNaanAccount: false,
        isWalletBackedUp: true,
        derivationPathIndex: index,
        name: "",
        importedAt: DateTime.now(),
        imageType: AccountProfileImageType.assets,
        profileImage: ServiceConfig.allAssetsProfileImages[
            Random().nextInt(ServiceConfig.allAssetsProfileImages.length - 1)],
        publicKeyHash: keyStore.publicKeyHash,
      )..accountSecretModel = AccountSecretModel(
          seedPhrase: mnemonic,
          secretKey: keyStore.secretKey!,
          publicKey: keyStore.publicKey!,
          derivationPathIndex: index,
          publicKeyHash: keyStore.publicKeyHash,
        );
    } catch (e) {
      transactionStatusSnackbar(
        duration: const Duration(seconds: 2),
        status: TransactionStatus.error,
        tezAddress: e.toString(),
        transactionAmount: 'Something went wrong!',
      );
      return null;
    }
    // tempAccount.add();

    // return tempAccount;
  }

  Future<AccountModel?> genLegacy(String mnemonic) async {
    // var tempAccount = <AccountModel>[];
    // "m/44'/1729'/$derivationIndex'/0'"
    try {
      var keyStore = Dartez.getKeysFromMnemonic(mnemonic: mnemonic);
      NaanAnalytics.logEvent(NaanAnalyticsEvents.ALREADY_HAVE_ACCOUNT, param: {
        "address": keyStore.publicKeyHash,
        "import_type": "mnemonic"
      });
      return AccountModel(
        isNaanAccount: false,
        isWalletBackedUp: true,
        derivationPathIndex: 0,
        name: "",
        importedAt: DateTime.now(),
        imageType: AccountProfileImageType.assets,
        profileImage: ServiceConfig.allAssetsProfileImages[
            Random().nextInt(ServiceConfig.allAssetsProfileImages.length - 1)],
        publicKeyHash: keyStore.publicKeyHash,
      )..accountSecretModel = AccountSecretModel(
          seedPhrase: mnemonic,
          secretKey: keyStore.secretKey!,
          publicKey: keyStore.publicKey!,
          derivationPathIndex: 0,
          publicKeyHash: keyStore.publicKeyHash,
        );
    } catch (e) {
      transactionStatusSnackbar(
        duration: const Duration(seconds: 2),
        status: TransactionStatus.error,
        tezAddress: e.toString(),
        transactionAmount: 'Something went wrong!',
      );
      return null;
    }
    // tempAccount.add();

    // return tempAccount;
  }

  /// write new watch address into storage
  Future<AccountModel> importWatchAddress(String pkH, String name,
      AccountProfileImageType imageType, String image) async {
    var account = AccountModel(
        importedAt: DateTime.now(),
        isNaanAccount: false,
        isWatchOnly: true,
        isWalletBackedUp: true,
        name: name,
        imageType: imageType,
        profileImage: image,
        publicKeyHash: pkH);
    NaanAnalytics.logEvent(NaanAnalyticsEvents.ALREADY_HAVE_ACCOUNT, param: {
      "address": pkH,
      "import_type": "watch_address",
    });
    await UserStorageService().writeNewAccount([account], true);
    return account;
  }
}
