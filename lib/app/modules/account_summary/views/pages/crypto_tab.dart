import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../controllers/account_summary_controller.dart';
import '../widgets/crypto_tab_widgets/delegate_tile.dart';
import '../widgets/crypto_tab_widgets/token_checkbox.dart';
import '../widgets/crypto_tab_widgets/token_edit_tile.dart';

class CryptoTabPage extends GetView<AccountSummaryController> {
  const CryptoTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: controller.expandTokenList.value
                      ? controller.tokens.length
                      : 3,
                  itemBuilder: (_, index) =>
                      controller.tokens[index].isHidden &&
                              !controller.isEditable.value
                          ? const SizedBox()
                          : TokenCheckbox(
                              tokenModel: controller.tokens,
                              isEditable: controller.isEditable.value,
                              tokenIndex: index,
                              onCheckboxTap: (value) {
                                controller
                                  ..tokens[index].isSelected = value ?? false
                                  ..tokens.refresh();
                              },
                              onPinnedTap: () {
                                controller
                                  ..tokens[index].isPinned =
                                      !controller.tokens[index].isPinned
                                  ..tokens.refresh();
                              },
                              onHiddenTap: () {
                                controller
                                  ..tokens[index].isHidden =
                                      !controller.tokens[index].isHidden
                                  ..tokens.refresh();
                              },
                            ),
                ),
                0.03.vspace,
                TokenEditTile(
                  viewAll: () => controller.expandTokenList.value =
                      !controller.expandTokenList.value,
                  expandedTokenList: controller.expandTokenList.value,
                  isEditable: controller.isEditable.value,
                  onEditTap: () => controller.isEditable.value =
                      !controller.isEditable.value,
                  isAnyTokenSelected: controller.tokens.any(
                    (element) => element.isSelected,
                  ),
                  onPinTap: controller.onPinToken,
                  onHideTap: controller.onHideToken,
                ),
                0.03.vspace,
                Text(
                  'Delegate',
                  style: labelLarge.copyWith(color: ColorConst.Primary.shade95),
                ),
                0.02.vspace,
                DelegateTile(
                  isDelegated: controller.isAccountDelegated.value,
                ),
                0.02.vspace
              ],
            )),
      ),
    );
  }
}
