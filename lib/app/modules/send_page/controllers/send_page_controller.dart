import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dartez/models/key_store_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/operation_service/operation_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_model.dart';
import 'package:naan_wallet/app/data/services/tezos_domain_service/tezos_domain_service.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/token_view.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:simple_gql/simple_gql.dart';

class SendPageController extends GetxController {
  AccountModel? senderAccountModel;

  RxDouble xtzPrice = 0.0.obs;
  RxList<AccountTokenModel> userTokens =
      <AccountTokenModel>[].obs; // List of tokens
  RxMap<String, List<NftTokenModel>> userNfts =
      <String, List<NftTokenModel>>{}.obs; // List of tokens

  Rx<TextfieldType> selectedTextfieldType = TextfieldType.token.obs;
  RxString estimatedFee = "0.00181".obs;
  int? callbackHash;
  int contractOffset = 0;
  List contracts = [];
  @override
  void onInit() {
    super.onInit();
    senderAccountModel = Get.arguments as AccountModel;

    callback(value) {
      xtzPrice.value = value;
      fetchAllTokens();
    }

    callbackHash = callback.hashCode;

    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback(callback);
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
    if (index == 2) {
      estimatedFee.value = "0.0";
      getFees();
    }
  }

  getFees() async {
    AccountSecretModel? accountSecretModel = await UserStorageService()
        .readAccountSecrets(senderAccountModel!.publicKeyHash!);

    // submit Tx
    KeyStoreModel keyStoreModel = KeyStoreModel(
      publicKeyHash: senderAccountModel!.publicKeyHash!,
      secretKey: accountSecretModel!.secretKey,
      publicKey: accountSecretModel.publicKey,
    );
    OperationModel operationModel;

    if (isNFTPage.value) {
      operationModel = OperationModel<NftTokenModel>();
    } else {
      operationModel = OperationModel<AccountTokenModel>();
    }

    operationModel.amount = !isNFTPage.value ? 0.00001 : 0.0;

    operationModel.keyStoreModel = keyStoreModel;

    operationModel.model =
        isNFTPage.value ? selectedNftModel : selectedTokenModel;

    operationModel.receiverContractAddres =
        !isNFTPage.value && selectedTokenModel!.name == "Tezos"
            ? ""
            : isNFTPage.value
                ? selectedNftModel!.faContract
                : selectedTokenModel!.contractAddress;

    operationModel.receiveAddress = selectedReceiver.value!.address;

    if (!isNFTPage.value && selectedTokenModel!.name == "Tezos") {
      estimatedFee.value = "0.00185";
      // print(opHash);
    } else {
      operationModel.buildParams();
      // do preApply from start and inject here,
      try {
        operationModel.preAppliedResult = await OperationService()
            .preApplyOperation(
                operationModel, ServiceConfig.currentSelectedNode);

        // var opHash =
        estimatedFee.value = ((int.parse(operationModel
                        .preAppliedResult!["gasEstimation"]
                        .toString()) /
                    1e6) *
                xtzPrice.value)
            .toString();
      } catch (e) {
        amountTileError.value = true;
        transactionStatusSnackbar(
          duration: const Duration(seconds: 2),
          status: TransactionStatus.error,
          tezAddress: 'You have low tez',
          transactionAmount: 'Low balance',
        );
        print(e.toString());
      }
      // print(opHash);
    }
  }

