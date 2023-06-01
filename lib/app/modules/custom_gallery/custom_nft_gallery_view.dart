// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';

import 'package:naan_wallet/app/modules/custom_gallery/widgets/custom_nft_detail_sheet.dart';

import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:naan_wallet/utils/nested_route_observer.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

import 'controller/custom_gallery_controller.dart';
import 'widgets/custom_nft_collection_sheet.dart';

///https://objkt.com/asset/hicetnunc/706649
class CustomNFTGalleryView extends GetView<CustomNFTGalleryController> {
  final String title;
  final NFTGalleryType nftGalleryType;
  final NftGalleryFilter? nftGalleryFilter;
  const CustomNFTGalleryView({
    super.key,
    required this.title,
    required this.nftGalleryType,
    this.nftGalleryFilter,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(CustomNFTGalleryController(
      nftGalleryType: nftGalleryType,
      nftGalleryFilter: nftGalleryFilter,
    ));

    return Obx(() {
      return controller.search.value
          ? _buildGalleryWithSearch(context)
          : _buildGalleryWithoutSearch(context);
    });
  }

  Widget _buildGalleryWithSearch(BuildContext context) {
    return Builder(builder: (context) {
      return NaanBottomSheet(
        bottomSheetHorizontalPadding: 0,
        // isScrollControlled: true,
        height: AppConstant.naanBottomSheetHeight,
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight -
                MediaQuery.of(context).viewInsets.bottom +
                60.7.arP,
            child: Navigator(
                observers: [NestedRouteObserver()],
                onGenerateRoute: (_) {
                  return MaterialPageRoute(builder: (context) {
                    return Obx(() {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.arP),
                            child: BottomSheetHeading(
                              title: title,
                            ),
                          ),
                          SizedBox(
                            height: 24.arP,
                          ),
                          _searchAppBarWidget(),
                          SizedBox(
                            height: 25.arP,
                          ),
                          controller.searchText.value.isEmpty
                              ? Container(
                                  margin: EdgeInsets.only(top: 0.03.height),
                                  child: Text(
                                    "Try searching for an artist, \ncollection name or NFT name"
                                        .tr,
                                    textAlign: TextAlign.center,
                                    style: bodyMedium.copyWith(
                                        color: ColorConst.grey),
                                  ),
                                )
                              : controller.isSearching.value
                                  ? NftGallerySkeleton()
                                  : controller.searchNfts.isEmpty
                                      ? Container(
                                          margin:
                                              EdgeInsets.only(top: 0.03.height),
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/nft_page/svg/no_results.svg",
                                                width: 0.5.width,
                                              ),
                                              SizedBox(
                                                height: 0.02.height,
                                              ),
                                              Text(
                                                "Probably Nothing".tr,
                                                textAlign: TextAlign.center,
                                                style: titleLarge,
                                              ),
                                              SizedBox(
                                                height: 0.01.height,
                                              ),
                                              Text(
                                                "We didn’t find any results. Did you \nmisspell your query?"
                                                    .tr,
                                                textAlign: TextAlign.center,
                                                style: bodySmall.copyWith(
                                                    color: ColorConst.grey),
                                              ),
                                            ],
                                          ),
                                        )
                                      : controller.searchNfts.length == 1 &&
                                              controller.searchNfts.entries
                                                      .first.value.length ==
                                                  1
                                          ? _getNftListViewWidget(
                                              1.1, controller.searchNfts)
                                          : _getCollectionGridViewWidget(
                                              controller.searchNfts),
                        ],
                      );
                    });
                  });
                }),
          ),
        ],
      );
    });
  }

  Widget _buildGalleryWithoutSearch(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetHorizontalPadding: 0,
      // isScrollControlled: true,
      height: AppConstant.naanBottomSheetHeight,

      bottomSheetWidgets: [
        SizedBox(
          height: AppConstant.naanBottomSheetChildHeight + 60.7.arP,
          child: Navigator(
              observers: [NestedRouteObserver()],
              onGenerateRoute: (context) {
                return MaterialPageRoute(builder: (context) {
                  return Obx(() {
                    return Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.arP),
                              child: BottomSheetHeading(
                                title: title,
                              ),
                            ),
                            SizedBox(
                              height: 24.arP,
                            ),
                            _searchAppBarWidgetMock(),
                            SizedBox(
                              height: 24.arP,
                            ),
                            controller.galleryNfts.value.isEmpty
                                ? controller.selectedGalleryFilter.value !=
                                        NftGalleryFilter.list
                                    ? NftGallerySkeletonList()
                                    : NftGallerySkeleton()
                                : NotificationListener<UserScrollNotification>(
                                    onNotification: (notification) {
                                      if (notification.metrics.extentAfter <=
                                              20 &&
                                          controller.offsetNFT <
                                              controller.NFTsPk.length &&
                                          !controller.loadingMore) {
                                        controller.fetchAllNftForGallery();
                                      }

                                      final ScrollDirection direction =
                                          notification.direction;
                                      if (direction ==
                                          ScrollDirection.forward) {
                                        controller.isScrollingUp.value = false;
                                      } else if (direction ==
                                          ScrollDirection.reverse) {
                                        controller.isScrollingUp.value = true;
                                      }
                                      return false;
                                    },
                                    child: Obx(
                                      () => controller.selectedGalleryFilter
                                                  .value ==
                                              NftGalleryFilter.collection
                                          ? _getCollectionGridViewWidget(
                                              controller.galleryNfts)
                                          : controller.selectedGalleryFilter
                                                      .value ==
                                                  NftGalleryFilter.list
                                              ? _getNftListViewWidget(
                                                  2.1, controller.galleryNfts)
                                              : _getNftListViewWidget(
                                                  1.1, controller.galleryNfts),
                                    ),
                                  ),
                          ],
                        ),
                        if (nftGalleryFilter == null)
                          Obx(
                            () => Align(
                              alignment: Alignment.bottomCenter,
                              child: _getHoverFilterWidget(context),
                            ),
                          ),
                      ],
                    );
                  });
                });
              }),
        )
      ],
    );
  }

  Container _buildEmptyPlaceHolder() {
    return Container(
      margin: EdgeInsets.only(top: 0.03.height),
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/nft_page/svg/no_results.svg",
            width: 0.5.width,
          ),
          SizedBox(
            height: 0.02.height,
          ),
          Text(
            "Probably Nothing".tr,
            textAlign: TextAlign.center,
            style: titleLarge,
          ),
          SizedBox(
            height: 0.01.height,
          ),
          Text(
            "We didn’t find any results. Did you \nmisspell your query?".tr,
            textAlign: TextAlign.center,
            style: bodySmall.copyWith(color: ColorConst.grey),
          ),
        ],
      ),
    );
  }

  Widget _searchAppBarWidget() => Row(
        children: [
          SizedBox(
              width: 1.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.arP),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff958E99).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.arP),
                          ),
                          child: Center(
                            child: TextField(
                              autofocus: true,
                              cursorColor: ColorConst.Primary,
                              onChanged: ((value) {
                                controller.debounceTimer?.cancel();
                                controller.debounceTimer = Timer(
                                    const Duration(milliseconds: 400), () {
                                  controller.searchNftGallery(
                                      value.toLowerCase().trim());
                                });
                              }),
                              textAlignVertical: TextAlignVertical.center,
                              style: bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: const Color(0xFFB0A9B3),
                                  size: 20.arP,
                                ),
                                hintText: "Search".tr,
                                hintStyle: bodyMedium.copyWith(
                                  color: const Color(0xFFB0A9B3),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      BouncingWidget(
                        onPressed: () {
                          controller.search.value = false;
                          controller.searchText.value = "";
                          controller.searchNfts.clear();
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 7.0),
                          child: Text(
                            "Cancel".tr,
                            style:
                                bodyMedium.copyWith(color: ColorConst.Primary),
                          ),
                        ),
                      )
                    ]),
              )),
        ],
      );

  Widget _searchAppBarWidgetMock() => Row(
        children: [
          SizedBox(
              width: 1.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.arP),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff958E99).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.arP),
                          ),
                          child: Center(
                            child: TextField(
                              cursorColor: ColorConst.Primary,
                              onTap: () {
                                controller.search.value = true;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              style: bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: const Color(0xFFB0A9B3),
                                  size: 20.arP,
                                ),
                                hintText: "Search".tr,
                                hintStyle: bodyMedium.copyWith(
                                  color: const Color(0xFFB0A9B3),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              )),
        ],
      );

  Widget _getHoverFilterWidget(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 145.arP,
        height: 50.arP,
        margin: EdgeInsets.only(
          bottom: 32.arP + MediaQuery.of(context).viewInsets.bottom,
        ),
        transform: Matrix4.identity()
          ..translate(
            0.0,
            !controller.isScrollingUp.value ? 0.0 : 200.arP,
          ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1C1F),
          borderRadius: BorderRadius.circular(
            20.arP,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
          border: Border.all(
            color: const Color(0xFF4A454E),
            width: 1.arP,
          ),
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            menuIcon(
              "assets/nft_page/svg/collection_view.svg",
              NftGalleryFilter.collection,
            ),
            menuIcon(
              "assets/nft_page/svg/listview.svg",
              NftGalleryFilter.list,
            ),
            menuIcon(
              "assets/nft_page/svg/thumbnails.svg",
              NftGalleryFilter.thumbnail,
            ),
          ],
        ),
      );

  Widget menuIcon(asset, NftGalleryFilter filter) => BouncingWidget(
        onPressed: () {
          controller.selectedGalleryFilter.value = filter;
        },
        child: Container(
          width: 140.arP / 3,
          child: Center(
            child: SizedBox(
              width: 18.arP,
              child: SvgPicture.asset(asset,
                  width: 18.arP,
                  // height: 18.arP,
                  fit: BoxFit.fill,
                  color: controller.selectedGalleryFilter.value == filter
                      ? Colors.white
                      : const Color(0xFF958E99)),
            ),
          ),
        ),
      );

  Widget _getNftListViewWidget(
          [double crossAxisCount = 2.1,
          Map<String, List<NftTokenModel>> nfts = const {}]) =>
      Expanded(
        child: RefreshIndicator(
          onRefresh: () async {
            controller.offsetNFT = 0;
            controller.NFTsPk.clear();
            controller.galleryNfts.clear();
            controller.nftList.clear();
            controller.fetchAllNftForGallery();
          },
          color: ColorConst.Primary,
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16.arP,
            ),
            child: ListView.builder(
              // cacheExtent: 10.arP,
              shrinkWrap: true,
              // addAutomaticKeepAlives: false,
              // addRepaintBoundaries: false,
              physics: AppConstant.scrollPhysics,
              itemBuilder: ((context, index) {
                if (index == nfts.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0.arP),
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        color: ColorConst.Primary,
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: index == 0 ? 0 : 10.arP,
                      ),
                      _getCollectionDetailsRow(
                        nfts.values.toList()[index][0],
                        nfts.values.toList()[index].length,
                      ),
                      SizedBox(
                        height: 15.arP,
                      ),
                      MasonryGridView.count(
                          shrinkWrap: true,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: (Get.width > 768
                                  ? crossAxisCount == 1.1
                                      ? 2
                                      : 3
                                  : crossAxisCount == 2.1 &&
                                          nfts.values.toList()[index].length ==
                                              1
                                      ? 1
                                      : crossAxisCount == 1.1
                                          ? 1
                                          : 2)
                              .toInt(),
                          mainAxisSpacing: 16.arP,
                          crossAxisSpacing: 12.arP,
                          itemCount: nfts.values.toList()[index].length,
                          itemBuilder: ((context, i) {
                            var nftTokenModel = nfts.values.toList()[index][i];
                            return BouncingWidget(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomNFTDetailBottomSheet(
                                          prevPage: "Gallery",
                                          onBackTap: Get.back,
                                          pk: nftTokenModel.pk!,
                                        )),
                              ),
                              child: Container(
                                width: double.infinity,
                                // constraints: const BoxConstraints(minHeight: 1),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF958E99).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    12.arP,
                                  ),
                                ),
                                padding: EdgeInsets.all(
                                  12.arP,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        minHeight: (Get.width > 768
                                                        ? crossAxisCount == 1.1
                                                            ? 2
                                                            : 3
                                                        : crossAxisCount ==
                                                                    2.1 &&
                                                                nfts.values
                                                                        .toList()[
                                                                            index]
                                                                        .length ==
                                                                    1
                                                            ? 1
                                                            : crossAxisCount ==
                                                                    1.1
                                                                ? 1
                                                                : 2)
                                                    .toInt() ==
                                                2
                                            ? 150.arP
                                            : 350.arP,
                                      ),
                                      width: double.infinity,
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.arP,
                                          ),
                                          child: NFTImage(
                                              memCacheHeight: 250,
                                              memCacheWidth: 250,
                                              nftTokenModel: nftTokenModel)
                                          //  nftTokenModel.artifactUri
                                          //             ?.startsWith("data") ??
                                          //         false
                                          //     ? SvgPicture.network(
                                          //         nftTokenModel.artifactUri!,
                                          //         fit: BoxFit.cover,
                                          //       )
                                          //     : CachedNetworkImage(
                                          //         imageUrl:
                                          //             "https://assets.objkt.media/file/assets-003/${nftTokenModel.faContract}/${nftTokenModel.tokenId.toString()}/thumb${crossAxisCount == 1.1 ? 400 : 288}",
                                          //         fit: BoxFit.fitWidth,
                                          //       ),
                                          ),
                                    ),
                                    SizedBox(
                                      height: 12.arP,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        nftTokenModel.fa!.name ?? "N/A",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.arP,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5.arP,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.arP,
                                    ),
                                    // created by text
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        nftTokenModel.creators!.isEmpty
                                            ? "N/A"
                                            : nftTokenModel.creators![0].holder!
                                                    .alias ??
                                                nftTokenModel.creators![0]
                                                    .holder!.address!
                                                    .tz1Short(),
                                        style: TextStyle(
                                          color: const Color(0xFF958E99),
                                          fontSize: 10.arP,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5.arP,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })),
                      SizedBox(
                        height: 16.arP,
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ],
                  );
                }
              }),
              itemCount: nfts.length +
                  (controller.offsetNFT < controller.NFTsPk.length &&
                          controller.searchText.isEmpty
                      ? 1
                      : 0),
            ),
          ),
        ),
      );

  Widget _getCollectionDetailsRow(NftTokenModel nftTokenModel, length) {
    var logo = nftTokenModel.fa!.logo!;
    if (logo.startsWith("ipfs://")) {
      logo = "https://ipfs.io/ipfs/${logo.replaceAll("ipfs://", "")}";
    }
    if (logo.isEmpty && (nftTokenModel.creators?.isNotEmpty ?? false)) {
      logo =
          "https://services.tzkt.io/v1/avatars/${nftTokenModel.creators!.first.creatorAddress}";
    }
    return Row(
      children: [
        Container(
          width: 32.arP,
          height: 32.arP,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: logo,
              maxHeightDiskCache: 59,
              maxWidthDiskCache: 59,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: 12.arP,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nftTokenModel.fa!.name ?? "N/A",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.arP,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1.arP,
              ),
            ),
          ],
        ),
        Expanded(child: Container()),
        Text(
          "$length items",
          style: TextStyle(
            color: const Color(0xFF958E99),
            fontSize: 12.arP,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1.arP,
          ),
        ),
      ],
    );
  }

  Widget _getCollectionGridViewWidget(Map<String, List<NftTokenModel>> nfts) =>
      Obx(
        () => Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.offsetNFT = 0;
              controller.NFTsPk.clear();
              controller.galleryNfts.clear();
              controller.nftList.clear();
              controller.fetchAllNftForGallery();
            },
            backgroundColor: Colors.transparent,
            color: ColorConst.Primary,
            child: SingleChildScrollView(
              physics: AppConstant.scrollPhysics,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.arP,
                    ),
                    child: MasonryGridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: Get.width > 768 ? 3 : 2,
                        mainAxisSpacing: 12.arP,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        shrinkWrap: true,
                        crossAxisSpacing: 12.arP,
                        // cacheExtent: 100.0.arP,
                        itemCount: nfts.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFF958E99).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                12.arP,
                              ),
                            ),
                            child: nfts.isEmpty
                                ? Container()
                                : NftCollectionItemWidget(
                                    galleryName: "Gallery",
                                    nftTokens: nfts.values.toList()[index],
                                  ),
                          );
                        }),
                  ),
                  controller.offsetNFT < controller.NFTsPk.length
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 30.arP),
                            child: const CupertinoActivityIndicator(
                              color: ColorConst.Primary,
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      );
}

