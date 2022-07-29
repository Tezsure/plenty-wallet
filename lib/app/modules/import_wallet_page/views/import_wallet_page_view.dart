import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/widgets/accounts_widget.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../mock/mock_data.dart';
import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../common_widgets/back_button.dart';
import '../controllers/import_wallet_page_controller.dart';

class ImportWalletPageView extends GetView<ImportWalletPageController> {
  const ImportWalletPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
      width: 1.width,
      height: 1.height,
      padding: EdgeInsets.symmetric(horizontal: 0.05.width),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              21.vspace,
              Row(
                children: [
                  backButton(),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        infoBottomSheet(),
                        isScrollControlled: true,
                        barrierColor: Colors.white.withOpacity(0.2),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: ColorConst.NeutralVariant.shade60,
                          size: 16,
                        ),
                        0.01.hspace,
                        Text(
                          "Info",
                          style: titleMedium.apply(
                              color: ColorConst.NeutralVariant.shade60),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      53.vspace,
                      Text(
                        "Import wallet",
                        style: titleLarge,
                      ),
                      29.vspace,
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
                                    controller:
                                        controller.phraseTextController.value,
                                    style: bodyMedium,
                                    onChanged: (value) =>
                                        controller.onTextChange(value),
                                    maxLines: null,
                                    minLines: null,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          top: 18, left: 18),
                                      hintStyle: bodyMedium.apply(
                                          color: Colors.white.withOpacity(0.2)),
                                      hintText:
                                          "Paste your secret phrase, private key\nor watch address",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => controller.phraseText.isNotEmpty ||
                                          controller.phraseText.value != ""
                                      ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.phraseTextController
                                                  .value.text = "";
                                              controller.phraseTextController
                                                      .value =
                                                  controller
                                                      .phraseTextController
                                                      .value;
                                            },
                                            child: Text(
                                              "Clear",
                                              style: titleSmall.apply(
                                                  color: ColorConst.Primary),
                                            ),
                                          ))
                                      : Container(),
                                ),
                                12.vspace,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => controller.phraseText.isEmpty
                    ? pasteButton()
                    : importButton(),
              ),
              38.vspace,
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            ],
          ),
          Obx(() => controller.showSuccessAnimation.value
              ? Container(
                  decoration: const BoxDecoration(
                      gradient: GradConst.GradientBackground),
                  height: 1.height,
                  width: 1.width,
                  child: Center(
                    child: Lottie.asset(
                      '${PathConst.ASSETS}create_wallet/lottie/wallet_success.json',
                      fit: BoxFit.contain,
                      height: 300,
                      width: 300,
                      frameRate: FrameRate(30),
                    ),
                  ),
                )
              : Container())
        ],
      ),
    );
  }

  SolidButton pasteButton() {
    return SolidButton(
      onPressed: controller.paste,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${PathConst.SVG}paste.svg",
            fit: BoxFit.scaleDown,
          ),
          13.hspace,
          Text(
            "Paste",
            style: titleSmall.apply(color: ColorConst.Neutral.shade95),
          )
        ],
      ),
    );
  }

  Widget importButton() {
    return Obx(
      () => SolidButton(
        onPressed: () {
          FocusManager.instance.primaryFocus
              ?.unfocus(); // Hide keyboard if it's open
          Get.bottomSheet(
            accountBottomSheet(),
            isScrollControlled: true,
            barrierColor: Colors.white.withOpacity(0.2),
          );
        },
        active: controller.phraseText.value.split(" ").join().length == 12,
        inActiveChild: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "${PathConst.SVG}import.svg",
              fit: BoxFit.scaleDown,
              color: ColorConst.NeutralVariant.shade60,
            ),
            3.hspace,
            Text(
              "Import",
              style: titleSmall.apply(color: ColorConst.NeutralVariant.shade60),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "${PathConst.SVG}import.svg",
              fit: BoxFit.scaleDown,
              color: ColorConst.Neutral.shade95,
            ),
            3.hspace,
            Text(
              "Import",
              style: titleSmall.apply(color: ColorConst.Neutral.shade95),
            )
          ],
        ),
      ),
    );
  }

  Widget accountBottomSheet() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xff07030c).withOpacity(1),
              const Color(0xff2d004f),
            ],
          ),
        ),
        width: 1.width,
        height: 0.85.height,
        padding: EdgeInsets.symmetric(horizontal: 0.05.width),
        child: Column(
          children: [
            5.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            20.vspace,
            Text(
              "Wallets ready to import",
              textAlign: TextAlign.start,
              style: titleLarge,
            ),
            10.vspace,
            const Expanded(
              child: AccountWidget(),
            ),
            5.vspace,
            SolidButton(
              onPressed: () => controller.showAnimation(),
              title: "Continue",
            ),
            20.vspace
          ],
        ),
      ),
    );
  }

  Widget infoBottomSheet() {
    return NaanBottomSheet(
        title: 'Wallets ready to import',
        isDraggableBottomSheet: true,
        listBuilder: (_, index) => RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: '${MockData.walletInfo.keys.elementAt(index)}\n',
              style: bodyMedium,
              children: [
                TextSpan(
                  text: "\n${MockData.walletInfo.values.elementAt(index)}\n",
                  style: bodySmall.copyWith(
                    color: ColorConst.NeutralVariant.shade60,
                  ),
                )
              ],
            )));
  }
}
