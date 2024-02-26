import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_config/storage/encryption/storage_encryption.dart';
import 'package:plenty_wallet/app/data/services/service_config/storage/impl/storage_impl.dart';

class SecureLocalStorage extends StorageImpl {
  late final FlutterSecureStorage _storage;

  @override
  void init() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.passcode,
      ),
    );
  }

  @override
  Future<void> delete({key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll(
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: const IOSOptions(
        accessibility: KeychainAccessibility.passcode,
      ),
    );
  }

  @override
  Future<String?> read({key}) async {
    var result = await _storage.read(key: key);

    if (result == null) {
      return null;
    }

    var json = jsonDecode(result);

    if ((json is! Map) ||
        (!json.containsKey("cipherText") || !json.containsKey("salt"))) {
      debugPrint("READ  ENCRYPTED STORAGE: $key $result");
      return result;
    }

    try {
      return await StorageEncryption().decryptData(json);
    } catch (e) {
      return "";
    }
  }

  @override
  Future<void> write({key, value}) async {
    value = await StorageEncryption().encryptData(value);

    await _storage.write(key: key, value: value);
  }

  // write raw
  Future<void> writeRaw({key, value}) async {
    await _storage.write(key: key, value: value);
  }

  // read raw
  Future<String?> readRaw({key}) async {
    return await _storage.read(key: key);
  }

  Future<void> notifyPassCodeChnage(String? oldPasscode) async {
    try {
      Map<String, String?> listOfAll = await _storage.readAll();

      for (var i = 0; i < listOfAll.length; i++) {
        var key = listOfAll.keys.elementAt(i);
        var value = listOfAll.values.elementAt(i);

        if (key != ServiceConfig.passCodeStorage &&
            (value ?? "").contains("cipherText")) {
          // handles encrypted data
          var decryptData = await StorageEncryption()
              .decryptData(jsonDecode(value!), passcode: oldPasscode);

          await delete(key: key);

          await write(key: key, value: decryptData);

          debugPrint("PASS CHANGE: $key");
        } else if (key != ServiceConfig.passCodeStorage && value != null) {
          // handles unencrypted data
          await delete(key: key);

          await write(key: key, value: value);

          debugPrint("PASS CHANGE: Enc First $key");
        } else {
          debugPrint("PASS CHANGE:  Ignore $key");
        }
      }
    } catch (e) {
      debugPrint("PASS CHANGE:  Error $e");
    }
  }

  Future<void> initMoveToEncryptedStorage() async {
    // move all data to encrypted storage other than passcode
    var passcode = await readRaw(key: ServiceConfig.passCodeStorage);
    if (passcode != null && passcode.length == 6) {
      debugPrint("OLD USER PASSCODE");
      AuthService().setNewPassCode(passcode);
    }

    Map<String, String?> listOfAll = await _storage.readAll();

    for (var i = 0; i < listOfAll.length; i++) {
      var key = listOfAll.keys.elementAt(i);
      var value = listOfAll.values.elementAt(i);

      if (key != ServiceConfig.passCodeStorage &&
          !(value ?? "").contains("cipherText")) {
        // handles unencrypted data
        await delete(key: key);

        await write(key: key, value: value);

        debugPrint("INIT CHANGE: Enc First $key $value");
      } else {
        debugPrint("INIT CHANGE:  Ignore $key");
      }
    }
  }
}
