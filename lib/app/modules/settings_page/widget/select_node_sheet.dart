import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/service_models/rpc_node_model.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:plenty_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:plenty_wallet/app/modules/settings_page/widget/add_RPC_sheet.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class SelectNodeBottomSheet extends StatefulWidget {
  final String? prevPage;
  SelectNodeBottomSheet({super.key, this.prevPage});

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
      prevPageName: widget.prevPage,
      title: "Node",
      leading: backButton(
          lastPageName: widget.prevPage, ontap: () => Navigator.pop(context)),
      // blurRadius: 5,
      height:
          widget.prevPage == null ? null : (AppConstant.naanBottomSheetHeight),
      isScrollControlled: widget.prevPage == null,
      // bottomSheetHorizontalPadding: widget.prevPage == null ? null : 0,
      bottomSheetWidgets: [
        SizedBox(
          height: widget.prevPage == null
              ? null
              : AppConstant.naanBottomSheetChildHeight,
          child: Column(
            children: [
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
              if (widget.prevPage != null) Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.arP),
                child: SolidButton(
                  borderColor: ColorConst.Primary,
                  textColor: ColorConst.Primary,
                  primaryColor: Colors.transparent,
                  onPressed: () {
                    CommonFunctions.bottomSheet(
                      AddRPCbottomSheet(),
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
                    if (widget.prevPage == null) {
                      Get.back();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  title: "Apply",
                ),
              ),
              BottomButtonPadding()
            ],
          ),
        ),
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
          "Custom Nodes :".tr,
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
                    "DELETE".tr,
                    style: labelMedium,
                  ),
                  Spacer(),
                  Text(
                    "DELETE".tr,
                    style: labelMedium,
                  ),
                ],
              ),
            ),
            confirmDismiss: (_) async {
              return await CommonFunctions.bottomSheet(
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
    return BouncingWidget(
      onPressed: () {
        selectedModel = model;
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 12.0.arP,
            horizontal: widget.prevPage == null ? 16.arP : 0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  style: labelMedium,
                ),
                // const Spacer(),
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
            "You can add the node again later".tr,
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
                    "Delete".tr,
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
                    "Cancel".tr,
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
    return BouncingWidget(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        width: double.infinity,
        height: 50.arP,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
