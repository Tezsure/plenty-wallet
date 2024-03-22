import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class DelegateInfoSheet extends GetView<DelegateWidgetController> {
  const DelegateInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> infos = [
      'Participate in Tezos staking without the hassle of setting up a node by delegating your staking rights to a trusted baker.',
      'Delegation allows you to share in the rewards of staking while a trusted baker handles the work. A small service fee is taken by the baker.',
      'In Tezos, delegation is safe and secure. Your funds are not locked or frozen and you can use them at any time.'
    ];
    // Get.lazyPut(() => DelegateWidgetController());
    return NaanBottomSheet(
        bottomSheetHorizontalPadding: 16.arP,
        height: 0.61.height,
        bottomSheetWidgets: [
          SizedBox(
            height: 0.55.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                0.015.vspace,
                Image.asset(
                  "${PathConst.HOME_PAGE}tezos.png",
                  width: 0.2.width,
                ),
                0.02.vspace,
                Text(
                  "Earn 5% APR on your tez".tr,
                  style: titleLarge,
                ),
                0.03.vspace,
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
                SolidButton(
                  active: true,
                  width: 1.width - 64.arP,
                  onPressed: () {
                    Get.back(result: true);
                  },
                  title: "Continue",
                ),
                BottomButtonPadding()
              ],
            ),
          ),
        ]);
  }
}
