import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../dapp_browser/views/dapp_browser_view.dart';

class TezQuake extends StatelessWidget {
  const TezQuake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        Get.bottomSheet(
          const DappBrowserView(),
          barrierColor: Colors.white.withOpacity(0.09),
          settings: const RouteSettings(
            arguments: "https://linktr.ee/tezquakeaid",
          ),
          isScrollControlled: true,
        );
      },
      child: HomeWidgetFrame(
        width: 1.width,
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
                  "${PathConst.HOME_PAGE}tez_quake_bg.png",
                  fit: BoxFit.cover,
                  // cacheHeight: 335,
                  // cacheWidth: 709,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.arP),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "${PathConst.HOME_PAGE}tez_quake_bottom.png",
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
