import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/no_accounts_founds_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/dapps_page/views/dapps_page_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_switch_widget/account_switch_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/iaf/controller/iaf_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/iaf/view/iaf_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class IAFWidget extends StatelessWidget {
  const IAFWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.put(AccountSummaryController());
        HomePageController home = Get.find<HomePageController>();
        if (home.userAccounts
            .where((element) => !element.isWatchOnly)
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
              title: "Claim drop",
              subtitle: 'Choose an account to claim your free NFT and tez ',
              onNext: () {
                if (Get.isRegistered<IAFController>()) {
                  Get.find<IAFController>()
                      .setUp(home.userAccounts[home.selectedIndex.value]);
                }
                Get.put(
                    IAFController(home.userAccounts[home.selectedIndex.value]));
                // String url =
                //     "https://wert.naan.app?address=${home.userAccounts[home.selectedIndex.value].publicKeyHash}";
                Get.bottomSheet(
                  IAFSheet(),
                  barrierColor: Colors.white.withOpacity(0.09),
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
      child: HomeWidgetFrame(
        width: 1.width,
        child: Container(
          decoration: BoxDecoration(
            gradient: appleRed,
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22.arP),
                child: Image.asset(
                  "${PathConst.HOME_PAGE}iaf.png",
                  fit: BoxFit.cover,
                  cacheHeight: 335,
                  cacheWidth: 709,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.arP),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "${PathConst.HOME_PAGE}iaf-watermark.png",
                    fit: BoxFit.cover,
                    width: 0.5.width,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
