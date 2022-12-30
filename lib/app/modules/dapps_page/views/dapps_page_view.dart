import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/dapp_models.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/dapps_page/views/widgets/dapp_bottomsheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../controllers/dapps_page_controller.dart';

class DappsPageView extends GetView<DappsPageController> {
  const DappsPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DappsPageController());
    return Container(
      height: 0.95.height,
      width: 1.width,
      padding: EdgeInsets.only(
        bottom: Platform.isIOS ? 0.05.height : 0.02.height,
      ),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: Colors.black),
      child: Column(
        children: [
          SizedBox(
            height: 5.arP,
          ),
          Container(
            height: 5.arP,
            width: 36.arP,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
            ),
          ),
          SizedBox(
            height: 41.arP,
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.dappBanners.length,
                itemBuilder: (context, index) {
                  List<DappModel> dapps = controller.dappBanners[index].dapps!
                      .map<DappModel>((e) => controller.dapps[e]!)
                      .toList();

                  return GestureDetector(
                    onTap: () => controller.dappBanners[index].type! == "banner"
                        ? Get.bottomSheet(
                            DappBottomSheet(
                              dappModel: dapps[0],
                            ),
                            isScrollControlled: true,
                            enableDrag: true,
                            enterBottomSheetDuration:
                                const Duration(milliseconds: 200),
                            exitBottomSheetDuration:
                                const Duration(milliseconds: 200),
                          )
                        : controller.dappBanners[index].type! == "category"
                            ? openCategoryBottomSheet(
                                controller.dappBanners[index], dapps)
                            : null,
                    child: Container(
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
                              child: controller.dappBanners[index].bannerImage!
                                      .endsWith(".svg")
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
                                if (controller.dappBanners[index].type! ==
                                        "banner" ||
                                    controller.dappBanners[index].type! ==
                                        "dappList")
                                  Text(
                                    controller.dappBanners[index].tag!,
                                    style: TextStyle(
                                      fontSize:
                                          controller.dappBanners[index].type! ==
                                                  "dappList"
                                              ? 12.arP
                                              : 16.arP,
                                      color:
                                          controller.dappBanners[index].type! ==
                                                  "dappList"
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
                                          controller.dappBanners[index].type! ==
                                                  "dappList"
                                              ? 20.arP
                                              : 28.arP,
                                      color: const Color(0xFFFFFFFF),
                                      letterSpacing: 0.45.arP,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),

                                controller.dappBanners[index].type! !=
                                        "dappList"
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
                                    fontSize: 14.arP,
                                    color: const Color(0xFFFFFFFF),
                                    letterSpacing: 0.27.arP,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDappListWidget(List<DappModel> dapps) {
    return ListView.builder(
      itemCount: dapps.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => DappListItemWidget(
        dapp: dapps[index],
        index: index,
        length: dapps.length,
      ),
    );
  }

  openCategoryBottomSheet(DappBannerModel dappBanner, List<DappModel> dapps) {
    Get.bottomSheet(
      CategoryListBottomSheet(dappBanner: dappBanner, dapps: dapps),
      isScrollControlled: true,
      enableDrag: true,
      enterBottomSheetDuration: const Duration(milliseconds: 200),
      exitBottomSheetDuration: const Duration(milliseconds: 200),
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
        GestureDetector(
          onTap: () {
            Get.bottomSheet(
              DappBottomSheet(
                dappModel: dapp,
              ),
              isScrollControlled: true,
              enableDrag: true,
              enterBottomSheetDuration: const Duration(milliseconds: 200),
              exitBottomSheetDuration: const Duration(milliseconds: 200),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // logo
              ClipRRect(
                borderRadius: BorderRadius.circular(10.arP),
                child: dapp.logo!.endsWith(".svg")
                    ? SvgPicture.network(
                        "${ServiceConfig.naanApis}/images/${dapp.logo!}",
                        fit: BoxFit.fill,
                        height: 50.arP,
                        width: 50.arP,
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            "${ServiceConfig.naanApis}/images/${dapp.logo!}",
                        fit: BoxFit.cover,
                        height: 50.arP,
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
                        fontSize: 14.arP,
                        color: const Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    // description
                    Text(
                      dapp.description!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.arP,
                        color: const Color(0xFF958E99),
                        letterSpacing: 0.27.arP,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.arP),
              InkWell(
                onTap: () {
                  Get.bottomSheet(
                    const DappBrowserView(),
                    barrierColor: Colors.white.withOpacity(0.09),
                    settings: RouteSettings(
                      arguments: dapp.url,
                    ),
                    isScrollControlled: true,
                  );
                },
                // Get.bottomSheet(
                //   DappBottomSheet(
                //     dappModel: dapp,
                //   ),
                //   isScrollControlled: true,
                //   enableDrag: true,
                //   enterBottomSheetDuration: const Duration(milliseconds: 200),
                //   exitBottomSheetDuration: const Duration(milliseconds: 200),
                // ),
                child: Container(
                  height: 32.arP,
                  width: 79.arP,
                  decoration: BoxDecoration(
                    color: const Color(0xFF332F37),
                    borderRadius: BorderRadius.circular(20.arP),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Launch",
                    style: TextStyle(
                      fontSize: 14.arP,
                      color: const Color(0xFF958E99),
                      letterSpacing: 0.5.arP,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
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
}

class CategoryListBottomSheet extends StatelessWidget {
  DappBannerModel dappBanner;
  List<DappModel> dapps = [];
  CategoryListBottomSheet(
      {Key? key, required this.dappBanner, required this.dapps})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: ClipRRect(
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
                        : Image.network(
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
                  physics: const BouncingScrollPhysics(),
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
      ),
    );
  }
}
