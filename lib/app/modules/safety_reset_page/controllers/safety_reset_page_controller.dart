import 'package:get/get.dart';

class SafetyResetPageController extends GetxController {

  RxBool isLoadingDone = false.obs;

  @override
  void onInit() {
    super.onInit();

    Future.delayed(Duration(seconds: 3), () {
      isLoadingDone.value = true;
    });

  }
}
