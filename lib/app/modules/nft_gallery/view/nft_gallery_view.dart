// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/nft_gallery/controller/nft_gallery_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';

class NftGalleryView extends GetView<NftGalleryController> {
  const NftGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 0.6.height,
          maxHeight: 0.95.height,
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              10.sp,
            ),
            topRight: Radius.circular(
              10.sp,
            ),
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 40.sp,
                  height: 5.spH,
                  margin: EdgeInsets.only(
                    top: 5.sp,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBF5).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(
                      100.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.arP,
                ),
                _appBarWidget(),
                SizedBox(
                  height: 24.arP,
                ),
                _getNftTypesChips(),
                SizedBox(
                  height: 20.arP,
                ),
                NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    final ScrollDirection direction = notification.direction;
                    if (direction == ScrollDirection.forward) {
                      controller.isScrollingUp.value = false;
                    } else if (direction == ScrollDirection.reverse) {
                      controller.isScrollingUp.value = true;
                    }
                    return true;
                  },
                  child: Obx(
                    () => controller.selectedGalleryFilter.value ==
                            NftGalleryFilter.collection
                        ? _getCollectionGridViewWidget()
                        : controller.selectedGalleryFilter.value ==
                                NftGalleryFilter.list
                            ? _getNftListViewWidget()
                            : _getNftListViewWidget(1.1),
                  ),
                ),
              ],
            ),
            Obx(
              () => Align(
                alignment: Alignment.bottomCenter,
                child: _getHoverFilterWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getHoverFilterWidget() => AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 132.arP,
        height: 40.arP,
        margin: EdgeInsets.only(
          bottom: 32.arP,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget menuIcon(asset, NftGalleryFilter filter) => GestureDetector(
        onTap: () {
          controller.selectedGalleryFilter.value = filter;
        },
        child: SvgPicture.asset(asset,
            width: 15.arP,
            fit: BoxFit.fill,
            color: controller.selectedGalleryFilter.value == filter
                ? Colors.white
                : const Color(0xFF958E99)),
      );

  Widget _getNftListViewWidget([double crossAxisCount = 2.1]) => Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16.arP,
          ),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: ((context, index) => Column(
                  children: [
                    SizedBox(
                      height: index == 0 ? 0 : 10.arP,
                    ),
                    _getCollectionDetailsRow(
                      controller.galleryNfts.values.toList()[index][0],
                      controller.galleryNfts.values.toList()[index].length,
                    ),
                    SizedBox(
                      height: 15.arP,
                    ),
                    MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: (Get.width > 768
                                ? crossAxisCount == 1.1
                                    ? 2
                                    : 3
                                : crossAxisCount == 2.1 &&
                                        controller.galleryNfts.values
                                                .toList()[index]
                                                .length ==
                                            1
                                    ? 1
                                    : crossAxisCount == 1.1
                                        ? 1
                                        : 2)
                            .toInt(),
                        mainAxisSpacing: 12.arP,
                        crossAxisSpacing: 12.arP,
                        itemCount: controller.galleryNfts.values
                            .toList()[index]
                            .length,
                        itemBuilder: ((context, i) {
                          var _nftTokenModel =
                              controller.galleryNfts.values.toList()[index][i];
                          return Container(
                            width: double.infinity,
                            // constraints: const BoxConstraints(minHeight: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFF958E99).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                12.arP,
                              ),
                            ),
                            padding: EdgeInsets.all(
                              12.arP,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      8.arP,
                                    ),
                                    child: Image.network(
                                      "https://assets.objkt.media/file/assets-003/${_nftTokenModel.faContract}/${_nftTokenModel.tokenId.toString()}/thumb${crossAxisCount == 1.1 ? 400 : 288}",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 12.arP,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _nftTokenModel.fa!.name!,
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
                                    _nftTokenModel.creators!.isEmpty
                                        ? "N/A"
                                        : _nftTokenModel
                                                .creators![0].holder!.alias ??
                                            _nftTokenModel
                                                .creators![0].holder!.address!
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
                          );
                        })),
                    SizedBox(
                      height: 16.arP,
                    ),
                    Divider(
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ],
                )),
            itemCount: controller.galleryNfts.length,
          ),
        ),
      );

  Widget _getCollectionDetailsRow(NftTokenModel nftTokenModel, length) {
    var logo = nftTokenModel.fa!.logo!;
    if (logo.startsWith("ipfs://")) {
      logo = "https://ipfs.io/ipfs/${logo.replaceAll("ipfs://", "")}";
    }
    return Row(
      children: [
        Container(
          width: 32.arP,
          height: 32.arP,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(logo),
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
              nftTokenModel.fa!.name!,
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

  Widget _getCollectionGridViewWidget() => Obx(
        () => Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16.arP,
            ),
            child: MasonryGridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: Get.width > 768 ? 3 : 2,
              mainAxisSpacing: 12.arP,
              crossAxisSpacing: 12.arP,
              itemCount: controller.galleryNfts.length,
              itemBuilder: (context, index) => Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF958E99).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    12.arP,
                  ),
                ),
                child: controller.galleryNfts.values.toList()[index].isEmpty
                    ? Container()
                    : NftCollectionItemWidget(
                        nftTokens:
                            controller.galleryNfts.values.toList()[index],
                      ),
              ),
            ),
          ),
        ),
      );

  Widget _getNftTypesChips() => SizedBox(
        width: double.infinity,
        height: 35.arP,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            for (var i = 0; i < controller.nftTypesChips.length; i++)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.sp,
                  vertical: 7.5.arP,
                ),
                margin: EdgeInsets.only(
                  left: i == 0 ? 16.arP : 12.arP,
                ),
                decoration: BoxDecoration(
                  color: i == 0
                      ? const Color(0xFFFF006E)
                      : const Color(0xFF4A454E).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(
                    20.arP,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  controller.nftTypesChips[i],
                  style: TextStyle(
                    color: i == 0 ? Colors.white : const Color(0xFF958E99),
                    fontSize: i == 0 ? 14.arP : 12.arP,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
          ],
        ),
      );

  Widget _appBarWidget() => Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.arP,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 16.arP,
              child: controller.selectedNftGallery.value.imageType ==
                      AccountProfileImageType.assets
                  ? Image.asset(
                      controller.selectedNftGallery.value.profileImage!)
                  : Image.file(
                      File(controller.selectedNftGallery.value.profileImage!)),
            ),
            SizedBox(
              width: 12.arP,
            ),
            Text(
              controller.selectedNftGallery.value.name!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.arP,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5.arP,
              ),
            ),
            SizedBox(
              width: 4.arP,
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
              size: 18.arP,
            ),
            Expanded(child: Container()),
            Icon(
              Icons.search_rounded,
              color: const Color(0xFF958E99),
              size: 18.arP,
            ),
          ],
        ),
      );
}

