import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';
import '../../common_widgets/back_button.dart';
import '../controllers/verify_phrase_page_controller.dart';

class VerifyPhrasePageView extends GetView<VerifyPhrasePageController> {
  const VerifyPhrasePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.height,
      width: 1.width,
      padding: const EdgeInsets.symmetric(vertical: 38),
      decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: backButton(),
            ),
            40.vspace,
            Align(
              alignment: Alignment.center,
              child: Text(
                'Verify your secret phrase',
                style: titleLarge,
              ),
            ),
            30.vspace,
            Obx(() => Align(
                  alignment: Alignment.center,
                  child: Text(
                    controller.phraseKeys[controller.keyIndex.value],
                    textAlign: TextAlign.center,
                    style: bodyMedium.copyWith(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                )),
            40.vspace,
            GridView.builder(
                shrinkWrap: true,
                itemCount:
                    controller.phraseList[controller.keyIndex.value].length,
                padding: const EdgeInsets.symmetric(horizontal: 47),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 140 / 52,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 12,
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
                              controller.phraseList[controller.keyIndex.value]
                                  .elementAt(index),
                              style: bodyMedium,
                            ),
                          ),
                        ),
                      ));
                }),
            25.vspace,
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
                          : ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                      type: MaterialType.canvas,
                      elevation: 1,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        onTap: () => controller.isPhraseVerified.value
                            ? Get.offAndToNamed(Routes.HOME_PAGE)
                            : controller.selectedPhrase.isEmpty
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
    );
  }
}
