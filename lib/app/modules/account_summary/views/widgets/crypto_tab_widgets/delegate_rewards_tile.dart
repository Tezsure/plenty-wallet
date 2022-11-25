import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';

class DelegateRewardsTile extends StatelessWidget {
  const DelegateRewardsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: 0.9.width,
      height: 0.2.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xff958e99).withOpacity(0.2),
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: 0.04.width, vertical: 0.01.height),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 20,
                child: Image.asset(
                  'assets/temp/delegate_baker.png',
                  fit: BoxFit.cover,
                  width: 40.sp,
                  height: 40.sp,
                ),
              ),
              0.02.hspace,
              RichText(
                  text: TextSpan(
                      text: 'MyTezosBaking\n',
                      style: labelMedium,
                      children: [
                    TextSpan(
                      text: 'tz1d6....pVok8',
                      style: labelSmall.copyWith(color: ColorConst.Primary),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.copy,
                          color: ColorConst.Primary,
                          size: 10,
                        ),
                        iconSize: 10,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ])),
              const Spacer(),
              Row(
                children: [
                  Text(
                    '504',
                    style: labelSmall,
                  ),
                  const Icon(
                    Icons.hourglass_empty,
                    color: ColorConst.Primary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
          0.013.vspace,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Delegated:\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: '100 tez', style: labelLarge)],
                    ),
                  ),
                  0.12.hspace,
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Rewards:\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: '2 tez', style: labelLarge)],
                    ),
                  ),
                  0.12.hspace,
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Baker fee:\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: '14%', style: labelLarge)],
                    ),
                  ),
                ],
              ),
              0.013.vspace,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Expected Payout:\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: '10 tez', style: labelLarge)],
                    ),
                  ),
                  0.03.hspace,
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Status\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                      children: [TextSpan(text: 'Pending', style: labelLarge)],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
