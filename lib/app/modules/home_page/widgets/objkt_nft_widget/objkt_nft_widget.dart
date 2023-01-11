import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/choose_payment_method.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../account_switch_widget/account_switch_widget.dart';

class ObjktNftWidget extends StatelessWidget {
  const ObjktNftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String url = "https://objkt.com";
        // Get.to(BuyNFTPage(), arguments: url);
        Get.bottomSheet(
          const DappBrowserView(),
          barrierColor: Colors.white.withOpacity(0.09),
          settings: RouteSettings(
            arguments: url,
          ),
          isScrollControlled: true,
        );
      },
      child: Container(
        height: 0.405.width,
        width: 0.405.width,
        margin: EdgeInsets.only(left: 24.arP),
        decoration: BoxDecoration(
          gradient: purpleGradient,
          borderRadius: BorderRadius.circular(22.arP),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 64.arP),
                child: Image.asset(
                  "${PathConst.HOME_PAGE}buy_nft.png",
                  cacheHeight: 217,
                  cacheWidth: 158,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.arP, vertical: 22.arP),
                child: Text("objkt.com",
                    style: bodySmall.copyWith(
                        fontWeight: FontWeight.w900, letterSpacing: 0.6.arP)),
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
                    Text("Buy NFT",
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
