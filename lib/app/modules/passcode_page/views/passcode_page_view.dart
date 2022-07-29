import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/passcode_page_controller.dart';

class PasscodePageView extends GetView<PasscodePageController> {
  const PasscodePageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
        width: 1.width,
        height: 1.height,
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            30.vspace,
            Align(
              alignment: Alignment.centerLeft,
              child: backButton(),
            ),
            20.vspace,
            Center(
              child: SizedBox(
                height: 0.27.width,
                width: 0.27.width,
                child: SvgPicture.asset(
                  "${PathConst.SVG}naan_logo.svg",
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            30.vspace,
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
            30.vspace,
            PassCodeWidget(onChanged: (value) {
              if (value.length == 6) {
                Get.toNamed(Routes.BIOMETRIC_PAGE);
              }
            })
          ],
        ),
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
      mainAxisAlignment: MainAxisAlignment.center,
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
        30.vspace,
        getKeyBoardWidget(),
      ],
    );
  }

  Widget getKeyBoardWidget() => Container(
        width: 0.7.width,
        alignment: Alignment.center,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            for (var i = 1; i < 4; i++) getButton(i.toString()),
            for (var i = 4; i < 7; i++) getButton(i.toString()),
            for (var i = 7; i < 10; i++) getButton(i.toString()),
            getButton(
              '',
              true,
            ),
            getButton(
              '0',
            ),
            getButton('', false, Icons.backspace_outlined, () {
              if (passCode.isNotEmpty) {
                setState(() {
                  passCode = passCode.substring(0, passCode.length - 1);
                });
                if (widget.onChanged != null) widget.onChanged!(passCode);
              }
            })
          ],
        ),
      );

  Widget getButton(String value,
          [isDisable = false, IconData? iconData, onIconTap]) =>
      Padding(
        padding: EdgeInsets.only(
          left: 0.04.width,
          right: 0.04.width,
          bottom: 0.04.width,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(0.065.width),
          ),
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(0.065.width),
            ),
            highlightColor: ColorConst.NeutralVariant.shade60.withOpacity(0.4),
            splashFactory: NoSplash.splashFactory,
            onTap: iconData != null
                ? onIconTap
                : () {
                    if (passCode.length < 6) {
                      setState(() {
                        passCode = passCode + value;
                      });
                      if (widget.onChanged != null) widget.onChanged!(passCode);
                    }
                  },
            child: Container(
              width: 0.13.width,
              height: 0.13.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.065.width),
                  ),
                  color: Colors.transparent),
              alignment: Alignment.center,
              child: isDisable
                  ? Container()
                  : iconData != null
                      ? Icon(
                          iconData,
                          color: ColorConst.NeutralVariant.shade60,
                          size: 18.sp,
                        )
                      : Text(
                          value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0.sp,
                          ),
                        ),
            ),
          ),
        ),
      );
}
