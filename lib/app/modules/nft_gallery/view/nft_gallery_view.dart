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
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/app/modules/nft_gallery/controller/nft_gallery_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/manage_accounts_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class NftGalleryView extends GetView<NftGalleryController> {
  const NftGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NftGalleryController());
    return Obx(
      () => !controller.isSearch.value
          ? BackdropFilter(
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
/*                         SizedBox(
                          height: 24.arP,
                        ),
                        _getNftTypesChips(), */
                        SizedBox(
                          height: 24.arP,
                        ),
                        NotificationListener<UserScrollNotification>(
                          onNotification: (notification) {
                            final ScrollDirection direction =
                                notification.direction;
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
                                ? _getCollectionGridViewWidget(
                                    controller.galleryNfts)
                                : controller.selectedGalleryFilter.value ==
                                        NftGalleryFilter.list
                                    ? _getNftListViewWidget(
                                        2.1, controller.galleryNfts)
                                    : _getNftListViewWidget(
                                        1.1, controller.galleryNfts),
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
            )
          : BackdropFilter(
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
                          height: 16.arP,
                        ),
                        _searchAppBarWidget(),
                        SizedBox(
                          height: 25.arP,
                        ),
                        controller.searchText.value.isEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: 0.03.height),
                                child: Text(
                                  "Try searching for an artist, \ncollection name or NFT name",
                                  textAlign: TextAlign.center,
                                  style: bodyMedium.copyWith(
                                      color: ColorConst.grey),
                                ),
                              )
                            : controller.searchNfts.isEmpty
                                ? Container(
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
                                          "Probably Nothing",
                                          textAlign: TextAlign.center,
                                          style: titleLarge,
                                        ),
                                        SizedBox(
                                          height: 0.01.height,
                                        ),
                                        Text(
                                          "We didn’t find any results. Did you \nmisspell your query?",
                                          textAlign: TextAlign.center,
                                          style: bodySmall.copyWith(
                                              color: ColorConst.grey),
                                        ),
                                      ],
                                    ),
                                  )
                                : controller.searchNfts.length == 1 &&
                                        controller.searchNfts.entries.first
                                                .value.length ==
                                            1
                                    ? _getNftListViewWidget(
                                        1.1, controller.searchNfts)
                                    : _getCollectionGridViewWidget(
                                        controller.searchNfts),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _getHoverFilterWidget() => AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 145.arP,
        height: 50.arP,
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
            width: 18.arP,
            fit: BoxFit.fill,
            color: controller.selectedGalleryFilter.value == filter
                ? Colors.white
                : const Color(0xFF958E99)),
      );

  Widget _getNftListViewWidget(
          [double crossAxisCount = 2.1,
          Map<String, List<NftTokenModel>> nfts = const {}]) =>
      Expanded(
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
                      nfts.values.toList()[index][0],
                      nfts.values.toList()[index].length,
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
                                        nfts.values.toList()[index].length == 1
                                    ? 1
                                    : crossAxisCount == 1.1
                                        ? 1
                                        : 2)
                            .toInt(),
                        mainAxisSpacing: 12.arP,
                        crossAxisSpacing: 12.arP,
                        itemCount: nfts.values.toList()[index].length,
                        itemBuilder: ((context, i) {
                          var _nftTokenModel = nfts.values.toList()[index][i];
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
            itemCount: nfts.length,
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

  Widget _getCollectionGridViewWidget(Map<String, List<NftTokenModel>> nfts) =>
      Obx(
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
              itemCount: nfts.length,
              itemBuilder: (context, index) => Container(
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
                        nftTokens: nfts.values.toList()[index],
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
            GestureDetector(
              onTap: () async {
                await Get.bottomSheet(
                  _selectGallery(controller.selectedGalleryIndex.value),
                  enterBottomSheetDuration: const Duration(milliseconds: 180),
                  exitBottomSheetDuration: const Duration(milliseconds: 150),
                );
                controller.isEditing.value = false;
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 16.arP,
                    child: controller.selectedNftGallery.value.imageType ==
                            AccountProfileImageType.assets
                        ? Image.asset(
                            controller.selectedNftGallery.value.profileImage!)
                        : Image.file(File(
                            controller.selectedNftGallery.value.profileImage!)),
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
                ],
              ),
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                controller.isSearch.value = true;
              },
              child: Icon(
                Icons.search_rounded,
                color: const Color(0xFF958E99),
                size: 18.arP,
              ),
            ),
          ],
        ),
      );

  Widget _searchAppBarWidget() => Row(
        children: [
          SizedBox(
              width: 1.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                              onChanged: ((value) => controller
                                  .searchNftGallery(value.toLowerCase())),
                              autofocus: true,
                              textAlignVertical: TextAlignVertical.center,
                              style: bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: const Color(0xFFB0A9B3),
                                  size: 18.sp,
                                ),
                                hintText: "Search",
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
                      GestureDetector(
                        onTap: () {
                          controller.isSearch.value = false;
                          controller.searchText.value = "";
                          controller.searchNfts.clear();
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 7.0),
                          child: Text(
                            "Cancel",
                            style:
                                bodyMedium.copyWith(color: ColorConst.Primary),
                          ),
                        ),
                      )
                    ]),
              )),
        ],
      );

  Widget _selectGallery(int galleryIndex) => Obx(
        () => Container(
          width: 1.width,
          height: 0.5.height,
          padding: EdgeInsets.only(
            bottom: Platform.isIOS ? 0.05.height : 0.02.height,
          ),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              color: Colors.black),
          child: Stack(
            children: [
              Positioned(
                top: 10 + 0.045.height,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    controller.isEditing.value = !controller.isEditing.value;
                  },
                  child: Text(controller.isEditing.value ? "Cancel" : "Edit",
                      style: bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorConst.Primary)),
                ),
              ),
              Column(
                children: [
                  0.005.vspace,
                  Container(
                    height: 5,
                    width: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                    ),
                  ),
                  0.04.vspace,
                  Text("Galleries", style: titleLarge),
                  0.04.vspace,
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return index == controller.nftGalleryList.length
                            ? GestureDetector(
                                onTap: () async {
                                  Get.back(closeOverlays: true);
                                  Get.back(closeOverlays: true);

                                  Get.find<NftGalleryWidgetController>()
                                      .showCreateNewNftGalleryBottomSheet();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "${PathConst.EMPTY_STATES}plus.png",
                                        height: 16.aR,
                                        fit: BoxFit.contain,
                                        scale: 1,
                                      ),
                                      0.02.hspace,
                                      Text(
                                        "Create a new Gallery",
                                        style: labelLarge.copyWith(
                                            fontSize: 14.aR,
                                            color: ColorConst.Primary,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  if (!controller.isEditing.value) {
                                    controller.changeSelectedNftGallery(index);
                                    Get.back(result: index);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Container(
                                          height: 32.sp,
                                          width: 32.sp,
                                          alignment: Alignment.bottomRight,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: controller
                                                          .nftGalleryList[index]
                                                          .imageType ==
                                                      AccountProfileImageType
                                                          .assets
                                                  ? AssetImage(controller
                                                      .nftGalleryList[index]
                                                      .profileImage
                                                      .toString())
                                                  : FileImage(
                                                      File(
                                                        controller
                                                            .nftGalleryList[
                                                                index]
                                                            .profileImage
                                                            .toString(),
                                                      ),
                                                    ) as ImageProvider,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                          controller.nftGalleryList[index].name
                                              .toString(),
                                          style: bodySmall.copyWith(
                                              fontWeight: FontWeight.w600)),
                                      controller.isEditing.value
                                          ? Expanded(
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: PopupMenuButton(
                                                    position:
                                                        PopupMenuPosition.under,
                                                    enableFeedback: true,
                                                    onCanceled: () => controller
                                                        .isTransactionPopUpOpened
                                                        .value = false,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    color:
                                                        const Color(0xff421121),
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder: (_) {
                                                      controller
                                                          .isTransactionPopUpOpened
                                                          .value = true;

                                                      return <PopupMenuEntry>[
                                                        CustomPopupMenuItem(
                                                          height: 30.sp,
                                                          width: 120.sp,
                                                          onTap: () {
                                                            controller
                                                                .editGallery(
                                                                    index);
                                                          },
                                                          padding:
                                                              EdgeInsets.zero,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: 10.sp,
                                                                ),
                                                                child: Text(
                                                                  "Edit",
                                                                  style:
                                                                      labelMedium,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10.sp,
                                                              ),
                                                              const Divider(
                                                                  height: 0,
                                                                  color: Color(
                                                                      0xff802040)),
                                                            ],
                                                          ),
                                                        ),
                                                        CustomPopupMenuItem(
                                                          height: 30.sp,
                                                          width: 120.sp,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10.sp),
                                                          onTap: () {
                                                            Get.back();
                                                            Get.back();
                                                            Get.bottomSheet(
                                                              _removeGallery(
                                                                  index),
                                                              enterBottomSheetDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          180),
                                                              exitBottomSheetDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          150),
                                                            );
                                                          },
                                                          child: Text(
                                                            "Remove",
                                                            style: labelMedium
                                                                .copyWith(
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                        ),
                                                      ];
                                                    },
                                                    child: Icon(
                                                      Icons.more_horiz,
                                                      size: 24.aR,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                            )
                                          : galleryIndex == index
                                              ? Expanded(
                                                  child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    height: 16.sp,
                                                    width: 16.sp,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      "assets/svg/check2.svg",
                                                      height: 16.sp,
                                                      width: 16.sp,
                                                    ),
                                                  ),
                                                ))
                                              : const Spacer()
                                    ],
                                  ),
                                ),
                              );
                      },
                      itemCount: controller.nftGalleryList.length + 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _removeGallery(int galleryIndex) => Container(
        width: 1.width,
        height: 0.38.height,
        padding: EdgeInsets.only(
          bottom: Platform.isIOS ? 0.05.height : 0.02.height,
        ),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        child: Column(
          children: [
            0.005.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60,
              ),
            ),
            0.04.vspace,
            Text("Remove Gallery", style: titleLarge),
            0.02.vspace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.175.width),
              child: Text(
                "Do you want to remove ${controller.nftGalleryList[galleryIndex].name} from your gallery list?",
                style: bodySmall.copyWith(
                  color: ColorConst.NeutralVariant.shade60,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.sp),
                    child: TextButton(
                        onPressed: () {
                          controller.removeGallery(galleryIndex);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorConst.darkGrey,
                            ),
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.sp),
                              child: Text(
                                "Remove",
                                style: titleSmall.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              ),
                            )))),
                  ),
                  SizedBox(
                    height: 4.sp,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.sp),
                    child: TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorConst.darkGrey,
                            ),
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.sp),
                              child: Text(
                                "Cancel",
                                style: titleSmall.copyWith(
                                    fontWeight: FontWeight.w600),
                              ),
                            )))),
                  ),
                  0.01.vspace,
                ],
              ),
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
