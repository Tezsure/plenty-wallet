import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/biometric_controller.dart';

class BiometricView extends GetView<BiometricController> {
  const BiometricView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(BiometricController());
    return Container(
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
              'Biometric Authentication',
              style: titleMedium,
            ),
            0.02.vspace,
            Text(
              'Touch the fingerprint sensor',
              style: bodySmall,
            ),
            0.06.vspace,
            Icon(Icons.fingerprint, size: 0.08.height, color: ColorConst.grey),
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: InkWell(
                    onTap: controller.usePasscode,
                    child: Text(
                      'Use Passcode',
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