  /// Paste the text from the clipboard to the search bar textfield.
  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      searchTextController.value.text = cdata.text!;
      searchText.value = cdata.text!;
      TezosDomainService().searchUsingText(cdata.text!).then((data) {
        /// add if not exits
        data = data
            .map<ContactModel>((e) => contacts.contains(e)
                ? contacts[contacts.indexOf(e)]
                : suggestedContacts.contains(e)
                    ? suggestedContacts[suggestedContacts.indexOf(e)]
                    : e)
            .toList();
        if (cdata.text!.isValidWalletAddress && data.isEmpty) {
          data.add(ContactModel(
              name: "Account",
              address: cdata.text!,
              imagePath: ServiceConfig.allAssetsProfileImages[Random().nextInt(
                ServiceConfig.allAssetsProfileImages.length - 1,
              )]));
        }
        suggestedContacts.value = data;
      });
/*       if (cdata.text!.isValidWalletAddress) {
        suggestedContacts.value.add(ContactModel(
            name: "Account",
            address: cdata.text!,
            imagePath: ServiceConfig.allAssetsProfileImages[Random().nextInt(
              ServiceConfig.allAssetsProfileImages.length - 1,
            )]));
      } */
    }
  }

  /// Paste the text from the clipboard to the search bar textfield.
  void scanner(String address) async {
    searchTextController.value.text = address;
    searchText.value = address;
    TezosDomainService().searchUsingText(address).then((data) {
      /// add if not exits
      data = data
          .map<ContactModel>((e) => contacts.contains(e)
              ? contacts[contacts.indexOf(e)]
              : suggestedContacts.contains(e)
                  ? suggestedContacts[suggestedContacts.indexOf(e)]
                  : e)
          .toList();
      if (address.isValidWalletAddress && data.isEmpty) {
        data.add(ContactModel(
            name: "Account",
            address: address,
            imagePath: ServiceConfig.allAssetsProfileImages[Random().nextInt(
              ServiceConfig.allAssetsProfileImages.length - 1,
            )]));
      }
      suggestedContacts.value = data;
    });
/*       if (cdata.text!.isValidWalletAddress) {
        suggestedContacts.value.add(ContactModel(
            name: "Account",
            address: cdata.text!,
            imagePath: ServiceConfig.allAssetsProfileImages[Random().nextInt(
              ServiceConfig.allAssetsProfileImages.length - 1,
            )]));
      } */
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

  bool isLoadingMore = false;
  RxBool nftLoading = false.obs;

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
    // userNfts.clear();
    if (senderAccountModel!.publicKeyHash == null) return;
/*     isLoadingMore = true;
    if (contractOffset == 0) {
      nftLoading.value = true;
    } */
    UserStorageService()
        .getUserNftsString(userAddress: senderAccountModel!.publicKeyHash!)
        .then((nftList) async {
      nftList ??= "[]";
      contracts = jsonDecode(nftList);
      userNfts.value = await compute(
          nftsIsolate,
          [
            [senderAccountModel!.publicKeyHash!],
            contracts.toList(),
            userNfts.value
          ],
          debugLabel: "getUserNft ACCOUNT SUMMARY");
      //contractOffset += 6;
      //isLoadingMore = false;
      //nftLoading.value = false;

/*       for (var i = 0; i < nftList.length; i++) {
        userNfts[nftList[i].fa!.contract!] =
            (userNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
      } */
    });
  }

  static Future<Map<String, List<NftTokenModel>>> nftsIsolate(
      /* int offsetContract,
      List<String> publicKeyHashes, List<String> contracts */
      List data) async {
    {
      int offset = 0;
      List<NftTokenModel> nfts = [];
      while (true) {
        final response = await GQLClient(
          'https://data.objkt.com/v3/graphql',
        ).query(
          query: ServiceConfig.getNftsFromContracts,
          variables: {
            'contracts': data[1],
            'holders': data[0],
            'offset': offset,
          },
        );
        nfts = [
          ...nfts,
          ...(response.data['token'])
              .map<NftTokenModel>((e) => NftTokenModel.fromJson(e))
              .toList()
        ];
        offset += 500;
        if (response.data['token'].length != 500) {
          break;
        }
      }
      Map<String, List<NftTokenModel>> userNfts = data[2];
      for (var i = 0; i < nfts.length; i++) {
        userNfts[nfts[i].faContract!] = (userNfts[nfts[i].faContract!] ?? [])
          ..add(nfts[i]);
      }
      return userNfts;
    }
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
    amountController.clear();
    amountUsdController.clear();
    selectedNftModel = nftModel;
    isNFTPage.value = true;
  }

  /// Sets the page to token for send flow
  void onTokenClick(AccountTokenModel tokenModel) {
    amountController.clear();
    amountUsdController.clear();

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
      }
      // else {
      //   setSelectedPageIndex(index: saveSelectedPageIndex.value);
      // }
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
    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .removeCallback(callbackHash);
    print("Closed sendflow callback");
    super.onClose();
  }
}
