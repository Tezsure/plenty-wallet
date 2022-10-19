import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/empty_states/empty1.svg",
                height: 180.sp,
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
                width: 0.5.width,
                title: "Get token",
                rowWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/empty_states/coins.png"),
                    0.03.hspace,
                    Text(
                      "Get token",
                      style: titleSmall.apply(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          )
        : SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.userTokens
                        .where((e) =>
                            (e.isSelected == true) && e.isHidden == false)
                        .toList()
                        .isNotEmpty) ...[
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.userTokens.length < 3
                            ? controller.userTokens.length
                            : (controller.expandTokenList.value)
                                ? controller.userTokens.length
                                : 3,
                        itemBuilder: (_, index) => controller
                                    .userTokens[index].isHidden &&
                                !controller.isEditable.value &&
                                controller.userTokens[index].isPinned
                            ? const SizedBox()
                            : controller.userTokens[index].isPinned ||
                                    controller.userTokens[index].isSelected &&
                                        !controller.userTokens[index].isHidden
                                ? TokenCheckbox(
                                    xtzPrice: controller.xtzPrice.value,
                                    tokenModel: controller.userTokens,
                                    isEditable: controller.isEditable.value,
                                    tokenIndex: index,
                                    onCheckboxTap: (value) {
                                      controller
                                        ..userTokens[index].isSelected =
                                            value ?? false
                                        ..userTokens.refresh();
                                    },
                                    onPinnedTap: () {
                                      controller
                                        ..userTokens[index].isPinned =
                                            !controller
                                                .userTokens[index].isPinned
                                        ..userTokens.refresh();
                                    },
                                    onHiddenTap: () {
                                      controller
                                        ..userTokens[index].isHidden =
                                            !controller
                                                .userTokens[index].isHidden
                                        ..userTokens.refresh();
                                    },
                                  )
                                : const SizedBox(),
                      ),
                      0.01.vspace,
                      TokenEditTile(
                        isAnyTokenHidden: controller.onHidePinToken(),
                        isAnyTokenPinned: controller.onShowPinToken(),
                        isTokenPinnedColor: controller.pinTokenColor(),
                        isTokenHiddenColor: controller.hideTokenColor(),
                        showEditButton: controller.userTokens
                                    .where((e) =>
                                        (e.isSelected == true) &&
                                        e.isHidden == false &&
                                        e.isPinned == true)
                                    .toList()
                                    .length -
                                1 <
                            3,
                        viewAll: () => controller.expandTokenList.value =
                            !controller.expandTokenList.value,
                        expandedTokenList: controller.expandTokenList.value,
                        isEditable: controller.isEditable.value,
                        onEditTap: controller.onEditTap,
                        onPinTap: controller.onPinToken,
                        onHideTap: controller.onHideToken,
                      ),
                      0.03.vspace,
                    ],
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: controller.userTokens.length < 3
                          ? controller.userTokens.length
                          : (controller.expandTokenList.value)
                              ? controller.userTokens.length
                              : 3 + controller.checkPinHideTokenList(),
                      itemBuilder: (_, index) => controller
                                  .userTokens[index].isHidden &&
                              !controller.isEditable.value &&
                              !controller.userTokens[index].isPinned
                          ? const SizedBox()
                          : !controller.userTokens[index].isPinned
                              ? TokenCheckbox(
                                  xtzPrice: controller.xtzPrice.value,
                                  tokenModel: controller.userTokens,
                                  isEditable: controller.isEditable.value,
                                  tokenIndex: index,
                                  onCheckboxTap: (value) {
                                    controller
                                      ..userTokens[index].isSelected =
                                          value ?? false
                                      ..userTokens.refresh();
                                  },
                                  onPinnedTap: () {
                                    controller
                                      ..userTokens[index].isPinned =
                                          !controller.userTokens[index].isPinned
                                      ..userTokens.refresh();
                                  },
                                  onHiddenTap: () {
                                    controller
                                      ..userTokens[index].isHidden =
                                          !controller.userTokens[index].isHidden
                                      ..userTokens.refresh();
                                  },
                                )
                              : const SizedBox(),
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
}
