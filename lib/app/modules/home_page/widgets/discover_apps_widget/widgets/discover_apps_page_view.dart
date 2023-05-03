import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/dapp_models.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/effects/scrolling_dot_effect.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/smooth_page_indicator.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/discover_apps_widget/widgets/dapp_bottomsheet.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/widgets/custom_tab_indicator.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../utils/constants/path_const.dart';
import '../controllers/dapps_page_controller.dart';

class DappsPageView extends GetView<DappsPageController> {
  DappsPageView({Key? key}) : super(key: key);
  // List<String> tabs = ["All", "NFT", "Games", "DeFi"];
  @override
  Widget build(BuildContext context) {
    Get.put(DappsPageController());
    return NaanBottomSheet(
      title: "Discover dApps",
      action: Padding(
        padding: EdgeInsets.only(right: 16.arP),
        child: closeButton(),
      ),
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetHorizontalPadding: 0,
      bottomSheetWidgets: [
        0.02.vspace,
        Obx(() {
          // bool showFav =
          //     controller.dapps.values.any((element) => element.isFavorite!);
          // bool showBanners =
          //     controller.dappBanners.any((p0) => p0.type == "banner");
          // bool showDapps = controller.dapps.values.isNotEmpty;
          return SizedBox(
            height: AppConstant.naanBottomSheetChildHeight - 0.01.height.arP,
            child: ListView.builder(
              itemCount: controller.dappBanners.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.dappBanners.length)
                  return SizedBox(height: .2.height);
                final data = controller.dappBanners[index];
                switch (data.type) {
                  case "banner":
                    return _buildBanner(index);
                  case "h_dappList":
                    return _buildHorizontalDapps(index);
                  case "v_dappList":
                    return _buildVertifcalDapps(index);
                }
                return Container();
              },
            ),
            // SingleChildScrollView(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       if (showFav) _buildHeader("Our favorites"),
            //       if (showFav) _buildHorizontalDapps(),
            //       if (showBanners) _buildHeader("Featured"),
            //       if (showBanners) _buildBanner(),
            //       if (showDapps) _buildHeader("Top DApps"),
            //       if (showDapps) _buildVertifcalDapps()
            //     ],
            //   ),
            // ),
          );
        }),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.arP, top: 30.arP, bottom: 20.arP),
      child: Text(
        title,
        style: titleLarge,
      ),
    );
  }

  Widget _buildBanner(int index) {
    final banners = controller.dappBanners[index].banners?.toList() ?? [];
    if (banners.isEmpty) return Container();
    final height = 435.arP;

    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(controller.dappBanners[index].tag ?? ""),
          Container(
            // width: .75.width,
            height: height + 28.arP,
            child: Swiper(
              loop: false,
              pagination: _buildRectPagination(banners.length),
              containerWidth: .75.width, fade: 0,
              // viewportFraction: .9,
              itemBuilder: (BuildContext context, int index) {
                final banner = banners[index];
                DappModel dapp = controller.dapps[banner.dapp]!;
                return BouncingWidget(
                  onPressed: () {
                    CommonFunctions.bottomSheet(
                      DappBottomSheet(
                        dappModel: dapp,
                      ),
                    );
                  },
                  child: SizedBox(
                    width: .75.width,
                    height: height,
                    child: Container(
                      width: .75.width,
                      height: height,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1A22),
                        borderRadius: BorderRadius.circular(
                          22.arP,
                        ),
                      ),
                      margin: EdgeInsets.only(
                        bottom: 28.arP,
                        left: 16.arP,
                        right: 16.arP,
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              22.arP,
                            ),
                            child: banner.bannerImage!.contains("svg")
                                ? SvgPicture.network(
                                    "${ServiceConfig.naanApis}/images/${banner.bannerImage!}",
                                    fit: BoxFit.cover,
                                    height: height,
                                    width: double.infinity,
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        "${ServiceConfig.naanApis}/images/${banners[index].bannerImage!}",
                                    fit: BoxFit.cover,
                                    height: height,
                                    width: double.infinity,
                                  ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 0.2.height,
                              width: double.infinity,
                              // ignore: prefer_const_constructors
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    22.arP,
                                  ),
                                  // ignore: prefer_const_constructors
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      colors: [
                                        Colors.transparent,
                                        // Colors.grey[900]!.withOpacity(0.33),
                                        Colors.grey[900]!.withOpacity(0.66),
                                        Colors.grey[900]!.withOpacity(0.99),
                                      ])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(24.arP),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner.title!,
                                  style: TextStyle(
                                    fontSize: 28.arP,
                                    color: const Color(0xFFFFFFFF),
                                    letterSpacing: 0.45.arP,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 12.arP,
                                ),
                                Text(
                                  banner.description!,
                                  style: TextStyle(
                                    fontSize: 14.txtArp,
                                    color: const Color(0xFFFFFFFF),
                                    letterSpacing: 0.27.arP,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },

              // indicatorLayout: PageIndicatorLayout.COLOR,
              autoplay: false,
              itemCount: banners.length,
              // pagination: SwiperPagination(),
              // control: SwiperControl(),
            ),
          ),
        ],
      );
    });
  }

  SwiperPagination _buildRectPagination(int length) {
    return SwiperPagination(
        builder: SwiperCustomPagination(builder: (context, config) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(length, (index) {
            bool selected = config.activeIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              width: selected ? 16.arP : 4.arP,
              height: 4.arP,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.arP),
                  color: selected
                      ? Colors.white
                      : ColorConst.NeutralVariant.shade20),
              margin: EdgeInsets.symmetric(horizontal: 4.arP),
            );
          }),
        ),
      );
    }));
  }

  Widget _buildVertifcalDapps(int index) {
    if (controller.dappBanners[index].dapps?.isEmpty ?? true) {
      return Container();
    }

    return Obx(() {
      final dapps = controller.dappBanners[index].dapps!
          .map<DappModel>((e) => controller.dapps[e]!)
          .toList();
      List<String> tabs = controller.dappBanners[index].types ?? [];
      // if (tabs.isNotEmpty) {
      tabs = ["All", ...tabs];
      // }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(controller.dappBanners[index].tag ?? ""),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.arP),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...List.generate(tabs.length, (i) => buildTab(tabs[i], i))
                  ],
                ),
                _switchTabBarView(tabs[controller.selectedTab.value], dapps)
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget noDappsWidget() => SizedBox(
        height: 0.4.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "${PathConst.EMPTY_STATES}no_accounts.svg",
                height: 125.arP,
                width: 125.arP,
              ),
              // 0.05.vspace,
              // Text(
              //   "No dapps found".tr,
              //   textAlign: TextAlign.center,
              //   style: titleLarge,
              // ),
              SizedBox(
                height: 24.arP,
              ),
              Text(
                "No dapps found".tr,
                textAlign: TextAlign.center,
                style: titleMedium.copyWith(color: ColorConst.textGrey1),
              ),
            ],
          ),
        ),
      );

  Widget buildTab(String name, int index) {
    return Obx(() {
      return BouncingWidget(
        onPressed: () {
          controller.selectedTab.value = index;
        },
        child: Container(
          width: 70.arP,
          padding: EdgeInsets.only(right: 4.arP),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: labelLarge.copyWith(
                    fontSize: 14.aR,
                    letterSpacing: 0.1.aR,
                    color: index == controller.selectedTab.value
                        ? Colors.white
                        : ColorConst.NeutralVariant.shade60),
              ),
              Container(
                height: 9.arP,
                width: 70.arP,
                decoration: index != controller.selectedTab.value
                    ? null
                    : MaterialIndicator(
                        color: ColorConst.Primary,
                        height: 4.aR,
                        topLeftRadius: 4.aR,
                        topRightRadius: 4.aR,
                        strokeWidth: 4.aR,
                      ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _switchTabBarView(String type, List<DappModel> dappsList) {
    if (controller.selectedTab.value == 0) {
      return _getDappListWidget(dappsList.toList());
    }
    final dapps = dappsList
        .where((element) =>
            element.type!.toLowerCase().contains(type.toLowerCase()))
        .toList();
    return _getDappListWidget(dapps);
  }

  Widget _getDappListWidget(List<DappModel> dapps) {
    if (dapps.isEmpty) return noDappsWidget();
    return ListView.builder(
      itemCount: dapps.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => DappListItemWidget(
        dapp: dapps[index],
        index: index,
        length: dapps.length,
      ),
    );
  }

  Widget _buildHorizontalDapps(int index) {
    if (controller.dappBanners[index].dapps?.isEmpty ?? true) {
      return Container();
    }
    final dapps = controller.dappBanners[index].dapps!
        .map<DappModel>((e) => controller.dapps[e]!)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(controller.dappBanners[index].tag ?? ""),
        SizedBox(
          height: 75.arP,
          child: ListView.builder(
              padding: EdgeInsets.only(
                left: 16.arP,
              ),
              itemCount: dapps.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: ((context, index) {
                final dapp = dapps[index];
                if (dapp.logo == null) return Container();
                return Padding(
                  padding: EdgeInsets.only(right: 32.0.arP),
                  child: BouncingWidget(
                    onPressed: () {
                      CommonFunctions.bottomSheet(
                        DappBottomSheet(
                          dappModel: dapp,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.arP),
                          child: dapp.favoriteLogo!.endsWith(".svg")
                              ? SvgPicture.network(
                                  "${ServiceConfig.naanApis}/images/${dapp.favoriteLogo!}",
                                  fit: BoxFit.fill,
                                  height: 50.arP,
                                  // placeholderBuilder: (_) => _buildIconPlaceHolder(),
                                  width: 50.arP,
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      "${ServiceConfig.naanApis}/images/${dapp.favoriteLogo!}",
                                  fit: BoxFit.cover,
                                  height: 50.arP,
                                  // placeholder: (context, url) =>
                                  //     _buildIconPlaceHolder(),
                                  memCacheHeight: 92,
                                  // errorWidget: (context, url, error) =>
                                  //     _buildIconPlaceHolder(),
                                  memCacheWidth: 92,
                                  width: 50.arP,
                                ),
                        ),
                        SizedBox(
                          height: 8.arP,
                        ),
                        Text(
                          dapp.name!,
                          style: labelMedium,
                        )
                      ],
                    ),
                  ),
                );
              })),
        ),
      ],
    );
  }

  Container _buildCard(int index, List<DappModel> dapps) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 20.arP,
        left: 16.arP,
        right: 16.arP,
      ),
      decoration: BoxDecoration(
        color: controller.dappBanners[index].type! == "dappList"
            ? const Color(0xFF1E1A22)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(
          22.arP,
        ),
      ),
      child: Stack(
        children: [
          if (controller.dappBanners[index].type! != "dappList")
            ClipRRect(
              borderRadius: BorderRadius.circular(
                22.arP,
              ),
              child: controller.dappBanners[index].bannerImage!.endsWith(".svg")
                  ? SvgPicture.network(
                      "${ServiceConfig.naanApis}/images/${controller.dappBanners[index].bannerImage!}",
                      fit: BoxFit.fill,
                      height: 400.arP,
                      width: double.infinity,
                    )
                  : CachedNetworkImage(
                      imageUrl:
                          "${ServiceConfig.naanApis}/images/${controller.dappBanners[index].bannerImage!}",
                      fit: BoxFit.cover,
                      height: 400.arP,
                      width: double.infinity,
                    ),
            ),
          if (controller.dappBanners[index].type! == "category")
            Container(
              width: double.infinity,
              height: 170.arP,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  22.arP,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: 28.arP,
              left: 14.arP,
              right: 14.arP,
              bottom: 28.arP,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // tag only when type is banner
                if (controller.dappBanners[index].type! == "banner" ||
                    controller.dappBanners[index].type! == "dappList")
                  Text(
                    controller.dappBanners[index].tag!,
                    style: TextStyle(
                      fontSize:
                          controller.dappBanners[index].type! == "dappList"
                              ? 12.arP
                              : 16.arP,
                      color: controller.dappBanners[index].type! == "dappList"
                          ? const Color(0xFF989898)
                          : const Color(0xFFFF006E),
                      letterSpacing: 1.arP,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                Container(
                  margin: EdgeInsets.only(
                    right: 30.arP,
                  ),
                  child: Text(
                    controller.dappBanners[index].title!,
                    style: TextStyle(
                      fontSize:
                          controller.dappBanners[index].type! == "dappList"
                              ? 20.arP
                              : 28.arP,
                      color: const Color(0xFFFFFFFF),
                      letterSpacing: 0.45.arP,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                controller.dappBanners[index].type! != "dappList"
                    ? Container()
                    : _getDappListWidget(dapps),

                // description only when type is banner
              ],
            ),
          ),
          if (controller.dappBanners[index].type! == "banner")
            Positioned(
              bottom: 0,
              left: 0,
              width: 0.82.width,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 28.arP,
                  left: 14.arP,
                  right: 14.arP,
                  bottom: 28.arP,
                ),
                child: Text(
                  controller.dappBanners[index].description!,
                  style: TextStyle(
                    fontSize: 14.txtArp,
                    color: const Color(0xFFFFFFFF),
                    letterSpacing: 0.27.arP,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  openCategoryBottomSheet(DappBannerDatum dappBanner, List<DappModel> dapps) {
    CommonFunctions.bottomSheet(
      CategoryListBottomSheet(dappBanner: dappBanner, dapps: dapps),
    );
  }
}

// ignore: must_be_immutable
class DappListItemWidget extends StatelessWidget {
  int index;
  int length;
  DappModel dapp;

  DappListItemWidget(
      {Key? key, required this.dapp, required this.index, required this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15.arP),
        BouncingWidget(
          onPressed: () {
            CommonFunctions.bottomSheet(
              DappBottomSheet(
                dappModel: dapp,
              ),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // logo
              if (dapp.logo == null)
                _buildIconPlaceHolder()
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.arP),
                  child: dapp.logo!.endsWith(".svg")
                      ? SvgPicture.network(
                          "${ServiceConfig.naanApis}/images/${dapp.logo!}",
                          fit: BoxFit.fill,
                          height: 50.arP,
                          placeholderBuilder: (_) => _buildIconPlaceHolder(),
                          width: 50.arP,
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              "${ServiceConfig.naanApis}/images/${dapp.logo!}",
                          fit: BoxFit.cover,
                          height: 50.arP,
                          placeholder: (context, url) =>
                              _buildIconPlaceHolder(),
                          memCacheHeight: 92,
                          errorWidget: (context, url, error) =>
                              _buildIconPlaceHolder(),
                          memCacheWidth: 92,
                          width: 50.arP,
                        ),
                ),
              SizedBox(width: 12.arP),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // name
                    Text(
                      dapp.name!,
                      style: TextStyle(
                        fontSize: 14.txtArp,
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    // description
                    Text(
                      dapp.description!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.txtArp,
                        color: const Color(0xFF958E99),
                        letterSpacing: 0.27.arP,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.arP),
              // BouncingWidget(
              //   onPressed: () {
              //     NaanAnalytics.logEvent(NaanAnalyticsEvents.DAPP_CLICK,
              //         param: {
              //           "type": "click",
              //           "name": dapp.name,
              //           "url": dapp.url
              //         });
              //     CommonFunctions.bottomSheet(
              //       const DappBrowserView(),
              //       fullscreen: true,
              //       settings: RouteSettings(
              //         arguments: dapp.url,
              //       ),
              //     );
              //   },
              //   // Get.bottomSheet(
              //   //   DappBottomSheet(
              //   //     dappModel: dapp,
              //   //   ),
              //   //   isScrollControlled: true,
              //   //   enableDrag: true,
              //   //   enterBottomSheetDuration: const Duration(milliseconds: 200),
              //   //   exitBottomSheetDuration: const Duration(milliseconds: 200),
              //   // ),
              //   child: Container(
              //     height: 32.arP,
              //     width: 79.arP,
              //     decoration: BoxDecoration(
              //       color: const Color(0xFF332F37),
              //       borderRadius: BorderRadius.circular(20.arP),
              //     ),
              //     alignment: Alignment.center,
              //     child: Text(
              //       "Launch".tr,
              //       style: TextStyle(
              //         fontSize: 14.arP,
              //         color: const Color(0xFF958E99),
              //         letterSpacing: 0.5.arP,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
        index == length - 1
            ? Container()
            : Container(
                height: 1.arP,
                margin: EdgeInsets.only(
                  left: 63.arP,
                  top: 15.arP,
                ),
                color: const Color(0xFF332F37),
              ),
      ],
    );
  }

  SizedBox _buildIconPlaceHolder() {
    return SizedBox(
      height: 50.arP,
      width: 50.arP,
      child: Shimmer.fromColors(
        baseColor: const Color(0xff474548),
        highlightColor: const Color(0xFF958E99).withOpacity(0.2),
        child: Container(
          height: 50.arP,
          width: 50.arP,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.arP),
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class CategoryListBottomSheet extends StatelessWidget {
  DappBannerDatum dappBanner;
  List<DappModel> dapps = [];
  CategoryListBottomSheet(
      {Key? key, required this.dappBanner, required this.dapps})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18.arP),
        topRight: Radius.circular(18.arP),
      ),
      child: Container(
        height: 0.9.height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.arP),
            topRight: Radius.circular(18.arP),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 0.3.height,
              child: Stack(
                children: [
                  // image
                  dappBanner.bannerImage!.endsWith('.svg')
                      ? SvgPicture.network(
                          "${ServiceConfig.naanApis}/images/${dappBanner.bannerImage!}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : CachedNetworkImage(
                          imageUrl:
                              "${ServiceConfig.naanApis}/images/${dappBanner.bannerImage!}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),

                  // gradient
                  Container(
                    width: double.infinity,
                    height: 0.3.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        18.arP,
                      ),
                    ),
                  ),

                  // back
                  Positioned(
                    top: 30.arP,
                    left: 14.arP,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18.arP,
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 5.arP,
                      width: 36.arP,
                      margin: EdgeInsets.only(
                        top: 5.arP,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color(0xffEBEBF5).withOpacity(0.3),
                      ),
                    ),
                  ),

                  // title
                  Positioned(
                    bottom: 30.arP,
                    left: 14.arP,
                    right: 14.arP,
                    child: Text(
                      dappBanner.title!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 28.arP,
                        letterSpacing: 0.45.arP,
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.arP,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  left: 16.arP,
                  right: 16.arP,
                ),
                itemCount: dapps.length,
                physics: AppConstant.scrollPhysics,
                itemBuilder: (context, index) => DappListItemWidget(
                  dapp: dapps[index],
                  index: index,
                  length: dapps.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
