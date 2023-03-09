import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/biometric_controller.dart';

class BiometricView extends GetView<BiometricController> {
  const BiometricView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(BiometricController());
    return Container(
        padding: EdgeInsets.only(
          bottom: Platform.isIOS ? 0.05.height : 0.02.height,
        ),
        height: 0.4.height,
        width: 1.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            0.005.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            0.04.vspace,
            Text(
              '${'Confirm Using Your'.tr} ${(Platform.isAndroid ? "Fingerprint" : "Face ID").tr}',
              style: titleMedium,
            ),
            0.02.vspace,
            Text(
              Platform.isAndroid
                  ? 'Touch the fingerprint sensor'.tr
                  : "Come to front camera".tr,
              style: bodySmall,
            ),
            0.03.vspace,
            Platform.isAndroid
                ? SvgPicture.asset(
                    "${PathConst.SVG}fingerprint.svg",
                    color: ColorConst.Neutral.shade100,
                    width: 75.arP,
                  )
                : SvgPicture.asset(
                    "${PathConst.SVG}faceid.svg",
                    color: ColorConst.Neutral.shade100,
                    width: 75.arP,
                  ),
            // Icon(Icons.fingerprint, size: 0.08.height, color: ColorConst.grey),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: BouncingWidget(
                    onPressed: controller.usePasscode,
                    child: Text(
                      'Use passcode'.tr,
                      style: bodySmall.copyWith(color: ColorConst.grey),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
