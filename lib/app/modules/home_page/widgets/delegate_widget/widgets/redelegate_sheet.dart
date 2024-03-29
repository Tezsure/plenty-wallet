import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_rewards_tile.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker_tile.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/utils.dart';

import '../../../controllers/home_page_controller.dart';

class ReDelegateBottomSheet extends GetView<DelegateWidgetController> {
  final DelegateBakerModel baker;

  ReDelegateBottomSheet({
    super.key,
    required this.baker,
  }) {
    Get.lazyPut(() => DelegateWidgetController());
    controller.getDelegateRewardList();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return NaanBottomSheet(
        prevPageName: controller.prevPage,
        height: AppConstant.naanBottomSheetHeight,
        title: "",
        leading: controller.prevPage == null
            ? null
            : backButton(
                ontap: () => Navigator.pop(context),
                lastPageName: controller.prevPage),
        // isScrollControlled: true,
        // bottomSheetHorizontalPadding: 16.arP,
        // decoration: const BoxDecoration(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        //   gradient: GradConst.GradientBackground,
        // ),
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    bottom: 24.arP,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total Rewards".tr,
                        style:
                            labelMedium.copyWith(color: ColorConst.textGrey1),
                      ),
                      Text(
                        controller.totalRewards.value.roundUpDollar(
                            Get.find<HomePageController>().xtzPrice.value),
                        style: headlineLarge,
                      ),
                    ],
                  ),
                ),
                Text("Delegated to".tr, style: labelLarge),
                0.015.vspace,
                DelegateBakerTile(
                  baker: baker,
                  redelegate: true,
                ),
                0.015.vspace,
                Text("Rewards".tr, style: labelLarge),
                .01.vspace,
                Expanded(
                  child: controller.delegateRewardList.isEmpty
                      ? Center(
                          child: Text(
                            "Delegation is pending . . .".tr,
                            style: titleMedium.copyWith(
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
