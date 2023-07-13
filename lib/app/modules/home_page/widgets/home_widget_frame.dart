import 'package:flutter/material.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

class HomeWidgetFrame extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  const HomeWidgetFrame(
      {super.key, this.width, this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.arP),
      child: Container(
        height: height ?? AppConstant.homeWidgetDimension,
        width: width ?? AppConstant.homeWidgetDimension,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.arP)),
        child: child,
      ),
    );
  }
}
