import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:naan_wallet/app/data/services/service_models/collectible_model.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'nft_widget.dart';

class CollectibleWidget extends GetView<SendPageController> {
  const CollectibleWidget({
    super.key,
    required this.collectibleModel,
    required this.widgetIndex,
  });

  final CollectibleModel collectibleModel;
  final int widgetIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Obx(
          () => Column(
            children: [
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  child: Image.asset(
                    collectibleModel.collectibleProfilePath,
                    fit: BoxFit.contain,
                  ),
                ),
                onExpansionChanged: (isExpand) =>
                    controller.setExpandNFTCollectible(widgetIndex),
                trailing: SizedBox(
                  height: 0.03.height,
                  width: 0.14.width,
                  child: expandButton(
                    isExpanded: controller.expandNFTCollectible.value &&
                        widgetIndex == controller.expandedIndex.value,
                  ),
                ),
                title: Text(
                  collectibleModel.name,
                  style: labelLarge,
                ),
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    spacing: 0.03.width,
                    runSpacing: 0.03.width,
                    children: collectibleModel.nfts
                        .map((nfTmodel) => NFTwidget(
                            nfTmodel: nfTmodel,
                            onTap: () => controller
                              ..onNFTClick()
                              ..setSelectedPageIndex(
                                  index: 2, isKeyboardRequested: false)))
                        .toList(),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget expandButton({required bool isExpanded}) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            collectibleModel.nfts.length.toString(),
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
          const SizedBox(
            width: 2,
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
            color: ColorConst.NeutralVariant.shade60,
            size: 10,
          )
        ],
      ),
    );
  }
}
