import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/custom_gallery/controller/custom_gallery_controller.dart';
import 'package:plenty_wallet/app/modules/custom_gallery/widgets/custom_nft_detail_sheet.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/register_widgets.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/teztown/controllers/teztown_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/teztown/widgets/details/teztown_details_sheet.dart';
import 'package:plenty_wallet/app/modules/custom_gallery/custom_nft_gallery_view.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import '../../../dapp_browser/views/dapp_browser_view.dart';

class TeztownWidget extends StatefulWidget {
  TeztownWidget({Key? key}) : super(key: key);

  @override
  State<TeztownWidget> createState() => _TeztownWidgetState();
}

class _TeztownWidgetState extends State<TeztownWidget> {
  List<String> titles = ["Rules", "Gallery", "Buy Ticket", "Burn Ticket"];

  List<String> icons = [
    "${PathConst.HOME_PAGE}teztown/details.svg",
    "${PathConst.HOME_PAGE}vca/gallery.svg",
    "${PathConst.HOME_PAGE}teztown/buy.svg",
    "${PathConst.HOME_PAGE}teztown/burn.svg"
  ];

  late TeztownController controller;
  @override
  Widget build(BuildContext context) {
    if (!ServiceConfig.isTeztownWidgetVisible) return Container();
    controller = Get.put(TeztownController(), permanent: true);
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
                    "${PathConst.HOME_PAGE}teztown/background.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                          "${PathConst.HOME_PAGE}teztown/name.png",
                          fit: BoxFit.cover,
                          height: AppConstant.homeWidgetDimension - 28.arP),
                    ),
                    Image.asset(
                      "${PathConst.HOME_PAGE}teztown/by_teztown.png",
                      height: 28.arP,
                      width: 56.arP,
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
                icons[index],
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

  void _onTap(int index) async {
    final homeController = Get.find<HomePageController>();
    final address = homeController.userAccounts.isEmpty
        ? null
        : homeController
            .userAccounts[homeController.selectedIndex.value].publicKeyHash;
    // await CommonFunctions.toggleLoaderOverlay(() async => controller.onInit());
    switch (index) {
      case 0:
        NaanAnalytics.logEvent(NaanAnalyticsEvents.TEZTOWN_DETAILS,
            param: {NaanAnalytics.address: address});
        CommonFunctions.bottomSheet(
          const TeztownDetailSheet(),
          fullscreen: true,
        );
        break;
      case 1:
        NaanAnalytics.logEvent(NaanAnalyticsEvents.TEZTOWN_GALLERY,
            param: {NaanAnalytics.address: address});
        CommonFunctions.bottomSheet(
          const CustomNFTGalleryView(
            nftGalleryType: NFTGalleryType.fromGalleryAddress,
            title: "Spring Fever",
          ),
          fullscreen: true,
        );
        break;
      case 2:
        NaanAnalytics.logEvent(NaanAnalyticsEvents.TEZTOWN_BUY_TICKET,
            param: {NaanAnalytics.address: address});
        CommonFunctions.bottomSheet(
            CustomNFTDetailBottomSheet(
              nftUrl: controller.teztownData.value.ticket,
              saveAddress: true,
            ),
            fullscreen: true);

        break;
      case 3:
        NaanAnalytics.logEvent(NaanAnalyticsEvents.TEZTOWN_BURN_TICKET,
            param: {NaanAnalytics.address: address});
        CommonFunctions.bottomSheet(
          const DappBrowserView(),
          fullscreen: true,
          settings: RouteSettings(
            arguments: controller.teztownData.value.burnWebsite ?? "",
          ),
        );

        break;
      default:
    }
  }
}
