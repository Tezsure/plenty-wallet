import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class BetaTagSheet extends StatefulWidget {
  BetaTagSheet({super.key});

  @override
  State<BetaTagSheet> createState() => _BetaTagSheetState();
}

class _BetaTagSheetState extends State<BetaTagSheet> {
  bool hasAgreed = false;
  @override
  void initState() {
    UserStorageService.getBetaTagAgree().then((value) {
      Platform.isIOS ? hasAgreed = true : hasAgreed = value;
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> infos = [
      "You may encounter issues or unexpected behavior. We appreciate your patience and understanding.",
      "Please report any issues or feedback to help us improve the app. Your feedback is essential!",
      "We may use your feedback and usage data for research and development purposes."
    ];
    return NaanBottomSheet(
      isScrollControlled: true,
      // title: "",
      bottomSheetWidgets: [
        SizedBox(
          height: hasAgreed ? 0.6.height : 0.69.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.01.vspace,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [closeButton()],
              ),
              // 0.028.vspace,
              _buildIcon(),
              Text(
                "Your naan is in Beta".tr,
                style: headlineSmall,
              ),
              0.02.vspace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "Welcome to the naan beta! By using the beta version of our product, you agree that:"
                        .tr,
                    style: labelMedium.copyWith(
                        color: ColorConst.textGrey1,
                        fontWeight: FontWeight.normal)),
              ),
              0.02.vspace,
              ...List.generate(
                  infos.length,
                  (index) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.arP,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 9.arP,
                              backgroundColor: ColorConst.Primary,
                              child: Text(
                                (index + 1).toString(),
                                style: labelSmall,
                              ),
                            ),
                            0.02.hspace,
                            Expanded(
                              child: Text(
                                infos[index].tr,
                                style: labelMedium.copyWith(
                                    color: ColorConst.textGrey1,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      )),
              SizedBox(
                height: 40.arP,
              ),
              if (!hasAgreed)
                SolidButton(
                  active: true,
                  width: 1.width - 64.arP,
                  onPressed: () {
                    final address =
                        Get.find<HomePageController>().userAccounts.isEmpty
                            ? null
                            : Get.find<HomePageController>()
                                .userAccounts[Get.find<HomePageController>()
                                    .selectedIndex
                                    .value]
                                .publicKeyHash;
                    NaanAnalytics.logEvent(NaanAnalyticsEvents.BETA_AGREE,
                        param: {NaanAnalytics.address: address});
                    UserStorageService.betaTagAgree();
                    Get.back();
                  },
                  title: "Agree",
                ),
              BottomButtonPadding()
            ],
          ),
        )
      ],
    );
  }

  Widget _buildIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: AppConstant.homeWidgetDimension,
          width: AppConstant.homeWidgetDimension,
          decoration: BoxDecoration(
              gradient: RadialGradient(
            // stops: [0.1, 0.3],
            colors: [
              Color(0xffff006e),
              Color(0xffff006e).withOpacity(0.36),
              Color(0xffff006e).withOpacity(0.26),
              Color(0xffff006e).withOpacity(0.16),
              Color(0xffff006e).withOpacity(0.06),
              // ColorConst.Primary.shade20,
              // ColorConst.Primary.shade10,
              // ColorConst.Primary.shade10.withOpacity(.5),
              Colors.transparent
            ],
          )),
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(11.arP)),
              padding: EdgeInsets.all(16.arP),
              margin: EdgeInsets.all(16.arP),
              height: AppConstant.homeWidgetDimension / 2.5,
              width: AppConstant.homeWidgetDimension / 2.5,
              child: Image.asset("assets/naan_logo.png"),
            ),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 10.arP, vertical: 3.arP),
              decoration: BoxDecoration(
                  color: ColorConst.Primary,
                  borderRadius: BorderRadius.circular(20.arP)),
              child: Text(
                "BETA",
                style: labelSmall,
              ),
            )
          ],
        ),
      ],
    );
  }
}
