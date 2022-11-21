import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/rpc_node_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/add_RPC_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class SelectNodeBottomSheet extends StatelessWidget {
  SelectNodeBottomSheet({super.key});

  final SettingsPageController controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: 5,
      isScrollControlled: true,
      bottomSheetHorizontalPadding: 32,
      bottomSheetWidgets: [
        Center(
          child: Text(
            'Select Node',
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
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: controller.networkType.value == NetworkType.mainNet
                ? controller.nodeModel.value.mainnet!.name?.length ?? 0
                : controller.nodeModel.value.testnet?.name?.length ?? 0,
            itemBuilder: (context, index) => optionMethod(
              isSelected: true,
              model: NodeModel(
                name: controller.networkType.value == NetworkType.mainNet
                    ? controller.nodeModel.value.mainnet!.name![index]
                    : controller.nodeModel.value.testnet!.name![index],
                url: controller.networkType.value == NetworkType.mainNet
                    ? controller.nodeModel.value.mainnet!.urls![index]
                    : controller.nodeModel.value.testnet!.urls![index],
              ),
            ),
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
                const Icon(
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
    required NodeModel model,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 58.sp,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    style: labelMedium,
                  ),
                  const Spacer(),
                  Text(
                    model.url!,
                    style: labelSmall.apply(
                      color: ColorConst.NeutralVariant.shade60,
                    ),
                  )
                ],
              ),
              const Spacer(),
              Obx(() => Radio(
                  activeColor: Colors.white,
                  fillColor: MaterialStateColor.resolveWith((state) =>
                      state.contains(MaterialState.selected)
                          ? ColorConst.Primary
                          : Colors.white),
                  value: true,
                  groupValue: controller.selectedNode.value.name == model.name,
                  onChanged: (val) {
                    //TODO ! Save the currentSelectedNode to local storage
                    controller.selectedNode.value = model;
                    ServiceConfig.currentSelectedNode = model.url!;
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
