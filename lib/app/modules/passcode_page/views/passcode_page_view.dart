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
    var args = ModalRoute.of(context)!.settings.arguments as List;
    controller.isToVerifyPassCode.value = args[0] as bool;
    if (args.length == 2) {
      controller.nextPageRoute = args[1] as String;
    }

    if (controller.isToVerifyPassCode.value) {
      controller.verifyPassCodeOrBiomatrics();
    }

    return Scaffold(
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.02.vspace,
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: CircleAvatar(
                    radius: 0.045.width,
                    backgroundColor: Colors.transparent,
                    child: SvgPicture.asset(
                      "${PathConst.SVG}arrow_back.svg",
                      fit: BoxFit.scaleDown,
                      
                    ),
                  ),
                ),
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
              Obx(
                () => Text(
                  controller.isToVerifyPassCode.value
                      ? controller.isPassCodeWrong.value
                          ? "Try Again"
                          : "Enter passcode"
                      : (controller.isPassCodeWrong.value)
                          ? "Try Again"
                          : controller.confirmPasscode.value.length < 6
                              ? "Set passcode"
                              : "Verify passcode",
                  textAlign: TextAlign.center,
                  style: titleMedium,
                ),
              ),
              0.01.vspace,
              Obx(
                () => Text(
                  controller.isPassCodeWrong.value
                      ? "Passcode doesn’t match"
                      : "Protect your naan by creating a passcode ",
                  style:
                      bodySmall.apply(color: ColorConst.NeutralVariant.shade60),
                ),
              ),
              0.05.vspace,
              PassCodeWidget(onChanged: (value) {
                debugPrint(
                    "confirm passcode : " + controller.confirmPasscode.value);
                debugPrint(
                    "set passcode : " + controller.enteredPassCode.value);

                if (controller.isToVerifyPassCode.value) {
                  if (value.length == 6) {
                    controller.checkOrWriteNewAndRedirectToNewPage(value);
                  } else {
                    controller.isPassCodeWrong.value = false;
                  }
                } else {
                  if (controller.enteredPassCode.value.length == 6 &&
                      controller.confirmPasscode.value ==
                          controller.enteredPassCode.value) {
                    controller.checkOrWriteNewAndRedirectToNewPage(value);
                  } else if (controller.enteredPassCode.value.length == 6 &&
                      controller.confirmPasscode.value.length == 6 &&
                      controller.confirmPasscode.value !=
                          controller.enteredPassCode.value) {
                    controller.isPassCodeWrong.value = true;
                
                    controller.enteredPassCode.value = "";
                  } else {
                    controller.isPassCodeWrong.value = false;
                  }
                }
              })
            ],
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
                  height: 22,
                  width: 22,
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
                        color: controller.isPassCodeWrong.value
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
                    if (controller.confirmPasscode.value.length == 6 ||
                        controller.isToVerifyPassCode.value) {
                      if (controller.enteredPassCode.value.length < 6) {
                        controller.enteredPassCode.value =
                            controller.enteredPassCode.value + value;
                        if (widget.onChanged != null) {
                          widget.onChanged!(controller.enteredPassCode.value);
                        }
                      }
                    } else {
                      if (controller.confirmPasscode.value.length < 6) {
                        controller.confirmPasscode.value =
                            controller.confirmPasscode.value + value;
                        if (widget.onChanged != null) {
                          widget.onChanged!(controller.confirmPasscode.value);
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
