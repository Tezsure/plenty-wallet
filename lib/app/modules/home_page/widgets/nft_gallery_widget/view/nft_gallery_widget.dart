import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class NftGalleryWidget extends StatefulWidget {
  const NftGalleryWidget({super.key});

  @override
  State<NftGalleryWidget> createState() => _NftGalleryWidgetState();
}

class _NftGalleryWidgetState extends State<NftGalleryWidget> {
  int currIndex = 0;
  NftGalleryWidgetController controller = Get.put(NftGalleryWidgetController());
  Widget _getNoGalleryStateWidget() => InkWell(
        onTap: () => controller.showCreateNewNftGalleryBottomSheet(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 22.sp,
                right: 18.3.sp,
              ),
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                "assets/nft_page/svg/add_icon.svg",
                height: 38.33.sp,
              ),
            ),
            Container(
              margin: EdgeInsets.all(
                22.sp,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create new gallery",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22.sp,
                    ),
                  ),
                  SizedBox(
                    height: 4.sp,
                  ),
                  Text(
                    "Use a gallery to display NFTs from\nmultiple accounts",
                    style: TextStyle(
                        color: const Color(0xFF958E99),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        letterSpacing: .5),
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget _getGalleryWidget() => GestureDetector(
        // onTap: () => controller.showCreateNewNftGalleryBottomSheet(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.arP),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: PageController(
                viewportFraction: 1,
                initialPage: 0,
              ),
              onPageChanged: (index) {
                currIndex = index;
                setState(() {});
              },
              physics: const BouncingScrollPhysics(),
              itemCount: controller.nftGalleryList.length + 1,
              itemBuilder: (context, index) {
                var scale = currIndex == index ? 1.0 : 0.8;

                if (controller.nftGalleryList.length == index) {
                  return TweenAnimationBuilder(
                      tween: Tween<double>(begin: scale, end: scale),
                      curve: Curves.easeIn,
                      builder: (context, value, child) => Transform.scale(
                            scale: value,
                            child: child,
                          ),
                      duration: const Duration(milliseconds: 350),
                      child: _getNoGalleryStateWidget());
                }
                return TweenAnimationBuilder(
                    tween: Tween<double>(begin: scale, end: scale),
                    curve: Curves.easeIn,
                    builder: (context, value, child) => Transform.scale(
                          scale: value,
                          child: child,
                        ),
                    duration: const Duration(milliseconds: 350),
                    child: GestureDetector(
                      onTap: () => controller.openGallery(index),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            // decoration: BoxDecoration(
                            //     gradient: applePurple,
                            //     image: DecorationImage(
                            //       image: CachedNetworkImageProvider(
                            //         "https://assets.objkt.media/file/assets-003/${controller.nftGalleryList[index].nftTokenModel!.faContract}/${controller.nftGalleryList[index].nftTokenModel!.tokenId.toString()}/thumb400",
                            //       ),
                            //       fit: BoxFit.cover,
                            //     )),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://assets.objkt.media/file/assets-003/${controller.nftGalleryList[index].nftTokenModel!.faContract}/${controller.nftGalleryList[index].nftTokenModel!.tokenId.toString()}/thumb400",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 0.2.height,
                              width: double.infinity,
                              // ignore: prefer_const_constructors
                              decoration: BoxDecoration(
                                  // ignore: prefer_const_constructors
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      colors: [
                                    Colors.transparent,
                                    Colors.grey[900]!.withOpacity(0.6),
                                    Colors.grey[900]!.withOpacity(0.99),
                                  ])),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              margin: EdgeInsets.all(
                                22.sp,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.nftGalleryList[index].name!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.sp,
                                  ),
                                  Text(
                                    controller.nftGalleryList[index]
                                        .nftTokenModel!.name!,
                                    style: TextStyle(
                                      color: const Color(0xFF958E99),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              },
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 26.sp,
        right: 26.sp,
      ),
      height: 0.87.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.arP),
        color: const Color(0xFF1E1C1F),
      ),
      child: Obx(
        () => controller.nftGalleryList.isEmpty
            ? _getNoGalleryStateWidget()
            : _getGalleryWidget(),
      ),
    );
  }
}


/* class NftGalleryWidget extends GetView<NftGalleryWidgetController> {
  const NftGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 26.sp,
        right: 26.sp,
      ),
      height: 0.87.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.arP),
        color: const Color(0xFF1E1C1F),
      ),
      child: Obx(
        () => controller.nftGalleryList.isEmpty
            ? _getNoGalleryStateWidget()
            : _getGalleryWidget(),
      ),
    );
  }

  Widget _getNoGalleryStateWidget() => GestureDetector(
        onTap: () => controller.showCreateNewNftGalleryBottomSheet(),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(
                  top: 22.sp,
                  right: 18.3.sp,
                ),
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  "assets/nft_page/svg/add_icon.svg",
                  height: 38.33.sp,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.all(
                  22.sp,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create new gallery",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(
                      height: 4.sp,
                    ),
                    Text(
                      "Use a gallery to display NFTs from\nmultiple accounts",
                      style: TextStyle(
                          color: const Color(0xFF958E99),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                          letterSpacing: .5),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget _getGalleryWidget() => GestureDetector(
        // onTap: () => controller.showCreateNewNftGalleryBottomSheet(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.arP),
          child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Obx(
                () => PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: PageController(
                    viewportFraction: 1,
                    initialPage: 0,
                  ),
                  onPageChanged: (index) {
                    controller.index.value = index;
                    print("hh");
                  },
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.nftGalleryList.length + 1,
                  itemBuilder: (context, index) {
                    if (controller.nftGalleryList.length == index) {
                      return Obx(
                        () {
                          print("aa");
                          return TweenAnimationBuilder(
                              tween: Tween<double>(
                                  begin: controller.index.value == index
                                      ? 1.0
                                      : 0.8,
                                  end: controller.index.value == index
                                      ? 1.0
                                      : 0.8),
                              curve: Curves.easeIn,
                              builder: (context, value, child) =>
                                  Transform.scale(
                                    scale: value,
                                    child: child,
                                  ),
                              duration: const Duration(milliseconds: 350),
                              child: _getNoGalleryStateWidget());
                        },
                      );
                    }
                    return TweenAnimationBuilder(
                        tween: Tween<double>(
                            begin: controller.index.value == index ? 1.0 : 0.8,
                            end: controller.index.value == index ? 1.0 : 0.8),
                        curve: Curves.easeIn,
                        builder: (context, value, child) => Transform.scale(
                              scale: value,
                              child: child,
                            ),
                        duration: const Duration(milliseconds: 350),
                        child: GestureDetector(
                          onTap: () => controller.openGallery(index),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: CachedNetworkImage(
                                  "https://assets.objkt.media/file/assets-003/${controller.nftGalleryList[index].nftTokenModel!.faContract}/${controller.nftGalleryList[index].nftTokenModel!.tokenId.toString()}/thumb288",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  margin: EdgeInsets.all(
                                    22.sp,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.nftGalleryList[index].name!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 22.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.sp,
                                      ),
                                      Text(
                                        controller.nftGalleryList[index]
                                            .nftTokenModel!.name!,
                                        style: TextStyle(
                                          color: const Color(0xFF958E99),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ));
                  },
                ),
              )),
        ),
      );
}
 */