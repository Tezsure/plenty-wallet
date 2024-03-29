import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import '../controllers/biometric_page_controller.dart';

class BiometricPageView extends GetView<BiometricPageController> {
  const BiometricPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as List;
    controller.previousRoute = args[0] as String;
    controller.nextPageRoute = args[1] as String;

    return OverrideTextScaleFactor(
      child: Container(
        color: Colors.black,
        width: 1.width,
        padding: EdgeInsets.symmetric(horizontal: 0.05.width),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                0.15.vspace,
                Platform.isAndroid
                    ? SvgPicture.asset(
                        "${PathConst.SVG}fingerprint.svg",
                        width: 102.arP,
                      )
                    : SvgPicture.asset(
                        "${PathConst.SVG}faceid.svg",
                        width: 102.arP,
                      ),
                0.05.vspace,
                Text(
                  (Platform.isAndroid
                          ? "Enable biometric unlock"
                          : "Enable Face ID")
                      .tr,
                  style: titleLarge,
                ),
                0.01.vspace,
                Text(
                  "${"Access your Plenty Wallet with your".tr} ${(Platform.isAndroid ? "Fingerprint" : "Face ID").tr}",
                  textAlign: TextAlign.center,
                  style: bodySmall.apply(
                    color: ColorConst.NeutralVariant.shade60,
                  ),
                ),
                const Spacer(),
                SolidButton(
                  title: "Enable",
                  titleStyle: titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () {
                    controller.checkOrWriteNewAndRedirectToNewPage(true);
                  },
                ),
                0.01.vspace,
                BouncingWidget(
                  onPressed: () {
                    controller.checkOrWriteNewAndRedirectToNewPage(false);
                  },
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "Skip".tr,
                      style: titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorConst.NeutralVariant.shade60),
                    ),
                  ),
                ),
                0.02.vspace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