class NftGallerySkeleton extends StatelessWidget {
  NftGallerySkeleton({
    super.key,
  });
  List<double> skeletonHeights = <double>[
    250.arP,
    300.arP,
    150.arP,
    90.arP,
    180.arP,
    200.arP,
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.arP,
        ),
        child: MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 1,
            mainAxisSpacing: 12.arP,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            shrinkWrap: true,
            crossAxisSpacing: 12.arP,
            // cacheExtent: 100.0.arP,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF958E99).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    12.arP,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    12.arP,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff1E1C1F),
                    borderRadius: BorderRadius.circular(
                      12.arP,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: SizedBox(
                          width: double.infinity,
                          height: skeletonHeights[index],
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xff474548),
                            highlightColor:
                                const Color(0xFF958E99).withOpacity(0.2),
                            child: Container(
                                decoration: BoxDecoration(
                              color: const Color(0xff474548),
                              borderRadius: BorderRadius.circular(
                                8.arP,
                              ),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12.arP,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 135.arP,
                          height: 16.arP,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              50.arP,
                            ),
                          ),
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xff474548),
                            highlightColor:
                                const Color(0xFF958E99).withOpacity(0.2),
                            child: Container(
                                decoration: BoxDecoration(
                              color: const Color(0xff474548),
                              borderRadius: BorderRadius.circular(
                                50.arP,
                              ),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.arP,
                      ),
                      // created by text
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 105.arP,
                          height: 16.arP,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              50.arP,
                            ),
                          ),
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xff474548),
                            highlightColor:
                                const Color(0xFF958E99).withOpacity(0.2),
                            child: Container(
                                decoration: BoxDecoration(
                              color: const Color(0xff474548),
                              borderRadius: BorderRadius.circular(
                                50.arP,
                              ),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class NftGallerySkeletonList extends StatelessWidget {
  NftGallerySkeletonList({
    super.key,
  });
  List<double> skeletonHeights = <double>[
    158.arP,
    90.arP,
    150.arP,
    90.arP,
    180.arP,
    200.arP,
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.arP,
        ),
        child: MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: Get.width > 768 ? 3 : 2,
            mainAxisSpacing: 12.arP,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            shrinkWrap: true,
            crossAxisSpacing: 12.arP,
            // cacheExtent: 100.0.arP,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF958E99).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    12.arP,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    12.arP,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff1E1C1F),
                    borderRadius: BorderRadius.circular(
                      12.arP,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: SizedBox(
                          width: double.infinity,
                          height: skeletonHeights[index],
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xff474548),
                            highlightColor:
                                const Color(0xFF958E99).withOpacity(0.2),
                            child: Container(
                                decoration: BoxDecoration(
                              color: const Color(0xff474548),
                              borderRadius: BorderRadius.circular(
                                8.arP,
                              ),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12.arP,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 135.arP,
                          height: 16.arP,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              50.arP,
                            ),
                          ),
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xff474548),
                            highlightColor:
                                const Color(0xFF958E99).withOpacity(0.2),
                            child: Container(
                                decoration: BoxDecoration(
                              color: const Color(0xff474548),
                              borderRadius: BorderRadius.circular(
                                50.arP,
                              ),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.arP,
                      ),
                      // created by text
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 105.arP,
                          height: 16.arP,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              50.arP,
                            ),
                          ),
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xff474548),
                            highlightColor:
                                const Color(0xFF958E99).withOpacity(0.2),
                            child: Container(
                                decoration: BoxDecoration(
                              color: const Color(0xff474548),
                              borderRadius: BorderRadius.circular(
                                50.arP,
                              ),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

/// Nft collection view item stateless widget
class NftCollectionItemWidget extends StatelessWidget {
  final List<NftTokenModel> nftTokens;

  final String galleryName;
  const NftCollectionItemWidget({
    Key? key,
    required this.nftTokens,
    required this.galleryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () {
        if (nftTokens.length != 1) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CustomNFTCollectionSheet(
                    prevPage: "Gallery",
                    nfts: nftTokens,
                  )));
          // return CommonFunctions.bottomSheet(
          //   NFTCollectionSheet(
          //     nfts: nftTokens,
          //     publicKeyHashs: publicKeyHashes,
          //   ),
          // );
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CustomNFTDetailBottomSheet(
                    onBackTap: Get.back,
                    prevPage: galleryName,
                    pk: nftTokens[0].pk,
                  )));
          // CommonFunctions.bottomSheet(
          //   NFTDetailBottomSheet(
          //     onBackTap: Get.back,
          //     pk: nftTokens[0].pk,
          //     publicKeyHashs: publicKeyHashes,
          //   ),
          // );
        }
        // Get.bottomSheet(NFtDetailView(nft: nftTokens[0]),
        //   isScrollControlled: true);
      },
      child: Container(
        padding: EdgeInsets.all(
          12.arP,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff1E1C1F),
          borderRadius: BorderRadius.circular(
            12.arP,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                runSpacing: 8.arP,
                spacing: 8.arP,
                alignment: WrapAlignment.spaceBetween,
                children: _getImagesWidget(),
              ),
            ),
            SizedBox(
              height: 12.arP,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                nftTokens[0].fa!.name ??
                    (nftTokens[0].faContract ?? "").tz1Short(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.arP,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5.arP,
                ),
              ),
            ),
            SizedBox(
              height: 4.arP,
            ),
            // created by text
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                nftTokens[0].creators!.isEmpty
                    ? "N/A"
                    : nftTokens.length > 1
                        ? (nftTokens[0].creators![0].holder!.alias ??
                                        nftTokens[0]
                                            .creators![0]
                                            .holder!
                                            .address!
                                            .tz1Short())
                                    .toString() ==
                                (nftTokens[nftTokens.length - 1]
                                            .creators![0]
                                            .holder!
                                            .alias ??
                                        nftTokens[nftTokens.length - 1]
                                            .creators![0]
                                            .holder!
                                            .address!
                                            .tz1Short())
                                    .toString()
                            ? nftTokens[0].creators![0].holder!.alias ??
                                nftTokens[0]
                                    .creators![0]
                                    .holder!
                                    .address!
                                    .tz1Short()
                            : "Various artists"
                        : nftTokens[0].creators![0].holder!.alias ??
                            nftTokens[0]
                                .creators![0]
                                .holder!
                                .address!
                                .tz1Short(),
                style: TextStyle(
                  color: const Color(0xFF958E99),
                  fontSize: 10.arP,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5.arP,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getImagesWidget() {
    List<Widget> images = [];
    // ignore: no_leading_underscores_for_local_identifiers
    List<NftTokenModel> _nftTokens = nftTokens.take(4).toList();
    final width = (0.25 - 0.06).width;
    double ratio = Get.width > 768 ? 1.5 : 1;
    for (var i = 0; i < _nftTokens.length; i++) {
      images.add(
        SizedBox(
          width: _nftTokens.length == 1
              ? double.infinity
              : _nftTokens.length == 3 && i == 0
                  ? double.infinity
                  : width / ratio,
          // : Get.width > 768
          //     ? 88.arP
          //     : 73.arP,
          height: _nftTokens.length == 1 ? 160.arP : width / ratio,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(
                8.arP,
              ),
              child: NFTImage(
                nftTokenModel: _nftTokens[i],
/*                 maxHeightDiskCache: 134,
                maxWidthDiskCache: 134, */
                memCacheHeight: 250,
                memCacheWidth: 250,
              )),
        ),
      );
    }
    if (nftTokens.length > images.length) {
      images.last = Stack(
        alignment: Alignment.center,
        children: [
          images.last,
          Container(
            width: (width / ratio) + 0.4.arP,
            height: (width / ratio) + 0.4.arP,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(
                8.arP,
              ),
            ),
            child: Center(
              child: Text(
                "+${nftTokens.length - images.length}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.txtArp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }

    switch (images.length) {
      case 1:
        images = images;
        break;
      case 2:
        images = [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [images[0], images[1]])
        ];
        break;
      case 3:
        images = [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              images[0],
              0.012.vspace,
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [images[1], images[2]]),
            ],
          )
        ];
        break;
      case 4:
        images = [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [images[0], images[1]]),
              0.012.vspace,
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [images[2], images[3]]),
            ],
          )
        ];
        break;
      default:
    }
    return images;
  }
}
