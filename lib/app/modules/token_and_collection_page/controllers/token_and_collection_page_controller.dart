import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/collectible_model.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/nft_model.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/token_model.dart';

class TokenAndCollectionPageController extends GetxController {
  RxList<TokenModel> tokens =
      List.generate(6, (index) => TokenModel(tokenName: "tezos", price: 24.4))
          .obs;

  RxBool isTokensExpaned = false.obs;

  RxList<CollectibleModel> collectibles = List.generate(
      6,
      (index) => CollectibleModel(
          name: "tezos",
          nfts: List.generate(
              3, (index) => NFTmodel(title: "title", name: "name")))).obs;


  RxBool isCollectibleExpaned = false.obs;
  
}
