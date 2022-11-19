import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../common_widgets/solid_button.dart';
import 'redelegate_sheet.dart';

class DelegateTile extends GetView<AccountSummaryController> {
  final bool isDelegated;

  const DelegateTile({
    super.key,
    required this.isDelegated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorConst.NeutralVariant.shade60.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 53,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Rewards\n',
                      style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60,
                      ),
                      children: [
                        const WidgetSpan(
                          child: SizedBox(
                            height: 30,
                          ),
                        ),
                        TextSpan(
                          text: isDelegated ? '10 ' : '0.00 ',
                          style: headlineSmall.copyWith(
                            color: isDelegated
                                ? Colors.white
                                : ColorConst.NeutralVariant.shade60,
                          ),
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.bottom,
                          child: isDelegated
                              ? GestureDetector(
                                  onTap: () => Get.bottomSheet(
                                      const ReDelegateBottomSheet(),
                                      enterBottomSheetDuration:
                                          const Duration(milliseconds: 180),
                                      exitBottomSheetDuration:
                                          const Duration(milliseconds: 150),
                                      isScrollControlled: true,
                                      enableDrag: true),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        "${PathConst.HOME_PAGE.SVG}xtz.svg",
                                        height: 20,
                                        width: 15,
                                      ),
                                      0.01.hspace,
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 12,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                )
                              : SvgPicture.asset(
                                  "${PathConst.HOME_PAGE.SVG}xtz.svg",
                                  height: 20,
                                  width: 15,
                                ),
                        ),
                        TextSpan(
                          text: isDelegated ? '\n\$23' : '\n\$0.00',
                          style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      text: 'Payout\n',
                      style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60,
                      ),
                      children: [
                        const WidgetSpan(
                          child: SizedBox(
                            height: 30,
                          ),
                        ),
                        TextSpan(
                          text: isDelegated ? '15 ' : '0.0 ',
                          style: headlineSmall.copyWith(
                            color: isDelegated
                                ? Colors.white
                                : ColorConst.NeutralVariant.shade60,
                          ),
                        ),
                        TextSpan(text: 'D', style: headlineSmall),
                        TextSpan(
                          text: isDelegated ? '\n1.2 cycles' : '\n\$0.0 cycles',
                          style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Divider(
            height: 20,
            color: ColorConst.Neutral.shade30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 0.032.height,
                width: 0.25.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConst.Neutral.shade30,
                ),
                child: Center(
                  child: Text(
                    isDelegated ? 'Earning 8% APR' : 'Earn 5% APR',
                    textAlign: TextAlign.center,
                    style: labelSmall.copyWith(
                      color: ColorConst.Neutral.shade70,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: isDelegated
                    ? () => Get.bottomSheet(
                        const DelegateSelectBaker(isScrollable: true),
                        enterBottomSheetDuration:
                            const Duration(milliseconds: 180),
                        exitBottomSheetDuration:
                            const Duration(milliseconds: 150),
                        isScrollControlled: true,
                        enableDrag: true)
                    : () => Get.bottomSheet(
                          NaanBottomSheet(
                            height: 0.4.height,
                            bottomSheetWidgets: [
                              Center(
                                child: SvgPicture.asset(
                                  '${PathConst.SVG}delegate_summary.svg',
                                  height: 82,
                                  width: 80,
                                ),
                              ),
                              0.02.vspace,
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Get 5% APR on your Tez\n',
                                  style: headlineSmall,
                                  children: [
                                    WidgetSpan(child: 0.04.vspace),
                                    TextSpan(
                                      text:
                                          'Your funds are neither locked nor frozen and do not move anywhere. You can spend them at\nany time and without any delay',
                                      style: bodySmall.copyWith(
                                          color: ColorConst
                                              .NeutralVariant.shade60),
                                    ),
                                  ],
                                ),
                              ),
                              0.03.vspace,
                              SolidButton(
                                title: 'Delegate',
                                onPressed: () => Get.bottomSheet(
                                        const DelegateSelectBaker(
                                          isScrollable: true,
                                        ),
                                        enterBottomSheetDuration:
                                            const Duration(milliseconds: 180),
                                        exitBottomSheetDuration:
                                            const Duration(milliseconds: 150),
                                        isScrollControlled: true)
                                    .whenComplete(
                                      () => Get.back(),
                                    )
                                    .whenComplete(() => controller
                                            .isAccountDelegated.value =
                                        !controller.isAccountDelegated.value),
                              ),
                            ],
                          ),
                          enterBottomSheetDuration:
                              const Duration(milliseconds: 180),
                          exitBottomSheetDuration:
                              const Duration(milliseconds: 150),
                        ),
                child: Container(
                  height: 0.032.height,
                  width: 0.25.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorConst.Primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isDelegated ? 'Re-delegate' : 'Delegate',
                        style: labelSmall,
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                        size: 10,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
