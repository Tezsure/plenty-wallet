import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/no_accounts_founds_bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/account_switch_widget/account_switch_widget.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/iaf/controller/iaf_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/iaf/view/iaf_sheet.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

class IAFWidget extends StatelessWidget {
  const IAFWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        Get.put(AccountSummaryController());
        HomePageController home = Get.find<HomePageController>();
        if (home.userAccounts
            .where((element) => !element.isWatchOnly)
            .toList()
            .isEmpty) {
          CommonFunctions.bottomSheet(
            NoAccountsFoundBottomSheet(),
          );
          return;
        } else {
          CommonFunctions.bottomSheet(
            AccountSwitch(
              title: "Claim NFT",
              subtitle: 'Choose an account to claim your free \nNFT and tez ',
              onNext: ({senderAddress = ""}) {
                if (Get.isRegistered<IAFController>()) {
                  Get.find<IAFController>()
                      .setUp(home.userAccounts[home.selectedIndex.value]);
                }
                Get.put(
                    IAFController(home.userAccounts[home.selectedIndex.value]));
                // String url =
                //     "https://wert.naan.app?address=${home.userAccounts[home.selectedIndex.value].publicKeyHash}";
                CommonFunctions.bottomSheet(IAFSheet(), fullscreen: true);
              },
            ),
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
                  // cacheHeight: 335,
                  // cacheWidth: 709,
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
