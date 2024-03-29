import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

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
    return BouncingWidget(
      onPressed: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12.aR),
        padding: EdgeInsets.symmetric(horizontal: 10.aR, vertical: 4.arP),
        // height: 30.aR,
        // width: buttonName.length > 4 ? 65.aR : 50.aR,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.aR),
          color: isDone ? ColorConst.Primary : const Color(0xff1e1c1f),
        ),
        alignment: Alignment.center,
        child: Text(
          buttonName.tr,
          style: labelLarge.copyWith(
              color: isDone ? Colors.white : ColorConst.NeutralVariant.shade60),
        ),
      ),
    );
  }
}
