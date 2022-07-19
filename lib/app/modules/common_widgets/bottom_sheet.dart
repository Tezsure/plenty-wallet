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
  const NaanBottomSheet(
      {Key? key, this.height, this.width, required this.children, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xff07030c).withOpacity(0.49),
              const Color(0xff2d004f),
            ],
          ),
        ),
        width: width ?? 1.width,
        height: height ?? 296,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            5.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              ),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
