import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/nft_tab_widgets/nft_collectibles.dart';

class NFTabPage extends GetView<AccountSummaryController> {
  NFTabPage({
    super.key,
  });
  final refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Expanded(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              enableTwoLevel: true,
              controller: refreshController,
              onRefresh: () async {
                await _onRefresh();
                refreshController.refreshCompleted();
              },
              onLoading: () async {
                await controller.fetchAllNfts();
                refreshController.loadComplete();
              },
              child:
                  controller.userNfts.isEmpty && controller.nftLoading.isFalse
                      ? _buildEmptyState()
                      : _buildBody(),
            ),
          ),
        ],
      );
    });
    // return Obx(() => controller.nftLoading.value
    //     ? const NftSkeleton()
    //     : controller.userNfts.isEmpty
    //         ? RefreshIndicator(
    //             color: ColorConst.Primary,
    //             backgroundColor: Colors.transparent,
    //             onRefresh: () async {
    //               controller.contractOffset = 0;
    //               controller.contracts.clear();
    //               controller.userNfts.clear();
    //               controller.fetchAllNfts();
    //             },
    //             child: _buildEmptyState(),
    //           )
    //         : RefreshIndicator(
    //             color: ColorConst.Primary,
    //             backgroundColor: Colors.transparent,
    //             onRefresh: _onRefresh,
    //             child: NotificationListener<UserScrollNotification>(
    //               onNotification: (ScrollNotification notification) {
    //                 if (notification.metrics.extentAfter <= 10 &&
    //                     controller.contractOffset <
    //                         controller.contracts.length &&
    //                     !controller.isLoadingMore) {
    //                   controller.fetchAllNfts();
    //                 }
    //                 return false;
    //               },
    //               child: _buildBody(),
    //             ),
    //           ));
  }

  ListView _buildEmptyState() {
    return ListView(
      children: [
        0.08.vspace,
        SvgPicture.asset(
          "assets/empty_states/empty2.svg",
          height: 120.aR,
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "No Collections".tr,
                style: titleLarge.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 22.aR),
                children: [
                  TextSpan(
                      text: "\nExplore new collectibles on objkt".tr,
                      style: labelMedium.copyWith(
                          fontSize: 12.aR,
                          color: ColorConst.NeutralVariant.shade60))
                ])),
      ],
    );
  }

  Future<void> _onRefresh() async {
    controller.contractOffset = 0;
    controller.contracts.clear();
    controller.userNfts.clear();
    await controller.fetchAllNfts();
  }

  Widget _buildBody() {
    return ListView.builder(
      physics: AppConstant.scrollPhysics,
      padding: EdgeInsets.only(left: 14.aR, right: 14.aR, top: 14.aR),
      itemCount: controller.userNfts.length + 1,
      // (controller.contractOffset < controller.contracts.length ? 1 : 0),
      shrinkWrap: true,
      addAutomaticKeepAlives: false,
      itemBuilder: ((context, index) {
        if (index == controller.userNfts.length) {
          return controller.isLoadingMore
              ? const NftSkeleton()
              : const SizedBox();
        }
        return NftCollectibles(
          nftList:
              controller.userNfts[controller.userNfts.keys.toList()[index]]!,
          account: controller.selectedAccount.value.publicKeyHash!,
        );
      }),
    );
  }
}

class NftSkeleton extends StatelessWidget {
  const NftSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: 24.aR,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  EdgeInsets.only(left: 17.aR, right: 16.aR, bottom: 20.arP),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Shimmer.fromColors(
                      baseColor: const Color(0xff474548),
                      highlightColor: const Color(0xFF958E99).withOpacity(0.2),
                      child: CircleAvatar(
                        radius: 20.arP,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 22.arP,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Shimmer.fromColors(
                            baseColor: const Color(0xff474548),
                            highlightColor:
                                const Color(0xFF958E99).withOpacity(0.2),
                            child: Container(
                              height: 14.arP,
                              width: 100.arP,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.arP),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Shimmer.fromColors(
                      baseColor: const Color(0xff474548),
                      highlightColor: const Color(0xFF958E99).withOpacity(0.2),
                      child: Container(
                        height: 14.arP,
                        width: 20.arP,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.arP),
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }
}
