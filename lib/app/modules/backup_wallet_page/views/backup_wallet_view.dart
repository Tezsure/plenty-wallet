import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/copy_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/verify_phrase_page/views/verify_phrase_page_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'package:naan_wallet/app/data/mock/mock_data.dart';
import '../controllers/backup_wallet_controller.dart';
import 'widgets/phrase_container.dart';

class BackupWalletView extends GetView<BackupWalletController> {
  final String seedPhrase;
  const BackupWalletView({
    Key? key,
    required this.seedPhrase,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(BackupWalletController());
    controller.seedPhrase = seedPhrase.split(" ");
    return SafeArea(
      bottom: false,
      top: true,
      child: NaanBottomSheet(
          height: 0.9.height,
          bottomSheetHorizontalPadding: 16.arP,
          bottomSheetWidgets: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                0.036.vspace,
                Text(
                  'Your Secret Phrase',
                  style: titleLarge,
                ),
                0.012.vspace,
                Text(
                  'These 12 words are the keys to your\nwallet. Back them up with a password\nmanager or write them down.',
                  textAlign: TextAlign.center,
                  style: bodySmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ),
                0.04.vspace,
                Obx(() => CopyButton(
                      isCopied: controller.phraseCopy.value,
                      onPressed: () => controller.paste().whenComplete(() =>
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Copied to your clipboard !')))),
                    )),
                0.020.vspace,
                GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: controller.seedPhrase.length,
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
                        phrase: controller.seedPhrase[index],
                      );
                    }),
                0.07.vspace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.arP),
                  child: SolidButton(
                    active: true,
                    onPressed: () {
                      Get.bottomSheet(
                          VerifyPhrasePageView(
                            seedPhrase: controller.seedPhrase.join(" "),
                          ),
                          isScrollControlled: true);
                    },
                    title: "I have saved these words",
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "${PathConst.SVG}check.svg",
                          color: ColorConst.Neutral.shade100,
                          width: 20.sp,
                        ),
                        0.02.hspace,
                        Text(
                          "I’ve saved these words",
                          style: titleSmall,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }

  Widget infoBottomSheet() {
    return NaanBottomSheet(
        blurRadius: 5,
        gradientStartingOpacity: 1,
        isDraggableBottomSheet: true,
        title: 'Introduction to crypto wallet',
        draggableListBuilder: (_, index) {
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
