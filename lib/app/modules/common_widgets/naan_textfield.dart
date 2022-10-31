// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class NaanTextfield extends StatelessWidget {
  final TextEditingController? controller;
  var onTextChange;
  final String? hint;
  final TextStyle? hintTextSyle;
  final Color? backgroundColor;
  final FocusNode? focusNode;
  TextStyle? textStyle;

  NaanTextfield(
      {Key? key,
      this.controller,
      this.hint,
      this.onTextChange,
      this.backgroundColor,
      this.focusNode,
      this.hintTextSyle,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: backgroundColor ?? Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            cursorColor: ColorConst.Primary,
            style: textStyle ?? bodyMedium,
            onChanged: onTextChange,
            decoration: InputDecoration(
                hintStyle: hintTextSyle ??
                    bodyMedium.apply(color: Colors.white.withOpacity(0.2)),
                hintText: hint,
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}

class NaanTextFormfield extends StatelessWidget {
  const NaanTextFormfield({Key? key, this.controller, this.height, this.hint})
      : super(key: key);
  final TextEditingController? controller;
  final double? height;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: TextFormField(
            controller: controller,
            cursorColor: ColorConst.Primary,
            maxLines: 100,
            style: bodyMedium,
            decoration: InputDecoration(
                hintStyle:
                    bodyMedium.apply(color: Colors.white.withOpacity(0.2)),
                hintText: hint,
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
