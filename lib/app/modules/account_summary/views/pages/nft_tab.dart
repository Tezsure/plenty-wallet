import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../widgets/nft_tab_widgets/nft_collectibles.dart';

class NFTabPage extends GetView<AccountSummaryController> {
  const NFTabPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return controller.userNfts.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              0.04.vspace,
              SvgPicture.asset(
                "assets/empty_states/empty2.svg",
                height: 120.sp,
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "No Collections",
                      style: titleLarge.copyWith(fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                            text: "\nExplore new collectibles on objkt",
                            style: labelMedium.copyWith(
                                color: ColorConst.NeutralVariant.shade60))
                      ]))
            ],
          )
        : ListView.builder(
            padding: EdgeInsets.only(left: 14.sp, right: 14.sp, top: 14.sp),
            itemCount: controller.userNfts.length,
            itemBuilder: ((context, index) => NftCollectibles(
                  nftList: controller
                      .userNfts[controller.userNfts.keys.toList()[index]]!,
                )),
          );
  }
}
