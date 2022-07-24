import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/copy_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/backup_wallet_controller.dart';
import 'widgets/phrase_container.dart';

class BackupWalletView extends GetView<BackupWalletController> {
  const BackupWalletView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 38),
          decoration:
              const BoxDecoration(gradient: GradConst.GradientBackground),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      backButton(),
                      InfoButton(
                        onPressed: () => Get.bottomSheet(
                          infoBottomSheet(),
                          // enableDrag: true,
                          // isDismissible: true,
                          // ignoreSafeArea: true,
                          isScrollControlled: true,
                          barrierColor: const Color.fromARGB(09, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
                40.h.vspace,
                Text(
                  'Your Secret Phrase',
                  style: titleLarge,
                ),
                30.h.vspace,
                Text(
                  'These 12 words are the keys to your\nwallet. Back them up with a password\nmanager or write them down.',
                  textAlign: TextAlign.center,
                  style: bodyLarge.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ),
                const CopyButton(),
                20.h.vspace,
                GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: controller.secretPhrase.length,
                    padding: const EdgeInsets.symmetric(horizontal: 57),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 130 / 40,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (_, index) {
                      return PhraseContainer(
                        index: index,
                        phrase: controller.secretPhrase[index],
                      );
                    }),
                Padding(
                  padding: EdgeInsets.only(bottom: 0, top: 0.04.height),
                  child: SolidButton(
                    onPressed: () => Get.toNamed(Routes.VERIFY_PHRASE_PAGE),
                    width: 0.7.width,
                    rowWidget: Icon(
                      Icons.check_circle_outline,
                      color: ColorConst.Primary.shade95,
                      size: 20,
                    ),
                    title: "I've saved these words",
                    textColor: ColorConst.Neutral.shade95,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoBottomSheet() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 1,
        minChildSize: 0.85,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xff07030c).withOpacity(0.49),
                  const Color(0xff2d004f),
                ],
              ),
            ),
            width: 1.width,
            padding: EdgeInsets.symmetric(horizontal: 0.05.width),
            child: Column(
              children: [
                0.005.vspace,
                Container(
                  height: 5,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
                0.05.vspace,
                Text(
                  "Wallets ready to import",
                  textAlign: TextAlign.start,
                  style: titleLarge,
                ),
                0.05.vspace,
                Expanded(
                  child: RawScrollbar(
                    controller: scrollController,
                    radius: const Radius.circular(2),
                    trackRadius: const Radius.circular(2),
                    thickness: 4,
                    thumbVisibility: true,
                    thumbColor: ColorConst.NeutralVariant.shade60,
                    trackColor:
                        ColorConst.NeutralVariant.shade60.withOpacity(0.4),
                    trackBorderColor:
                        ColorConst.NeutralVariant.shade60.withOpacity(0.4),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemCount: 6,
                      // primary: true,
                      itemBuilder: (_, index) {
                        return RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text:
                                '${controller.walletInfo.keys.elementAt(index)}\n',
                            style: bodyMedium,
                            children: [
                              TextSpan(
                                text:
                                    "\n${controller.walletInfo.values.elementAt(index)}\n",
                                style: bodySmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade60,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget nfoBottomSheet() {
    return NaanBottomSheet(
        height: 0.8.height,
        blurRadius: 5,
        gradientStartingOpacity: 1,
        title: 'Introduction to crypto wallet',
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: 6,
            primary: true,
            itemBuilder: (_, index) {
              return RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  text: '${controller.walletInfo.keys.elementAt(index)}\n',
                  style: bodyMedium,
                  children: [
                    TextSpan(
                      text:
                          "\n${controller.walletInfo.values.elementAt(index)}\n",
                      style: bodySmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ]);
  }
}
