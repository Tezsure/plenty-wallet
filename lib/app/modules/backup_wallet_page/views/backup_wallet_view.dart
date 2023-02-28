import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/copy_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/verify_phrase_page/views/verify_phrase_page_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
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
    return NaanBottomSheet(
        height: AppConstant.naanBottomSheetHeight,
        title: "",
        leading: backButton(),
        action: InfoButton(
            onPressed: () => CommonFunctions.bottomSheet(
                  const InfoBottomSheet(),
                )),
        // bottomSheetHorizontalPadding: 16.arP,
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                0.02.vspace,
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
                    padding: EdgeInsets.symmetric(horizontal: 30.arP),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (130 / 40).arP,
                      crossAxisSpacing: 20.arP,
                      mainAxisSpacing: 12.arP,
                    ),
                    itemBuilder: (_, index) {
                      return PhraseContainer(
                        index: index,
                        phrase: controller.seedPhrase[index],
                      );
                    }),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.arP),
                  child: SolidButton(
                    active: true,
                    onPressed: () {
                      CommonFunctions.bottomSheet(
                        VerifyPhrasePageView(
                          seedPhrase: controller.seedPhrase.join(" "),
                        ),
                      );
                    },
                    title: "I have saved these words",
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "${PathConst.SVG}check.svg",
                          color: ColorConst.Neutral.shade100,
                          width: 20.arP,
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
                BottomButtonPadding()
              ],
            ),
          ),
        ]);
  }

  // Widget infoBottomSheet() {
  //   return NaanBottomSheet(
  //       blurRadius: 5,
  //       gradientStartingOpacity: 1,
  //       isDraggableBottomSheet: true,
  //       title: 'Introduction to crypto wallet',
  //       draggableListBuilder: (_, index) {
  //         return RichText(
  //             textAlign: TextAlign.start,
  //             text: TextSpan(
  //               text: '${MockData.walletInfo.keys.elementAt(index)}\n',
  //               style: bodyMedium,
  //               children: [
  //                 TextSpan(
  //                   text: "\n${MockData.walletInfo.values.elementAt(index)}\n",
  //                   style: bodySmall.copyWith(
  //                     color: ColorConst.NeutralVariant.shade60,
  //                   ),
  //                 )
  //               ],
  //             ));
  //       });
  // }
}
