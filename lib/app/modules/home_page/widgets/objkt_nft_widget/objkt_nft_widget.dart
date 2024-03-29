import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class ObjktNftWidget extends StatelessWidget {
  const ObjktNftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        String url = "https://objkt.com";
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
          decoration: BoxDecoration(color: Colors.white
              // gradient: purpleGradient,
              // borderRadius: BorderRadius.circular(22.arP),
              ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 24.arP),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.arP),
                    child: Image.asset(
                      "${PathConst.HOME_PAGE}buy_nft.png",
                      // cacheHeight: 217,
                      // cacheWidth: 158,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.arP, vertical: 22.arP),
                  child: Text("objkt.com",
                      style: bodySmall.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6.arP)),
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
                      Text("Buy NFTs".tr,
                          style: headlineSmall.copyWith(
                              color: Colors.black, fontSize: 20.arP)),
                      Text("using your card".tr,
                          style: bodySmall.copyWith(
                            color: Colors.black,
                          )),
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
}
