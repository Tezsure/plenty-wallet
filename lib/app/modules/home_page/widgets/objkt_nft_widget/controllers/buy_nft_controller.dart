import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/review_nft.dart';

class BuyNFTController extends GetxController {
  Rx<AccountTokenModel?> selectedToken = null.obs;
  Rx<NftTokenModel?> selectedNFT = NftTokenModel(
          artifactUri:
              "https://ipfs.io/ipfs/QmdcbZTmrFnBk2vowNshC7Cr2UwQW12C1iSc25WWP9o98y",
          name: "Landscape",
          lowestAsk: 100)
      .obs;
  void selectMethod(AccountTokenModel token) {
    selectedToken = token.obs;
    Get.bottomSheet(
      ReviewNFTSheet(),
      settings: RouteSettings(
        arguments: "",
      ),
    );
  }
}
