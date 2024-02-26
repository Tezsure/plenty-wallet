import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/modules/beacon_bottom_sheet/biometric/views/biometric_view.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'dart:convert';
import 'package:pointycastle/export.dart';

class AuthService {
  final _PassCodeUtils _passCodeUtils = _PassCodeUtils();

  /// set new passcode for user to enter the app
  Future<void> setNewPassCode(String passcode) async {
    String encodedPasscode = _passCodeUtils.encodePassCodeForStore(passcode);

    var oldPasscode = await ServiceConfig.secureLocalStorage
        .readRaw(key: ServiceConfig.passCodeStorage);

    await ServiceConfig.secureLocalStorage
        .writeRaw(key: ServiceConfig.passCodeStorage, value: encodedPasscode);

    if (oldPasscode != null && oldPasscode.contains("passcode_hash")) {
      await ServiceConfig.secureLocalStorage.notifyPassCodeChnage(oldPasscode);
    }
    try {
      await updateLockMechanism(false);
    } catch (e) {
      debugPrint(e.toString());
    }

    // DataHandlerService().initDataServices();
  }

  /// verify passcode return true if passCode is right
  Future<bool> verifyPassCode(String passCode) async {
    String? storedPasscode = await ServiceConfig.secureLocalStorage
        .readRaw(key: ServiceConfig.passCodeStorage);

    // check if storedPasscode is map json
    if (storedPasscode != null) {
      if (storedPasscode.contains("passcode_hash")) {
        var result = _passCodeUtils.matchPassCode(passCode, storedPasscode);
        if (!result) {
          // update lock mechanism
          await updateLockMechanism(true);
        } else {
          // update lock mechanism = 0
          await updateLockMechanism(false);
        }
        return result;
      } else {
        // set new passcode from storedPasscode
        await setNewPassCode(storedPasscode);
        storedPasscode = await ServiceConfig.secureLocalStorage
            .readRaw(key: ServiceConfig.passCodeStorage);
        var result = _passCodeUtils.matchPassCode(passCode, storedPasscode);
        if (!result) {
          // update lock mechanism ++
          await updateLockMechanism(true);
        } else {
          // update lock mechanism = 0
          await updateLockMechanism(false);
        }
        return result;
      }
    } else {
      return false;
    }
  }

