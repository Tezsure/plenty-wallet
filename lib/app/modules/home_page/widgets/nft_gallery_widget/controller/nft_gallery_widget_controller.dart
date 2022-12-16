import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/view/create_new_nft_gallery/create_new_nft_gallery_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/nft_gallery/controller/nft_gallery_controller.dart';
import 'package:naan_wallet/app/modules/nft_gallery/view/nft_gallery_view.dart';

class NftGalleryWidgetController extends GetxController {
  List<AccountModel>? accounts;
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
    await fetchNftGallerys();
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
  }

  Future<void> fetchNftGallerys() async {
    List<NftGalleryModel> tempNftGallerys =
        (await UserStorageService().getAllGallery());
    for (int i = 0; i < tempNftGallerys.length; i++) {
      bool noNfts = await checkIfEmpty(tempNftGallerys[i].publicKeyHashs!);
      if (noNfts) {
        await tempNftGallerys[i].randomNft();
      } else {
        tempNftGallerys.removeAt(i);
      }
    }
    nftGalleryList.value = tempNftGallerys;
  }

  //return false if empty
  Future<bool> checkIfEmpty(List<String> publicKeyHashs) async {
    bool noNfts = false;
    for (int j = 0; j < publicKeyHashs.length; j++) {
      if ((await UserStorageService()
              .getUserNfts(userAddress: publicKeyHashs[j]))
          .isNotEmpty) {
        noNfts = true;
        break;
      }
    }
    return noNfts;
  }

  Future<void> showCreateNewNftGalleryBottomSheet() async {
    accounts = await UserStorageService().getAllAccount() +
        (await UserStorageService().getAllAccount(watchAccountsList: true));
    accountNameFocus = FocusNode();
    NaanAnalytics.logEvent(NaanAnalyticsEvents.CREATE_NFT_GALLERY, param: {
      "addresses": accounts?.map((e) => e.publicKeyHash).join(","),
    });
    Get.bottomSheet(
      const CreateNewNftGalleryBottomSheet(),
      isScrollControlled: true,
      ignoreSafeArea: false,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
    ).then(
      (_) async {
        selectedAccountIndex = <String, bool>{}.obs;
        accounts = null;
        formIndex.value = 0;
        accountNameFocus.hasFocus ? accountNameFocus.unfocus() : null;
        accountNameController.text = 'Gallery 1';
        selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
        accountName.value = accountNameController.text;
      },
    );
  }

  Future<void> showEditNewNftGalleryBottomSheet(
      NftGalleryModel nftGallery, int galleryIndex) async {
    accounts = await UserStorageService().getAllAccount() +
        (await UserStorageService().getAllAccount(watchAccountsList: true));

    for (var element in accounts!) {
      if (nftGallery.publicKeyHashs!.contains(element.publicKeyHash)) {
        selectedAccountIndex[element.publicKeyHash!] = true;
      }
    }
    accountNameController.text = nftGallery.name!;
    selectedImagePath.value = nftGallery.profileImage!;
    accountName.value = accountNameController.text;
    NaanAnalytics.logEvent(NaanAnalyticsEvents.EDIT_NFT_GALLERY, param: {
      "addresses": accounts?.map((e) => e.publicKeyHash).join(","),
    });
    accountNameFocus = FocusNode();
    await Get.bottomSheet(
      CreateNewNftGalleryBottomSheet(
        nftGalleryModel: nftGallery,
        galleryIndex: galleryIndex,
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
    ).then(
      (_) async {
        selectedAccountIndex = <String, bool>{}.obs;
        accounts = null;
        formIndex.value = 0;
        accountNameFocus.hasFocus ? accountNameFocus.unfocus() : null;
        accountNameController.text = 'Gallery 1';
        selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
        accountName.value = accountNameController.text;
      },
    );
  }

  Future<void> editNftGallery(int galleryIndex) async {
    final List<String> publicKeyHashs = selectedAccountIndex.keys
        .where((String key) => selectedAccountIndex[key] == true)
        .toList();

    if (!(await checkIfEmpty(publicKeyHashs))) {
      Get.snackbar('Cant create gallery', 'No NFTs found in selected accounts',
          backgroundColor: Colors.red, colorText: Colors.white);
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

    Get.back();
  }

  Future<void> addNewNftGallery() async {
    final List<String> publicKeyHashs = selectedAccountIndex.keys
        .where((String key) => selectedAccountIndex[key] == true)
        .toList();

    if (!(await checkIfEmpty(publicKeyHashs))) {
      Get.snackbar('Cant create gallery', 'No NFTs found in selected accounts',
          backgroundColor: Colors.red, colorText: Colors.white);
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
      Get.snackbar(
          'Cant create gallery', 'Gallery with same name already exists',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    await fetchNftGallerys();

    Get.back();

    Get.bottomSheet(
      const NftGalleryView(),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      settings:
          RouteSettings(arguments: [nftGalleryList.length - 1, nftGalleryList]),
    ).then((_) {
      Get.delete<NftGalleryController>();
    });
  }

  void openGallery(int index) {
    NaanAnalytics.logEvent(NaanAnalyticsEvents.MY_GALLERY_CLICK);
    Get.bottomSheet(
      const NftGalleryView(),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      isScrollControlled: true,
      settings: RouteSettings(arguments: [index, nftGalleryList]),
      backgroundColor: Colors.transparent,
    );
  }
}
