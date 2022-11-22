import 'package:flutter/material.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_reward_model.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';

class DelegateRewardsTile extends StatelessWidget {
  final DelegateRewardModel reward;
  final DelegateBakerModel delegatedBaker;
  const DelegateRewardsTile(
      {super.key, required this.reward, required this.delegatedBaker});

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
                child: ClipOval(
                  child: Image.network(
                    delegatedBaker.logo ?? "",
                    fit: BoxFit.fill,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              0.02.hspace,
              RichText(
                  text: TextSpan(
                      text: '${delegatedBaker.name}\n',
                      style: labelMedium,
                      children: [
                    TextSpan(
                      text: tz1Shortner(delegatedBaker.address!),
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
                      children: [
                        TextSpan(
                            text: '${reward.balance} tez', style: labelLarge)
                      ],
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
                      children: [
                        TextSpan(
                            text:
                                '${((delegatedBaker.fee ?? 0) * 100).toStringAsFixed(2)}%',
                            style: labelLarge)
                      ],
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
                      children: [
                        TextSpan(
                            text:
                                reward.activeStake! > 0 ? "Active" : 'Pending',
                            style: labelLarge)
                      ],
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
