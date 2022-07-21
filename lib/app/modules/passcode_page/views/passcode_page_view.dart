import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
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
          0.05.vspace,
          Align(
            alignment: Alignment.centerLeft,
            child: backButton(),
          ),
          0.05.vspace,
          Center(
            child: SizedBox(
              height: 0.27.width,
              width: 0.27.width,
              child: SvgPicture.asset(
                PathConst.SVG + "naan_logo.svg",
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          0.05.vspace,
          Text(
            "Set passcode",
            textAlign: TextAlign.center,
            style: titleMedium,
          ),
          0.01.vspace,
          Text(
            "Protect your wallet by setting a passcode",
            style: bodySmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
          0.05.vspace,
          PassCodeWidget(onChanged: (value) {
            if (value.length == 6) {
              Get.toNamed(Routes.BIOMETRIC_PAGE);
            }
            print(value);
          })
        ],
      ),
    );
  }
}

class PassCodeWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const PassCodeWidget({Key? key, this.onChanged}) : super(key: key);

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
          width: 0.45.width,
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
        0.05.vspace,
        SizedBox(
          width: 0.75.width,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 0.1.width,
            crossAxisSpacing: 0.1.width,
            children:
                List.generate(9, (index) => numButton((index + 1).toString())),
          ),
        ),
        SizedBox(
          height: 36,
        ),
        SizedBox(
          width: 0.75.width,
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
    return MaterialButton(
      onPressed: () {
        if (passCode.length < 6) {
          setState(() {
            passCode = passCode + value;
          });
          if (widget.onChanged != null) widget.onChanged!(passCode);
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
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
    return MaterialButton(
      onPressed: () {
        if (passCode.isNotEmpty) {
          setState(() {
            passCode = passCode.substring(0, passCode.length - 1);
          });
          if (widget.onChanged != null) widget.onChanged!(passCode);
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
