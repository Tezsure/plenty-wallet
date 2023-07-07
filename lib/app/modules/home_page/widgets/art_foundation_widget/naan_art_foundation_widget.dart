import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../../utils/constants/path_const.dart';

class NaanArtFoundationWidget extends StatelessWidget {
  const NaanArtFoundationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        final address = Get.find<HomePageController>().userAccounts.isEmpty
            ? null
            : Get.find<HomePageController>().userAccounts.first.publicKeyHash;
        NaanAnalytics.logEvent(NaanAnalyticsEvents.NAAN_COLLECTION,
            param: {NaanAnalytics.address: address});
        String url = "https://objkt.com/profile/naancollection/owned?page=1";
        // Get.to(BuyNFTPage(), arguments: url);
        CommonFunctions.bottomSheet(
          const DappBrowserView(),
          fullscreen: true,
          settings: RouteSettings(
            arguments: url,
          ),
        );
      },
      child: HomeWidgetFrame(
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22.arP),
                child: NFTImage(
                  nftTokenModel: AppConstant.naanCollection!,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.arP, vertical: 16.arP),
                    child: _buildIcon()),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: AppConstant.homeWidgetDimension / 2,
                  width: double.infinity,
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                      // ignore: prefer_const_constructors
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // ignore: prefer_const_literals_to_create_immutables
                          colors: [
                        Colors.transparent,
                        Colors.grey[900]!.withOpacity(0.3),
                        Colors.grey[900]!.withOpacity(0.6),
                        Colors.grey[900]!.withOpacity(0.99),
                      ])),
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
                      Text("Plenty Wallet Official".tr, style: labelMedium),
                      Text("Art Collection".tr, style: labelMedium),
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
      child: SvgPicture.asset("${PathConst.SVG}plenty_wallet.svg"),
    );
  }
}
