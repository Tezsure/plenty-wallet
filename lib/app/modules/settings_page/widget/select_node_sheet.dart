import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/models/node_model.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/add_RPC_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class SelectNodeBottomSheet extends StatelessWidget {
  SelectNodeBottomSheet({Key? key}) : super(key: key);

  final SettingsPageController controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: 5,
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
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: controller.nodes.length,
            itemBuilder: (context, index) =>
                optionMethod(value: controller.nodes[index]),
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xff4a454e),
              height: 1,
              thickness: 1,
            ),
          ),
        ),
        0.015.vspace,
        GestureDetector(
          onTap: () {
            Get.bottomSheet(AddRPCbottomSheet());
          },
          child: Container(
            height: 52,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                0.025.hspace,
                Text(
                  "Add custom RPC",
                  style: labelMedium,
                )
              ],
            ),
          ),
        ),
        0.055.vspace,
      ],
    );
  }

  Widget optionMethod({
    GestureTapCallback? onTap,
    required NodeModel value,
  }) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 57,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.title,
                    style: labelMedium,
                  ),
                  Spacer(),
                  Text(
                    value.address,
                    style: labelSmall.apply(
                        color: ColorConst.NeutralVariant.shade60),
                  )
                ],
              ),
              const Spacer(),
              Obx(
                () => Radio(
                    activeColor: Colors.white,
                    fillColor: MaterialStateColor.resolveWith((state) =>
                        state.contains(MaterialState.selected)
                            ? ColorConst.Primary
                            : Colors.white),
                    value: value,
                    groupValue: controller.selectedNode.value,
                    onChanged: (NodeModel? type) {
                      controller.selectedNode.value = type!;
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
