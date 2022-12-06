import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';
import '../../common_widgets/back_button.dart';
import '../controllers/verify_phrase_page_controller.dart';

class VerifyPhrasePageView extends GetView<VerifyPhrasePageController> {
  final String seedPhrase;
  const VerifyPhrasePageView({
    Key? key,
    required this.seedPhrase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyPhrasePageController());
    controller.listSeeds = seedPhrase.split(" ");
    controller.phrase1 = controller.listSeeds.sublist(0, 4).toList();
    controller.phrase2 = controller.listSeeds.sublist(4, 8).toList();
    controller.phrase3 = controller.listSeeds.sublist(8).toList();
    controller.phraseList = [
      controller.phrase1,
      controller.phrase2,
      controller.phrase3
    ];
    return NaanBottomSheet(
        height: 0.9.height,
        bottomSheetHorizontalPadding: 16.arP,
        bottomSheetWidgets: [
          SizedBox(
            height: 0.82.height,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      backButton(),
                      InfoButton(
                        onPressed: () => Get.bottomSheet(
                          const InfoBottomSheet(),
                          enterBottomSheetDuration:
                              const Duration(milliseconds: 180),
                          exitBottomSheetDuration:
                              const Duration(milliseconds: 150),
                          enableDrag: true,
                          isDismissible: true,
                          isScrollControlled: true,
                          barrierColor: const Color.fromARGB(09, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                  0.038.vspace,
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Verify your secret phrase',
                      style: titleLarge,
                    ),
                  ),
                  0.012.vspace,
                  Obx(() => Align(
                        alignment: Alignment.center,
                        child: Text(
                          controller.phraseKeys[controller.keyIndex.value],
                          textAlign: TextAlign.center,
                          style: bodyMedium.copyWith(
                              color: ColorConst.NeutralVariant.shade60),
                        ),
                      )),
                  0.040.vspace,
                  GridView.builder(
                      shrinkWrap: true,
                      itemCount: controller
                          .phraseList[controller.keyIndex.value].length,
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 140 / 52,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (_, index) {
                        return Obx(() => Material(
                              color: (controller.phraseIndex?.value == index &&
                                      controller.isPhraseSelected.value)
                                  ? ColorConst.Primary
                                  : ColorConst.NeutralVariant.shade60
                                      .withOpacity(0.2),
                              type: MaterialType.canvas,
                              elevation: 1,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              child: InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                onTap: () => controller.selectSecretPhrase(
                                  index: index,
                                ),
                                splashColor: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    controller
                                        .phraseList[controller.keyIndex.value]
                                        .elementAt(index),
                                    style: bodyMedium,
                                  ),
                                ),
                              ),
                            ));
                      }),
                  0.025.vspace,
                  Obx(() => controller.showError.value
                      ? Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Wrong word selected. Try again',
                            style: bodySmall.copyWith(color: ColorConst.Error),
                          ),
                        )
                      : Container()),
                  const Spacer(),
                  Obx(() => Align(
                        alignment: Alignment.bottomCenter,
                        child: Material(
                            color: (controller.isPhraseSelected.value)
                                ? ColorConst.Primary
                                : ColorConst.NeutralVariant.shade60
                                    .withOpacity(0.2),
                            type: MaterialType.canvas,
                            elevation: 1,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              onTap: () => controller.selectedPhrase.isEmpty
                                  ? null
                                  : controller.verifySecretPhrase(),
                              splashColor: Colors.transparent,
                              child: Container(
                                height: 48,
                                width: 0.8.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.isPhraseVerified.value &&
                                          controller.isPhraseSelected.value
                                      ? 'Done'
                                      : 'Next',
                                  style: titleSmall.apply(
                                    color: (controller.isPhraseSelected.value)
                                        ? Colors.white
                                        : ColorConst.NeutralVariant.shade60,
                                  ),
                                ),
                              ),
                            )),
                      )),
                ]),
          ),
        ]);
  }
}
