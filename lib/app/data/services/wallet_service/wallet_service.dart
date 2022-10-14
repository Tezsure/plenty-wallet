import 'dart:math';

// ignore: implementation_imports
import 'package:dartez/src/soft-signer/soft_signer.dart' show SignerCurve;

import 'package:dartez/dartez.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';

class WalletService {
  WalletService();

  /// At start derivation index will be one and every naan crated account will have tag isNaanAccount=true
  /// If there is no naan created account then it will gen new mnemonic with derivation index 0
  /// and after that it use the same mnemonic to create account but derivationIndex+1
  /// Default derivation Path = m/44'/1729'/0'/0'
  /// Returns new AccountModel of newly created account
  Future<AccountModel> createNewAccount(
      String name, AccountProfileImageType imageType, String image) async {
    UserStorageService userStorageService = UserStorageService();
    List<AccountModel> storedAccounts =
        await userStorageService.getAllAccount(onlyNaanAccount: true);
    int derivationIndex = storedAccounts.isEmpty
        ? 0
        : (storedAccounts.last.derivationPathIndex! + 1);
    String derivationPath = "m/44'/1729'/$derivationIndex'/0'";

    AccountSecretModel? accountSecretModel = storedAccounts.isEmpty
        ? null
        : await userStorageService
            .readAccountSecrets(storedAccounts.last.publicKeyHash!);

    String? mnemonic = storedAccounts.isEmpty
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
      secretKey: keyStore[0],
      publicKey: keyStore[1],
      derivationPathIndex: derivationIndex,
      publicKeyHash: keyStore[2],
    );
    AccountModel accountModel = AccountModel(
      isNaanAccount: true,
      isAccountHidden: false,
      isAccountPrimary: storedAccounts.isEmpty ? true : false,
      derivationPathIndex: derivationIndex,
      name: name,
      imageType: imageType,
      profileImage: image,
      publicKeyHash: keyStore[2],
    );

    accountModel.accountSecretModel = accountSecretModel;

    // write new account in storage and return the newly created account
    await userStorageService
        .writeNewAccount(<AccountModel>[accountModel], false, true);

    // write new account secrets in storage
    return accountModel;
  }

  /// import wallet using private ket
  Future<AccountModel> importWalletUsingPrivateKey(String privateKey,
      String name, AccountProfileImageType imageType, String image) async {
    UserStorageService userStorageService = UserStorageService();
    AccountModel accountModel;

    List<String> keyStore = Dartez.getKeysFromSecretKey(privateKey);
    AccountSecretModel accountSecretModel = AccountSecretModel(
      seedPhrase: "",
      secretKey: keyStore[0],
      publicKey: keyStore[1],
      derivationPathIndex: 0,
      publicKeyHash: keyStore[2],
    );
    accountModel = AccountModel(
      isNaanAccount: false,
      derivationPathIndex: 0,
      name: name,
      imageType: imageType,
      profileImage: image,
      publicKeyHash: keyStore[2],
    );

    accountModel.accountSecretModel = accountSecretModel;

    // write new account in storage and return the newly created account
    await userStorageService
        .writeNewAccount(<AccountModel>[accountModel], false, true);

    return accountModel;
  }

  /// gen account using mnemonic
  /// startIndex is the starting of derivation index and size is account return list size
  Future<List<AccountModel>> genAccountFromMnemonic(
      String mnemonic, int startIndex, int size) async {
    List<AccountModel> tempAccount = <AccountModel>[];
    for (int i = 0; i < size; i++) {
      // "m/44'/1729'/$derivationIndex'/0'"
      List<String> keyStore = await Dartez.restoreIdentityFromDerivationPath(
          "m/44'/1729'/${i + startIndex}'/0'", mnemonic);
      tempAccount.add(AccountModel(
        isNaanAccount: false,
        derivationPathIndex: i + startIndex,
        name: "",
        imageType: AccountProfileImageType.assets,
        profileImage: ServiceConfig.allAssetsProfileImages[
            Random().nextInt(ServiceConfig.allAssetsProfileImages.length - 1)],
        publicKeyHash: keyStore[2],
      )..accountSecretModel = AccountSecretModel(
          seedPhrase: mnemonic,
          secretKey: keyStore[0],
          publicKey: keyStore[1],
          derivationPathIndex: i + startIndex,
          publicKeyHash: keyStore[2],
        ));
    }
    return tempAccount;
  }

  /// write new watch address into storage
  Future<AccountModel> importWatchAddress(String pkH, String name,
      AccountProfileImageType imageType, String image) async {
    AccountModel account = AccountModel(
        isNaanAccount: false,
        isWatchOnly: true,
        name: name,
        imageType: imageType,
        profileImage: image,
        publicKeyHash: pkH);
    await UserStorageService().writeNewAccount([account], true);
    return account;
  }
}
