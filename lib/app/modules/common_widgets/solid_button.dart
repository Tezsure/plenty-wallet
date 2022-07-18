import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../utils/material_Tap.dart';

class SolidButton extends StatelessWidget {
  final String title;
  final GestureTapCallback? onPressed;
  const SolidButton({Key? key, required this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return materialTap(
      onPressed: onPressed,
      color: ColorConst.Primary,
      splashColor: ColorConst.Primary.shade60,
      inkwellRadius: 8,
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            //color: Color(0xff8637eb),
            color: Colors.transparent),
        alignment: Alignment.center,
        child: Text(
          title,
          style: titleSmall.apply(color: ColorConst.Neutral),
        ),
      ),
    );
  }
}
