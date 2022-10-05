import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/nft_gallery/views/nft_gallery_filter.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/styles/styles.dart';
import '../controllers/nft_gallery_controller.dart';
import 'widgets/nft_categories.dart';
import 'widgets/nft_search_bar.dart';

class NFTCollectionView extends GetView<NftGalleryController> {
  const NFTCollectionView({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: filterFloatingButton(),
              body: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Obx(
                      () => AppBar(
                          toolbarHeight:
                              controller.searchNft.value ? 100 : kToolbarHeight,
                          backgroundColor: Colors.transparent,
                          automaticallyImplyLeading: false,
                          title: Text(
                            'NFTs',
                            style: titleMedium,
                          ),
                          centerTitle: true,
                          actions: [
                            NFTSearchBar(
                              onTap: controller.searchNftToggle,
                              isSearching: controller.searchNft.value,
                            ),
                          ]),
                    ),
                    if (controller.searchNft.value) ...[
                      Center(
                        child: Text(
                          'Try searching for collections or NFT',
                          style: bodyMedium.copyWith(
                              color: ColorConst.NeutralVariant.shade70),
                        ),
                      ),
                    ] else ...[
                      TabBar(
                          enableFeedback: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 0.04.width),
                          isScrollable: true,
                          indicatorColor: ColorConst.Primary,
                          tabs: [
                            Tab(
                              child: Text(
                                'Collected',
                                style: labelMedium,
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Created',
                                style: labelMedium,
                              ),
                            ),
                          ]),
                      Obx(() => CollectionCategories(
                            currentSelectedCategoryIndex:
                                controller.currentSelectedCategoryIndex.value,
                            onTap: (i) => controller
                                .changeCurrentSelectedCategoryIndex(i),
                            categoriesName: controller.nftChips,
                          )),
                      Expanded(
                        child: TabBarView(children: [
                          MasonryGridView.builder(
                              controller: scrollController,
                              itemCount: controller.usersNfts.length,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.sp, vertical: 10.sp),
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                              ),
                              itemBuilder: (_, index) {
                                return NFTGalleryImages(
                                  collectionsModel: controller.usersNfts[
                                      controller.usersNfts.keys
                                          .toList()[index]]!,
                                  collectionsIndex: index,
                                  collectionsKey:
                                      controller.usersNfts.keys.toList()[index],
                                );
                              }),
                          const SizedBox(),
                        ]),
                      ),
                    ],
                  ],
                ),
              ),
            ))));
  }

  Widget filterFloatingButton() {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          NFTfilterBottomSheet(),
          barrierColor: Colors.transparent,
          isScrollControlled: true,
        );
      },
      child: Container(
          height: 56,
          width: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: ColorConst.Primary,
              borderRadius: BorderRadius.circular(16)),
          child: const Icon(
            Icons.filter_list_rounded,
            size: 24,
            color: Colors.white,
          )),
    );
  }
}

class NFTGalleryImages extends GetView<NftGalleryController> {
  final List<NftTokenModel> collectionsModel;
  final int collectionsIndex;
  final String collectionsKey;
  final String? titleGallery;
  final int numOfShowImages;

  const NFTGalleryImages({
    super.key,
    required this.collectionsModel,
    this.titleGallery,
    this.numOfShowImages = 4,
    required this.collectionsIndex,
    required this.collectionsKey,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _getHeight(collectionsModel.length),
      decoration: BoxDecoration(
        color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GridView.builder(
                  primary: false,
                  itemCount: collectionsModel.length > 4
                      ? numOfShowImages
                      : collectionsModel.length,
                  padding: const EdgeInsets.all(0),
                  semanticChildCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _childCount(collectionsModel.length),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return index < collectionsModel.length - 1 &&
                            index == numOfShowImages - 1
                        ? _expandedNftImageCollectionButton(index)
                        : GalleryItemThumbnail(
                            nftModel: collectionsModel[index],
                            onTap: () {
                              controller.selectedCollectionsKey.value =
                                  collectionsKey;
                              controller.currentPageIndex.value = 1;
                            },
                          );
                  }),
            ),
            0.01.vspace,
            RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                    text: 'Flowers & Bytes\n',
                    style: labelMedium,
                    children: [
                      TextSpan(
                        text: 'Felix le peintre',
                        style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade60,
                        ),
                      )
                    ])),
          ],
        ),
      ),
    );
  }

  int _childCount(int totalNFTs) {
    if (totalNFTs > 2) {
      return 2;
    } else {
      return 1;
    }
  }

  double _getHeight(int totalNFTs) {
    double defaultValue = 0.29.height;
    if (totalNFTs == 1) {
      return 0.29.height;
    }
    if (totalNFTs <= 2) {
      return 0.18.height;
    } else if (totalNFTs <= 3) {
      return defaultValue;
    } else if (totalNFTs > 4) {
      return 0.3.height;
    } else {
      return defaultValue;
    }
  }

// build image with number for other images
  Widget _expandedNftImageCollectionButton(int index) {
    return GestureDetector(
      onTap: () {
        // TODO Open collection images in another scrollable view
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: AlignmentDirectional.center,
          fit: StackFit.expand,
          children: <Widget>[
            GalleryItemThumbnail(
              nftModel: collectionsModel[index],
            ),
            Container(
              color: Colors.black.withOpacity(.7),
              child: Center(
                child: Text(
                  "+${collectionsModel.length - index}",
                  style: titleLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// to show image in GridView
class GalleryItemThumbnail extends StatelessWidget {
  const GalleryItemThumbnail({super.key, required this.nftModel, this.onTap});

  final NftTokenModel nftModel;
  final GestureTapCallback? onTap;
  // var nftArtifactUrl =
  //     "https://assets.objkt.media/file/assets-003/${nfTmodel.faContract}/${nfTmodel.tokenId.toString()}/thumb400";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: nftModel.name!,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(
                  "https://assets.objkt.media/file/assets-003/${nftModel.faContract}/${nftModel.tokenId.toString()}/thumb400",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }
}
