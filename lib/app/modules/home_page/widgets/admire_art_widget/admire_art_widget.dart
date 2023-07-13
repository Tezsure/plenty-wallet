import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

import '../../../dapp_browser/views/dapp_browser_view.dart';

class AdmireArt extends StatelessWidget {
  const AdmireArt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        CommonFunctions.bottomSheet(
          const DappBrowserView(),
          fullscreen: true,
          settings: RouteSettings(
            arguments: ServiceConfig.admireArtUrl,
          ),
        );
      },
      child: HomeWidgetFrame(
        width: 1.width,
        child: Container(
          decoration: BoxDecoration(
            gradient: appleBlack,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22.arP),
                child: NFTImage(
                  nftTokenModel: AppConstant.admireArtCollection!,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(12.arP),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.arP),
                    child: Image.asset(
                      "${PathConst.HOME_PAGE}admire_art.png",
                      width: 30.arP,
                      height: 30.arP,
                      // cacheHeight: 335,
                      // cacheWidth: 709,
                    ),
                  ),
                ),
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
              Padding(
                padding: EdgeInsets.all(16.arP),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "${PathConst.HOME_PAGE}admire_art_bottom.png",
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
