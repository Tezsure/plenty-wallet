import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/nft_tab_widgets/nft_collectibles.dart';

class NFTabPage extends GetView<AccountSummaryController> {
  const NFTabPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.nftLoading.value
        ? NftSkeleton()
        : controller.userNfts.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  0.04.vspace,
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
                          ]))
                ],
              )
            : RefreshIndicator(
                color: ColorConst.Primary,
                backgroundColor: Colors.transparent,
                onRefresh: () async {
                  controller.contractOffset = 0;
                  controller.contracts.clear();
                  controller.userNfts.clear();
                  controller.fetchAllNfts();
                },
                child: NotificationListener<UserScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification.metrics.extentAfter <= 10 &&
                        controller.contractOffset <
                            controller.contracts.length &&
                        !controller.isLoadingMore) {
                      controller.fetchAllNfts();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    physics: AppConstant.scrollPhysics,
                    padding:
                        EdgeInsets.only(left: 14.aR, right: 14.aR, top: 14.aR),
                    itemCount: controller.userNfts.length +
                        (controller.contractOffset < controller.contracts.length
                            ? 1
                            : 0),
                    shrinkWrap: true,
                    addAutomaticKeepAlives: false,
                    itemBuilder: ((context, index) {
                      if (index == controller.userNfts.length) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 30.arP),
                          child: const Center(
                            child: CupertinoActivityIndicator(
                              color: ColorConst.Primary,
                            ),
                          ),
                        );
                      }
                      return NftCollectibles(
                        nftList: controller.userNfts[
                            controller.userNfts.keys.toList()[index]]!,
                        account:
                            controller.selectedAccount.value.publicKeyHash!,
                      );
                    }),
                  ),
                ),
              ));
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
