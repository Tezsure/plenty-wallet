import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_config/storage/impl/storage_impl.dart';

class HiveStorage extends StorageImpl {
  late Box<String> _box;

  @override
  Future<void> init() async {
    Directory tmpPath = await getTemporaryDirectory();

    Hive.init(tmpPath.path);
    _box = await Hive.openBox<String>("plenty_wallet");
  }

  Future<String?> moveStorageReturn({key}) async {
    var result = await ServiceConfig.secureLocalStorage.read(key: key);
    if (result != null) {
      await write(key: key, value: result);
      await ServiceConfig.secureLocalStorage.delete(key: key);
    }
    return result;
  }

  @override
  Future<String?> read({key}) async {
    var result = _box.get(key);

    if (result == null) {
      debugPrint(
          "HiveStorage: $key not found, trying to move from secure storage");
    }

    return result ?? await moveStorageReturn(key: key);
  }

  @override
  Future<void> write({key, value}) async {
    await _box.put(key, value);
  }

  @override
  Future<void> delete({key}) async {
    await _box.delete(key);
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
  }
}
