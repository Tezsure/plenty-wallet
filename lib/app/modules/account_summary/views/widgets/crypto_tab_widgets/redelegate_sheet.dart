import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'delegate_rewards_tile.dart';
import 'redelegate_tile.dart';

class ReDelegateBottomSheet extends StatelessWidget {
  const ReDelegateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.95.height,
      width: 1.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        gradient: GradConst.GradientBackground,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.01.vspace,
          Center(
            child: Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
          ),
          0.02.vspace,
          Center(
            child: Text(
              'Rewards',
              style: titleMedium,
            ),
          ),
          0.02.vspace,
          const Center(child: ReDelegateTile()),
          Padding(
            padding: EdgeInsets.all(14.sp),
            child: Text('Rewards', style: titleMedium),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 0.63.height,
                width: 0.94.width,
                child: ListView.builder(
                  itemCount: 6,
                  primary: false,
                  shrinkWrap: false,
                  itemBuilder: (_, index) => const DelegateRewardsTile(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
