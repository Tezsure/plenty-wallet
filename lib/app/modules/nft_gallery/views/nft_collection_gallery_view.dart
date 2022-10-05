import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';

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
    List<NftTokenModel> nftTokenModels =
        controller.selectedCollectionsKey.value.isNotEmpty
            ? controller.usersNfts[controller.selectedCollectionsKey.value]!
            : [];

    return DraggableScrollableSheet(
        maxChildSize: 0.96,
        initialChildSize: 0.95,
        minChildSize: 0.6,
        builder: ((context, scrollController) => Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                gradient: GradConst.GradientBackground,
              ),
              height: 1.height,
              width: 1.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    0.01.vspace,
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 5,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                    nftTokenModels.isNotEmpty
                        ? nftCollectionGalleryAppBar(
                            nftTokenModels[0], nftTokenModels.length)
                        : Container(),
                    const SizedBox(
                      height: 17,
                    ),
                    Expanded(
                      child: MasonryGridView.builder(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: nftTokenModels.length,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                          ),
                          itemBuilder: (_, index) {
                            return nftWidget(
                              nftModel: nftTokenModels[index],
                              nftIndex: index,
                            );
                          }),
                    )
                  ],
                ),
              ),
            )));
  }

  Row nftCollectionGalleryAppBar(NftTokenModel nftTokenModel, int items) {
    return Row(
      children: [
        IconButton(
          onPressed: onBackTap,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
          iconSize: 20,
        ),
        const Spacer(),
        CircleAvatar(
          radius: 16,
          backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          nftTokenModel.fa!.name!,
          style: labelLarge,
        ),
        const Spacer(),
        Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            "$items items",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
        )
      ],
    );
  }

  Widget nftWidget({required NftTokenModel nftModel, required nftIndex}) {
    return GestureDetector(
      onTap: () {
        controller.selectedNftIndex.value = nftIndex;
        controller.currentPageIndex.value = 2;
      },
      child: Container(
        width: (1.width / 2) - 18,
        decoration: BoxDecoration(
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://assets.objkt.media/file/assets-003/${nftModel.faContract}/${nftModel.tokenId.toString()}/thumb400",
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "data",
              style: labelMedium,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "data",
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            )
          ],
        ),
      ),
    );
  }
}
