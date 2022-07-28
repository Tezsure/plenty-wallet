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

import '../../../../mock/mock_data.dart';
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
          height: 1.height,
          width: 1.width,
          padding: const EdgeInsets.only(top: 38),
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
                          enableDrag: true,
                          isDismissible: true,
                          isScrollControlled: true,
                          barrierColor: const Color.fromARGB(09, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
                40.vspace,
                Text(
                  'Your Secret Phrase',
                  style: titleLarge,
                ),
                30.vspace,
                Text(
                  'These 12 words are the keys to your\nwallet. Back them up with a password\nmanager or write them down.',
                  textAlign: TextAlign.center,
                  style: bodyLarge.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ),
                Obx(() => CopyButton(
                      isCopied: controller.phraseCopy.value,
                      onPressed: () => controller.paste().whenComplete(() =>
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Copied to your clipboard !')))),
                    )),
                20.vspace,
                GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: MockData.secretPhrase.length,
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
                        phrase: MockData.secretPhrase[index],
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
    return NaanBottomSheet(
        blurRadius: 5,
        gradientStartingOpacity: 1,
        isDraggableBottomSheet: true,
        title: 'Introduction to crypto wallet',
        listBuilder: (_, index) {
          return RichText(
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
              ));
        });
  }
}
