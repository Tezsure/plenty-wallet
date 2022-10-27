import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';

class EditButtons extends StatelessWidget {
  const EditButtons({
    super.key,
    required this.buttonName,
    required this.isDone,
    this.onTap,
  });

  final String buttonName;
  final bool isDone;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.sp),
        height: 30.sp,
        width: buttonName.length > 3 ? 60.sp : 47.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.sp),
          color: isDone ? ColorConst.Primary : const Color(0xff1e1c1f),
        ),
        alignment: Alignment.center,
        child: Text(
          buttonName,
          style: labelLarge.copyWith(
              letterSpacing: 0.5,
              height: 16 / 14,
              fontWeight: FontWeight.w600,
              color: isDone ? Colors.white : ColorConst.NeutralVariant.shade60),
        ),
      ),
    );
  }
}
