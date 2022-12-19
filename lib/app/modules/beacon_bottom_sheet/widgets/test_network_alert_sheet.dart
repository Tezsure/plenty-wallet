import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/select_network_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';

class TestNetworkBottomSheet extends StatelessWidget {
  const TestNetworkBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final settingController = Get.put(SettingsPageController());
    return Obx(() {
      return NaanBottomSheet(
        height: 0.5.height,
        bottomSheetWidgets: [
          Container(
            height: 0.45.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                0.05.vspace,
                SvgPicture.asset(
                  "${PathConst.SETTINGS_PAGE.SVG}node.svg",
                  width: 45.arP,
                ),
                0.03.vspace,
                Text(
                  "Connection Failed",
                  style: titleSmall.copyWith(color: ColorConst.Error),
                ),
                0.01.vspace,
                Text(
                  "You are connecting from an account on test net.\nThis feature supports  only main net connection. ",
                  style: labelMedium.copyWith(color: ColorConst.textGrey1),
                ),
                0.032.vspace,
                Text(
                  "Select Network",
                  style: labelMedium.copyWith(color: ColorConst.textGrey1),
                ),
                0.008.vspace,
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      SelectNetworkBottomSheet(),
                      enterBottomSheetDuration:
                          const Duration(milliseconds: 180),
                      exitBottomSheetDuration:
                          const Duration(milliseconds: 150),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorConst.textGrey1),
                        color: ColorConst.darkGrey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          settingController
                                  .networkType.value.name.capitalizeFirst ??
                              "",
                          style: labelMedium,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.white,
                          size: 20.aR,
                        )
                      ],
                    ),
                  ),
                ),
                0.05.vspace,
                Row(
                  children: [
                    Expanded(
                      child: SolidButton(
                        onPressed: Get.back,
                        borderColor: ColorConst.Neutral.shade80,
                        textColor: ColorConst.Neutral.shade80,
                        title: "Cancel",
                        primaryColor: Colors.transparent,
                      ),
                    ),
                    0.016.hspace,
                    Expanded(
                      child: SolidButton(
                        onPressed: settingController.networkType.value.index ==
                                NetworkType.mainnet.index
                            ? () {}
                            : null,
                        title: "Proceed",
                      ),
                    ),
                  ],
                ),
                0.01.vspace
              ],
            ),
          )
        ],
      );
    });
  }
}
