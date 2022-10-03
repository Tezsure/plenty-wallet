import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class SelectNetworkBottomSheet extends StatelessWidget {
  SelectNetworkBottomSheet({Key? key}) : super(key: key);

  final SettingsPageController controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: 5,
      height: 217,
      bottomSheetWidgets: [
        Center(
          child: Text(
            'Select Network',
            style: labelMedium,
            textAlign: TextAlign.center,
          ),
        ),
        0.03.vspace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          ),
          child: Obx(
            () => Column(
              children: [
                optionMethod(
                  value: NetworkType.mainNet,
                  title: "Main Net",
                ),
                const Divider(
                  color: Color(0xff4a454e),
                  height: 1,
                  thickness: 1,
                ),
                optionMethod(
                  value: NetworkType.testNet,
                  title: "Test Net",
                ),
              ],
            ),
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
      onTap: onTap,
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
            Radio(
                activeColor: Colors.white,
                fillColor: MaterialStateColor.resolveWith((state) =>
                    state.contains(MaterialState.selected)
                        ? ColorConst.Primary
                        : Colors.white),
                value: value,
                groupValue: controller.networkType.value,
                onChanged: (NetworkType? type) {
                  controller.networkType.value = type!;
                })
          ],
        ),
      ),
    );
  }
}
