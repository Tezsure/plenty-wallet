import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../data/services/service_models/account_model.dart';

class ReceivePageController extends GetxController {
  RxBool isCopied = false.obs; // is copied to clipboard

  late AccountModel? userAccount;

  @override
  void onInit() {
    userAccount = Get.arguments as AccountModel?;
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
      padding: const EdgeInsets.only(bottom: 60),
      messageText: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: ColorConst.Neutral.shade10,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline_rounded,
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(
              width: 5,
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
