import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:plenty_wallet/app/modules/passcode_page/views/reset_passcode_view.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import '../controllers/passcode_page_controller.dart';

class PasscodePageView extends GetView<PasscodePageController> {
  const PasscodePageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as List;
    controller.isToVerifyPassCode.value = args[0] as bool;
    if (args.length == 2) {
      controller.nextPageRoute = args[1] as String;
    } else {
      controller.nextPageRoute = null;
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: OverrideTextScaleFactor(
        child: CupertinoPageScaffold(
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              leading: Get.previousRoute == Routes.SPLASH_PAGE ||
                      (controller.nextPageRoute != null &&
                          controller.nextPageRoute == Routes.LOCKED)
                  ? Container()
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.arP),
                        child: backButton(),
                      ),
                    ),
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              color: Colors.black,
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
                    Obx(
                      () => Text(
                        controller.isPasscodeLock.value
                            ? controller.lockTimeTitle.value
                            : (controller.isToVerifyPassCode.value
                                    ? controller.isPassCodeWrong.value
                                        ? "Try Again"
                                        : "Enter passcode"
                                    : (controller.isPassCodeWrong.value)
                                        ? "Try Again"
                                        : controller.confirmPasscode.value
                                                    .length <
                                                6
                                            ? "Set passcode"
                                            : "Verify passcode")
                                .tr,
                        textAlign: TextAlign.center,
                        style: titleMedium,
                      ),
                    ),
                    0.01.vspace,
                    Obx(
                      () => Text(
                        controller.isPasscodeLock.value
                            ? controller.safetyResetAttempts.value != -1
                                ? "${controller.safetyResetAttempts.value} attempts left"
                                : ""
                            : controller.passCodeError.value.isNotEmpty
                                ? controller.passCodeError.value
                                : (controller.isPassCodeWrong.value
                                        ? "Passcode doesn’t match"
                                        : controller.enteredPassCode.value
                                                    .length <
                                                6
                                            ? ""
                                            : controller.confirmPasscode.value
                                                        .length <
                                                    6
                                                ? "Protect your Plenty Wallet by creating a passcode"
                                                : "Re-enter your passcode")
                                    .tr,
                        style: bodySmall.apply(
                            color: controller.passCodeError.value.isNotEmpty ||
                                    (controller.isPasscodeLock.value &&
                                        controller.safetyResetAttempts.value !=
                                            -1)
                                ? ColorConst.Error.shade60
                                : ColorConst.NeutralVariant.shade60),
                      ),
                    ),
                    0.05.vspace,
                    PassCodeWidget(onChanged: (value) async {
                      controller.passCodeError.value = "";
                      // debugdebugPrint(
                      //     "confirm passcode : ${controller.confirmPasscode.value}");
                      // debugdebugPrint(
                      //     "set passcode : ${controller.enteredPassCode.value}");

                      if (controller.isToVerifyPassCode.value) {
                        if (value.length == 6) {
                          await controller
                              .checkOrWriteNewAndRedirectToNewPage(value);
                        } else {
                          controller.isPassCodeWrong.value = false;
                        }
                      } else {
                        if (controller.enteredPassCode.value.length == 6 &&
                            controller.confirmPasscode.value ==
                                controller.enteredPassCode.value) {
                          await controller
                              .checkOrWriteNewAndRedirectToNewPage(value);
                        } else if (controller.enteredPassCode.value.length ==
                                6 &&
                            controller.confirmPasscode.value.length == 6 &&
                            controller.confirmPasscode.value !=
                                controller.enteredPassCode.value) {
                          controller.wrongPasscodeLimit++;
                          controller.isPassCodeWrong.value = true;
                          controller.enteredPassCode.value = "";
                          HapticFeedback.heavyImpact();
                          if (controller.wrongPasscodeLimit.value == 5) {
                            controller.wrongPasscodeLimit.value = 0;
                            controller.isPassCodeWrong.value = false;
                            controller.confirmPasscode.value = "";
                            controller.enteredPassCode.value = "";
                          }
                        } else {
                          controller.isPassCodeWrong.value = false;
                        }
                      }
                    }),
                    Obx(
                      () => Column(
                        children: [
                          controller.isPasscodeSet.value
                              ? Column(
                                  children: [
                                    0.05.vspace,
                                    BouncingWidget(
                                      onPressed: () {
                                        Get.to(() => ResetWalletPageView());
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.arP),
                                        child: Text(
                                          "Forgot passcode?",
                                          style: labelMedium.apply(
                                              color: ColorConst
                                                  .NeutralVariant.shade60),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    const BottomButtonPadding()
                  ],
                ),
              ),
            ),
          ),
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
  // String passCode = "";

  PasscodePageController controller = Get.find<PasscodePageController>();

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
                  height: 22.arP,
                  width: 22.arP,
                  decoration: BoxDecoration(
                    color: controller.confirmPasscode.value.length == 6 ||
                            controller.isToVerifyPassCode.value
                        ? (controller.enteredPassCode.value.length - 1 < index
                            ? Colors.transparent
                            : Colors.white)
                        : (controller.confirmPasscode.value.length - 1 < index
                            ? Colors.transparent
                            : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: controller.isPasscodeLock.value
                            ? ColorConst.NeutralVariant.shade60
                            : controller.isPassCodeWrong.value
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
        width: 0.8.width,
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
              if (controller.confirmPasscode.value.length == 6 ||
                  controller.isToVerifyPassCode.value) {
                if (controller.enteredPassCode.value.isNotEmpty) {
                  controller.enteredPassCode.value =
                      controller.enteredPassCode.value.substring(
                          0, controller.enteredPassCode.value.length - 1);
                  if (widget.onChanged != null) {
                    widget.onChanged!(controller.enteredPassCode.value);
                  }
                }
              } else {
                if (controller.confirmPasscode.value.isNotEmpty) {
                  controller.confirmPasscode.value =
                      controller.confirmPasscode.value.substring(
                          0, controller.confirmPasscode.value.length - 1);
                  if (widget.onChanged != null) {
                    widget.onChanged!(controller.confirmPasscode.value);
                  }
                }
              }
            })
          ],
        ),
      );

  Widget getButton(String value,
      [isDisable = false, IconData? iconData, onIconTap]) {
    return Padding(
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
        child: Obx(
          () => BouncingWidget(
            // borderRadius: BorderRadius.all(
            //   Radius.circular(0.065.width),
            // ),
            // highlightColor: ColorConst.NeutralVariant.shade60.withOpacity(0.4),
            // splashFactory: NoSplash.splashFactory,
            onPressed: controller.isPasscodeLock.value
                ? null
                : iconData != null
                    ? onIconTap
                    : () {
                        if (controller.confirmPasscode.value.length == 6 ||
                            controller.isToVerifyPassCode.value) {
                          if (controller.enteredPassCode.value.length < 6) {
                            controller.enteredPassCode.value =
                                controller.enteredPassCode.value + value;
                            if (widget.onChanged != null) {
                              widget
                                  .onChanged!(controller.enteredPassCode.value);
                            }
                          }
                        } else {
                          if (controller.confirmPasscode.value.length < 6) {
                            controller.confirmPasscode.value =
                                controller.confirmPasscode.value + value;
                            if (widget.onChanged != null) {
                              widget
                                  .onChanged!(controller.confirmPasscode.value);
                            }
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
                      : Text(
                          value,
                          style: TextStyle(
                            color: controller.isPasscodeLock.value
                                ? ColorConst.NeutralVariant.shade60
                                : Colors.white,
                            fontSize: 22.0.arP,
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
