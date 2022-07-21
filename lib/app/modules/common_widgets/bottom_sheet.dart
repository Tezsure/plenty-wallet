import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class NaanBottomSheet extends StatelessWidget {
  final double? height;
  final double? width;
  final List<Widget> children;
  final String? title;
  final double? blurRadius;
  final double? gradientStartingOpacity;
  const NaanBottomSheet(
      {Key? key,
      this.height,
      this.width,
      required this.children,
      this.title,
      this.blurRadius,
      this.gradientStartingOpacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: blurRadius ?? 50, sigmaY: blurRadius ?? 50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xff07030c)
                  .withOpacity(gradientStartingOpacity ?? 0.49),
              const Color(0xff2d004f),
            ],
          ),
        ),
        width: width ?? 1.width,
        height: height ?? 296,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.vspace,
              Center(
                child: Container(
                  height: 5,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
              ),
              20.vspace,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title ?? "Bottom Sheet Title",
                  textAlign: TextAlign.start,
                  style: titleLarge,
                ),
              ),
              20.vspace,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
