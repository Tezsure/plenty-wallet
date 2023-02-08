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

class SelectNodeBottomSheet extends StatefulWidget {
  SelectNodeBottomSheet({super.key});

  @override
  State<SelectNodeBottomSheet> createState() => _SelectNodeBottomSheetState();
}

class _SelectNodeBottomSheetState extends State<SelectNodeBottomSheet> {
  final SettingsPageController controller = Get.find<SettingsPageController>();
  late NodeModel selectedModel;

  @override
  void initState() {
    selectedModel = controller.selectedNode.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "Node",
      blurRadius: 5,
      isScrollControlled: true,
      bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        0.02.vspace,
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: controller.networkType.value == NetworkType.mainnet
              ? controller.nodeModel.value.mainnet!.nodes?.length ?? 0
              : controller.nodeModel.value.testnet?.nodes?.length ?? 0,
          itemBuilder: (context, index) => optionMethod(
            // isSelected: true,
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
        _buildCustomNodes(),
        0.02.vspace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.arP),
          child: SolidButton(
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
        ),
        SizedBox(
          height: 16.aR,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.arP),
          child: SolidButton(
            active: selectedModel != controller.selectedNode.value,
            onPressed: () {
              controller.changeNode(selectedModel);
              Get.back();
            },
            title: "Apply",
          ),
        ),
        0.055.vspace,
      ],
    );
  }

  Widget _buildCustomNodes() {
    if (controller.customNodes.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: ColorConst.darkGrey,
          height: 1,
          thickness: 1,
        ),
        SizedBox(
          height: 8.arP,
        ),
        Text(
          "Custom Nodes :",
          style: labelMedium.copyWith(color: ColorConst.Primary),
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: controller.customNodes.length,
          itemBuilder: (context, index) => Dismissible(
            background: Container(
              height: 58,
              width: double.infinity,
              color: ColorConst.Error,
              padding: EdgeInsets.symmetric(horizontal: 16.arP),
              child: Row(
                children: [
                  Text(
                    "DELETE",
                    style: labelMedium,
                  ),
                  Spacer(),
                  Text(
                    "DELETE",
                    style: labelMedium,
                  ),
                ],
              ),
            ),
            confirmDismiss: (_) async {
              return await Get.bottomSheet(
                      deleteNodeBottomSheet(controller.customNodes[index]))
                  .then((value) => value != null);
            },
            onDismissed: (_) {
              controller.deleteCustomNode(controller.customNodes[index]);
            },
            key: Key(controller.customNodes[index].url ?? ""),
            child: optionMethod(
              model: controller.customNodes[index],
            ),
          ),
          separatorBuilder: (context, index) => const Divider(
            color: Colors.black,
            height: 1,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget optionMethod({
    required NodeModel model,
  }) {
    return InkWell(
      onTap: () {
        selectedModel = model;
        setState(() {});
      },
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 59.arP,
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
              selectedModel.url == model.url
                  ? SvgPicture.asset(
                      "${PathConst.SVG}check_3.svg",
                      // color: ColorConst.Primary,
                      height: 16.6.arP,
                      fit: BoxFit.contain,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteNodeBottomSheet(NodeModel node) {
    return NaanBottomSheet(
      title: "Delete node",
      blurRadius: 5,
      height: 275,
      bottomSheetWidgets: [
        Center(
          child: Text(
            "You can add the node again later",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
        ),
        0.03.vspace,
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Column(
            children: [
              optionDelete(
                  child: Text(
                    "Delete",
                    style: labelMedium.apply(color: ColorConst.Error.shade60),
                  ),
                  onTap: () {
                    controller.deleteCustomNode(node);
                  }),
              SizedBox(
                height: 16.arP,
              ),
              optionDelete(
                  child: Text(
                    "Cancel",
                    style: labelMedium,
                  ),
                  onTap: () {
                    Get.back();
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget optionDelete({Widget? child, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        width: double.infinity,
        height: 54,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
