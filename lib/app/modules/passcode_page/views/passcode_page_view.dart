import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/passcode_page_controller.dart';

class PasscodePageView extends GetView<PasscodePageController> {
  const PasscodePageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: GradConst.GradientBackground),
      width: 1.width,
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          38.vspace,
          Align(
            alignment: Alignment.centerLeft,
            child: backButton(),
          ),
          40.vspace,
          Center(
            child: SizedBox(
              height: 107,
              width: 107,
              child: SvgPicture.asset(PathConst.SVG + "naan_logo.svg"),
            ),
          ),
          35.vspace,
          Text(
            "Set passcode",
            textAlign: TextAlign.center,
            style: titleMedium,
          ),
          8.vspace,
          Text(
            "Protect your wallet by setting a passcode",
            style: bodySmall.apply(color: ColorConst.NeutralVariant.shade60),
          )
        ],
      ),
    );
  }
}
