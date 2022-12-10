import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';

enum NftGalleryFilter { collection, list, thumbnail }

class NftGalleryController extends GetxController {
  RxInt selectedGalleryIndex = 0.obs;
  RxList<NftGalleryModel> nftGalleryList = <NftGalleryModel>[].obs;
  var selectedNftGallery = NftGalleryModel().obs;

  RxString searchText = ''.obs;

  RxBool isEditing = false.obs;

  RxBool isTransactionPopUpOpened = false.obs;

  List<NftTokenModel> nftList = [];

  RxBool isSearch = false.obs;

  RxMap<String, List<NftTokenModel>> galleryNfts =
      <String, List<NftTokenModel>>{}.obs;

  RxMap<String, List<NftTokenModel>> searchNfts =
      <String, List<NftTokenModel>>{}.obs;

  final List<String> nftTypesChips = [
    "All",
    "Art",
    "Collectibles",
    "Domain Names",
    "Music",
  ];

  RxBool isScrollingUp = false.obs;
  var selectedGalleryFilter = NftGalleryFilter.collection.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    selectedGalleryIndex.value = Get.arguments[0];
    nftGalleryList.value = Get.arguments[1];
    selectedNftGallery.value = nftGalleryList[selectedGalleryIndex.value];
    await fetchAllNftForGallery();
  }

  changeSelectedNftGallery(int index) async {
    selectedGalleryIndex.value = index;
    selectedNftGallery.value = nftGalleryList[index];
    galleryNfts.value = {};
    await fetchAllNftForGallery();
  }

  Future<void> searchNftGallery(String searchText) async {
    searchNfts.value = {};
    this.searchText.value = searchText;
    if (searchText.isNotEmpty) {
      List<NftTokenModel> filteredNfts = nftList
          .where((element) =>
              element.name!.toLowerCase().contains(searchText) ||
              element.fa!.name!.toLowerCase().contains(searchText) ||
              (element.creators![0].holder!.alias ??
                      element.creators![0].holder!.address!.tz1Short())
                  .toLowerCase()
                  .contains(searchText))
          .toList();

      for (var i = 0; i < filteredNfts.length; i++) {
        searchNfts[filteredNfts[i].fa!.contract!] =
            (searchNfts[filteredNfts[i].fa!.contract!] ?? [])
              ..add(filteredNfts[i]);
      }
    }
  }

  Future<void> fetchAllNftForGallery() async {
    nftList = await selectedNftGallery.value.fetchAllNft();
    for (var i = 0; i < nftList.length; i++) {
      galleryNfts[nftList[i].fa!.contract!] =
          (galleryNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
    }
  }

  Future<void> removeGallery(int galleryIndex) async {
  
    await UserStorageService().removeGallery(galleryIndex);
    await fetchAllNftForGallery();
    await Get.find<NftGalleryWidgetController>().fetchNftGallerys();
    print("nfts left: ${nftGalleryList.length}");
    if (nftGalleryList.isEmpty) {
      Get.back();
    } else {
      selectedGalleryIndex.value = 0;
      selectedNftGallery.value = nftGalleryList[0];
      galleryNfts.value = {};
      await fetchAllNftForGallery();
    }

    Get.back();
  }

  Future<void> editGallery(int galleryIndex) async {
    Get.back();
    await Get.find<NftGalleryWidgetController>()
        .showEditNewNftGalleryBottomSheet(
      nftGalleryList[galleryIndex],
      galleryIndex,
    );
    selectedNftGallery.value = nftGalleryList[galleryIndex];
    isEditing.value = false;
    galleryNfts.value = {};
    await fetchAllNftForGallery();
  }
}
