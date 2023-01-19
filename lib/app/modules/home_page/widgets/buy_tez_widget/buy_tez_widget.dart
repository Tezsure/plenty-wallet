import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/no_accounts_founds_bottom_sheet.dart';

import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_switch_widget/account_switch_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_account_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../dapp_browser/views/dapp_browser_view.dart';

class BuyTezWidget extends StatelessWidget {
  const BuyTezWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.put(AccountSummaryController());
        HomePageController home = Get.find<HomePageController>();
/*         Get.bottomSheet(
          AccountSelectorSheet(
            onNext: () {
              HomePageController home = Get.find<HomePageController>();

              String url =
                  "https://wert.naan.app?address=${home.userAccounts[home.selectedIndex.value].publicKeyHash}";

              print(url);
              Get.bottomSheet(
                const DappBrowserView(),
                barrierColor: Colors.white.withOpacity(0.09),
                settings: RouteSettings(
                  arguments: url,
                ),
                isScrollControlled: true,
              );
            },
          ),
          isScrollControlled: true,
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
        ); */
        if (home.userAccounts
            .where((element) => element.isWatchOnly == false)
            .toList()
            .isEmpty) {
          Get.bottomSheet(
            const NoAccountsFoundBottomSheet(),
            isScrollControlled: true,
            enterBottomSheetDuration: const Duration(milliseconds: 180),
            exitBottomSheetDuration: const Duration(milliseconds: 150),
          );
          return;
        } else {
          Get.bottomSheet(
            AccountSwitch(
              title: "Buy tez",
              subtitle:
                  'This module will be powered by wert.io and you will be using wert’s interface.',
              onNext: () {
                String url =
                    "https://wert.naan.app?address=${home.userAccounts[home.selectedIndex.value].publicKeyHash}";
                Get.bottomSheet(
                  const DappBrowserView(),
                  barrierColor: Colors.white.withOpacity(0.09),
                  settings: RouteSettings(
                    arguments: url,
                  ),
                  isScrollControlled: true,
                );
              },
            ),
            isScrollControlled: true,
            enterBottomSheetDuration: const Duration(milliseconds: 180),
            exitBottomSheetDuration: const Duration(milliseconds: 150),
          );
        }
      },
      child: Container(
        height: AppConstant.homeWidgetDimension,
        width: AppConstant.homeWidgetDimension,
        // margin: EdgeInsets.only(left: 24.arP),
        decoration: BoxDecoration(
          gradient: appleYellow,
          borderRadius: BorderRadius.circular(22.arP),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                "${PathConst.HOME_PAGE}buy_tez.png",
                cacheHeight: 335,
                cacheWidth: 335,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(16.arP),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Buy tez",
                        style: headlineSmall.copyWith(fontSize: 20.arP)),
                    Text(
                      "with credit card",
                      style: bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
