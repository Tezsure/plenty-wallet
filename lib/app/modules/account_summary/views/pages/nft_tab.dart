import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../widgets/nft_tab_widgets/nft_collectibles.dart';

class NFTabPage extends GetView<AccountSummaryController> {
  const NFTabPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? const Center(
            child: CircularProgressIndicator(
              color: ColorConst.Primary,
            ),
          )
        : controller.userNfts.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  0.04.vspace,
                  SvgPicture.asset(
                    "assets/empty_states/empty2.svg",
                    height: 120.aR,
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "No Collections",
                          style: titleLarge.copyWith(
                              fontWeight: FontWeight.w700, fontSize: 22.aR),
                          children: [
                            TextSpan(
                                text: "\nExplore new collectibles on objkt",
                                style: labelMedium.copyWith(
                                    fontSize: 12.aR,
                                    color: ColorConst.NeutralVariant.shade60))
                          ]))
                ],
              )
            : NotificationListener<UserScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification.metrics.extentAfter <= 10 &&
                      controller.contractOffset < controller.contracts.length &&
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
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorConst.Primary,
                        ),
                      );
                    }
                    return NftCollectibles(
                      nftList: controller
                          .userNfts[controller.userNfts.keys.toList()[index]]!,
                      account: controller.selectedAccount.value.publicKeyHash!,
                    );
                  }),
                )));
  }
}