/// Nft collection view item stateless widget
class NftCollectionItemWidget extends StatelessWidget {
  final List<NftTokenModel> nftTokens;
  const NftCollectionItemWidget({
    Key? key,
    required this.nftTokens,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        12.arP,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            runSpacing: 12.arP,
            spacing: 8.arP,
            children: _getImagesWidget(),
          ),
          SizedBox(
            height: 12.arP,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              nftTokens[0].fa!.name!,
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
                  : nftTokens[0].creators![0].holder!.alias ??
                      nftTokens[0].creators![0].holder!.address!.tz1Short(),
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
    );
  }

  List<Widget> _getImagesWidget() {
    final List<Widget> images = [];
    // ignore: no_leading_underscores_for_local_identifiers
    List<NftTokenModel> _nftTokens = nftTokens.take(4).toList();
    for (var i = 0; i < _nftTokens.length; i++) {
      images.add(
        SizedBox(
          width: _nftTokens.length == 1
              ? double.infinity
              : _nftTokens.length == 3 && i == 0
                  ? double.infinity
                  : Get.width > 768
                      ? 88.arP
                      : 73.arP,
          height: _nftTokens.length == 1 ? 160.arP : 73.arP,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              8.arP,
            ),
            child: Image.network(
              "https://assets.objkt.media/file/assets-003/${_nftTokens[i].faContract}/${_nftTokens[i].tokenId.toString()}/thumb288",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    if (nftTokens.length > images.length) {
      images.last = Stack(
        children: [
          images.last,
          Container(
            width: Get.width > 768 ? 88.arP : 73.arP,
            height: 74.arP,
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
                  fontSize: 12.arP,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return images;
  }
}
