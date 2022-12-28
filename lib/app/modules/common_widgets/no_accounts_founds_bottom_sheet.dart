import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class NoAccountsFoundBottomSheet extends StatelessWidget {
  const NoAccountsFoundBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.arP),
            topRight: Radius.circular(10.arP),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 5.arP,
                width: 36.arP,
                margin: EdgeInsets.only(
                  top: 5.arP,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xffEBEBF5).withOpacity(0.3),
                ),
              ),
            ),
            SizedBox(
              height: 40.arP,
            ),
            SizedBox(
              height: 0.6.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "${PathConst.EMPTY_STATES}no_accounts.svg",
                            height: 175.arP,
                            width: 175.arP,
                          ),
                          0.05.vspace,
                          Text(
                            "No accounts found",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 22.arP,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 12.arP,
                          ),
                          Text(
                            "Create or import new account to create\nnew gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF958E99),
                              decoration: TextDecoration.none,
                              fontSize: 12.arP,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.4.arP,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.arP,
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
            0.0125.vspace,
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
            SizedBox(
              height: 40.arP,
            ),
          ],
        ),
      ),
    );
  }
}
