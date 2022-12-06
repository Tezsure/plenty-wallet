import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class SelectNetworkBottomSheet extends StatelessWidget {
  SelectNetworkBottomSheet({Key? key}) : super(key: key);

  final SettingsPageController controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "Select Network",
      blurRadius: 5,
      height: 360.arP,
      bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        Obx(
          () => Column(
            children: [
              SizedBox(
                height: 30.aR,
              ),
              optionMethod(
                value: NetworkType.mainnet,
                title: "Main net",
              ),
              const Divider(
                color: Colors.black,
                height: 1,
                thickness: 1,
              ),
              optionMethod(
                value: NetworkType.testnet,
                title: "Test net",
              ),
              SizedBox(
                height: 30.aR,
              ),
              SolidButton(
                onPressed: Get.back,
                title: "Apply",
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget optionMethod({
    required String title,
    GestureTapCallback? onTap,
    required NetworkType value,
  }) {
    return InkWell(
      onTap: onTap ??
          () {
            controller.changeNetwork(value);
          },
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: Row(
          children: [
            Text(
              title,
              style: labelMedium,
            ),
            const Spacer(),
            if (controller.networkType.value.index == value.index)
              SvgPicture.asset(
                "${PathConst.SVG}check2.svg",
                color: ColorConst.Primary,
                height: 16.6.sp,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ),
    );
  }
}
