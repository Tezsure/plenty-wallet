import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'token_textfield.dart';

class TokenView extends GetView<SendPageController> {
  const TokenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.Neutral.shade10.withOpacity(0.6),
            child: Obx(
              () => ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: controller.amountTileFocus.value
                            ? ColorConst.Neutral.shade70
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(8)),
                dense: true,
                leading: SizedBox(
                  width: 0.3.width,
                  child: TokenSendTextfield(
                    focusNode: controller.recipientFocusNode.value,
                    hintText: '0.00',
                    controller: controller.recipientController,
                    onChanged: (val) => controller.amount.value = val,
                  ),
                ),
                trailing: SizedBox(
                  width: 0.4.width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 24,
                            width: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: ColorConst.Neutral.shade80
                                    .withOpacity(0.2)),
                            child: Center(
                              child: Text('Max',
                                  style: labelSmall.copyWith(
                                      color: ColorConst.Primary.shade60)),
                            ),
                          ),
                        ),
                        0.02.hspace,
                        Text(
                          'XTZ',
                          style: labelLarge.copyWith(
                              color: ColorConst.Neutral.shade70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        0.008.vspace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            child: Obx(() => ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: !controller.amountTileFocus.value
                            ? ColorConst.NeutralVariant.shade60
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(8)),
                dense: true,
                leading: SizedBox(
                  width: 0.3.width,
                  child: TokenSendTextfield(
                    onChanged: (val) => controller.amount.value = val,
                    hintText: controller.amount.value.isNumericOnly &&
                            controller.amount.value.isNotEmpty
                        ? '3.42'
                        : '0.00',
                    hintStyle: headlineMedium.copyWith(
                        color: controller.amount.value.isNumericOnly &&
                                controller.amount.value.isNotEmpty
                            ? ColorConst.NeutralVariant.shade60
                            : ColorConst.NeutralVariant.shade30),
                  ),
                ),
                trailing: Text(
                  'USD',
                  style: labelLarge.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ))),
          ),
        ),
      ],
    );
  }
}
