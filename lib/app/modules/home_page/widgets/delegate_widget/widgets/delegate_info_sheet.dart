import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker_tile.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class DelegateInfoSheet extends GetView<DelegateWidgetController> {
  const DelegateInfoSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> infos = [
      'You are earning interest on your Tez through a process called Delegation. It is super safe on Tezos.',
      'Your funds are neither locked nor frozen and do not move anywhere. You can spend them at any time.',
      'Through delegation, you are delegating your staking/baking rights to another person(baker). Baker passes on the rewards he gets, to you as a delegator.'
    ];
    Get.lazyPut(() => DelegateWidgetController());
    return NaanBottomSheet(
        mainAxisAlignment: MainAxisAlignment.end,
        bottomSheetHorizontalPadding: 16.sp,
        height: 0.64.height,
        blurRadius: 5,
        width: double.infinity,
        bottomSheetWidgets: [
          SafeArea(
            child: SizedBox(
              height: 0.57.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  0.015.vspace,
                  SvgPicture.asset(
                    "${PathConst.HOME_PAGE.SVG}tezos_price.svg",
                    width: 0.2.width,
                  ),
                  0.02.vspace,
                  Text(
                    "Earn 5% APR on your tez",
                    style: titleLarge,
                  ),

                  0.03.vspace,
                  ...List.generate(
                      infos.length,
                      (index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.sp),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 10.sp,
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
                  Spacer(),
                  // 0.075.vspace,
                  SolidButton(
                    active: true,
                    onPressed: () {
                      // if (Get.isBottomSheetOpen ?? false) {
                      Get.back();
                      // }
                      Get.bottomSheet(
                          DelegateSelectBaker(
                            isScrollable: true,
                          ),
                          enableDrag: true,
                          isScrollControlled: true);
                    },
                    title: "Delegate",
                  ),
                  0.018.vspace
                ],
              ),
            ),
          ),
        ]);
  }
}
