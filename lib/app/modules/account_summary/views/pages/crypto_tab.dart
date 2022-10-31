import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
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
                  height: 120.aR,
                ),
                0.03.vspace,
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "No token found\n",
                        style: titleLarge.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 22.aR),
                        children: [
                          WidgetSpan(child: 0.04.vspace),
                          TextSpan(
                              text:
                                  "Buy or Transfer token from another\n wallet or elsewhere",
                              style: labelMedium.copyWith(
                                  fontSize: 12.aR,
                                  color: ColorConst.NeutralVariant.shade60))
                        ])),
              ],
            ),
          )
        : CustomScrollView(slivers: [
            SliverPadding(
              padding: EdgeInsets.only(left: 17.aR, right: 16.aR, top: 24.aR),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _tokenBox(controller.pinnedList[index], index, true),
                  childCount: controller.pinnedList.length,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(left: 17.aR, right: 16.aR),
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
                        (context, index) => controller.isEditable.value
                            ? _tokenBox(
                                controller.unPinnedList[index], index, false)
                            : !controller.unPinnedList[index].isHidden
                                ? _tokenBox(controller.unPinnedList[index],
                                    index, false)
                                : const SizedBox(),
                        childCount: controller.unPinnedList.length,
                      ),
                    ),
                  )
                : const SliverToBoxAdapter(),
          ]));
  }

  Widget _tokenBox(AccountTokenModel token, int index, bool isPinnedList) =>
      TokenCheckbox(
        xtzPrice: controller.xtzPrice.value,
        tokenModel: token,
        isEditable: controller.isEditable.value,
        onCheckboxTap: () => controller.onCheckBoxTap(isPinnedList, index),
      );

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
