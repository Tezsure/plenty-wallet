import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
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
      child: Container(
        height: 0.405.width,
        width: 0.405.width,
        margin: EdgeInsets.only(left: 24.sp),
        decoration: BoxDecoration(
          gradient: appleYellow,
          borderRadius: BorderRadius.circular(22.sp),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset("${PathConst.HOME_PAGE.SVG}buy_tez.svg"),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Buy Tez",
                        style: headlineSmall.copyWith(fontSize: 20.sp)),
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
