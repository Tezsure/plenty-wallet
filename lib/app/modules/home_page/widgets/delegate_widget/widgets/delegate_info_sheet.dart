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
    Get.lazyPut(() => DelegateWidgetController());
    return NaanBottomSheet(
        mainAxisAlignment: MainAxisAlignment.end,
        bottomSheetHorizontalPadding: 16.sp,
        height: 0.45.height,
        blurRadius: 5,
        width: double.infinity,
        bottomSheetWidgets: [
          SafeArea(
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
                0.006.vspace,
                Text(
                  "Your funds are neither locked nor frozen and do\n not move anywhere. You can spend them at\n any time and without any delay.",
                  textAlign: TextAlign.center,
                  style: labelMedium.copyWith(color: ColorConst.textGrey1),
                ),
                0.075.vspace,
                SolidButton(
                  active: true,
                  onPressed: () {
                    // if (Get.isBottomSheetOpen ?? false) {
                    Get.back();
                    // }
                    Get.bottomSheet(
                        const DelegateSelectBaker(
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
        ]);
  }
}
