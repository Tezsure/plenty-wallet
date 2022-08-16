import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class MyNFTwidget extends StatelessWidget {
  const MyNFTwidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment(0, 0),
          end: Alignment(0, 1.2),
          colors: [
            Colors.white,
            Color(0xff1E1A22),
          ],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      child: Container(
        height: 0.45.width,
        width: 0.45.width,
        padding: EdgeInsets.all(0.035.width),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/temp/nft.png'),
            fit: BoxFit.cover,
          ),
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
              style:
                  labelSmall.apply(color: ColorConst.NeutralVariant.shade100),
            ),
          ],
        ),
      ),
    );
  }
}
