import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/no_accounts_founds_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';

import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../controllers/home_page_controller.dart';
import '../accounts_widget/views/widget/add_account_widget.dart';

class EarnTezWidget extends StatelessWidget {
  const EarnTezWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        HomePageController home = Get.find<HomePageController>();
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
        }
        NaanAnalytics.logEvent(NaanAnalyticsEvents.DELEGATE_WIDGET_CLICK);
        Get.put(DelegateWidgetController()).openBakerList();
      },
      child: Container(
        height: AppConstant.homeWidgetDimension,
        width: AppConstant.homeWidgetDimension,
        decoration: BoxDecoration(
          gradient: blueGradient,
          borderRadius: BorderRadius.circular(22.arP),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                "${PathConst.HOME_PAGE}earn_tez.png",
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
                    Text("Earn 5%",
                        style: headlineSmall.copyWith(fontSize: 20.arP)),
                    Text(
                      "on your tez",
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
