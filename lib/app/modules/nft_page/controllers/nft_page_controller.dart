import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class NftPageController extends GetxController {

  var currentSelectedTab = 0.obs;
  Duration duration = Duration(milliseconds: 250);
  var listOfWidth = <double>[0, (1.width / 2) - 24, (1.width / 2) - 24].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
