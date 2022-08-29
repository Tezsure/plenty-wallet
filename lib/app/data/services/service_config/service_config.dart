import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class ServiceConfig {
  // Current selected node
  static String currentSelectedNode = "https://mainnet.smartpy.io";

  // Main storage keys
  static const String oldStorageName = "tezsure-wallet-storage-v1.0.0";
  static const String storageName = "naan_wallet_version_2.0.0";

  // Accounts storage keys
  static const String accountsStorage = "${storageName}_accounts_storage";
  static const String watchAccountsStorage =
      "${storageName}_gallery_accounts_storage";

  static const String passCodeStorage = "${storageName}_password";
  static const String biometricAuthStorage = "${storageName}_biometricAuth";

  /// Flutter Secure Storage instance </br>
  /// Android it uses keyStore to encrypt the data </br>
  /// Ios it uses Keychain to encrypt the data
  static const FlutterSecureStorage localStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const List<String> allAssetsProfileImages = <String>[
    "${PathConst.PROFILE_IMAGES}1.png",
    "${PathConst.PROFILE_IMAGES}2.png",
    "${PathConst.PROFILE_IMAGES}3.png",
    "${PathConst.PROFILE_IMAGES}4.png",
    "${PathConst.PROFILE_IMAGES}5.png",
    "${PathConst.PROFILE_IMAGES}6.png",
    "${PathConst.PROFILE_IMAGES}7.png",
    "${PathConst.PROFILE_IMAGES}8.png",
    "${PathConst.PROFILE_IMAGES}9.png",
    "${PathConst.PROFILE_IMAGES}10.png",
    "${PathConst.PROFILE_IMAGES}11.png",
  ];

  /// Clear the local storage
  Future<void> clearStorage() async {
    await localStorage.deleteAll();
  }
}
