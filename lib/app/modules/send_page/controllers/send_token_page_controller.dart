import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/contact_page/models/contact_model.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/collectible_model.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/nft_model.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/token_model.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class SendPageController extends GetxController {
  TextEditingController recipientController = TextEditingController();
  FocusNode recipientFocusNode = FocusNode();
  Rx<TextEditingController> searchTextController = TextEditingController().obs;

  Rx<String> searchText = "".obs;
  RxList<ContactModel> recentsContacts = List.generate(
    3,
    (index) => ContactModel(
        name: 'AmSrik',
        address: "tzAm...Srik",
        imagePath: ServiceConfig.allAssetsProfileImages[
            Random().nextInt(ServiceConfig.allAssetsProfileImages.length - 1)]),
  ).obs;

  RxList<ContactModel> contacts = List.generate(
      20,
      (index) => ContactModel(
          name: 'AmSrik',
          address: "tzAm...Srik",
          imagePath: ServiceConfig.allAssetsProfileImages[Random()
              .nextInt(ServiceConfig.allAssetsProfileImages.length - 1)])).obs;

  RxList<ContactModel> suggestedContacts = <ContactModel>[].obs;

  void setSelectedPageIndex(
      {required int index, bool isKeyboardRequested = false}) {
    if (isKeyboardRequested) {
      recipientFocusNode.requestFocus();
    }
    selectedPageIndex.value = index;
  }

  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      searchTextController.value.text = cdata.text!;
      searchText.value = cdata.text!;
    }
  }

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

  RxString amount = ''.obs;
  RxBool isNFTPage = false.obs;

  RxInt selectedPageIndex = 0.obs;

  void onNFTClick() {
    isNFTPage.value = true;
  }

  void onTokenClick() {
    isNFTPage.value = false;
  }

  @override
  void onReady() {
    recipientController = TextEditingController();
    super.onReady();
  }

  @override
  void onClose() {
    recipientFocusNode
      ..unfocus()
      ..dispose();
    recipientController.dispose();
    searchTextController.value.dispose();
    super.onClose();
  }
}
