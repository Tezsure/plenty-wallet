import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/collectible_model.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_model.dart';
import 'package:naan_wallet/app/data/services/service_models/token_model.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class SendPageController extends GetxController {
  // * Functions & variables for global send flow * //

  RxInt selectedPageIndex =
      0.obs; // 0 - contact, 1 - collection, 2 - send review
  RxInt saveSelectedPageIndex = 0
      .obs; // 0 - contact, 1 - collection, 2 - send review when search textfield has focus, it saves the last page index
  /// Changes the current page index of the send flow, if the keyboard is requested through [isKeyboardRequested], the keyboard will be
  /// shown for next indexed page.
  void setSelectedPageIndex(
      {required int index, bool isKeyboardRequested = false}) {
    if (isKeyboardRequested) {
      recipientFocusNode.value.requestFocus();
    }
    selectedPageIndex.value = index;
  }

  /// Paste the text from the clipboard to the search bar textfield.
  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      searchTextController.value.text = cdata.text!;
      searchText.value = cdata.text!;
    }
  }

  // * For Search Bar Textfield * //

  FocusNode searchBarFocusNode =
      FocusNode(); // FocusNode for search bar textfield
  Rx<TextEditingController> searchTextController = TextEditingController()
      .obs; // TextEditingController for search bar textfield
  Rx<String> searchText = "".obs; // String for search bar textfield

  // * Contact Page * //

  void onContactSelect({required ContactModel contactModel}) {
    searchBarFocusNode.unfocus();
    searchText.value = contactModel.name;
    searchTextController.value.text = contactModel.name;
    setSelectedPageIndex(index: 1);
  }

  RxList<ContactModel> recentsContacts = List.generate(
    3,
    (index) => ContactModel(
        name: 'AmSrik',
        address: "tzAm...Srik",
        imagePath: ServiceConfig.allAssetsProfileImages[
            Random().nextInt(ServiceConfig.allAssetsProfileImages.length - 1)]),
  ).obs; // List of recent contacts

  RxList<ContactModel> contacts = List.generate(
          20,
          (index) => ContactModel(
              name: 'AmSrik',
              address: "tzAm...Srik",
              imagePath: ServiceConfig.allAssetsProfileImages[Random()
                  .nextInt(ServiceConfig.allAssetsProfileImages.length - 1)]))
      .obs; // List of contacts

  RxList<ContactModel> suggestedContacts =
      <ContactModel>[].obs; // List of suggested contacts

  // * Collection Page * //

  RxBool isTokensExpanded =
      false.obs; // check whether token list is expanded or not
  RxBool isCollectibleExpanded =
      false.obs; // Check whether nft list is expanded or not
  RxBool expandNFTCollectible =
      false.obs; // Bool for toggling nft list expansion
  RxInt expandedIndex = 0.obs; // Index of the expanded nft list item

  void setExpandNFTCollectible(int index) {
    if (expandedIndex.value == index) {
      expandNFTCollectible.value = !expandNFTCollectible.value;
    } else {
      expandedIndex.value = index;
      expandNFTCollectible.value = true;
    }
  }

  RxList<TokenModel> tokens = List.generate(
          6,
          (index) => TokenModel(
              tokenName: "tezos",
              price: 24.4,
              imagePath:
                  "${PathConst.SEND_PAGE}token${(Random().nextInt(3) + 1)}.svg"))
      .obs; // List of tokens

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
  ).obs; // List of nft collectibles

  // * Token/Send Review Page * //

  TextEditingController recipientController =
      TextEditingController(); // TextEditingController for recipient textfield
  Rx<FocusNode> recipientFocusNode =
      FocusNode().obs; // FocusNode for send token page textfield
  RxString amount = ''.obs; // String for amount textfield
  RxBool isNFTPage = false.obs; // Whether the page is NFT page or not
  RxBool amountTileFocus =
      false.obs; // Whether the amount tile is focused or not

  /// Sets the page to NFT page for send flow
  void onNFTClick() {
    isNFTPage.value = true;
  }

  /// Sets the page to token for send flow
  void onTokenClick() {
    isNFTPage.value = false;
  }

  @override
  void onReady() {
    recipientController = TextEditingController();
    recipientFocusNode.value.addListener(() {
      recipientFocusNode.value.hasFocus
          ? amountTileFocus.value = true
          : amountTileFocus.value = false;
    });
    searchBarFocusNode.addListener(() {
      if (searchBarFocusNode.hasFocus) {
        saveSelectedPageIndex.value = selectedPageIndex.value;
        setSelectedPageIndex(index: 0);
      } else {
        setSelectedPageIndex(index: saveSelectedPageIndex.value);
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    searchBarFocusNode
      ..removeListener(() {})
      ..unfocus()
      ..dispose();
    recipientFocusNode.value
      ..removeListener(() {})
      ..unfocus()
      ..dispose();
    recipientController.dispose();
    searchTextController.value.dispose();
    SendPageController().dispose();
    super.onClose();
  }
}
