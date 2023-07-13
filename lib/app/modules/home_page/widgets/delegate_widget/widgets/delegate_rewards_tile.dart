import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/service_models/delegate_reward_model.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/utils.dart';

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
      // height: 192.arP,
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
                  // _buildInfo(
                  //     'Rewards', '${totalRewards.toStringAsFixed(2)} tez'),

                  _buildInfo('Baker fee',
                      '${((reward.bakerDetail?.fee ?? 0) * 100).toStringAsFixed(2)}%'),
                  0.03.hspace, Spacer()
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
            text: '${title.tr}:\n',
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
          radius: 20.arP,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: reward.bakerDetail?.logo ?? "",
              fit: BoxFit.fill,
              width: 40.arP,
              height: 40.arP,
              maxWidthDiskCache: 80,
              maxHeightDiskCache: 80,
            ),
          ),
        ),
        0.02.hspace,
        RichText(
            text: TextSpan(
                text: '${reward.bakerDetail?.name ?? ""}\n',
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
                      maxWidth: 0.45.width,
                      backgroundColor: Colors.transparent,
                      snackPosition: SnackPosition.BOTTOM,
                      snackStyle: SnackStyle.FLOATING,
                      padding: EdgeInsets.only(bottom: 60.arP),
                      messageText: Container(
                        height: 36.arP,
                        padding: EdgeInsets.symmetric(horizontal: 10.arP),
                        decoration: BoxDecoration(
                            color: ColorConst.Neutral.shade10,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 14.arP,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5.arP,
                            ),
                            Text(
                              "Copied to clipboard",
                              style: labelSmall,
                            )
                          ],
                        ),
                      ),
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
            Icon(
              Icons.hourglass_empty,
              color: ColorConst.Primary,
              size: 20.arP,
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
