import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../data/services/service_models/collectible_model.dart';
import '../widgets/nft_tab_widgets/nft_collectibles.dart';

class NFTabPage extends StatelessWidget {
  final List<CollectibleModel> collectibles;

  const NFTabPage({super.key, required this.collectibles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 0.035.width),
      itemCount: collectibles.length,
      itemBuilder: ((context, index) =>
          NftCollectibles(collectibleModel: collectibles[index])),
    );
  }
}
