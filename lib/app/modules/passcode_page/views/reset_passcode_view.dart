import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/info_bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/info_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/passcode_page/controllers/passcode_page_controller.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../common_widgets/bouncing_widget.dart';
import '../../home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';

class ResetWalletPageView extends GetView<PasscodePageController> {
  bool isBottomSheet;
  bool isWatchAddress;
  ResetWalletPageView({
    Key? key,
    this.isBottomSheet = false,
    this.isWatchAddress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PasscodePageController());
    if (isBottomSheet) {
      return NaanBottomSheet(
        // bottomSheetHorizontalPadding: 16.arP,
        // isScrollControlled: true,
        height: AppConstant.naanBottomSheetHeight,
        bottomSheetWidgets: [
          SizedBox(
              height: AppConstant.naanBottomSheetChildHeight -
                  MediaQuery.of(context).viewInsets.bottom +
                  60.arP,
              child: _buildBody(context,
                  isWatchAddress: isWatchAddress, isBottomSheet: isBottomSheet))
        ],
      );
    }
    return OverrideTextScaleFactor(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CupertinoPageScaffold(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.arP),
            child: SafeArea(bottom: false, child: _buildBody(context)),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context,
      {bool isWatchAddress = false, bool isBottomSheet = false}) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.02.vspace,
          Row(
            children: [
              !isBottomSheet ? backButton() : const SizedBox(),
              // GestureDetector(
              //   onTap: () => Get.back(),
              //   child: SvgPicture.asset(
              //     "${PathConst.SVG}arrow_back.svg",
              //     fit: BoxFit.scaleDown,
              //   ),
              // ),
              const Spacer(),
              isBottomSheet
                  ? closeButton()
                  : InfoButton(
                      onPressed: () {
                        CommonFunctions.bottomSheet(
                            InfoBottomSheet(isWatchAddress: isWatchAddress),
                            fullscreen: true);
                      },
                    ),

              // GestureDetector(
              //   onTap: () {
              //     Get.bottomSheet(
              //       const InfoBottomSheet(),
              //       isScrollControlled: true,
              //       barrierColor: Colors.white.withOpacity(0.2),
              //     );
              //   },
              //   child: Row(
              //     children: [
              //       Text(
              //         "info",
              //         style: titleMedium.copyWith(
              //             fontWeight: FontWeight.w600,
              //             color: ColorConst.NeutralVariant.shade60),
              //       ),
              //       0.01.hspace,
              //       Icon(
              //         Icons.info_outline,
              //         color: ColorConst.NeutralVariant.shade60,
              //         size: 16,
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
          0.02.vspace,
          if (isBottomSheet)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InfoButton(
                  onPressed: () {
                    CommonFunctions.bottomSheet(
                        InfoBottomSheet(isWatchAddress: isWatchAddress),
                        fullscreen: true);
                  },
                ),
              ],
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: isWatchAddress
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  0.05.vspace,
                  Text(
                    ("Reset passcode").tr,
                    style: titleLarge,
                  ),
                  0.023.vspace,
                  Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.2),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.02.height,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 0.18.height,
                        child: Column(
                          children: [
                            0.02.vspace,
                            Expanded(
                              child: TextFormField(
                                cursorColor: ColorConst.Primary,
                                expands: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny("  "),
                                  // FilteringTextInputFormatter.deny(".")
                                ],
                                controller:
                                    controller.phraseTextController.value,
                                style: bodyMedium,
                                onChanged: (value) {
                                  controller.onTextChange(value);
                                },
                                maxLines: null,
                                minLines: null,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(0),
                                    hintStyle: bodyMedium.apply(
                                        color: Colors.white.withOpacity(0.2)),
                                    hintText:
                                        ("Paste your secret phrase or private key")
                                            .tr,
                                    border: InputBorder.none),
                              ),
                            ),
                            /*                           controller.phraseText.isNotEmpty ||
                                      controller.phraseText.value != ""
                                  ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.importWalletDataType =
                                              ImportWalletDataType.none;
                                          controller.phraseTextController.value
                                              .text = "";
                                          controller.phraseText.value = "";
                                        },
                                        child: Text(
                                          "Clear".tr,
                                          style: titleSmall.apply(
                                              color: ColorConst.Primary),
                                        ),
                                      ),
                                    )
                                  : Container(), */
                            0.01.vspace,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Obx(
              () => controller.resetString.isEmpty
                  ? pasteButton()
                  : importButton(
                      isWatchAddress: isWatchAddress,
                    ),
            ),
          ),
          0.03.vspace,
          BouncingWidget(
            onPressed: () {
              CommonFunctions.bottomSheet(const ResetWalletBottomSheet());
            },
            child: Center(
              child: Text("Reset plenty wallet".tr,
                  style: labelLarge.copyWith(
                    color: ColorConst.NaanRed,
                  )),
            ),
          ),