  // check and get duration of lock in Duration
  Future<Duration?> getLockDuration() async {
    String? lockEndTime = await ServiceConfig.secureLocalStorage
        .read(key: ServiceConfig.lockEndTimeStorage);

    if (lockEndTime != null) {
      DateTime lockEndTimeDate = DateTime.parse(lockEndTime);
      DateTime now = DateTime.now();

      if (lockEndTimeDate.isAfter(now)) {
        return lockEndTimeDate.difference(now);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  /// update lock mechanism
  Future<void> updateLockMechanism(bool isUpdate) async {
    int totalWrongAttempts;
    try {
      totalWrongAttempts = int.parse(await ServiceConfig.secureLocalStorage
              .read(key: ServiceConfig.totalWrongAttemptsStorage) ??
          "0");
    } catch (e) {
      totalWrongAttempts = 0;
    }

    if (isUpdate) {
      totalWrongAttempts++;

      await ServiceConfig.secureLocalStorage.write(
          key: ServiceConfig.totalWrongAttemptsStorage,
          value: totalWrongAttempts.toString());

      if (totalWrongAttempts > 0 && totalWrongAttempts % 3 == 0) {
        debugPrint("Total wrong attempts {$totalWrongAttempts}}");
        int baseLockoutDuration = 1;
        // calculate lock out min based on totalWrongAttempts
        int additionalLockoutMinutes = ((totalWrongAttempts - 1) ~/ 3) * 2;

        int lockoutDuration = baseLockoutDuration + additionalLockoutMinutes;

        var lockEndTime =
            DateTime.now().add(Duration(minutes: lockoutDuration));

        await ServiceConfig.secureLocalStorage.write(
            key: ServiceConfig.lockEndTimeStorage,
            value: lockEndTime.toString());
      } else {
        await ServiceConfig.secureLocalStorage
            .write(key: ServiceConfig.lockEndTimeStorage, value: null);

        await ServiceConfig.secureLocalStorage.write(
            key: ServiceConfig.totalWrongAttemptsStorage,
            value: totalWrongAttempts.toString());
      }
    } else {
      await ServiceConfig.secureLocalStorage
          .write(key: ServiceConfig.lockEndTimeStorage, value: null);

      await ServiceConfig.secureLocalStorage
          .write(key: ServiceConfig.totalWrongAttemptsStorage, value: "0");
    }
  }

  /// set biometricauth true/false
  Future<void> setBiometricAuth(bool isEnable) async {
    await ServiceConfig.secureLocalStorage.write(
        key: ServiceConfig.biometricAuthStorage, value: isEnable ? "1" : "0");
  }

  Future<bool> getIsPassCodeSet() async =>
      await ServiceConfig.secureLocalStorage
          .readRaw(key: ServiceConfig.passCodeStorage) !=
      null;

  Future<bool> getBiometricAuth() async {
    return (await ServiceConfig.secureLocalStorage
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

    bool ifPassSet = await authService.getIsPassCodeSet();
    bool isBioEnabled = await authService.getBiometricAuth();
    if (ifPassSet) {
      if (isBioEnabled) {
        final bioResult = await CommonFunctions.bottomSheet(
            const BiometricView(),
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
    return true;
  }

  Future<bool> verifyBiometricOrPassCodeDirect(
      {String localizedReason = "Verify to continue"}) async {
    AuthService authService = AuthService();

    bool ifPassSet = await authService.getIsPassCodeSet();

    if (ifPassSet) {
      var isValid = await Get.toNamed(Routes.PASSCODE_PAGE, arguments: [
        true,
      ]);
      debugPrint("isValid $isValid");
      if (isValid == null || !isValid) {
        return false;
      }
      AppConstant.hapticFeedback();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyBiometricOrPassCodeInactive(
      {String localizedReason = "Verify to continue"}) async {
    AuthService authService = AuthService();

    bool ifPassSet = await authService.getIsPassCodeSet();

    if (ifPassSet) {
      var isValid = await Get.toNamed(
        Routes.PASSCODE_PAGE,
        arguments: [true, Routes.LOCKED],
      );
      if (isValid == null || !isValid) {
        return false;
      }
      AppConstant.hapticFeedback();

      return true;
    }
    return true;
  }

  bool isWeakPasscode(String passcode) {
    // Check for weak passcodes
    if (passcode == '000000' || passcode == '111111') {
      return true;
    }

    // Additional checks for sequential or repeated patterns
    for (int i = 0; i < passcode.length - 1; i++) {
      if (passcode.codeUnitAt(i + 1) != passcode.codeUnitAt(i) + 1) {
        return false; // Not sequential
      }
    }

    return true; // Sequential
  }

  double calculateEntropy(String passcode) {
    final uniqueCharacters = passcode.split('').toSet().length;
    return log(pow(10, uniqueCharacters)) / log(2);
  }

  bool checkPasscodeStrength(String passcode) {
    if (passcode.length != 6) {
      return false; // Invalid passcode format
    }

    if (isWeakPasscode(passcode)) {
      return false; // Weak passcode
    }

    final entropy = calculateEntropy(passcode);
    if (entropy < 12.5) {
      return false; // Low entropy
    }

    return true; // Strong passcode
  }

  // set safety reset
  Future<void> setSafetyReset(String? s) async {
    await ServiceConfig.secureLocalStorage
        .write(key: ServiceConfig.safetyResetStorage, value: s);
  }

  // get safety reset
  Future<String?> getSafetyReset() async {
    return await ServiceConfig.secureLocalStorage
        .read(key: ServiceConfig.safetyResetStorage);
  }

  // get total wrong attempts left before safety reset
  Future<int> getTotalWrongAttemptsLeft() async {
    String? safetyReset = await getSafetyReset();
    if (safetyReset != null) {
      int totalWrongAttempts = int.parse(await ServiceConfig.secureLocalStorage
              .read(key: ServiceConfig.totalWrongAttemptsStorage) ??
          "0");

      int safetyResetInt = int.parse(safetyReset);

      return safetyResetInt - totalWrongAttempts;
    } else {
      return -1;
    }
  }
}

class _PassCodeUtils {
  String encodePassCodeForStore(String passcode) {
    final randomSalt = _generateRandomSalt(); // Generate a new random salt
    final hashedPasscode = _hashPasscode(passcode, randomSalt);
    final hashForStorage = {
      'passcode_hash': hashedPasscode,
      'salt': randomSalt
    };

    return json.encode(hashForStorage);
  }

  matchPassCode(String passcode, String? storedPasscode) {
    if (storedPasscode == null) {
      // If there's no stored hash, the passcode is not set yet.
      return false;
    }

    final storedData = _parseStoredHash(storedPasscode);

    List<int> salt = storedData['salt'].map<int>((e) => e as int).toList();

    final hashedPasscode = _hashPasscode(passcode, salt);

    // Perform a constant-time comparison to avoid timing leaks
    return _secureStringComparison(storedData['passcode_hash'], hashedPasscode);
  }

  // Helper function to generate a random salt
  List<int> _generateRandomSalt() {
    final random = Random.secure();
    return List<int>.generate(16, (_) => random.nextInt(256));
  }

  // Helper function to hash the passcode using PBKDF2
  String _hashPasscode(String passcode, List<int> salt) {
    final pbkdf2Params = Pbkdf2Parameters(
      Uint8List.fromList(salt), // Salt as a Uint8List
      ServiceConfig.pbkdf2Iterations,
      32, // Key length (SHA-256 output size)
    );

    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(pbkdf2Params);

    final passcodeBytes = utf8.encode(passcode);
    final key = pbkdf2.process(Uint8List.fromList(passcodeBytes));
    return base64.encode(key);
  }

  // Helper function to parse the stored hash string and return a Map
  Map<String, dynamic> _parseStoredHash(String storedHash) {
    try {
      final jsonData = json.decode(storedHash);
      return Map<String, dynamic>.from(jsonData);
    } catch (_) {
      // Invalid format, return an empty map
      return {};
    }
  }

  // Helper function for constant-time string comparison
  bool _secureStringComparison(String a, String b) {
    if (a.length != b.length) {
      return false;
    }

    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }

    return result == 0;
  }
}
