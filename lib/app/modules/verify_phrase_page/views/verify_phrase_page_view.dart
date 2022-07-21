import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
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
            40.h.vspace,
            Align(
              alignment: Alignment.center,
              child: Text(
                'Verify your secret phrase',
                style: titleLarge,
              ),
            ),
            30.h.vspace,
            Align(
              alignment: Alignment.center,
              child: Text(
                "Which word is the #2 word\nof your secret phrase?",
                textAlign: TextAlign.center,
                style: bodyMedium.copyWith(
                    color: ColorConst.NeutralVariant.shade60),
              ),
            ),
            40.h.vspace,
            GridView.builder(
                shrinkWrap: true,
                itemCount: 4,
                padding: const EdgeInsets.symmetric(horizontal: 47),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 140 / 52,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (_, index) {
                  return const SolidButton(title: 'food');
                }),
            const Spacer(),
            Align(
                alignment: Alignment.bottomCenter,
                child: SolidButton(width: 0.9.width, title: 'Next'))
          ]),
    );
  }
}
