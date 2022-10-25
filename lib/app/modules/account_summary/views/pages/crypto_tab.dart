import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../controllers/account_summary_controller.dart';
import '../widgets/crypto_tab_widgets/token_checkbox.dart';
import '../widgets/crypto_tab_widgets/token_edit_tile.dart';

class CryptoTabPage extends GetView<AccountSummaryController> {
  const CryptoTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.userTokens.isEmpty
        ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/empty_states/empty1.svg",
                  height: 120.sp,
                ),
                0.03.vspace,
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "No token found\n",
                        style: titleLarge.copyWith(fontWeight: FontWeight.w700),
                        children: [
                          WidgetSpan(child: 0.04.vspace),
                          TextSpan(
                              text:
                                  "Buy or Transfer token from another\n wallet or elsewhere",
                              style: labelMedium.copyWith(
                                  color: ColorConst.NeutralVariant.shade60))
                        ])),
                0.05.vspace,
                SolidButton(
                  height: 40.sp,
                  width: 0.5.width,
                  title: "Get token",
                  rowWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/empty_states/coins.png",
                        height: 16.sp,
                        fit: BoxFit.contain,
                      ),
                      0.03.hspace,
                      Text(
                        "Get token",
                        style: titleSmall.apply(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(left: 17.sp, right: 16.sp, top: 24.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.pinnedTokenCounts() > 0 ||
                        controller.selectedPinnedTokenCounts() > 1) ...[
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.userTokens.length,
                        itemBuilder: (_, index) {
                          if (controller.pinnedTokenCounts() == 0) {
                            if (controller.pinAccountList
                                    .contains(controller.userTokens[index]) &&
                                controller.userTokens[index].isSelected ==
                                    true &&
                                !controller.userTokens[index].isHidden) {
                              return TokenCheckbox(
                                  xtzPrice: controller.xtzPrice.value,
                                  tokenModel: controller.userTokens,
                                  isEditable: controller.isEditable.value,
                                  tokenIndex: index,
                                  onCheckboxTap: (value) => controller
                                      .onCheckBoxTap(value ?? false, index),
                                  onPinnedTap: () =>
                                      controller.onPinnedBoxTap(index),
                                  onHiddenTap: () =>
                                      controller.onHideBoxTap(index));
                            } else {
                              return const SizedBox();
                            }
                          } else {
                            if (controller.userTokens[index].isPinned &&
                                controller.userTokens[index].isSelected &&
                                !controller.userTokens[index].isHidden) {
                              return TokenCheckbox(
                                  xtzPrice: controller.xtzPrice.value,
                                  tokenModel: controller.userTokens,
                                  isEditable: controller.isEditable.value,
                                  tokenIndex: index,
                                  onCheckboxTap: (value) => controller
                                      .onCheckBoxTap(value ?? false, index),
                                  onPinnedTap: () =>
                                      controller.onPinnedBoxTap(index),
                                  onHiddenTap: () =>
                                      controller.onHideBoxTap(index));
                            } else {
                              if (controller.pinAccountList
                                      .contains(controller.userTokens[index]) &&
                                  controller.userTokens[index].isSelected ==
                                      true &&
                                  !controller.userTokens[index].isHidden) {
                                return TokenCheckbox(
                                    xtzPrice: controller.xtzPrice.value,
                                    tokenModel: controller.userTokens,
                                    isEditable: controller.isEditable.value,
                                    tokenIndex: index,
                                    onCheckboxTap: (value) => controller
                                        .onCheckBoxTap(value ?? false, index),
                                    onPinnedTap: () =>
                                        controller.onPinnedBoxTap(index),
                                    onHiddenTap: () =>
                                        controller.onHideBoxTap(index));
                              } else {
                                return const SizedBox();
                              }
                            }
                          }
                        },
                      ),
                      0.01.vspace,
                      TokenEditTile(
                        isAnyTokenHidden: controller.onHidePinToken(),
                        isAnyTokenPinned: controller.onShowPinToken(),
                        isTokenPinnedColor: controller.pinTokenColor(),
                        isTokenHiddenColor: controller.hideTokenColor(),
                        viewAll: () => controller.expandTokenList.value =
                            !controller.expandTokenList.value,
                        expandedTokenList: controller.expandTokenList.value,
                        isEditable: controller.isEditable.value,
                        onEditTap: controller.onEditTap,
                        onPinTap: controller.onPinToken,
                        onHideTap: controller.onHideToken,
                      ),
                      0.03.vspace,
                      controller.expandTokenList.value
                          ? ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: controller.userTokens.length,
                              itemBuilder: (_, index) {
                                if (controller
                                            .userTokens[index].isPinned ==
                                        false &&
                                    controller.userTokens[index].isHidden ==
                                        false &&
                                    !controller.pinAccountList.contains(
                                        controller.userTokens[index]) &&
                                    controller.isEditable.isFalse) {
                                  return TokenCheckbox(
                                      xtzPrice: controller.xtzPrice.value,
                                      tokenModel: controller.userTokens,
                                      isEditable: controller.isEditable.value,
                                      tokenIndex: index,
                                      onCheckboxTap: (value) => controller
                                          .onCheckBoxTap(value ?? false, index),
                                      onPinnedTap: () =>
                                          controller.onPinnedBoxTap(index),
                                      onHiddenTap: () =>
                                          controller.onHideBoxTap(index));
                                } else if (controller.isEditable.value &&
                                    !controller.userTokens[index].isPinned &&
                                    !controller.pinAccountList.contains(
                                        controller.userTokens[index])) {
                                  return TokenCheckbox(
                                      xtzPrice: controller.xtzPrice.value,
                                      tokenModel: controller.userTokens,
                                      isEditable: controller.isEditable.value,
                                      tokenIndex: index,
                                      onCheckboxTap: (value) => controller
                                          .onCheckBoxTap(value ?? false, index),
                                      onPinnedTap: () =>
                                          controller.onPinnedBoxTap(index),
                                      onHiddenTap: () =>
                                          controller.onHideBoxTap(index));
                                } else {
                                  return const SizedBox();
                                }
                              },
                            )
                          : const SizedBox(),
                    ] else ...[
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.userTokens.length < 5
                            ? controller.userTokens.length
                            : 4,
                        itemBuilder: (_, index) {
                          return TokenCheckbox(
                              xtzPrice: controller.xtzPrice.value,
                              tokenModel: controller.userTokens,
                              isEditable: controller.isEditable.value,
                              tokenIndex: index,
                              onCheckboxTap: (value) => controller
                                  .onCheckBoxTap(value ?? false, index),
                              onPinnedTap: () =>
                                  controller.onPinnedBoxTap(index),
                              onHiddenTap: () =>
                                  controller.onHideBoxTap(index));
                        },
                      ),
                      0.01.vspace,
                      TokenEditTile(
                        isAnyTokenHidden: controller.onHidePinToken(),
                        isAnyTokenPinned: controller.onShowPinToken(),
                        isTokenPinnedColor: controller.pinTokenColor(),
                        isTokenHiddenColor: controller.hideTokenColor(),
                        viewAll: () => controller.expandTokenList.value =
                            !controller.expandTokenList.value,
                        expandedTokenList: controller.expandTokenList.value,
                        isEditable: controller.isEditable.value,
                        onEditTap: controller.onEditTap,
                        onPinTap: controller.onPinToken,
                        onHideTap: controller.onHideToken,
                      ),
                      controller.expandTokenList.value
                          ? ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: controller.userTokens.length,
                              itemBuilder: (_, index) {
                                return index < 4
                                    ? const SizedBox()
                                    : TokenCheckbox(
                                        xtzPrice: controller.xtzPrice.value,
                                        tokenModel: controller.userTokens,
                                        isEditable: controller.isEditable.value,
                                        tokenIndex: index,
                                        onCheckboxTap: (value) =>
                                            controller.onCheckBoxTap(
                                                value ?? false, index),
                                        onPinnedTap: () =>
                                            controller.onPinnedBoxTap(index),
                                        onHiddenTap: () =>
                                            controller.onHideBoxTap(index));
                              },
                            )
                          : const SizedBox(),
                    ],

                    // Text(
                    //   'Delegate',
                    //   style: labelLarge.copyWith(color: ColorConst.Primary.shade95),
                    // ),
                    // 0.02.vspace,
                    // DelegateTile(
                    //   isDelegated: controller.isAccountDelegated.value,
                    // ),
                    // 0.02.vspace
                  ],
                )),
          ));
  }

  jsonEncode(AccountTokenModel userToken) {}
}
