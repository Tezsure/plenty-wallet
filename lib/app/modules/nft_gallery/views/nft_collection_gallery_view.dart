import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/nft_gallery/controllers/nft_gallery_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class NFTcollectionGalleryView extends GetView<NftGalleryController> {
  final GestureTapCallback? onBackTap;
  const NFTcollectionGalleryView({
    super.key,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: 5,
      height: 0.95.height,
      bottomSheetHorizontalPadding: 12,
      bottomSheetWidgets: [
        nftCollectionGalleryAppBar(),
        SizedBox(
          height: 17,
        ),
        Expanded(
          child: MasonryGridView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: controller
                  .collectibles[controller.selectedCollectibleIndex.value]
                  .nfts
                  .length,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              gridDelegate:
                  const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
              ),
              itemBuilder: (_, index) {
                return nftWidget(
                    nftModel: controller
                        .collectibles[controller.selectedCollectibleIndex.value]
                        .nfts[index]);
              }),
        )
      ],
    );
  }

  Row nftCollectionGalleryAppBar() {
    return Row(
      children: [
        IconButton(
          onPressed: onBackTap,
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          iconSize: 20,
        ),
        Spacer(),
        CircleAvatar(
          radius: 16,
          backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        SizedBox(
          width: 12,
        ),
        Text(
          "stay a vision",
          style: labelLarge,
        ),
        Spacer(),
        Container(
          height: 24,
          padding: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            "${controller.collectibles[controller.selectedCollectibleIndex.value].nfts.length} items",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
        )
      ],
    );
  }

  Widget nftWidget({required NFTmodel nftModel}) {
    return Container(
      width: (1.width / 2) - 18,
      decoration: BoxDecoration(
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              nftModel.nftPath,
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "data",
            style: labelMedium,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "data",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          )
        ],
      ),
    );
  }
}
