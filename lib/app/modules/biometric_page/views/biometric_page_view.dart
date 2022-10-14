import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/biometric_page_controller.dart';

class BiometricPageView extends GetView<BiometricPageController> {
  const BiometricPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as List;
    controller.previousRoute = args[0] as String;
    controller.nextPageRoute = args[1] as String;

    return Container(
      color: Colors.black,
      width: 1.width,
      padding: EdgeInsets.symmetric(horizontal: 0.05.width),
      child: SafeArea(
        child: Column(
          children: [
            0.2.vspace,
            Platform.isAndroid
                ? SvgPicture.asset("${PathConst.SVG}fingerprint.svg")
                : SvgPicture.asset("${PathConst.SVG}faceid.svg"),
            0.05.vspace,
            Text(
              Platform.isAndroid ? "Enable biometry unlock" : "Enable Face ID",
              style: titleLarge,
            ),
            0.01.vspace,
            Text(
              "Access your naan with your ${Platform.isAndroid ? "fingerprint" : "face ID"}",
              textAlign: TextAlign.center,
              style: bodySmall.apply(
                color: ColorConst.NeutralVariant.shade60,
              ),
            ),
            const Spacer(),
            SolidButton(
              title: "Enable",
              onPressed: () {
                controller.checkOrWriteNewAndRedirectToNewPage(true);
              },
            ),
            0.01.vspace,
            GestureDetector(
              onTap: () {
                controller.checkOrWriteNewAndRedirectToNewPage(false);
              },
              child: Container(
                height: 48,
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "Skip",
                  style: titleSmall.apply(
                      color: ColorConst.NeutralVariant.shade60),
                ),
              ),
            ),
            0.02.vspace,
          ],
        ),
      ),
    );
  }
}
