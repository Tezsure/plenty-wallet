import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../../../utils/styles/styles.dart';
import '../../common_widgets/back_button.dart';
import '../controllers/settings_page_controller.dart';

class ChangePasscode extends GetView<SettingsPageController> {
  const ChangePasscode({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OverrideTextScaleFactor(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 16.arP),
            child: backButton(),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.black,
        body: Container(
          // decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
          padding: EdgeInsets.symmetric(horizontal: 21.arP),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff6923E7).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24.arP),
                    ),
                    height: 0.27.width,
                    width: 0.27.width,
                    padding: EdgeInsets.all(20.arP),
                    child: SvgPicture.asset(
                      "${PathConst.SVG}plenty_wallet_black.svg",
                      width: 66.arP,
                      height: 66.arP,
                    ),
                  ),
                ),
                0.05.vspace,
                Obx(() => Text(
                      controller.isPasscodeLock.value
                          ? controller.lockTimeTitle.value
                          : (controller.verifyPassCode.value
                                  ? controller.confirmPasscode.value
                                      ? "Confirm new passcode"
                                      : "Set new passcode"
                                  : "Enter current passcode")
                              .tr,
                      textAlign: TextAlign.center,
                      style: titleMedium,
                    )),
                0.01.vspace,
                Obx(
                  () => Text(
                    controller.isPasscodeLock.value
                        ? controller.safetyResetAttempts.value != -1
                            ? "${controller.safetyResetAttempts.value} attempts left"
                            : ""
                        : (controller.passcodeError.value.isEmpty
                            ? "Protect your wallet by setting a passcode".tr
                            : controller.passcodeError.value),
                    style: bodySmall.apply(
                        color: controller.passcodeError.value.isEmpty
                            ? ColorConst.NeutralVariant.shade60
                            : ColorConst.NaanRed),
                  ),
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
                    border: Border.all(
                        color: _controller.isPasscodeLock.value
                            ? ColorConst.NeutralVariant.shade60
                            : _controller.isPassCodeWrong.value
                                ? ColorConst.Error.shade60
                                : Colors.white,
                        width: 2),
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
          child: BouncingWidget(
            onPressed: _controller.isPasscodeLock.value
                ? null
                : iconData != null
                    ? onIconTap
                    : () {
                        if (_controller.enteredPassCode.value.length < 6) {
                          _controller.enteredPassCode.value =
                              _controller.enteredPassCode.value + value;
                          if (widget.onChanged != null) {
                            widget
                                .onChanged!(_controller.enteredPassCode.value);
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
                          size: 18.arP,
                        )
                      : Obx(
                          () => Text(
                            value,
                            style: TextStyle(
                              color: _controller.isPasscodeLock.value
                                  ? ColorConst.NeutralVariant.shade60
                                  : Colors.white,
                              fontSize: 18.0.arP,
                            ),
                          ),
                        ),
            ),
          ),
        ),
      );
}
