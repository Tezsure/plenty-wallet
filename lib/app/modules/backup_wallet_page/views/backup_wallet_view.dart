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
  final String? prevPage;

  const BackupWalletView({
    Key? key,
    this.prevPage,
    required this.seedPhrase,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(BackupWalletController());
    controller.seedPhrase = seedPhrase.split(" ");
    return NaanBottomSheet(
        height:
            AppConstant.naanBottomSheetHeight - (prevPage == null ? 0 : 64.arP),
        // title: "Secret Phrase",
        prevPageName: prevPage,
        // bottomSheetHorizontalPadding: prevPage == null ? null : 0,
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetHeight - 24.arP,
            child: prevPage == null
                ? Navigator(
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(
                          builder: (context) => _buildBody(context));
                    },
                  )
                : _buildBody(context),
          ),
        ]);
  }

  Column _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BottomSheetHeading(
          title: "Secret phrase",
          leading: prevPage == null
              ? null
              : backButton(
                  lastPageName: prevPage,
                  ontap:
                      prevPage == null ? null : () => Navigator.pop(context)),
        ),
        0.04.vspace,
        Text(
          'These ${controller.seedPhrase.length} words are the keys to your\nwallet. Back them up with a password\nmanager or write them down.'
              .tr,
          textAlign: TextAlign.center,
          style: bodySmall.copyWith(color: ColorConst.NeutralVariant.shade60),
        ),
        0.04.vspace,
        Obx(() => CopyButton(
              isCopied: controller.phraseCopy.value,
              onPressed: () => controller.paste().whenComplete(() =>
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Copied to your clipboard !'.tr)))),
            )),
        0.020.vspace,
        GridView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: controller.seedPhrase.length,
            padding: EdgeInsets.symmetric(
                horizontal:
                    controller.seedPhrase.length == 24 ? 20.arP : 30.arP),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: controller.seedPhrase.length == 24 ? 3 : 2,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyPhrasePageView(
                      seedPhrase: controller.seedPhrase.join(" "),
                    ),
                  ));

              // CommonFunctions.bottomSheet(
              //   VerifyPhrasePageView(
              //     seedPhrase: controller.seedPhrase.join(" "),
              //   ),
              // );
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
                  "I’ve saved these words".tr,
                  style: titleSmall,
                )
              ],
            ),
          ),
        ),
        BottomButtonPadding()
      ],
    );
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
