import 'dart:math';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/token_model.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

import '../../../data/services/service_models/collectible_model.dart';
import '../../../data/services/service_models/nft_model.dart';

class AccountSummaryController extends GetxController {
  RxBool isEditable = false.obs; // for token edit mode
  RxBool expandTokenList =
      false.obs; // false = show 3 tokens, true = show all tokens
  RxBool isAccountDelegated =
      false.obs; // To check if current account is delegated

  void onPinToken() {
    // Move the selected indexes on top of the list when pin is clicked
    tokens
      ..where((token) => token.isSelected && !token.isHidden)
          .toList()
          .forEach((element) {
        element.isPinned = true;
        tokens.remove(element);
        tokens.insert(0, element);
      })
      ..refresh();
    isEditable.value = false;
    expandTokenList.value = false;
  }

  void onHideToken() {
    // Move the tokens to the end of the list when hide is clicked
    tokens
      ..where((token) => token.isSelected && !token.isPinned)
          .toList()
          .forEach((element) {
        element.isHidden = true;
        tokens.remove(element);
        tokens.add(element);
      })
      ..refresh();
    isEditable.value = false;
    expandTokenList.value = false;
  }

  // ? NFTS TAB Page Data

  static List<String> mockCollectibleName = [
    'unstable dreams',
    'DOGAMI',
    'hic et nun'
  ];

  RxList<CollectibleModel> collectibles = List.generate(
    6,
    (index) => CollectibleModel(
      name: mockCollectibleName[Random().nextInt(3)],
      collectibleProfilePath:
          "${PathConst.SEND_PAGE}nft_art${(Random().nextInt(3) + 1)}.png",
      nfts: List.generate(
        3,
        (index) => NFTmodel(
            title: "Unstable #5",
            name: "unstable dreams",
            nftPath:
                "${PathConst.SEND_PAGE}nft_image${(Random().nextInt(4) + 1)}.png"),
      ),
    ),
  ).obs; // List of nft collectibles

  RxList<TokenModel> tokens = List.generate(
          6,
          (index) => TokenModel(
                tokenName: "tezos",
                price: 24.4,
                isSelected: false,
                imagePath:
                    "${PathConst.SEND_PAGE}token${(Random().nextInt(3) + 1)}.svg",
              ),
          growable: true)
      .obs; // List of tokens

}
