import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';

class BackupPageController extends GetxController {
  RxList<AccountModel> accounts = List.generate(
      20,
      (index) => AccountModel(
          isNaanAccount: true,
          name: "NAME $index",
          secretKey: "dlkjhevhfklndbhvhcusj",
          publicKey: "nxkjfbhedvzbv",
          derivationPathIndex: 478382,
          seedPhrase: "j h w g y f c u s b j k v d v")).obs;
}
