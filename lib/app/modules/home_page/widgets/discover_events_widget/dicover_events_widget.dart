import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../dapp_browser/views/dapp_browser_view.dart';
import '../../../events/views/events_view.dart';

class DiscoverEvents extends StatelessWidget {
  const DiscoverEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        CommonFunctions.bottomSheet(
          const EventsView(),
        );
      },
      child: HomeWidgetFrame(
        width: 1.width,
        child: Container(
          decoration: BoxDecoration(
            gradient: pinkGradient,
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Padding(
                padding: EdgeInsets.all(16.arP),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    "${PathConst.HOME_PAGE}discover_illustration.png",
                    fit: BoxFit.cover,
                    width: 0.31.width,
                    // cacheHeight: 335,
                    // cacheWidth: 709,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.arP),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "${PathConst.HOME_PAGE}discover_text.png",
                    fit: BoxFit.cover,
                    width: 0.44.width,
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
