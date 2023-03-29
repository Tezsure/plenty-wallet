import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../../utils/colors/colors.dart';

class NftHistoryTile extends StatelessWidget {
  const NftHistoryTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 0.03.width, vertical: 0.003.height),
      decoration: BoxDecoration(
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            minVerticalPadding: 0,
            visualDensity: VisualDensity.compact,
            dense: true,
            leading: Container(
              height: 40.arP,
              width: 40.arP,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/temp/nft_preview.png',
                  ),
                ),
              ),
            ),
            title: Text(
              'Receive',
              style: labelMedium,
            ),
            subtitle: Text(
              tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
              style:
                  labelSmall.copyWith(color: ColorConst.NeutralVariant.shade60),
            ),
            trailing: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                  text: '+1 Unstable\n',
                  style:
                      labelMedium.copyWith(color: ColorConst.naanCustomColor),
                  children: [
                    WidgetSpan(child: 0.02.vspace),
                    TextSpan(
                        text: 'N/A',
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60))
                  ]),
            ),
          ),
          Container(
            height: 0.33.height,
            width: 0.76.width,
            margin: EdgeInsets.only(
                right: 0.04.width, bottom: 0.02.height, top: 0.01.height),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                alignment: Alignment.center,
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/temp/nft_preview.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
