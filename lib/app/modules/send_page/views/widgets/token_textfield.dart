import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/token_view.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class TokenSendTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String val)? onChanged;
  final TextStyle? hintStyle;
  final String hintText;
  final FocusNode? focusNode;
  final RxBool? isError;
  final TextfieldType textfieldType;
  final GestureTapCallback? onTap;
  const TokenSendTextfield(
      {super.key,
      this.controller,
      this.onChanged,
      this.hintStyle,
      required this.hintText,
      this.focusNode,
      this.onTap,
      this.isError,
      required this.textfieldType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      focusNode: focusNode,
      controller: controller,
      cursorHeight: 28.arP,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.left,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [ReplaceCommaFormatter()],
      style: headlineMedium.copyWith(
          // fontSize: 28.arP,
          // fontWeight: FontWeight.w600,
          color: isError != null && isError!.value
              ? ColorConst.NaanRed
              : textfieldType == TextfieldType.token
                  ? ColorConst.NeutralVariant.shade40
                  : ColorConst.NeutralVariant.shade60),
      cursorColor: ColorConst.Primary,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 0, bottom: -4.arP),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        isDense: true,
        border: InputBorder.none,
        // border: OutlineInputBorder(),
        hintText: hintText,
        alignLabelWithHint: true,
        hintStyle: hintStyle ??
            headlineMedium.copyWith(
              color: ColorConst.NeutralVariant.shade30,
            ),
      ),
    );
  }
}

class ReplaceCommaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newString = newValue.text;
    if (newValue.text.contains(",")) {
      if (oldValue.text.contains(".")) {
        newString = newValue.text.replaceAll(",", "");
      } else {
        newString = newValue.text.replaceAll(",", ".");
      }
    }
    //avoid multiple dots
    if (newString.contains(".")) {
      final split = newString.split(".");
      if (split.length > 2) {
        newString = split[0] + "." + split[1];
      }
    }
/*     final regEx = RegExp(r"^\d*\.?\d*");
    String newString =
        (regEx.stringMatch(newValue.text) ?? "").replaceAll(',', '.'); */
    return TextEditingValue(
        text: newString,
        selection: TextSelection.fromPosition(
          TextPosition(
            offset: newString.length,
          ),
        ));
  }
}
