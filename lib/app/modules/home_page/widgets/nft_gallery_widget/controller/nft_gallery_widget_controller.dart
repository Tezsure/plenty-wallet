import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    var tempNftGallerys = (await UserStorageService().getAllGallery());
    for (int i = 0; i < tempNftGallerys.length; i++) {
      await tempNftGallerys[i].randomNft();
    }
    nftGalleryList.value = tempNftGallerys;
  }

  void showCreateNewNftGalleryBottomSheet() async {
    accounts = await UserStorageService().getAllAccount() +
        (await UserStorageService().getAllAccount(watchAccountsList: true));
    accountNameFocus = FocusNode();
    Get.bottomSheet(
      const CreateNewNftGalleryBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(
        milliseconds: 200,
      ),
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

  Future<void> addNewNftGallery() async {
    final List<String> publicKeyHashs = selectedAccountIndex.keys
        .where((String key) => selectedAccountIndex[key] == true)
        .toList();

    await UserStorageService().writeNewGallery(NftGalleryModel(
      name: accountName.value,
      publicKeyHashs: publicKeyHashs,
      profileImage: selectedImagePath.value,
      imageType: currentSelectedType,
    ));

    await fetchNftGallerys();

    Get.back();
    Get.put(NftGalleryController(
      nftGalleryList.length - 1,
      nftGalleryList,
    ));
    Get.bottomSheet(
      const NftGalleryView(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(
        milliseconds: 200,
      ),
    ).then((_) {
      Get.delete<NftGalleryController>();
    });
  }

  void openGallery(int index) {
    Get.put(NftGalleryController(index, nftGalleryList));
    Get.bottomSheet(
      const NftGalleryView(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enterBottomSheetDuration: const Duration(
        milliseconds: 200,
      ),
    ).then((_) {
      Get.delete<NftGalleryController>();
    });
  }
}
