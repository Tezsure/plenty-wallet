import 'package:local_auth/local_auth.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';

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

  Future<bool> getIsPassCodeSet() async =>
      await ServiceConfig.localStorage
          .read(key: ServiceConfig.passCodeStorage) !=
      null;

  Future<bool> getBiometricAuth() async {
    return (await ServiceConfig.localStorage
            .read(key: ServiceConfig.biometricAuthStorage)) ==
        "1";
  }

  /// check if device support biometrictype fingerprint or not <br>
  /// return false if not supported device
  Future<bool> checkIfDeviceSupportBiometricAuth() async {
    final LocalAuthentication auth = LocalAuthentication();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    return availableBiometrics.isNotEmpty &&
        (availableBiometrics.contains(BiometricType.fingerprint) ||
            availableBiometrics.contains(BiometricType.strong));
  }

  Future<bool> verifyBiometric(
      {String localizedReason = "Verify to continue"}) async {
    final LocalAuthentication auth = LocalAuthentication();
    return await auth.authenticate(
      localizedReason: localizedReason,
      options: const AuthenticationOptions(biometricOnly: true),
    );
  }
}
