import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';

class PatchService {
  Future<List<AccountModel>> recoverWalletsFromOldStorage() async {
    var oldStorage = await const FlutterSecureStorage()
        .read(key: ServiceConfig.oldStorageName);

    if (oldStorage != null && oldStorage.isNotEmpty) {
      try {
        jsonDecode(oldStorage);
      } catch (e) {
        try {
          if (oldStorage.startsWith("[")) {
            oldStorage = String.fromCharCodes(jsonDecode(oldStorage));
          }
        } catch (e) {
          try {
            int.parse(oldStorage![0]);
            oldStorage = "[${oldStorage.replaceAll(" ", ",")}]";
          } catch (e) {
            // TODO: Add insta bug here
          }
        }
      }

      if (oldStorage != null && oldStorage != "") {
        var accounts = jsonDecode(oldStorage)['accounts'];
        List<AccountModel> accountList = [];
        for (var account in jsonDecode(accounts)) {
          accountList.add(AccountModel(
            name: account["name"],
            imageType: AccountProfileImageType.assets,
            profileImage: ServiceConfig.allAssetsProfileImages[
                Random().nextInt(ServiceConfig.allAssetsProfileImages.length)],
            publicKeyHash: account["publicKeyHash"],
            isNaanAccount: account["isNaanWallet"],
          )..accountSecretModel = AccountSecretModel(
              seedPhrase: account["seed"],
              publicKey: account["publicKey"],
              secretKey: account["secretKey"],
              derivationPathIndex: int.parse(
                account["derivationPathIndex"]
                    .split("/")[2]
                    .toString()
                    .replaceAll("'", ""),
              )));
        }
        return accountList;
      }
    }
    return <AccountModel>[];
  }
}
