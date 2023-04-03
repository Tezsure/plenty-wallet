import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/custom_gallery/controller/custom_gallery_controller.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/register_widgets.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/vca/vca_redeem_nft/controller/vca_redeem_nft_controller.dart';
import 'package:naan_wallet/app/modules/custom_gallery/custom_nft_gallery_view.dart';
import 'package:naan_wallet/app/modules/vca_events/views/events_view.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../dapp_browser/views/dapp_browser_view.dart';
import 'vca_redeem_nft/widget/info_sheet.dart';

class VCAWidget extends StatelessWidget {
  VCAWidget({Key? key}) : super(key: key);
  List<String> titles = ["Website", "POAP NFT", "Guide", "Gallery"];
  List<String> icons = ["globe.svg", "gift.svg", "map.svg", "gallery.svg"];
  @override
  Widget build(BuildContext context) {
    if (!ServiceConfig.isVCAWidgetVisible) return Container();
    return Column(
      children: [
        HomeWidgetFrame(
          width: 1.width,
          height: .87.width,
          child: Container(
            decoration: BoxDecoration(
              gradient: blueGradientLight,
            ),
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22.arP),
                  child: Image.asset(
                    "${PathConst.HOME_PAGE}vca/background.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(32.arP),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset("${PathConst.HOME_PAGE}vca/name.png",
                            fit: BoxFit.cover, width: 1.width),
                      ),
                    ),
                    const Spacer(),
                    GridView.builder(
                      padding: EdgeInsets.all(12.arP),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 12.arP,
                          crossAxisSpacing: 12.arP,
                          childAspectRatio: 2.6,
                          crossAxisCount: 2),
                      itemBuilder: (context, index) => _buildChip(index),
                      itemCount: titles.length,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        homeWidgetsGap
      ],
    );
  }

  Widget _buildChip(int index) {
    return BouncingWidget(
      onPressed: () => _onTap(index),
      child: Container(
        padding: EdgeInsets.all(16.arP),
        decoration: BoxDecoration(
            color: ColorConst.darkGrey,
            borderRadius: BorderRadius.circular(16.arP)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.arP),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConst.NeutralVariant.shade20),
              child: SvgPicture.asset(
                "${PathConst.HOME_PAGE}vca/${icons[index]}",
                height: 22.arP,
                width: 22.arP,
              ),
            ),
            SizedBox(
              width: 8.arP,
            ),
            Text(
              titles[index],
              style: labelLarge,
            )
          ],
        ),
      ),
    );
  }

  void _onTap(int index) {
    final homeController = Get.find<HomePageController>();
    final address = homeController.userAccounts.isEmpty
        ? null
        : homeController
            .userAccounts[homeController.selectedIndex.value].publicKeyHash;
    switch (index) {
      case 0:
        NaanAnalytics.logEvent(NaanAnalyticsEvents.VCA_WEBSITE,
            param: {NaanAnalytics.address: address});
        CommonFunctions.bottomSheet(
          const DappBrowserView(),
          fullscreen: true,
          settings: const RouteSettings(
            arguments: "https://proofofpeople.verticalcrypto.art/newyork.html",
          ),
        );
        break;
      case 1:
        NaanAnalytics.logEvent(NaanAnalyticsEvents.VCA_CLAIM_NFT_CLICK,
            param: {NaanAnalytics.address: address});
        CommonFunctions.bottomSheet(VCAPOAPInfoSheet());
        break;
      case 2:
        NaanAnalytics.logEvent(NaanAnalyticsEvents.VCA_EVENTS_CLICK,
            param: {NaanAnalytics.address: address});

        CommonFunctions.bottomSheet(
          const VCAEventsView(),
          fullscreen: true,
        );
        break;
      case 3:
        NaanAnalytics.logEvent(NaanAnalyticsEvents.VCA_GALLERY_CLICK,
            param: {NaanAnalytics.address: address});

        CommonFunctions.bottomSheet(
          const CustomNFTGalleryView(
            title: "Proof of People x Refraction",
            nftGalleryType: NFTGalleryType.fromPKs,
            nftGalleryFilter: NftGalleryFilter.list,
          ),
          fullscreen: true,
        );
        break;
      default:
    }
  }
}
