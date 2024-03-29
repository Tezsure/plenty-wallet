import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:plenty_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../widgets/crypto_tab_widgets/token_checkbox.dart';
import '../widgets/crypto_tab_widgets/token_edit_tile.dart';

class CryptoTabPage extends GetView<AccountSummaryController> {
  CryptoTabPage({super.key});
  final refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                enableTwoLevel: true,
                controller: refreshController,
                onRefresh: () async {
                  await controller.refreshTokens();
                  refreshController.refreshCompleted();
                },
                child: controller.isLoading.value
                    ? const TokensSkeleton()
                    : controller.userTokens.isEmpty
                        ? _buildEmpty()
                        : CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.only(
                                    left: 17.aR,
                                    right: 16.aR,
                                    top: 24.aR,
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) => _tokenBox(
                                          controller.pinnedList[index],
                                          index,
                                          true),
                                      childCount: controller.pinnedList.length,
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.only(
                                      left: 17.aR, right: 16.aR),
                                  sliver: SliverToBoxAdapter(
                                    child: _tokenEditTile(),
                                  ),
                                ),
                                controller.expandTokenList.value
                                    ? SliverPadding(
                                        padding: EdgeInsets.only(
                                          left: 17.aR,
                                          right: 16.aR,
                                        ),
                                        sliver: SliverList(
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) => controller
                                                    .isEditable.value
                                                ? _tokenBox(
                                                    controller
                                                        .unPinnedList[index],
                                                    index,
                                                    false)
                                                : !controller
                                                        .unPinnedList[index]
                                                        .isHidden
                                                    ? _tokenBox(
                                                        controller.unPinnedList[
                                                            index],
                                                        index,
                                                        false)
                                                    : const SizedBox(),
                                            childCount:
                                                controller.unPinnedList.length,
                                          ),
                                        ),
                                      )
                                    : SliverToBoxAdapter(
                                        child: Container(
                                          height:
                                              controller.pinnedList.length == 1
                                                  ? 340.arP
                                                  : controller.pinnedList
                                                              .length ==
                                                          2
                                                      ? 280.arP
                                                      : controller.pinnedList
                                                                  .length ==
                                                              3
                                                          ? 210.arP
                                                          : 145.arP,
                                        ),
                                      ),
                              ]),
              ),
            ),
          ],
        ));
  }

  SingleChildScrollView _buildEmpty() {
    return SingleChildScrollView(
      physics: AppConstant.scrollPhysics,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          0.02.vspace,
          SvgPicture.asset(
            "assets/empty_states/empty1.svg",
            height: 120.aR,
          ),
          0.03.vspace,
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "No token found\n".tr,
                  style: titleLarge.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 22.aR),
                  children: [
                    WidgetSpan(child: 0.04.vspace),
                    TextSpan(
                        text:
                            "Buy or Transfer token from another\n wallet or elsewhere"
                                .tr,
                        style: labelMedium.copyWith(
                            fontSize: 12.aR,
                            color: ColorConst.NeutralVariant.shade60))
                  ])),
        ],
      ),
    );
  }

  Widget _tokenBox(AccountTokenModel token, int index, bool isPinnedList) {
    return TokenCheckbox(
      xtzPrice: controller.xtzPrice.value,
      tokenModel: token,
      isEditable: controller.isEditable.value,
      onCheckboxTap: () => controller.onCheckBoxTap(isPinnedList, index),
    );
  }

  Widget _tokenEditTile() => TokenEditTile(
        showHideButton: (controller.pinnedList.length >= 4),
        showEditButton:
            controller.pinnedList.length == controller.userTokens.length,
        isAnyTokenHidden: controller.showHideButton,
        isAnyTokenPinned: controller.showPinButton,
        isTokenPinnedColor: controller.selectedTokenIndexSet.isNotEmpty,
        isTokenHiddenColor: controller.selectedTokenIndexSet.isNotEmpty,
        viewAll: () => controller.expandTokenList.value =
            !controller.expandTokenList.value,
        expandedTokenList: controller.expandTokenList.value,
        isEditable: controller.isEditable.value,
        onEditTap: controller.onEditTap,
        onPinTap: controller.onPinToken,
        onHideTap: controller.onHideToken,
      );
}

class TokensSkeleton extends StatelessWidget {
  final bool isScrollable;
  final int itemCount;
  const TokensSkeleton(
      {super.key, this.isScrollable = true, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: itemCount == 1 ? 16.arP : 24.aR,
      ),
      child: ListView.builder(
        shrinkWrap: !isScrollable,
        physics: isScrollable
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: itemCount == 1
                ? EdgeInsets.only(left: 32.aR, right: 32.aR, bottom: 16.arP)
                : EdgeInsets.only(left: 16.aR, right: 16.aR, bottom: 16.arP),
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
                  width: 12.arP,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      SizedBox(
                        height: 10.arP,
                      ),
                      SizedBox(
                        child: Shimmer.fromColors(
                          baseColor: const Color(0xff474548),
                          highlightColor:
                              const Color(0xFF958E99).withOpacity(0.2),
                          child: Container(
                            height: 14.arP,
                            width: 60.arP,
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
                      width: 30.arP,
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
        itemCount: itemCount,
      ),
    );
  }
}
