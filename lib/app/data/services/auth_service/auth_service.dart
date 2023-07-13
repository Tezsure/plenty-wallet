import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/modules/beacon_bottom_sheet/biometric/views/biometric_view.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';

class AuthService {
  /// set new passcode for user to enter the app
  Future<void> setNewPassCode(String passcode) async {
    await ServiceConfig.localStorage
        .write(key: ServiceConfig.passCodeStorage, value: passcode);
  }

  /// verify passcode return true if passCode is right
  Future<bool> verifyPassCode(String passCode) async {
    String? pass = await ServiceConfig.localStorage
        .read(key: ServiceConfig.passCodeStorage);
    return pass == passCode;
  }

  /// set biometricauth true/false
  Future<void> setBiometricAuth(bool isEnable) async {
    await ServiceConfig.localStorage.write(
        key: ServiceConfig.biometricAuthStorage, value: isEnable ? "1" : "0");
  }

  /// set walletbackup true/false
  // Future<void> setWalletBackup(bool isEnable) async {
  //   await ServiceConfig.localStorage.write(
  //       key: ServiceConfig.walletBackupStorage, value: isEnable ? "1" : "0");
  // }

  Future<bool> getIsPassCodeSet() async =>
      await ServiceConfig.localStorage
          .read(key: ServiceConfig.passCodeStorage) !=
      null;

  Future<bool> getBiometricAuth() async {
    return (await ServiceConfig.localStorage
            .read(key: ServiceConfig.biometricAuthStorage)) ==
        "1";
  }

  // Future<bool> getIsWalletBackup() async =>
  //     (await ServiceConfig.localStorage
  //         .read(key: ServiceConfig.walletBackupStorage)) !=
  //     null;

  /// check if device support biometrictype fingerprint or not <br>
  /// return false if not supported device
  Future<bool> checkIfDeviceSupportBiometricAuth() async {
    final LocalAuthentication auth = LocalAuthentication();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    return availableBiometrics.isNotEmpty &&
        (availableBiometrics.contains(BiometricType.fingerprint) ||
            availableBiometrics.contains(BiometricType.strong) ||
            availableBiometrics.contains(BiometricType.face));
  }

  Future<bool> verifyBiometric(
      {String localizedReason = "Verify to continue"}) async {
    final LocalAuthentication auth = LocalAuthentication();
    return await auth.authenticate(
      localizedReason: localizedReason,
      options: const AuthenticationOptions(biometricOnly: true),
    );
  }

  Future<bool> verifyBiometricOrPassCode(
      {String localizedReason = "Verify to continue"}) async {
    AuthService authService = AuthService();
    bool isBioEnabled = await authService.getBiometricAuth();

    if (isBioEnabled) {
      final bioResult = await CommonFunctions.bottomSheet(const BiometricView(),
          settings: RouteSettings(arguments: isBioEnabled));
      if (bioResult == null || !bioResult) {
        return false;
      }
      AppConstant.hapticFeedback();
      return true;
    } else {
      var isValid = await Get.toNamed(Routes.PASSCODE_PAGE, arguments: [
        true,
      ]);
      if (isValid == null || !isValid) {
        return false;
      }
      AppConstant.hapticFeedback();

      return true;
    }
  }
}
