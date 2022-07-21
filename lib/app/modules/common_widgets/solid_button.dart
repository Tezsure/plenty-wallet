import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../utils/material_Tap.dart';

class SolidButton extends StatelessWidget {
  final String title;
  final GestureTapCallback? onPressed;
  bool active;
  final Widget? child;

  final Widget? inActiveChild;

  SolidButton({
    Key? key,
    this.title = "",
    this.onPressed,
    this.active = true,
    this.child,
    this.inActiveChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: active ? onPressed : null,
      disabledColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      color: ColorConst.Primary,
      splashColor: ColorConst.Primary.shade60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            //color: Color(0xff8637eb),
            color: Colors.transparent),
        alignment: Alignment.center,
        child: child != null
            ? (active ? child : inActiveChild)
            : Text(
                title,
                style: titleSmall.apply(
                    color: active
                        ? ColorConst.Neutral.shade95
                        : ColorConst.NeutralVariant.shade60),
              ),
      ),
    );
  }
}
