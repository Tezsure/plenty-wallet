import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/custom_packages/animated_scroll_indicator/smooth_page_indicator.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../custom_packages/animated_scroll_indicator/effects/scrolling_dot_effect.dart';

class NftGalleryWidget extends StatefulWidget {
  const NftGalleryWidget({super.key});

  @override
  State<NftGalleryWidget> createState() => _NftGalleryWidgetState();
}

class _NftGalleryWidgetState extends State<NftGalleryWidget>
    with AutomaticKeepAliveClientMixin {
  int currIndex = 0;
  NftGalleryWidgetController controller =
      Get.find<NftGalleryWidgetController>();
  Widget _getNoGalleryStateWidget() => BouncingWidget(
        onPressed: () => controller.showCreateNewNftGalleryBottomSheet(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.arP),
            // color: Colors.white,
            color: const Color(0xFF1E1C1F),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 22.arP,
                  right: 22.arP,
                ),
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  "assets/nft_page/svg/add_icon.svg",
                  height: 38.33.arP,
                ),
              ),
              Container(
                margin: EdgeInsets.all(
                  22.arP,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create gallery".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.arP,
                      ),
                    ),
                    SizedBox(
                      height: 4.arP,
                    ),
                    Text(
                      "Display NFTs from multiple\nwallets".tr,
                      style: TextStyle(
                        color: const Color(0xFF958E99),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.arP,
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _getLoadingGallerySkeleton() => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.arP),
        // color: Colors.white,
        color: const Color(0xFF1E1C1F),
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xff474548),
        highlightColor: const Color(0xFF958E99).withOpacity(0.2),
        child: Container(
            decoration: BoxDecoration(
          color: const Color(0xff474548),
          borderRadius: BorderRadius.circular(22.arP),
        )),
      ));

  Widget _getGalleryWidget() => ClipRRect(
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
            physics: AppConstant.scrollPhysics,
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
              // final String image =
              //     "https://assets.objkt.media/file/assets-003/${controller.nftGalleryList[index].nftTokenModel!.faContract}/${controller.nftGalleryList[index].nftTokenModel!.tokenId.toString()}/thumb400";
              return TweenAnimationBuilder(
                  tween: Tween<double>(begin: scale, end: scale),
                  curve: Curves.easeIn,
                  builder: (context, value, child) => Transform.scale(
                        scale: value,
                        child: child,
                      ),
                  duration: const Duration(milliseconds: 350),
                  child: BouncingWidget(
                    onPressed: () => controller.openGallery(index),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
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
                            child: NFTImage(
                                nftTokenModel: controller
                                    .nftGalleryList[index].nftTokenModel!),
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
                                22.arP,
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
                                      fontSize: 22.arP,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.arP,
                                  ),
                                  Text(
                                    controller.nftGalleryList[index]
                                            .nftTokenModel?.name ??
                                        "",
                                    style: TextStyle(
                                      color: const Color(0xFF958E99),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.arP,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.only(
          left: 22.arP,
          right: 10.arP,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                // color: Colors.red,
                width: double.infinity,

                height: 0.87.width,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(22.arP),
                //   // color: Colors.white,
                //   color: const Color(0xFF1E1C1F),
                // ),
                child: Obx(
                  () => controller.loading.value
                      ? _getLoadingGallerySkeleton()
                      : controller.nftGalleryList.isEmpty
                          ? _getNoGalleryStateWidget()
                          : _getGalleryWidget(),
                ),
              ),
            ),
            SizedBox(
              width: 8.arP,
            ),
            if (controller.nftGalleryList.isNotEmpty)
              SizedBox(
                width: 4.arP,
                child: AnimatedSmoothIndicator(
                    effect: ScrollingDotsEffect(
                      dotHeight: 4.arP,
                      dotWidth: 4.arP,
                      // expansionFactor: 1.01,
                      activeDotColor: Colors.white,
                      dotColor: ColorConst.darkGrey,
                    ),
                    curve: Curves.easeIn,
                    axisDirection: Axis.vertical,
                    activeIndex: currIndex,
                    count: controller.nftGalleryList.length + 1),
              )
            else
              SizedBox(
                width: 4.arP,
              ),
          ],
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}


/* class NftGalleryWidget extends GetView<NftGalleryWidgetController> {
  const NftGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 26.arP,
        right: 26.arP,
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
                  top: 22.arP,
                  right: 18.3.arP,
                ),
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  "assets/nft_page/svg/add_icon.svg",
                  height: 38.33.arP,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.all(
                  22.arP,
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
                        fontSize: 22.arP,
                      ),
                    ),
                    SizedBox(
                      height: 4.arP,
                    ),
                    Text(
                      "Use a gallery to display NFTs from\nmultiple accounts",
                      style: TextStyle(
                          color: const Color(0xFF958E99),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.arP,
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
                                    22.arP,
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
                                          fontSize: 22.arP,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.arP,
                                      ),
                                      Text(
                                        controller.nftGalleryList[index]
                                            .nftTokenModel!.name!,
                                        style: TextStyle(
                                          color: const Color(0xFF958E99),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.arP,
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