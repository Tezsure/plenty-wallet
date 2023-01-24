import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/bottom_button_padding.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../../utils/colors/colors.dart';
import '../../../../../../../utils/styles/styles.dart';

class AddAccountWidget extends StatelessWidget {
  final String? warning;
  const AddAccountWidget({super.key, this.warning});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          addAccountSheet(warning),
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
          barrierColor: Colors.transparent,
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 20.arP,
          right: 15.arP,
          top: 20.arP,
          bottom: 20.arP,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: ColorConst.darkGrey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                "assets/nft_page/svg/add_icon.svg",
                height: 38.33.arP,
              ),
            ),
            const Spacer(),
            Text(
              'Add account',
              style: titleLarge,
            ),
            Text(
              'Manage multiple accounts\neasily',
              style: bodySmall.copyWith(color: ColorConst.textGrey1),
            ),
          ],
        ),
      ),
    );
  }
}

InkWell _optionMethod({Widget? child, GestureTapCallback? onTap}) {
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

Widget addAccountSheet(warning) {
  return NaanBottomSheet(
    bottomSheetHorizontalPadding: 0,
    height: 300.arP,
    title: warning ?? 'Add account',
    bottomSheetWidgets: [
      SizedBox(
        height: 8.arP,
      ),
      Center(
        child: Text(
          'Create or import an account',
          style: TextStyle(
              fontSize: 12.arP,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF958E99),
              letterSpacing: 0.4.arP),
          textAlign: TextAlign.center,
        ),
      ),
      Spacer(),
      SizedBox(
        height: 10.arP,
      ),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10.arP,
            ),
            SolidButton(
              width: 1.width - 64.arP,
              title: "Create a new account",
              titleStyle: titleSmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              onPressed: () {
                Get.back();
                Get.bottomSheet(AddNewAccountBottomSheet(),
                        enterBottomSheetDuration:
                            const Duration(milliseconds: 180),
                        exitBottomSheetDuration:
                            const Duration(milliseconds: 150),
                        barrierColor: Colors.transparent,
                        isScrollControlled: true)
                    .whenComplete(() {
                  Get.find<AccountsWidgetController>().resetCreateNewWallet();
                });
              },
            ),
            0.016.vspace,
            GestureDetector(
              onTap: () {
                Get.back();

                Get.toNamed(Routes.IMPORT_WALLET_PAGE);
              },
              child: Container(
                width: 1.width - 64.arP,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorConst.Neutral.shade80,
                    width: 1.50,
                  ),
                ),
                alignment: Alignment.center,
                child: Text("I already have an account",
                    style: titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorConst.Neutral.shade80)),
              ),
            ),
            BottomButtonPadding()
          ],
        ),
      ),
    ],
  );
}
