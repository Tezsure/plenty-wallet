import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_rewards_tile.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker_tile.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'redelegate_tile.dart';

class ReDelegateBottomSheet extends GetView<DelegateWidgetController> {
  final DelegateBakerModel baker;
  ReDelegateBottomSheet({super.key, required this.baker}) {
    Get.lazyPut(() => DelegateWidgetController());
    controller.toggleLoaderOverlay(() => controller.getDelegateRewardList());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return NaanBottomSheet(
        height: 0.9.height,
        bottomSheetHorizontalPadding: 16.sp,
        // decoration: const BoxDecoration(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        //   gradient: GradConst.GradientBackground,
        // ),
        bottomSheetWidgets: [
          SizedBox(
            height: 0.87.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 24.sp),
                  child: Column(
                    children: [
                      Text(
                        "Total Rewards",
                        style:
                            labelMedium.copyWith(color: ColorConst.textGrey1),
                      ),
                      Text(
                        "\$${controller.totalRewards.toStringAsFixed(4)}",
                        style: headlineLarge,
                      ),
                    ],
                  ),
                ),
                Text("Delegated to", style: labelLarge),
                0.015.vspace,
                DelegateBakerTile(
                  baker: baker,
                  redelegate: true,
                ),
                0.015.vspace,
                Text("Rewards", style: labelLarge),
                .01.vspace,
                Expanded(
                  child: controller.delegateRewardList.isEmpty
                      ? Center(
                          child: Text(
                            "Delegation is pending . . .",
                            style: bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ColorConst.textGrey1),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.delegateRewardList.length,
                          itemBuilder: (_, index) => DelegateRewardsTile(
                              reward: controller.delegateRewardList[index]),
                        ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
