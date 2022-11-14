import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/token_view.dart';

class SendPageController extends GetxController {
  AccountModel? senderAccountModel;

  RxDouble xtzPrice = 0.0.obs;
  RxList<AccountTokenModel> userTokens =
      <AccountTokenModel>[].obs; // List of tokens
  RxMap<String, List<NftTokenModel>> userNfts =
      <String, List<NftTokenModel>>{}.obs; // List of tokens
  

  Rx<TextfieldType> selectedTextfieldType = TextfieldType.token.obs;
  @override
  void onInit() {
    super.onInit();
    senderAccountModel = Get.arguments as AccountModel;
    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback((value) {
      xtzPrice.value = value;
      fetchAllTokens();
    });
    fetchAllNfts();

    updateSavedContacts();
  }

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
      FocusScope.of(Get.context!).requestFocus(amountFocusNode.value);
      // amountFocusNode.value.unfocus();
      // amountFocusNode.value.requestFocus(FocusNode());
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

  Timer? searchDebounceTimer;

  FocusNode searchBarFocusNode =
      FocusNode(); // FocusNode for search bar textfield
  Rx<TextEditingController> searchTextController = TextEditingController()
      .obs; // TextEditingController for search bar textfield
  Rx<String> searchText = "".obs; // String for search bar textfield

  // * Contact Page * //

  Rx<ContactModel?> selectedReceiver = Rx<ContactModel?>(null);

  void onContactSelect({required ContactModel contactModel}) {
    selectedReceiver.value = contactModel;
    searchBarFocusNode.unfocus();
    searchText.value = contactModel.name == "Account"
        ? contactModel.address
        : contactModel.name;
    searchTextController.value.text = contactModel.name == "Account"
        ? contactModel.address
        : contactModel.name;
    setSelectedPageIndex(index: 1);
  }

  RxList<ContactModel> recentsContacts = <ContactModel>[].obs;

  RxList<ContactModel> contacts = <ContactModel>[].obs;

  RxList<ContactModel> suggestedContacts =
      <ContactModel>[].obs; // List of suggested contacts

  Future<void> updateSavedContacts() async {
    contacts.value = await UserStorageService().getAllSavedContacts();
  }

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

  Future<void> fetchAllTokens() async {
    userTokens.clear();
    userTokens.addAll(await UserStorageService()
        .getUserTokens(userAddress: senderAccountModel!.publicKeyHash!));
    if (userTokens.isEmpty) {
      userTokens.add(AccountTokenModel(
        name: "Tezos",
        balance: senderAccountModel!.accountDataModel!.xtzBalance!,
        contractAddress: "xtz",
        symbol: "Tezos",
        currentPrice: xtzPrice.value,
        tokenId: "0",
        decimals: 6,
        iconUrl: "assets/tezos_logo.png",
      ));
    } else {
      if (userTokens.any((element) => element.name!.contains("Tezos"))) {
        userTokens.map((element) => element.name!.contains("Tezos")
            ? element.copyWith(
                balance: senderAccountModel!.accountDataModel!.xtzBalance!,
                currentPrice: xtzPrice.value,
              )
            : null);
      } else {
        userTokens.insert(
            0,
            AccountTokenModel(
              name: "Tezos",
              balance: senderAccountModel!.accountDataModel!.xtzBalance!,
              contractAddress: "xtz",
              symbol: "Tezos",
              currentPrice: xtzPrice.value,
              tokenId: "0",
              decimals: 6,
              iconUrl: "assets/tezos_logo.png",
            ));
      }
    }
  }

  Future<void> fetchAllNfts() async {
    UserStorageService()
        .getUserNfts(userAddress: senderAccountModel!.publicKeyHash!)
        .then((nftList) {
      for (var i = 0; i < nftList.length; i++) {
        userNfts[nftList[i].fa!.contract!] =
            (userNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
      }
    });
  }

  // * Token/Send Review Page * //

  TextEditingController amountController =
      TextEditingController(); // TextEditingController for recipient textfield
  Rx<FocusNode> amountFocusNode =
      FocusNode().obs; // FocusNode for send token page textfield
  RxString amount = ''.obs; // String for amount textfield
  RxBool isNFTPage = false.obs; // Whether the page is NFT page or not
  RxBool amountTileFocus =
      false.obs; // Whether the amount tile is focused or not
  RxBool amountTileError = false.obs;
  RxBool amountUsdTileError = false.obs;
  TextEditingController amountUsdController = TextEditingController();
  NftTokenModel? selectedNftModel;
  AccountTokenModel? selectedTokenModel;
  RxString amountText = "".obs;

  /// Sets the page to NFT page for send flow
  void onNFTClick(NftTokenModel nftModel) {
    selectedNftModel = nftModel;
    isNFTPage.value = true;
  }

  /// Sets the page to token for send flow
  void onTokenClick(AccountTokenModel tokenModel) {
    selectedTokenModel = tokenModel;
    isNFTPage.value = false;
  }

  @override
  void onReady() {
    amountController = TextEditingController();
    amountFocusNode.value.addListener(() {
      amountFocusNode.value.hasFocus
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
    amountFocusNode.value
      ..removeListener(() {})
      ..unfocus()
      ..dispose();
    amountUsdController.dispose();
    amountController.dispose();
    searchTextController.value.dispose();
    SendPageController().dispose();
    super.onClose();
  }
}
