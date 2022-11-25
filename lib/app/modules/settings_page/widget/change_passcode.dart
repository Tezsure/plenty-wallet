import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../../../utils/styles/styles.dart';
import '../../common_widgets/back_button.dart';
import '../controllers/settings_page_controller.dart';

class ChangePasscode extends GetView<SettingsPageController> {
  const ChangePasscode({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.02.vspace,
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
                    "${PathConst.SVG}naan_logo.svg",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              0.05.vspace,
              Obx(() => Text(
                    controller.verifyPassCode.value
                        ? "Set passcode"
                        : "Enter passcode",
                    textAlign: TextAlign.center,
                    style: titleMedium,
                  )),
              0.01.vspace,
              Text(
                "Protect your wallet by setting a passcode",
                style:
                    bodySmall.apply(color: ColorConst.NeutralVariant.shade60),
              ),
              0.05.vspace,
              AppPassCode(onChanged: (value) {
                if (value.length == 6) {
                  controller.changeAppPasscode(value);
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}

class AppPassCode extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const AppPassCode({Key? key, this.onChanged}) : super(key: key);

  @override
  State<AppPassCode> createState() => _AppPassCode();
}

class _AppPassCode extends State<AppPassCode> {
  // String passCode = "";
  final _controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 0.45.width,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: _controller.enteredPassCode.value.length - 1 < index
                        ? Colors.transparent
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ),
        0.05.vspace,
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
              if (_controller.enteredPassCode.value.isNotEmpty) {
                _controller.enteredPassCode.value = _controller
                    .enteredPassCode.value
                    .substring(0, _controller.enteredPassCode.value.length - 1);
                if (widget.onChanged != null) {
                  widget.onChanged!(_controller.enteredPassCode.value);
                }
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
                    if (_controller.enteredPassCode.value.length < 6) {
                      _controller.enteredPassCode.value =
                          _controller.enteredPassCode.value + value;
                      if (widget.onChanged != null) {
                        widget.onChanged!(_controller.enteredPassCode.value);
                      }
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
