// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class NaanTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onTextChange;
  final String? hint;
  final TextStyle? hintTextSyle;
  final Color? backgroundColor;
  final Function()? onEditingComplete;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final double? height;
  final TextStyle? textStyle;
  // auto focus
  final int? maxLen;
  final bool? autofocus;

  const NaanTextfield(
      {Key? key,
      this.onEditingComplete,
      this.controller,
      this.hint,
      this.onTextChange,
      this.backgroundColor,
      this.hintTextSyle,
      this.onSubmitted,
      this.focusNode,
      this.height,
      this.textStyle,
      this.autofocus = false,
      this.maxLen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      autofocus: autofocus ?? false,
      controller: controller,
      cursorColor: ColorConst.Primary,
      style: bodyMedium,
      textAlign: TextAlign.start,
      maxLength: maxLen ?? 1000,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onTextChange,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        counterText: "",
        fillColor: backgroundColor ?? Colors.white.withOpacity(0.1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.arP),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.arP),
            borderSide: BorderSide.none),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 10.arP, vertical: 20.arP),
        // contentPadding: EdgeInsets.zero,
        hintStyle: hintTextSyle ??
            bodyMedium.copyWith(color: Colors.white.withOpacity(0.2)),
        hintText: hint?.tr,
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
      borderRadius: BorderRadius.circular(8.arP),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.arP),
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
