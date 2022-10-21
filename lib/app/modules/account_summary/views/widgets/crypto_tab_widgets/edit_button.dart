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
        height: 32.sp,
        width: 58.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isDone ? ColorConst.Primary : const Color(0xff1e1c1f),
        ),
        alignment: Alignment.center,
        child: Text(
          buttonName,
          style: labelLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: isDone ? Colors.white : ColorConst.NeutralVariant.shade60),
        ),
      ),
    );
  }
}
