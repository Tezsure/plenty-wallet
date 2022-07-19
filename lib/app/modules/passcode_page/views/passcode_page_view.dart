import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/material_Tap.dart';
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
          ),
          36.vspace,
          PassCodeWidget()
        ],
      ),
    );
  }
}

class PassCodeWidget extends StatefulWidget {
  const PassCodeWidget({Key? key}) : super(key: key);

  @override
  State<PassCodeWidget> createState() => _PassCodeWidgetState();
}

class _PassCodeWidgetState extends State<PassCodeWidget> {
  String passCode = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 204,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (index) => Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  color: passCode.length - 1 < index
                      ? Colors.transparent
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
        ),
        43.vspace,
        SizedBox(
          width: 236,
          child: Wrap(
            runSpacing: 36,
            spacing: 40,
            children:
                List.generate(9, (index) => numButton((index + 1).toString())),
          ),
        ),
        36.vspace,
        SizedBox(
          width: 236,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 52,
              ),
              numButton("0"),
              backButton(),
            ],
          ),
        )
      ],
    );
  }

  Widget numButton(String value) {
    return materialTap(
      onPressed: () {
        if (passCode.length < 6) {
          setState(() {
            passCode = passCode + value;
            print(passCode);
          });
        }
      },
      inkwellRadius: 26,
      splashColor: ColorConst.Neutral.shade60.withOpacity(0.4),
      color: Colors.transparent,
      child: Container(
        height: 52,
        width: 52,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Text(
          value,
          style: headlineSmall,
        ),
      ),
    );
  }

  Widget backButton() {
    return materialTap(
      onPressed: () {
        if (passCode.length > 0) {
          setState(() {
            passCode = passCode.substring(0, passCode.length - 1);
            print(passCode);
          });
        }
      },
      inkwellRadius: 26,
      splashColor: ColorConst.Neutral.shade60.withOpacity(0.4),
      color: Colors.transparent,
      child: Container(
        height: 52,
        width: 52,
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace_outlined,
          color: ColorConst.NeutralVariant.shade60,
          size: 18,
        ),
      ),
    );
  }
}
