import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/rpc_node_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/add_RPC_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class SelectNodeBottomSheet extends StatelessWidget {
  SelectNodeBottomSheet({super.key});

  final SettingsPageController controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "Select Node",
      blurRadius: 5,
      isScrollControlled: true,
      bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        0.02.vspace,
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: controller.networkType.value == NetworkType.mainnet
              ? controller.nodeModel.value.mainnet!.nodes?.length ?? 0
              : controller.nodeModel.value.testnet?.nodes?.length ?? 0,
          itemBuilder: (context, index) => optionMethod(
            isSelected: true,
            model: controller.networkType.value == NetworkType.mainnet
                ? controller.nodeModel.value.mainnet!.nodes![index]
                : controller.nodeModel.value.testnet!.nodes![index],
          ),
          separatorBuilder: (context, index) => const Divider(
            color: Colors.black,
            height: 1,
            thickness: 1,
          ),
        ),
        0.02.vspace,
        SolidButton(
          borderColor: ColorConst.Primary,
          textColor: ColorConst.Primary,
          primaryColor: Colors.transparent,
          onPressed: () {
            Get.bottomSheet(
              AddRPCbottomSheet(),
              enterBottomSheetDuration: const Duration(milliseconds: 180),
              exitBottomSheetDuration: const Duration(milliseconds: 150),
            );
          },
          title: "Add custom RPC",
        ),
        SizedBox(
          height: 16.aR,
        ),
        SolidButton(
          onPressed: Get.back,
          title: "Apply",
        ),
        0.055.vspace,
      ],
    );
  }

  Widget optionMethod({
    required NodeModel model,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        controller.changeNode(model);
      },
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
              Obx(() {
                if (controller.selectedNode.value.url == model.url) {
                  return SvgPicture.asset(
                    "${PathConst.SVG}check2.svg",
                    color: ColorConst.Primary,
                    height: 16.6.sp,
                    fit: BoxFit.contain,
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
