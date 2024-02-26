import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:screen_protector/screen_protector.dart';

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
/*     await ScreenProtector.preventScreenshotOn();
    await ScreenProtector.protectDataLeakageOn(); */

    super.onInit();
  }

/*   @override
  void onClose() async {
    await ScreenProtector.preventScreenshotOff();
    await ScreenProtector.protectDataLeakageOff();
  } */
}
