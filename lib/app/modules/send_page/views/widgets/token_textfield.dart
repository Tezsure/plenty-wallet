import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
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
  const TokenSendTextfield({
    super.key,
    this.controller,
    this.onChanged,
    this.hintStyle,
    required this.hintText,
    this.focusNode,
    this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      cursorHeight: 28.sp,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.left,
      style: headlineMedium.copyWith(
          color: isError != null && isError!.value
              ? ColorConst.NaanRed
              : ColorConst.Neutral.shade70),
      cursorColor: Colors.white,
      onChanged: onChanged,
      decoration: InputDecoration(
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
