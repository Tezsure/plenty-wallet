import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_reward_model.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';

class DelegateRewardsTile extends StatelessWidget {
  final DelegateRewardModel reward;

  const DelegateRewardsTile({
    super.key,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: 0.9.width,
      height: 192.arP,
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
          _buildHeader(),
          0.013.vspace,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInfo('Delegated',
                      '${(reward.balance / pow(10, 6)).toStringAsFixed(4)} tez'),
                  0.03.hspace,
                  _buildInfo(
                      'Rewards', '${totalRewards.toStringAsFixed(2)} tez'),
                  0.03.hspace,
                  _buildInfo('Baker fee',
                      '${((reward.bakerDetail?.fee ?? 0) * 100).toStringAsFixed(2)}%'),
                ],
              ),
              0.013.vspace,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildInfo('Expected Payout',
                      '${netExpectedPayout.toStringAsFixed(5)} tez'),
                  0.03.hspace,
                  _buildInfo('Status', reward.status ?? ". . ."),
                  0.03.hspace,
                  const Spacer()
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String title, String value) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: '$title:\n',
            style:
                labelSmall.copyWith(color: ColorConst.NeutralVariant.shade70),
            children: [TextSpan(text: value, style: labelLarge)],
          ),
        ),
      ),
    );
  }

  Row _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 20,
          child: ClipOval(
            child: Image.network(
              reward.bakerDetail?.logo ?? "",
              fit: BoxFit.fill,
              width: 40,
              height: 40,
            ),
          ),
        ),
        0.02.hspace,
        RichText(
            text: TextSpan(
                text: '${reward.bakerDetail?.name}\n',
                style: labelMedium,
                children: [
              TextSpan(
                text: tz1Shortner(reward.bakerDetail?.address ?? ""),
                style: labelSmall.copyWith(color: ColorConst.Primary),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: IconButton(
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: reward.bakerDetail?.address ?? ""));
                    Get.rawSnackbar(
                      message: "Copied to clipboard",
                      shouldIconPulse: true,
                      snackPosition: SnackPosition.BOTTOM,
                      maxWidth: 0.9.width,
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      duration: const Duration(milliseconds: 750),
                    );
                  },
                  icon: SvgPicture.asset(
                    '${PathConst.SVG}copy.svg',
                    color: ColorConst.Primary,
                    fit: BoxFit.contain,
                    height: 12.aR,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ])),
        const Spacer(),
        Row(
          children: [
            Text(
              reward.cycle.toString(),
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
    );
  }

  double get totalRewards {
    if (reward.status == "Completed") {
      return ((reward.blockRewards + reward.endorsementRewards) / pow(10, 6));
    }
    return ((reward.futureBlockRewards + reward.futureEndorsementRewards) /
        pow(10, 6));
  }

  double get expectedPayout =>
      (reward.balance / reward.activeStake) * totalRewards;

  double get netExpectedPayout =>
      (1 - (reward.bakerDetail?.fee ?? 0)) * expectedPayout;
}
