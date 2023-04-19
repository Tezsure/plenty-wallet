import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/dapps_page/views/dapps_page_view.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class DiscoverAppsWidget extends StatelessWidget {
  const DiscoverAppsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        CommonFunctions.bottomSheet(
          DappsPageView(),
          fullscreen: true,
        );
      },
      child: HomeWidgetFrame(
        width: 1.width,
        child: Container(
          decoration: BoxDecoration(
            gradient: appleOrange,
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22.arP),
                child: Image.asset(
                  "${PathConst.HOME_PAGE}discover_apps.png",
                  fit: BoxFit.cover,
                  // cacheHeight: 335,
                  // cacheWidth: 709,
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
                      Text("Discover".tr,
                          style: headlineSmall.copyWith(fontSize: 20.arP)),
                      Text(
                        "apps on Tezos".tr,
                        style: bodySmall,
                      ),
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