          const BottomButtonPadding()
          // SizedBox(
          //   height: MediaQuery.of(context).viewInsets.bottom,
          // )
        ],
      ),
    );
  }

  SolidButton pasteButton() {
    return SolidButton(
      width: 1.width - 64.arP,
      onPressed: controller.paste,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${PathConst.SVG}paste.svg",
            color: Colors.white,
            fit: BoxFit.scaleDown,
          ),
          0.02.hspace,
          Text(
            "Paste".tr,
            style: titleSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget importButton({bool isWatchAddress = false}) {
    return Obx(
      () {
        return SolidButton(
          title: "Next",
          width: 1.width - 64.arP,
          onPressed: () async {
            if (controller.isAccountAlreadyPresent.value) {
              Get.to(() => const ChangePasscode());
            }
          },
          // active: isImportActive(),
          active: controller.isAccountAlreadyPresent.value,

          // (controller.phraseText.trim().split(" ").join().length >= 2 &&
          //         controller.importWalletDataType !=
          //             ImportWalletDataType.none) &&

          // inActiveChild: Text(
          //   "Import",
          //   style: titleSmall,
          // ),
          // child: Text(
          //   "Import",
          //   style: titleSmall,
          // )
        );
      },
    );
  }
}

class ChangePasscode extends GetView<PasscodePageController> {
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
                      (controller.confirmPasscodeReset.value
                              ? "Confirm new passcode"
                              : "Set new passcode")
                          .tr,
                      textAlign: TextAlign.center,
                      style: titleMedium,
                    )),
                0.01.vspace,
                Obx(
                  () => Text(
                    controller.passCodeError.value.isEmpty
                        ? !controller.confirmPasscodeReset.value
                            ? "Reset your wallet by setting up a new passcode"
                            : "Confirm your new passcode"
                        : controller.passCodeError.value,
                    style: bodySmall.apply(
                        color: controller.passCodeError.value.isEmpty
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
  final _controller = Get.find<PasscodePageController>();

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
          child: BouncingWidget(
            onPressed: iconData != null
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
                          size: 18.arP,
                        )
                      : Text(
                          value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0.arP,
                          ),
                        ),
            ),
          ),
        ),
      );
}

class ResetWalletBottomSheet extends StatelessWidget {
  const ResetWalletBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      // blurRadius: 5.arP,
      height: 330.arP,
      title: "Reset Plenty Wallet",
      bottomSheetWidgets: [
        // const Spacer(),
        Center(
          child: Text(
            'You can lose your funds forever if you\ndidn’t make a backup. Are you sure you\nwant to reset Plenty Wallet?'
                .tr,
            style: bodySmall.copyWith(color: ColorConst.textGrey1),
            textAlign: TextAlign.center,
          ),
        ),
        // const Spacer(),
        0.02.vspace,
        Column(
          children: [
            optionMethod(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Platform.isAndroid
                        ? SvgPicture.asset(
                            "${PathConst.SVG}fingerprint.svg",
                            color: ColorConst.Error.shade60,
                            width: 24.arP,
                          )
                        : SvgPicture.asset(
                            "${PathConst.SVG}faceid.svg",
                            color: ColorConst.Error.shade60,
                            width: 24.arP,
                          ),
                    0.02.hspace,
                    Text(
                      "Hold to reset Plenty Wallet".tr,
                      style: labelMedium.apply(color: ColorConst.Error.shade60),
                    ),
                  ],
                ),
                onLongPress: () async {
                  if (Get.find<HomePageController>().userAccounts.isEmpty) {
                    await ServiceConfig().clearStorage();
                    NaanAnalytics.logEvent(NaanAnalyticsEvents.RESET_NAAN);
                    Get.offAllNamed(Routes.ONBOARDING_PAGE);
                  } else {
                    await ServiceConfig().clearStorage();
                    NaanAnalytics.logEvent(NaanAnalyticsEvents.RESET_NAAN);
                    Get.offAllNamed(Routes.ONBOARDING_PAGE);
                  }
                  try {
                    Get.find<HomePageController>().resetUserAccounts();
                  } catch (_) {}
                  try {
                    Get.find<NftGalleryWidgetController>().fetchNftGallerys();
                  } catch (_) {}
                }),
            0.02.vspace,
            optionMethod(
                child: Text(
                  "Cancel".tr,
                  style: labelMedium,
                ),
                onTap: () {
                  Get.back();
                }),
            BottomButtonPadding()
          ],
        ),
      ],
    );
  }

  Widget optionMethod({
    Widget? child,
    GestureTapCallback? onTap,
    GestureTapCallback? onLongPress,
  }) {
    return Center(
      child: SolidButton(
        width: 1.width - 64.arP,
        primaryColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        onLongPressed: onLongPress,
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
