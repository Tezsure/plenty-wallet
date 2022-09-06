import 'package:flutter/material.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';

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
        height: 24,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color:
              isDone ? ColorConst.Primary : ColorConst.NeutralVariant.shade30,
        ),
        alignment: Alignment.center,
        child: Text(
          buttonName,
          style: labelSmall,
        ),
      ),
    );
  }
}
