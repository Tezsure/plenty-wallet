import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker_tile.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class DelegateBakerSuccessSheet extends GetView<DelegateWidgetController> {
  const DelegateBakerSuccessSheet({super.key});

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
              
                Icon(
                  Icons.check_circle_outline,
                  color: ColorConst.Primary,
                  size: 75.sp,
                ),
                0.015.vspace,
                Text(
                  "Delegation successful",
                  style: titleLarge,
                ),
                0.006.vspace,
                Text(
                  "Your delegation request should be \nconfirmed in next 30 seconds",
                  textAlign: TextAlign.center,
                  style: labelMedium.copyWith(color: ColorConst.textGrey1),
                ),
                0.03.vspace,
                SolidButton(
                  borderColor: ColorConst.Primary,
                  active: true,
                  textColor: ColorConst.Primary,
                  primaryColor: Colors.transparent,
                  onPressed: () {},
                  title: "Done",
                ),
                0.018.vspace,
                SolidButton(
                  active: true,
                  onPressed: () {},
                  title: "Share Naan",
                ),
                0.018.vspace
              ],
            ),
          ),
        ]);
  }
}
