import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:naan_wallet/app/data/services/service_models/collectible_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_model.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

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
                  child: _expandButton(
                    isExpanded: controller.expandNFTCollectible.value &&
                        widgetIndex == controller.expandedIndex.value,
                  ),
                ),
                title: Text(
                  collectibleModel.name,
                  style: labelLarge,
                ),
                children: [
                  SizedBox(
                      height: 0.31.height *
                          (collectibleModel.nfts.length / 2).ceil(),
                      width: 1.width,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: collectibleModel.nfts.length,
                        shrinkWrap: false,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 0.5.width,
                            mainAxisExtent: 0.3.height,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: ((context, index) => NFTwidget(
                              nfTmodel: collectibleModel.nfts[index],
                              onTap: () => controller
                                ..onNFTClick()
                                ..setSelectedPageIndex(
                                    index: 2, isKeyboardRequested: false),
                            )),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _expandButton({required bool isExpanded}) {
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

class NFTwidget extends StatelessWidget {
  final NFTmodel nfTmodel;
  final GestureTapCallback? onTap;
  const NFTwidget({super.key, required this.nfTmodel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 0.45.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 0.42.width,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    nfTmodel.nftPath,
                  ),
                ),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              nfTmodel.title,
              style: labelMedium,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              nfTmodel.name,
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
          ],
        ),
      ),
    );
  }
}
