import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../widgets/nft_tab_widgets/nft_collectibles.dart';

class NFTabPage extends GetView<AccountSummaryController> {
  const NFTabPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 0.035.width),
      itemCount: controller.userNfts.length,
      itemBuilder: ((context, index) => NftCollectibles(
            nftList:
                controller.userNfts[controller.userNfts.keys.toList()[index]]!,
          )),
    );
  }
}
