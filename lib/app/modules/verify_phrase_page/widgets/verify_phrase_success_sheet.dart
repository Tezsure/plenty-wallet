import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class VerifyPhraseSuccessSheet extends StatelessWidget {
  const VerifyPhraseSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    AppConstant.hapticFeedback();
    NaanAnalytics.logEvent(NaanAnalyticsEvents.BACKUP_SUCCESSFUL);
    return NaanBottomSheet(
        bottomSheetHorizontalPadding: 32.arP,
        height: 0.37.height,
        bottomSheetWidgets: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.035.vspace,
              LottieBuilder.asset(
                '${PathConst.SEND_PAGE}lottie/success_primary.json',
                height: 80.arP,
                width: 80.arP,
                repeat: false,
              ),
              0.0175.vspace,
              Text(
                "Backup successful".tr,
                style: titleLarge,
              ),
              0.006.vspace,
              Text(
                "Hope you have written the secret \nphrase safely".tr,
                textAlign: TextAlign.center,
                style: labelSmall.copyWith(color: ColorConst.textGrey1),
              ),
              0.036.vspace,
              SolidButton(
                active: true,
                onPressed: () {
                  Get.back();
                },
                title: "Done",
              ),
              BottomButtonPadding()
            ],
          ),
        ]);
  }
}
