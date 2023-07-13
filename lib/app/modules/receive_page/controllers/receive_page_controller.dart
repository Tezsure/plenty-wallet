import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/utils.dart';

import '../../../data/services/service_models/account_model.dart';

class ReceivePageController extends GetxController {
  RxBool isCopied = false.obs; // is copied to clipboard

  late AccountModel? userAccount;
  final homeController = Get.find<HomePageController>();
  @override
  void onInit() {
    userAccount =
        homeController.userAccounts[homeController.selectedIndex.value];

    super.onInit();
  }

  /// Copy address to clipboard and show snackbar message
  void copyAddress(String address) {
    Clipboard.setData(ClipboardData(text: address));
    isCopied.value = true;
    Get.rawSnackbar(
      maxWidth: 0.45.width,
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      padding: EdgeInsets.only(bottom: 60.arP),
      messageText: Container(
        height: 36.arP,
        padding: EdgeInsets.symmetric(horizontal: 10.arP),
        decoration: BoxDecoration(
            color: ColorConst.Neutral.shade10,
            borderRadius: BorderRadius.circular(8.arP)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 14.arP,
              color: Colors.white,
            ),
            SizedBox(
              width: 5.arP,
            ),
            Text(
              "Copied ${address.tz1Short()}",
              style: labelSmall,
            )
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    ReceivePageController().dispose();
    super.onClose();
  }
}
