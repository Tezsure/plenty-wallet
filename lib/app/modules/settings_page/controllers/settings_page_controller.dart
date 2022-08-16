import 'package:get/get.dart';

class SettingsPageController extends GetxController {
  RxBool backup = true.obs;
  RxBool fingerprint = false.obs;

  switchFingerprint(bool value) => fingerprint.value = value;
  switchbackup() => backup.value = !backup.value;
}
