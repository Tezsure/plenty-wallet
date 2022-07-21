import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
      child: Container(
        width: .6.width,
        height: 0.06.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade10,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.copy_rounded,
            color: Colors.white,
          ),
          13.h.hspace,
          Text(
            'copy to clipboard',
            style: titleSmall.copyWith(color: Colors.white),
          )
        ]),
      ),
    );
  }
}
