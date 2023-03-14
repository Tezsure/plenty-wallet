import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/app/modules/nft_gallery/controller/nft_gallery_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../data/services/service_config/service_config.dart';

class ResetWalletBottomSheet extends StatelessWidget {
  const ResetWalletBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingController = Get.find<SettingsPageController>();
    bool isWalletBackup = settingController.isWalletBackup.value;
    return NaanBottomSheet(
      // blurRadius: 5.arP,
      height: isWalletBackup ? 325.arP : 400.arP,
      title: "Reset naan",
      bottomSheetWidgets: [
        // const Spacer(),
        Center(
          child: Text(
            'You can lose your funds forever if you\ndidn’t make a backup. Are you sure you\nwant to reset naan?'
                .tr,
            style: bodySmall.copyWith(color: ColorConst.textGrey1),
            textAlign: TextAlign.center,
          ),
        ),
        // const Spacer(),
        0.02.vspace,
        Column(
          children: [
            optionMethod(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Platform.isAndroid
                        ? SvgPicture.asset(
                            "${PathConst.SVG}fingerprint.svg",
                            color: ColorConst.Error.shade60,
                            width: 24.arP,
                          )
                        : SvgPicture.asset(
                            "${PathConst.SVG}faceid.svg",
                            color: ColorConst.Error.shade60,
                            width: 24.arP,
                          ),
                    0.02.hspace,
                    Text(
                      "Hold to reset naan".tr,
                      style: labelMedium.apply(color: ColorConst.Error.shade60),
                    ),
                  ],
                ),
                onLongPress: () async {
                  if (Get.find<HomePageController>().userAccounts.isEmpty) {
                    await ServiceConfig().clearStorage();
                    NaanAnalytics.logEvent(NaanAnalyticsEvents.RESET_NAAN);
                    Get.offAllNamed(Routes.ONBOARDING_PAGE);
                  } else {
                    final isVerified =
                        await AuthService().verifyBiometricOrPassCode();
                    if (isVerified) {
                      await ServiceConfig().clearStorage();
                      NaanAnalytics.logEvent(NaanAnalyticsEvents.RESET_NAAN);
                      Get.offAllNamed(Routes.ONBOARDING_PAGE);
                    }
                  }
                  try {
                    Get.find<HomePageController>().dispose();
                  } catch (_) {}
                  try {
                    Get.find<NftGalleryWidgetController>().fetchNftGallerys();
                  } catch (_) {}
                }),
            if (!isWalletBackup)
              Column(
                children: [
                  0.016.vspace,
                  optionMethod(
                      child: Text(
                        "Backup Account".tr,
                        style: labelMedium,
                      ),
                      onTap: () {
                        settingController.checkWalletBackup(Get.context!, null);
                      }),
                ],
              ),
            0.02.vspace,
            optionMethod(
                child: Text(
                  "Cancel".tr,
                  style: labelMedium,
                ),
                onTap: () {
                  Get.back();
                }),
            BottomButtonPadding()
          ],
        ),
      ],
    );
  }

  Widget optionMethod({
    Widget? child,
    GestureTapCallback? onTap,
    GestureTapCallback? onLongPress,
  }) {
    return Center(
      child: SolidButton(
        width: 1.width - 64.arP,
        primaryColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        onLongPressed: onLongPress,
        onPressed: onTap,
        child: child,
      ),
    );
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        width: double.infinity,
        height: 50,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
