import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class TezosDomainWidget extends StatefulWidget {
  TezosDomainWidget({Key? key}) : super(key: key);

  @override
  State<TezosDomainWidget> createState() => _TezosDomainWidgetState();
}

class _TezosDomainWidgetState extends State<TezosDomainWidget> {
  @override
  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        final address = Get.find<HomePageController>().userAccounts.isEmpty
            ? null
            : Get.find<HomePageController>()
                .userAccounts[
                    Get.find<HomePageController>().selectedIndex.value]
                .publicKeyHash;
        NaanAnalytics.logEvent(NaanAnalyticsEvents.TEZOS_DOMAIN,
            param: {NaanAnalytics.address: address});
        CommonFunctions.bottomSheet(
          const DappBrowserView(),
          fullscreen: true,
          settings: const RouteSettings(
            arguments: "https://tezos.domains/",
          ),
        );
      },
      child: HomeWidgetFrame(
        width: AppConstant.homeWidgetDimension,
        child: Container(
          decoration: BoxDecoration(gradient: lightBlue),
          width: AppConstant.homeWidgetDimension,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.arP, vertical: 16.arP),
                    child: _buildIcon()),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.arP),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Register",
                          style: titleLarge.copyWith(fontSize: 20.arP)),
                      Text("a .tez domain",
                          style: bodySmall.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8.arP)),
      padding: EdgeInsets.all(4.arP),
      height: AppConstant.homeWidgetDimension / 6,
      width: AppConstant.homeWidgetDimension / 6,
      child: Image.asset("assets/home_page/tez_domain.png"),
    );
  }
}
