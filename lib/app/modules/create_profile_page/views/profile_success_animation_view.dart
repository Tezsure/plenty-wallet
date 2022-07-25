import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/views/home_page_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/material_Tap.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class ProfileSuccessAnimationView extends StatelessWidget {
  const ProfileSuccessAnimationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 1.height,
        width: 1.width,
        decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
        child: Stack(
          children: [
            const HomePageView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: NaanBottomSheet(
                gradientStartingOpacity: 1,
                blurRadius: 5,
                title: 'Backup Your Wallet',
                bottomSheetWidgets: [
                  Text(
                    'With no backup. losing your device will result\nin the loss of access forever. The only way to\nguard against losses is to backup your wallet.',
                    textAlign: TextAlign.start,
                    style: bodySmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                  30.h.vspace,
                  SolidButton(
                      textColor: ColorConst.Neutral.shade95,
                      title: "Backup Wallet ( ~1 min )",
                      onPressed: () => Get.toNamed(Routes.BACKUP_WALLET)),
                  12.h.vspace,
                  materialTap(
                    inkwellRadius: 8,
                    onPressed: () => Get.toNamed(Routes.HOME_PAGE),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorConst.Neutral.shade80,
                          width: 1.50,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text("I will risk it",
                          style: titleSmall.apply(
                              color: ColorConst.Primary.shade80)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
