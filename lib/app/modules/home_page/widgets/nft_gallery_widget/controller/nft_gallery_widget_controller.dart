import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/view/create_new_nft_gallery/create_new_nft_gallery_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/nft_gallery/controller/nft_gallery_controller.dart';
import 'package:naan_wallet/app/modules/nft_gallery/view/nft_gallery_view.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:naan_wallet/utils/common_functions.dart';

class NftGalleryWidgetController extends GetxController {
  RxList<AccountModel> accounts = <AccountModel>[].obs;
  RxInt index = 0.obs;
  RxMap<String, bool> selectedAccountIndex = <String, bool>{}.obs;

  RxInt formIndex = 0.obs;
  FocusNode accountNameFocus = FocusNode();
  TextEditingController accountNameController =
      TextEditingController(text: 'Gallery 1');
  var currentSelectedType = AccountProfileImageType.assets;
  RxString selectedImagePath = "".obs;
  RxString accountName = 'Gallery 1'.obs;

  RxList<NftGalleryModel> nftGalleryList = <NftGalleryModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await DataHandlerService().nftPatch(() {
      fetchNftGallerys();
    });
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
  }

  Future<void> fetchNftGallerys() async {
    try {
      await UserStorageService().getAllGallery().then((value) async {
        for (int i = 0; i < value.length; i++) {
          await value[i].randomNft();
        }
        nftGalleryList.value = value;
      });
    } catch (e) {
      log(e.toString());
    }

    // List<NftGalleryModel> tempNftGallerys =
    //     (await UserStorageService().getAllGallery());
    // for (int i = 0; i < tempNftGallerys.length; i++) {
    //   bool noNfts = await checkIfEmpty(tempNftGallerys[i].publicKeyHashs!);
    //   if (noNfts) {
    //     await tempNftGallerys[i].randomNft();
    //   } else {
    //     tempNftGallerys.removeAt(i);
    //   }
    // }
    // nftGalleryList.value = tempNftGallerys;
  }

  RxBool isCreating = false.obs;
  //return false if empty

  Future<NftState> checkIfEmpty(List<String> publicKeyHashs) async {
    NftState nftState = NftState.done;
    int emptyCount = 0;
    for (int j = 0; j < publicKeyHashs.length; j++) {
      String? nfts = await UserStorageService()
          .getUserNftsString(userAddress: publicKeyHashs[j]);
      if (nfts == null) {
        nftState = NftState.processing;
        break;
      } else if (nfts == "[]") {
        emptyCount++;
      }
    }
    if (emptyCount == publicKeyHashs.length) {
      nftState = NftState.empty;
    }

    return nftState;
  }

  Future<void> showCreateNewNftGalleryBottomSheet() async {
    accounts.value = await UserStorageService().getAllAccount() +
        (await UserStorageService().getAllAccount(watchAccountsList: true));
    accountNameFocus = FocusNode();

    accountNameController.text = 'Gallery ${nftGalleryList.length + 1}';
    accountName.value = accountNameController.text;
    // NaanAnalytics.logEvent(NaanAnalyticsEvents.CREATE_NFT_GALLERY, param: {
    //   "addresses": accounts?.map((e) => e.publicKeyHash).join(","),
    // });
    CommonFunctions.bottomSheet(const CreateNewNftGalleryBottomSheet(),
            fullscreen: true)
        .then(
      (_) async {
        selectedAccountIndex = <String, bool>{}.obs;
        accounts.value = [];
        formIndex.value = 0;
        accountNameFocus.hasFocus ? accountNameFocus.unfocus() : null;
        accountNameController.text = 'Gallery ${nftGalleryList.length + 1}';
        selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
        accountName.value = accountNameController.text;
      },
    );
  }

  Future<void> showEditNewNftGalleryBottomSheet(
      NftGalleryModel nftGallery, int galleryIndex) async {
    accounts.value = await UserStorageService().getAllAccount() +
        (await UserStorageService().getAllAccount(watchAccountsList: true));

    for (var element in accounts) {
      if (nftGallery.publicKeyHashs!.contains(element.publicKeyHash)) {
        selectedAccountIndex[element.publicKeyHash!] = true;
      }
    }
    accountNameController.text = nftGallery.name!;
    selectedImagePath.value = nftGallery.profileImage!;
    accountName.value = accountNameController.text;
    // NaanAnalytics.logEvent(NaanAnalyticsEvents.EDIT_NFT_GALLERY, param: {
    //   "addresses": accounts?.map((e) => e.publicKeyHash).join(","),
    // });
    accountNameFocus = FocusNode();
    accountNameController.text = 'Gallery ${nftGalleryList.length + 1}';
    accountName.value = accountNameController.text;

    await CommonFunctions.bottomSheet(
            CreateNewNftGalleryBottomSheet(
              nftGalleryModel: nftGallery,
              galleryIndex: galleryIndex,
            ),
            fullscreen: true)
        .then(
      (_) async {
        selectedAccountIndex = <String, bool>{}.obs;
        accounts.value = [];
        formIndex.value = 0;
        accountNameFocus.hasFocus ? accountNameFocus.unfocus() : null;
        accountNameController.text = 'Gallery ${nftGalleryList.length + 1}';
        selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
        accountName.value = accountNameController.text;
      },
    );
  }

  Future<void> editNftGallery(int galleryIndex) async {
    final List<String> publicKeyHashs = selectedAccountIndex.keys
        .where((String key) => selectedAccountIndex[key] == true)
        .toList();
    isCreating.value = true;
    // Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
    // if (nftGalleryList.firstWhereOrNull(
    //         (element) => unOrdDeepEq(element.publicKeyHashs, publicKeyHashs)) !=
    //     null) {
    //   transactionStatusSnackbar(
    //     duration: const Duration(seconds: 2),
    //     status: TransactionStatus.error,
    //     tezAddress: 'Gallery with same Accounts already exists',
    //     transactionAmount: 'Cannot create gallery',
    //   );
    //   isCreating.value = false;
    //   return;
    // }
    NftState check = await checkIfEmpty(publicKeyHashs);
    if (check == NftState.empty) {
      transactionStatusSnackbar(
        duration: const Duration(seconds: 2),
        status: TransactionStatus.error,
        tezAddress: 'No NFTs found in selected wallets',
        transactionAmount: 'Cannot create gallery',
      );
      isCreating.value = false;
      return;
    } else if (check == NftState.processing) {
      transactionStatusSnackbar(
        duration: const Duration(seconds: 2),
        status: TransactionStatus.error,
        tezAddress: 'NFTs still under processing',
        transactionAmount: 'Please wait',
      );
      isCreating.value = false;
      return;
    }

    await UserStorageService().editGallery(
        NftGalleryModel(
          name: accountName.value,
          publicKeyHashs: publicKeyHashs,
          profileImage: selectedImagePath.value,
          imageType: currentSelectedType,
        ),
        galleryIndex);

    await fetchNftGallerys();
    isCreating.value = false;
    Get.back();
  }

  Future<void> addNewNftGallery() async {
    final List<String> publicKeyHashs = selectedAccountIndex.keys
        .where((String key) => selectedAccountIndex[key] == true)
        .toList();

    isCreating.value = true;
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
    if (nftGalleryList.firstWhereOrNull(
            (element) => unOrdDeepEq(element.publicKeyHashs, publicKeyHashs)) !=
        null) {
      transactionStatusSnackbar(
        duration: const Duration(seconds: 2),
        status: TransactionStatus.error,
        tezAddress: 'Gallery with same wallets already exists',
        transactionAmount: 'Cannot create gallery',
      );
      isCreating.value = false;
      return;
    }

    NftState check = await checkIfEmpty(publicKeyHashs);
    if (check == NftState.empty) {
      transactionStatusSnackbar(
        duration: const Duration(seconds: 2),
        status: TransactionStatus.error,
        tezAddress: 'No NFTs found in selected wallets',
        transactionAmount: 'Cannot create gallery',
      );
      isCreating.value = false;
      return;
    } else if (check == NftState.processing) {
      transactionStatusSnackbar(
        duration: const Duration(seconds: 2),
        status: TransactionStatus.error,
        tezAddress: 'NFTs still under processing',
        transactionAmount: 'Please wait',
      );
      isCreating.value = false;
      return;
    }

    try {
      await UserStorageService().writeNewGallery(NftGalleryModel(
        name: accountName.value,
        publicKeyHashs: publicKeyHashs,
        profileImage: selectedImagePath.value,
        imageType: currentSelectedType,
      ));
    } catch (e) {
      transactionStatusSnackbar(
        duration: const Duration(seconds: 2),
        status: TransactionStatus.error,
        tezAddress: (e as Exception).toString(),
        transactionAmount: 'Cannot create gallery',
      );
      isCreating.value = false;
      return;
    }

    await fetchNftGallerys();
    isCreating.value = false;
    Get.back();

    try {
      Get.find<NftGalleryController>();
    } catch (_) {
      Get.put(NftGalleryController());
    }

    CommonFunctions.bottomSheet(
      NftGalleryView(),
      fullscreen: true,
      settings:
          RouteSettings(arguments: [nftGalleryList.length - 1, nftGalleryList]),
    ).then((_) {
      Get.delete<NftGalleryController>();
    });
  }

  void openGallery(int index) {
    // NaanAnalytics.logEvent(NaanAnalyticsEvents.MY_GALLERY_CLICK, param: {
    //   NaanAnalytics.address: nftGalleryList[index].publicKeyHashs?.join(", ")
    // });
    CommonFunctions.bottomSheet(
      NftGalleryView(),
      fullscreen: true,
      settings: RouteSettings(arguments: [index, nftGalleryList]),
    );
  }
}
