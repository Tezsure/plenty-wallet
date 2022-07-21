import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../utils/material_Tap.dart';

class SolidButton extends StatelessWidget {
  final String title;
  final GestureTapCallback? onPressed;
  final Color? textColor;
  final double? height;
  final double? width;
  final Widget? rowWidget;
  const SolidButton(
      {Key? key,
      required this.title,
      this.onPressed,
      this.textColor,
      this.height,
      this.width,
      this.rowWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return materialTap(
      onPressed: onPressed,
      color: ColorConst.Primary,
      splashColor: ColorConst.Primary.shade60,
      inkwellRadius: 8,
      child: Container(
        height: height ?? 48,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (rowWidget != null) ...[rowWidget!, 10.w.hspace],
            Text(
              title,
              style: titleSmall.apply(
                color: textColor ?? ColorConst.Neutral,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
