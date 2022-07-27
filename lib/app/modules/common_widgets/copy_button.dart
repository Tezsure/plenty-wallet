import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class CopyButton extends StatelessWidget {
  final bool isCopied;
  final Function()? onPressed;
  const CopyButton({Key? key, this.isCopied = false, this.onPressed})
      : super(key: key);

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
        child: MaterialButton(
          onPressed: onPressed,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.copy_rounded,
              color: Colors.white,
            ),
            13.hspace,
            Text(
              isCopied ? 'copied!' : 'copy to clipboard',
              style: titleSmall.copyWith(color: Colors.white),
            )
          ]),
        ),
      ),
    );
  }
}
