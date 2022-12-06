import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class InfoButton extends StatelessWidget {
  final Function()? onPressed;
  const InfoButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'info',
            style: bodySmall.copyWith(
                color: ColorConst.NeutralVariant.shade60,
                fontWeight: FontWeight.bold),
          ),
          0.010.hspace,
          Icon(
            Icons.info_outline,
            size: 16,
            color: ColorConst.NeutralVariant.shade60,
          ),
        ],
      ),
    );
  }
}
