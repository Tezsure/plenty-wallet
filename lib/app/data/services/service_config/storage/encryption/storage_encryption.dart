import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:pointycastle/export.dart';

class StorageEncryption {
  Future<String?> encryptData(String? value, {String? passcode}) async {
    if (value == null) {
      return null;
    }
    final random = Random.secure();

    // use as salt and iv
    var salt = List<int>.generate(16, (_) => random.nextInt(256));

    final cbc = CBCBlockCipher(AESEngine())
      ..init(
          true,
          ParametersWithIV(
              KeyParameter(
                  await _KeyHelper().generateKey(salt, passcode: passcode)),
              Uint8List.fromList(salt)));

    var valueUint = padInBlockSize(value);
    final cipherText = Uint8List(valueUint.length);
    // Uint8List.fromList(utf8.encode(value));

    var offset = 0;
    while (offset < value.length) {
      offset += cbc.processBlock(valueUint, offset, cipherText, offset);
    }

    return json.encode({
      'cipherText': base64.encode(cipherText),
      'salt': salt,
    });
  }

  /// Pad a block to the next block size
  Uint8List padInBlockSize(String value) {
    var length = (value.length / 16).ceil() * 16;
    var valueUint = Uint8List(length);
    valueUint.setRange(0, value.length, utf8.encode(value));
    return valueUint;
  }

  /// Remove padding from a block
  Uint8List unpadBlockSize(Uint8List value) {
    var length = value.length;
    while (value[length - 1] == 0) {
      length--;
    }
    return value.sublist(0, length);
  }

  Future<String> decryptData(var jsonData, {String? passcode}) async {
    final cipherText = base64.decode(jsonData['cipherText']);
    List<int> salt = jsonData['salt'].map<int>((e) => e as int).toList();

    final cbc = CBCBlockCipher(AESEngine())
      ..init(
          false,
          ParametersWithIV(
              KeyParameter(
                  await _KeyHelper().generateKey(salt, passcode: passcode)),
              Uint8List.fromList(salt)));

    final plainText = Uint8List(cipherText.length);

    var offset = 0;
    while (offset < cipherText.length) {
      offset += cbc.processBlock(cipherText, offset, plainText, offset);
    }

    return utf8.decode(unpadBlockSize(plainText));
  }
}

class _KeyHelper {
  Future<Uint8List> generateKey(List<int> salt, {String? passcode}) async {
    final pbkdf2Params = Pbkdf2Parameters(
      Uint8List.fromList(salt), // Salt as a Uint8List
      10,
      32, // Key length (SHA-256 output size)
    );

    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(pbkdf2Params);
    pbkdf2.init(pbkdf2Params);
    final sPasscode = passcode ??
        await ServiceConfig.secureLocalStorage
            .readRaw(key: ServiceConfig.passCodeStorage);
    return pbkdf2.process(
        Uint8List.fromList(utf8.encode(_parseStoredHash(sPasscode ?? "{}"))));
  }

  // Helper function to parse the stored hash string and return a Map
  String _parseStoredHash(String storedHash) {
    try {
      final jsonData = json.decode(storedHash);
      return Map<String, dynamic>.from(jsonData)['passcode_hash'] ?? "";
    } catch (_) {
      // Invalid format, return an empty map
      return "";
    }
  }
}



/*

  Once password is set or match 



*/


