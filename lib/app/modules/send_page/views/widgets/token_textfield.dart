import 'package:flutter/material.dart';
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
      cursorHeight: 28.sp,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: 28.arP,
          fontWeight: FontWeight.w600,
          color: isError != null && isError!.value
              ? ColorConst.NaanRed
              : textfieldType == TextfieldType.token
                  ? ColorConst.NeutralVariant.shade70
                  : ColorConst.NeutralVariant.shade60),
      cursorColor: Colors.white,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(top: 2.arP),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        isDense: true,
        border: InputBorder.none,
        hintText: hintText,
        alignLabelWithHint: true,
        hintStyle: hintStyle ??
            headlineMedium.copyWith(color: ColorConst.NeutralVariant.shade30),
      ),
    );
  }
}
