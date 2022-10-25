import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../data/services/service_config/service_config.dart';

class ResetWalletBottomSheet extends StatelessWidget {
  const ResetWalletBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: 5.sp,
      height: 150.sp,
      bottomSheetWidgets: [
        Center(
          child: Text(
            'You can lose your funds forever if you\ndidn’t make a backup. Are you sure you\nwant to reset?',
            style: labelMedium,
            textAlign: TextAlign.center,
          ),
        ),
        0.03.vspace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          ),
          child: Column(
            children: [
              optionMethod(
                  child: Text(
                    "Reset Wallet",
                    style: labelMedium.apply(color: ColorConst.Error.shade60),
                  ),
                  onTap: () async {
                    await ServiceConfig().clearStorage();
                    Get.offAllNamed(Routes.SPLASH_PAGE);
                  }),
              const Divider(
                color: Color(0xff4a454e),
                height: 1,
                thickness: 1,
              ),
              optionMethod(
                  child: Text(
                    "Cancel",
                    style: labelMedium,
                  ),
                  onTap: () {
                    Get.back();
                  }),
            ],
          ),
        ),
      ],
    );
  }

  InkWell optionMethod({Widget? child, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
