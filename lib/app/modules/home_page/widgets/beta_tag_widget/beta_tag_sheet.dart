import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class BetaTagSheet extends StatelessWidget {
  BetaTagSheet({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> infos = [
      "Your experience may not be perfect and you may encounter issues or unexpected behavior",
      "You will report any issues or feedback you have to help us improve the product.",
      "We may use your feedback and usage data to improve the product and for research and development purposes."
    ];
    return NaanBottomSheet(
      isScrollControlled: true,
      bottomSheetWidgets: [
        SizedBox(
          height: 0.68.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 0.028.vspace,
              _buildIcon(),
              Text(
                "Our App is in Beta",
                style: headlineSmall,
              ),
              0.02.vspace,
              Text(
                  "By using the beta version of our product, you understand and agree that:",
                  style: labelMedium.copyWith(
                      color: ColorConst.textGrey1,
                      fontWeight: FontWeight.normal)),
              0.02.vspace,
              ...List.generate(
                  infos.length,
                  (index) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.arP, horizontal: 14.arP),
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
                                infos[index],
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
              SolidButton(
                active: true,
                width: 1.width - 64.arP,
                onPressed: () {
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
