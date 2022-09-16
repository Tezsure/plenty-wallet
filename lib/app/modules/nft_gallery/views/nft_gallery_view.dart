import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../utils/colors/colors.dart';
import '../controllers/nft_gallery_controller.dart';
import 'nft_detail_view.dart';

class NftGalleryView extends GetView<NftGalleryController> {
  NftGalleryView({super.key});
  @override
  final controller = Get.put(NftGalleryController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => IndexedStack(
          index: controller.currentPageIndex.value,
          children: [
            const NFTCollectionView(),
            NFTDetailView(
              onBackTap: () => controller.currentPageIndex.value = 0,
            ),
          ],
        ));
  }
}

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
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastOutSlowIn,
                            margin: controller.searchNft.value
                                ? EdgeInsets.only(
                                    top: 10.sp,
                                    left: 10.sp,
                                    right: 20.sp,
                                    bottom: 10.sp,
                                  )
                                : EdgeInsets.zero,
                            padding: controller.searchNft.value
                                ? EdgeInsets.only(bottom: 20.sp)
                                : null,
                            width:
                                controller.searchNft.value ? 0.9.width : null,
                            child: Visibility(
                              visible: controller.searchNft.value,
                              replacement: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  onPressed: controller.searchNftToggle,
                                  icon: const Icon(Icons.search),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.start,
                                  onEditingComplete: controller.searchNftToggle,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: ColorConst.NeutralVariant.shade60
                                        .withOpacity(0.2),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: ColorConst.NeutralVariant.shade60,
                                      size: 22,
                                    ),
                                    counterStyle: const TextStyle(
                                        backgroundColor: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none),
                                    hintText: 'Search baker',
                                    alignLabelWithHint: true,
                                    floatingLabelAlignment:
                                        FloatingLabelAlignment.center,
                                    hintStyle: bodySmall.copyWith(
                                        color:
                                            ColorConst.NeutralVariant.shade70),
                                    labelStyle: labelSmall,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
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
                  SizedBox(
                    height: 0.06.height,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.sp, vertical: 10.sp),
                      itemCount: controller.nftChips.length,
                      physics: const BouncingScrollPhysics(
                          parent: ClampingScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.sp),
                            child: Chip(
                              autofocus: true,
                              iconTheme: const IconThemeData(
                                  color: Colors.transparent),
                              label: Text(
                                controller.nftChips[index],
                                style: labelSmall,
                              ),
                              backgroundColor:
                                  ColorConst.NeutralVariant.shade20,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              side: BorderSide(
                                color: ColorConst.NeutralVariant.shade60,
                                width: 1,
                              ),
                              labelStyle: labelSmall,
                              visualDensity: VisualDensity.compact,
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      MasonryGridView.builder(
                          controller: scrollController,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.sp, vertical: 10.sp),
                          gridDelegate:
                              const SliverSimpleGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                          ),
                          itemBuilder: (_, i) {
                            return GalleryImage(
                                galleryItems: listOfUrls
                                    .map((e) =>
                                        GalleryItemModel(id: e, imageUrl: e))
                                    .toList());
                          }),
                      Container(),
                    ]),
                  ),
                ],
              ),
            ))));
  }
}

class ImageFeedDesign extends StatelessWidget {
  const ImageFeedDesign({super.key, required this.image});
  final String image;
  final String place = 'Bali';
  final String distance = '2.834 km';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2 - 30,
          height: _getHeight(),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(image),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                distance,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _getHeight() {
    double defaultValue = 170.0;
    Random random = Random();

    return defaultValue + random.nextInt(100);
  }
}

List<String> listOfUrls = [
  "https://cosmosmagazine.com/wp-content/uploads/2020/02/191010_nature.jpg",
  "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
  "https://isha.sadhguru.org/blog/wp-content/uploads/2016/05/natures-temples.jpg",
  "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
  "https://s23574.pcdn.co/wp-content/uploads/Singular-1140x703.jpg",
  "https://www.expatica.com/app/uploads/sites/9/2017/06/Lake-Oeschinen-1200x675.jpg",
];

class GalleryImage extends GetView<NftGalleryController> {
  final List<GalleryItemModel> galleryItems;
  final String? titleGallery;
  final int numOfShowImages;

  const GalleryImage({
    super.key,
    required this.galleryItems,
    this.titleGallery,
    this.numOfShowImages = 4,
  }) : assert(numOfShowImages <= galleryItems.length);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _getHeight(),
      decoration: BoxDecoration(
        color: ColorConst.NeutralVariant.shade80.withOpacity(0.2),
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
                  itemCount: galleryItems.length > 4
                      ? numOfShowImages
                      : galleryItems.length,
                  padding: const EdgeInsets.all(0),
                  semanticChildCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemBuilder: (BuildContext context, int index) {
                    return index < galleryItems.length - 1 &&
                            index == numOfShowImages - 1
                        ? _expandedNftImageCollectionButton(index)
                        : GalleryItemThumbnail(
                            galleryItem: galleryItems[index],
                            onTap: () {
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
                      TextSpan(text: 'Felix le peintre', style: labelSmall)
                    ])),
          ],
        ),
      ),
    );
  }

  double _getHeight() {
    double defaultValue = 0.29.height;
    Random random = Random();

    return defaultValue + random.nextInt(100);
  }

// build image with number for other images
  Widget _expandedNftImageCollectionButton(int index) {
    return GestureDetector(
      onTap: () {
        // openImageFullScreen(index);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          GalleryItemThumbnail(
            galleryItem: galleryItems[index],
          ),
          Container(
            color: Colors.black.withOpacity(.7),
            child: Center(
              child: Text(
                "+${galleryItems.length - index}",
                style: titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryItemModel {
  GalleryItemModel({required this.id, required this.imageUrl});
// id image (image url) to use in hero animation
  final String id;
  // image url
  final String imageUrl;
}

// to show image in GridView
class GalleryItemThumbnail extends StatelessWidget {
  const GalleryItemThumbnail(
      {super.key, required this.galleryItem, this.onTap});

  final GalleryItemModel galleryItem;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: galleryItem.id,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: galleryItem.imageUrl,
          height: 100.0,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
