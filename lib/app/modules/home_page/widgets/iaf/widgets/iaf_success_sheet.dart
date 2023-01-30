import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:share_plus/share_plus.dart';

class IAFClaimSuccessSheet extends StatelessWidget {
  const IAFClaimSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    HapticFeedback.heavyImpact();
    return NaanBottomSheet(
        bottomSheetHorizontalPadding: 16.arP,
        height: 0.45.height,
        blurRadius: 5,
        width: double.infinity,
        bottomSheetWidgets: [
          SafeArea(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  0.015.vspace,
                  LottieBuilder.asset(
                    '${PathConst.SEND_PAGE}lottie/success_primary.json',
                    height: 80.arP,
                    width: 80.arP,
                    repeat: false,
                  ),
                  // Icon(
                  //   Icons.check_circle_outline,
                  //   color: ColorConst.Primary,
                  //   size: 80.arP,
                  // ),
                  0.0175.vspace,
                  Text(
                    "Claim complete",
                    style: titleLarge,
                  ),
                  0.006.vspace,
                  Text(
                    "Claim will be completed within 1-2 minutes.\nThe NFT can be viewed in the account\nwidget located on the home screen.",
                    textAlign: TextAlign.center,
                    style: labelMedium.copyWith(color: ColorConst.textGrey1),
                  ),
                  0.03.vspace,
                  SolidButton(
                    width: 1.width - 64.arP,
                    borderColor: ColorConst.Primary,
                    active: true,
                    textColor: ColorConst.Primary,
                    primaryColor: Colors.transparent,
                    onPressed: () {
                      Get.back();
                    },
                    title: "Done",
                  ),
                  0.018.vspace,
                  SolidButton(
                    width: 1.width - 64.arP,
                    active: true,
                    onPressed: () {
                      Share.share(
                          "👋 Hey friend! You should download naan, it's my favorite Tezos wallet to buy Tez, send transactions, connecting to Dapps and exploring NFT gallery of anyone. ${AppConstant.naanWebsite}");
                    },
                    title: "Share naan",
                  ),
                  0.018.vspace
                ],
              ),
            ),
          ),
        ]);
  }
}
