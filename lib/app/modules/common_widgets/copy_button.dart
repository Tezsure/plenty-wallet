import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class CopyButton extends StatelessWidget {
  final bool isCopied;
  final Function()? onPressed;
  const CopyButton({super.key, this.isCopied = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13.arP, vertical: 20.arP),
      padding: EdgeInsets.symmetric(horizontal: 16.arP, vertical: 16.arP),
      // width: 0.5.width,
      // height: 0.06.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.arP),
        color: ColorConst.NeutralVariant.shade10,
      ),
      child: BouncingWidget(
        onPressed: onPressed,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                '${PathConst.SVG}copy.svg',
                color: Colors.white,
                fit: BoxFit.contain,
                height: 24.aR,
              ),
              0.014.hspace,
              Text(
                (isCopied ? 'copied!' : 'copy to clipboard').tr,
                style: titleSmall.copyWith(
                    color: Colors.white, overflow: TextOverflow.ellipsis),
              )
            ]),
      ),
    );
  }
}
