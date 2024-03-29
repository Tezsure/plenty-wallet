import 'package:flutter/material.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

import '../../../events/views/events_view.dart';

class DiscoverEvents extends StatelessWidget {
  const DiscoverEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        NaanAnalytics.logEvent(
          NaanAnalyticsEvents.EVENTS_OPENED,
        );
        CommonFunctions.bottomSheet(const EventsView(), fullscreen: true);
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
