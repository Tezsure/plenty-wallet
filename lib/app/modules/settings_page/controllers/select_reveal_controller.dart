
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';

class SelectRevealController extends GetxController {
  RxBool privateKeyReveal = true.obs;
  RxBool seedPhraseReveal = true.obs;
  final String pkHash;
  SelectRevealController(this.pkHash);
  @override
  void onInit() async {
    final keys = await UserStorageService().readAccountSecrets(pkHash);
    privateKeyReveal.value = keys?.secretKey != null;
    seedPhraseReveal.value = keys?.seedPhrase?.isNotEmpty ?? false;
    // TODO: implement onInit
    super.onInit();
  }
}
