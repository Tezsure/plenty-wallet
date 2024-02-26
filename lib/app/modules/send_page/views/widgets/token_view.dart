import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/list_tile.dart';
import 'package:plenty_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/utils.dart';

import 'token_textfield.dart';

enum TextfieldType { token, usd }

class TokenView extends StatelessWidget {
  SendPageController controller;
  TokenView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(8.arP),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          child: Obx(
            () => NaanListTile(
              dense: true,
              minVerticalPadding: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.arP)),
              leading: SizedBox(
                width: 0.5.width,
                child: TokenSendTextfield(
                  textfieldType: TextfieldType.token,
                  onTap: () {
                    controller.selectedTextfieldType.value =
                        TextfieldType.token;
                  },
                  focusNode: controller.amountFocusNode.value,
                  hintText: '0.00',
                  hintStyle: headlineMedium.copyWith(
                    color: controller.amount.value.isNumericOnly &&
                            controller.amount.value.isNotEmpty
                        ? ColorConst.NeutralVariant.shade60
                        : ColorConst.NeutralVariant.shade30,
                    fontWeight: FontWeight.w600,
                  ),
                  controller: controller.amountController,
                  isError: (controller.amountTileError.value ||
                          controller.amountUsdTileError.value)
                      .obs,
                  onChanged: _onChange,
                ),
              ),
              trailing: SizedBox(
                width: 0.3.width,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      controller.selectedTextfieldType.value ==
                              TextfieldType.token
                          ? BouncingWidget(
                              // splashColor: Colors.transparent,
                              onPressed: () {
                                if (!controller
                                    .amountFocusNode.value.hasFocus) {
                                  controller.amountFocusNode.value
                                      .requestFocus();
                                }

                                // check for if estimated fee is greater than balance
                                if (controller.selectedTokenModel!.balance <
                                    (double.parse(
                                            controller.estimatedFee.value) /
                                        controller.xtzPrice.value)) {
                                  controller.amountController.text = "0";
                                  controller.amountController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                      offset: controller
                                          .amountController.text.length,
                                    ),
                                  );
                                  _onChange(controller.amountController.text);

                                  // show snackbar
                                  Get.snackbar(
                                    'Insufficient Balance'.tr,
                                    'You don\'t have enough balance to pay the estimated fee'
                                        .tr,
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    margin: EdgeInsets.all(8.arP),
                                    borderRadius: 8.arP,
                                    duration: const Duration(seconds: 3),
                                    isDismissible: true,
                                    forwardAnimationCurve: Curves.easeOutBack,
                                    icon: const Icon(
                                      Icons.error_outline,
                                      color: Colors.white,
                                    ),
                                  );

                                  return;
                                }

                                controller.amountController.text = (controller
                                            .selectedTokenModel!.balance -
                                        (double.parse(
                                                controller.estimatedFee.value) /
                                            controller.xtzPrice.value))
                                    .toString();
                                controller.amountController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                    offset:
                                        controller.amountController.text.length,
                                  ),
                                );
                                _onChange(controller.amountController.text);
                              },
                              child: Container(
                                height: 28.arP,
                                width: 48.arP,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24.arP),
                                    color: const Color(0xFF332F37)),
                                child: Center(
                                  child: Text('Max'.tr,
                                      style: labelMedium.copyWith(
                                          color: const Color(0xFF625C66))),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      0.02.hspace,
                      controller.selectedTokenModel != null
                          ? Text(
                              controller.selectedTokenModel!.symbol!,
                              style: labelLarge.copyWith(
                                  color: const Color(0xFF625C66)),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        0.008.vspace,
        controller.selectedTokenModel?.currentPrice != 0
            ? Material(
                borderRadius: BorderRadius.circular(8.arP),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                child: Obx(() => NaanListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.arP)),
                      leading: SizedBox(
                        width: 0.5.width,
                        child: TokenSendTextfield(
                          textfieldType: TextfieldType.usd,
                          onTap: () {
                            controller.selectedTextfieldType.value =
                                TextfieldType.usd;
                          },
                          maxLen: 8,
                          // focusNode: controller.focus
                          controller: controller.amountUsdController,
                          onChanged: (val) {
                            val = sanitizeAndValidateAmount(val, 6);

                            if (val.isNotEmpty &&
                                val != controller.amountUsdController.text) {
                              controller.amountUsdController.text = val;
                              controller.amountUsdController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: controller
                                          .amountUsdController.text.length));
                            }

                            controller.amountText.value = val;
                            if (controller.amountFocusNode.value.hasFocus) {
                              controller.amountController.text = val;
                              return;
                            }
                            if (val.isEmpty) {
                              controller.amountController.text = "";
                              controller.amountUsdController.text = "";
                              return;
                            }
                            double multiplier = ServiceConfig.currency ==
                                    Currency.usd
                                ? 1
                                : ServiceConfig.currency == Currency.tez
                                    ? 1 / controller.xtzPrice.value
                                    : ServiceConfig.currency == Currency.inr
                                        ? ServiceConfig.inr
                                        : ServiceConfig.currency == Currency.eur
                                            ? ServiceConfig.eur
                                            : 1;
                            if (double.parse(val) >
                                (controller.selectedTokenModel!.name == "Tezos"
                                    ? controller.selectedTokenModel!.balance *
                                        controller.xtzPrice.value *
                                        multiplier
                                    : controller.selectedTokenModel!.balance *
                                        controller
                                            .selectedTokenModel!.currentPrice! *
                                        /* controller.xtzPrice.value * */
                                        multiplier)) {
                              controller.amountUsdTileError.value = true;
                            } else {
                              controller.amountUsdTileError.value = false;
                            }
                            calculateValuesAndUpdate(val, true);
                          },
                          isError: controller.amountUsdTileError,
                          hintText: '0.00',
                          hintStyle: headlineMedium.copyWith(
                            color: controller.amount.value.isNumericOnly &&
                                    controller.amount.value.isNotEmpty
                                ? ColorConst.NeutralVariant.shade60
                                : ColorConst.NeutralVariant.shade30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      trailing: SizedBox(
                        width: 0.3.width,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              controller.selectedTextfieldType.value ==
                                      TextfieldType.usd
                                  ? BouncingWidget(
                                      onPressed: () {
                                        var maxAmount = controller
                                                    .selectedTokenModel !=
                                                null
                                            ? (controller.selectedTokenModel!
                                                    .balance -
                                                (double.parse(controller
                                                        .estimatedFee.value) /
                                                    controller.xtzPrice.value))
                                            : 0;

                                        if (maxAmount < 0) {
                                          maxAmount = 0;
                                          // show snackbar
                                          Get.snackbar(
                                            'Insufficient Balance'.tr,
                                            'You don\'t have enough balance to pay the estimated fee'
                                                .tr,
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            margin: EdgeInsets.all(8.arP),
                                            borderRadius: 8.arP,
                                            duration:
                                                const Duration(seconds: 3),
                                            isDismissible: true,
                                            forwardAnimationCurve:
                                                Curves.easeOutBack,
                                            icon: const Icon(
                                              Icons.error_outline,
                                              color: Colors.white,
                                            ),
                                          );
                                        }

                                        controller.amountController.text =
                                            maxAmount.toString();
                                        controller.amountController.selection =
                                            TextSelection.fromPosition(
                                          TextPosition(
                                            offset: controller
                                                .amountController.text.length,
                                          ),
                                        );
                                        controller.amountText.value =
                                            controller.amountController.text;
                                        calculateValuesAndUpdate(
                                            controller.amountController.text);
                                      },
                                      child: Container(
                                        height: 28.arP,
                                        width: 48.arP,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24.arP),
                                            color: ColorConst
                                                .NeutralVariant.shade60
                                                .withOpacity(0.2)),
                                        child: Center(
                                          child: Text('Max'.tr,
                                              style: labelMedium.copyWith(
                                                  color: ColorConst
                                                      .NeutralVariant.shade60)),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              0.02.hspace,
                              Text(
                                ServiceConfig.currency.name.toUpperCase(),
                                style: labelLarge.copyWith(
                                    color: ColorConst.NeutralVariant.shade60),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              )
            : const SizedBox(),
      ],
    );
  }

  _onChange(val) {
    var oldVal = val;

    val = sanitizeAndValidateAmount(val);
    val = formatEnterAmount(val);

    if (oldVal == "0") val = "0";

    controller.amountText.value = val;
    controller.amountController.text = val;
    controller.amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.amountController.text.length));
    try {
      controller.amountText.value = val;
      if (!controller.amountFocusNode.value.hasFocus) {
        return;
      }
      String formatedAmount = formatEnterAmount(val);
      if (val.contains(".")) {
        if (formatedAmount != val) {
          controller.amountController.text = formatedAmount;
          controller.amountController.selection = TextSelection.fromPosition(
              TextPosition(offset: formatedAmount.length));
        }
      }
      if (formatedAmount.isNotEmpty &&
          double.parse(formatedAmount) >
              controller.selectedTokenModel!.balance) {
        controller.amountTileError.value = true;
      } else {
        controller.amountTileError.value = false;
      }
      if (formatedAmount.isNotEmpty) {
        calculateValuesAndUpdate(formatedAmount);
      } else {
        controller.amountUsdController.text = "";
      }
    } catch (e) {
      controller.amountText.value = "";
    }
  }

  void calculateValuesAndUpdate(String value, [bool isUsd = false]) {
    double newAmountValue = 0.0;
    double newUsdValue = 0.0;
    double multiplier = ServiceConfig.currency == Currency.usd
        ? 1
        : ServiceConfig.currency == Currency.tez
            ? 1 / controller.xtzPrice.value
            : ServiceConfig.currency == Currency.inr
                ? ServiceConfig.inr
                : ServiceConfig.currency == Currency.eur
                    ? ServiceConfig.eur
                    : 1;
    if (isUsd) {
      newAmountValue = controller.selectedTokenModel!.name == "Tezos"
          ? double.parse(value) / (controller.xtzPrice.value * multiplier)
          : double.parse(value) /
              (/* controller.xtzPrice.value * */
                  controller.selectedTokenModel!.currentPrice! * multiplier);
      if (newAmountValue.isNaN || newAmountValue.isInfinite) {
        newAmountValue = 0;
      }
    } else {
      newUsdValue = controller.selectedTokenModel!.name == "Tezos"
          ? double.parse(value) * controller.xtzPrice.value * multiplier
          : double.parse(value) *
              controller.selectedTokenModel!.currentPrice! *
              // controller.xtzPrice.value
              // *
              multiplier;
      if (newUsdValue.isNaN || newUsdValue.isInfinite) {
        newUsdValue = 0;
      }
    }
    if (!isUsd &&
        controller.amountUsdController.text !=
            newUsdValue.toStringAsFixed(6).removeTrailing0) {
      controller.amountUsdController.text =
          newUsdValue.toStringAsFixed(6).removeTrailing0;
      controller.amountUsdController.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.amountUsdController.text.length));
    }
    if (isUsd &&
        controller.amountController.text !=
            newAmountValue
                .toStringAsFixed(controller.selectedTokenModel!.decimals > 20
                    ? 20
                    : controller.selectedTokenModel!.decimals)
                .removeTrailing0) {
      controller.amountController.text = newAmountValue
          .toStringAsFixed(controller.selectedTokenModel!.decimals > 20
              ? 20
              : controller.selectedTokenModel!.decimals)
          .removeTrailing0;
      controller.amountController.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.amountController.text.length));
    }
  }

  String formatEnterAmount(String amount) {
    var decimalEnters = amount.substring(amount.indexOf(".") + 1).length;
    if (decimalEnters == 0) return amount;
    return double.parse(amount).toStringAsFixed(
        decimalEnters > controller.selectedTokenModel!.decimals
            ? controller.selectedTokenModel!.decimals
            : decimalEnters);
  }

  String sanitizeAndValidateAmount(String amount, [int? decimals]) {
    if (amount.isEmpty) {
      return '';
    }
    // Remove non-numeric characters from the amount, except for the decimal point
    final sanitizedAmount = amount.replaceAll(RegExp(r'[^0-9.]'), '');

    // Check if the sanitized amount is a non-empty string
    if (sanitizedAmount.isEmpty) {
      return '';
    }

    // Check if the sanitized amount is greater than zero
    final parsedAmount = double.tryParse(sanitizedAmount);
    if (parsedAmount == null || parsedAmount <= 0) {
      var amounts = sanitizedAmount.split('.');
      return amount.contains('.')
          ? amounts.last.length <= (decimals ?? 6)
              ? sanitizedAmount
              : sanitizedAmount.substring(
                  0, amounts.first.length + (decimals ?? 6))
          : '0';
    }

    // Check if the sanitized amount has more than the allowed number of decimal places
    final sanitizedAmountDecimalPlaces = sanitizedAmount.contains('.')
        ? sanitizedAmount.split('.').last.length
        : 0;

    if (decimals != null && sanitizedAmountDecimalPlaces > decimals) {
      return amount.contains('.')
          ? sanitizedAmount.substring(
              0, sanitizedAmount.length - (sanitizedAmountDecimalPlaces - 6))
          : sanitizedAmount.substring(0, sanitizedAmount.length - 6);
    }

    // Return the sanitized and validated amount as a string
    return sanitizedAmount;
  }
}
