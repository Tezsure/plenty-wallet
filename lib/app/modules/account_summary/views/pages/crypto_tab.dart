import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
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
                0.02.vspace,
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
                    // Pinned Token Section
                    if (controller.pinTokenSet.isNotEmpty &&
                        controller.pinTokenSet.length > 4) ...[
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.userTokens.length,
                        itemBuilder: (_, index) {
                          String tokenName = controller.userTokens[index].name!;
                          return controller.pinTokenSet.contains(tokenName) &&
                                  !controller.hideTokenSet.contains(tokenName)
                              ? _tokenBox(index)
                              : const SizedBox();
                        },
                      ),
                      // Token Edit Tile
                      if (controller.userTokens.length > 4) ...[
                        _tokenEditTile(),
                        controller.expandTokenList.value
                            ? ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: controller.userTokens.length,
                                itemBuilder: (_, index) {
                                  String tokenName =
                                      controller.userTokens[index].name!;
                                  return controller.isEditable.isFalse &&
                                          !controller.pinTokenSet
                                              .contains(tokenName) &&
                                          !controller.hideTokenSet
                                              .contains(tokenName)
                                      ? _tokenBox(index)
                                      : controller.isEditable.isTrue &&
                                              !controller.pinTokenSet
                                                  .contains(tokenName)
                                          ? _tokenBox(index)
                                          : const SizedBox();
                                },
                              )
                            : const SizedBox(),
                      ] else
                        _tokenEditTile(true),
                    ] else ...[
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.userTokens.length,
                        itemBuilder: (_, index) {
                          String tokenName = controller.userTokens[index].name!;
                          return index < 4
                              ? controller.pinTokenSet.contains(tokenName) &&
                                      !controller.hideTokenSet
                                          .contains(tokenName)
                                  ? _tokenBox(index)
                                  : _tokenBox(index)
                              : const SizedBox();
                        },
                      ),
                      // Token Edit Tile
                      if (controller.userTokens.length > 4) ...[
                        _tokenEditTile(),
                        controller.expandTokenList.value
                            ? ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: controller.userTokens.length,
                                itemBuilder: (_, index) {
                                  String tokenName =
                                      controller.userTokens[index].name!;
                                  return index < 4
                                      ? const SizedBox()
                                      : controller.isEditable.isFalse &&
                                              !controller.pinTokenSet
                                                  .contains(tokenName) &&
                                              !controller.hideTokenSet
                                                  .contains(tokenName)
                                          ? _tokenBox(index)
                                          : controller.isEditable.isTrue &&
                                                  !controller.pinTokenSet
                                                      .contains(tokenName)
                                              ? _tokenBox(index)
                                              : const SizedBox();
                                },
                              )
                            : const SizedBox(),
                      ] else
                        _tokenEditTile(true),
                    ],
                  ],
                )),
          ));
  }

  Widget _tokenBox(int index) => TokenCheckbox(
      xtzPrice: controller.xtzPrice.value,
      tokenModel: controller.userTokens,
      isEditable: controller.isEditable.value,
      tokenIndex: index,
      onCheckboxTap: (value) => controller.onCheckBoxTap(index),
      onPinnedTap: () => controller.isPinTapped(index),
      onHiddenTap: () => controller.isHideTapped(index));

  Widget _tokenEditTile([bool showEdit = false]) => TokenEditTile(
        showHideButton: (controller.userTokens.length > 4),
        showEditButton: showEdit,
        isAnyTokenHidden: controller.onHideTokenClick,
        isAnyTokenPinned: controller.onPinTokenClick,
        isTokenPinnedColor: controller.pinButtonColor,
        isTokenHiddenColor: controller.hideButtonColor,
        viewAll: () => controller.expandTokenList.value =
            !controller.expandTokenList.value,
        expandedTokenList: controller.expandTokenList.value,
        isEditable: controller.isEditable.value,
        onEditTap: controller.onEditTap,
        onPinTap: controller.onPinToken,
        onHideTap: controller.onHideToken,
      );
}
