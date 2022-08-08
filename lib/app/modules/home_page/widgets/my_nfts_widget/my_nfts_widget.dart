import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class MyNFTwidget extends StatelessWidget {
  const MyNFTwidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.45.width,
      width: 0.45.width,
      padding: EdgeInsets.all(0.035.width),
      decoration: BoxDecoration(
        color: ColorConst.NeutralVariant.shade10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "My NFTs",
            style: titleMedium,
          ),
          Text(
            "ottez #2103",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade70),
          ),
        ],
      ),
    );
  }
}
