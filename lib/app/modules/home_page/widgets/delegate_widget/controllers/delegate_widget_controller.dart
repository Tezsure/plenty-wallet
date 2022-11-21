import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/biometric/views/biometric_view.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_success_sheet.dart';

class DelegateWidgetController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final RxString bakerAddress = ''.obs;

  final RxBool showFilter = true.obs;
  final ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      showFilter.value = scrollController.position.userScrollDirection ==
          ScrollDirection.forward;
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    textEditingController.dispose();
  }

  void onTextChanged(String value) {
    bakerAddress.value = value;
  }

  confirmBioMetric() async {
    try {
      AuthService authService = AuthService();
      bool isBioEnabled = await authService.getBiometricAuth();

      if (isBioEnabled) {
        final bioResult = await Get.bottomSheet(const BiometricView(),
            barrierColor: Colors.white.withOpacity(0.09),
            isScrollControlled: true,
            settings: RouteSettings(arguments: isBioEnabled));
        if (bioResult == null) {
          return;
        }
        if (!bioResult) {
          return;
        }
      } else {
        var isValid = await Get.toNamed('/passcode-page', arguments: [
          true,
        ]);
        if (isValid == null) {
          return;
        }
        if (!isValid) {
          return;
        }
      }
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
      Get.bottomSheet(const DelegateBakerSuccessSheet())
          .whenComplete(() => Get.back());
    } catch (e) {}
  }
}
