import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

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
        height: AppConstant.naanBottomSheetHeight,
        title: "Verify",
        prevPageName: "Back",
        leading: backButton(
            ontap: () => Navigator.pop(context), lastPageName: "Back"),
        // bottomSheetHorizontalPadding: 0.arP,
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     backButton(),
                  //     InfoButton(
                  //       onPressed: () => CommonFunctions.bottomSheet(
                  //         const InfoBottomSheet(),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  0.04.vspace,

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
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller
                          .phraseList[controller.keyIndex.value].length,
                      padding: EdgeInsets.symmetric(horizontal: 32.arP),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: (140 / 41).arP,
                        crossAxisSpacing: 24.arP,
                        mainAxisSpacing: 16.arP,
                      ),
                      itemBuilder: (_, index) {
                        return Obx(() => BouncingWidget(
                              onPressed: () => controller.selectSecretPhrase(
                                index: index,
                              ),
                              child: Material(
                                color:
                                    (controller.phraseIndex?.value == index &&
                                            controller.isPhraseSelected.value)
                                        ? ColorConst.Primary
                                        : ColorConst.NeutralVariant.shade60
                                            .withOpacity(0.2),
                                type: MaterialType.canvas,
                                elevation: 1,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                child: Center(
                                  child: Text(
                                    controller
                                        .phraseList[controller.keyIndex.value]
                                        .elementAt(index),
                                    style: labelLarge.copyWith(
                                        color: (controller.phraseIndex?.value ==
                                                    index &&
                                                controller
                                                    .isPhraseSelected.value)
                                            ? ColorConst.Neutral.shade100
                                            : ColorConst
                                                .NeutralVariant.shade60),
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
                            'Wrong word selected. Try again'.tr,
                            style: bodySmall.copyWith(color: ColorConst.Error),
                          ),
                        )
                      : Container()),
                  const Spacer(),
                  Obx(() => SolidButton(
                        title: controller.isPhraseVerified.value &&
                                controller.isPhraseSelected.value
                            ? 'Done'
                            : 'Next',
                        onPressed: controller.selectedPhrase.isEmpty
                            ? null
                            : controller.verifySecretPhrase,
                      )),
                  BottomButtonPadding()
                ]),
          ),
        ]);
  }
}
