import 'dart:math';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/collectible_model.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/nft_model.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/token_model.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class TokenAndCollectionPageController extends GetxController {
  RxList<TokenModel> tokens = List.generate(
          6,
          (index) => TokenModel(
              tokenName: "tezos",
              price: 24.4,
              imagePath:
                  "${PathConst.SEND_PAGE}token${(Random().nextInt(3) + 1)}.svg"))
      .obs;

  RxBool isTokensExpaned = false.obs;

  RxList<CollectibleModel> collectibles = List.generate(
    6,
    (index) => CollectibleModel(
      name: "tezos",
      collectibleProfilePath:
          "${PathConst.SEND_PAGE}nft_art${(Random().nextInt(3) + 1)}.png",
      nfts: List.generate(
        3,
        (index) => NFTmodel(
            title: "title",
            name: "name",
            nftPath:
                "${PathConst.SEND_PAGE}nft_image${(Random().nextInt(4) + 1)}.png"),
      ),
    ),
  ).obs;

  RxBool isCollectibleExpaned = false.obs;
}
