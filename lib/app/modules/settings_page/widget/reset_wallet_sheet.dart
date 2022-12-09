import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/web3auth_services/web3auth.dart';
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
      height: 275.sp,
      title: "Disconnect app",
      bottomSheetWidgets: [
        Center(
          child: Text(
            'You can reconnect to this app later',
            style: labelMedium.copyWith(color: ColorConst.textGrey1),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        0.016.vspace,
        Column(
          children: [
            optionMethod(
                child: Text(
                  "Disconnect",
                  style: labelMedium.apply(color: ColorConst.Error.shade60),
                ),
                onTap: () async {
                  await ServiceConfig().clearStorage();

                  Get.offAllNamed(Routes.ONBOARDING_PAGE);
                }),
            0.016.vspace,
            optionMethod(
                child: Text(
                  "Cancel",
                  style: labelMedium,
                ),
                onTap: () {
                  Get.back();
                }),
            0.016.vspace,
            const SafeArea(child: SizedBox.shrink())
          ],
        ),
      ],
    );
  }

  InkWell optionMethod({Widget? child, GestureTapCallback? onTap}) {
    return InkWell(
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
