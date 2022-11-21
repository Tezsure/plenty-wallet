import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class DelegateBakerTile extends StatelessWidget {
  const DelegateBakerTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.01.height),
      child: Container(
        // width: 338,
        height: 0.12.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff958e99).withOpacity(0.2),
          border: Border.all(
            color: Colors.transparent,
            width: 2,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0.04.width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  child: Image.asset(
                    'assets/temp/delegate_baker.png',
                    fit: BoxFit.fill,
                    width: 40,
                    height: 40,
                  ),
                ),
                0.02.hspace,
                Text(
                  'MyTezosBaking',
                  style: labelMedium,
                ),
                0.015.hspace,
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.launch,
                    color: ColorConst.textGrey1,
                    size: 13,
                  ),
                ),
              ],
            ),
            0.013.vspace,
            Row(
              children: [
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Baker fee:\n',
                    style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade70),
                    children: [TextSpan(text: '14%', style: labelLarge)],
                  ),
                ),
                0.06.hspace,
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Staking:\n',
                    style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade70),
                    children: [TextSpan(text: '116K', style: labelLarge)],
                  ),
                ),
                0.06.hspace,
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Yield:\n',
                    style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade70),
                    children: [TextSpan(text: '4.85%', style: labelLarge)],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
