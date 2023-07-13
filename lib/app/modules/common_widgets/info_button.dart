import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class InfoButton extends StatelessWidget {
  final Function()? onPressed;
  const InfoButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: onPressed,
      child: Row(
        children: [
          Text(
            "info".tr,
            style: titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorConst.NeutralVariant.shade60),
          ),
          0.01.hspace,
          Icon(
            Icons.info_outline,
            color: ColorConst.NeutralVariant.shade60,
            size: 16,
          ),
        ],
      ),
    );
  }
}
