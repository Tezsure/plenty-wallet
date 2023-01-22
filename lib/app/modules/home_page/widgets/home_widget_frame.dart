import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class HomeWidgetFrame extends StatelessWidget {
  final double? width;
  final Widget child;
  const HomeWidgetFrame({super.key, this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22.arP),
      child: Container(
        height: AppConstant.homeWidgetDimension,
        width: width ?? AppConstant.homeWidgetDimension,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.arP)),
        child: child,
      ),
    );
  }
}
