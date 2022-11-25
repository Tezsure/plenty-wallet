import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/utils/utils.dart';

enum NftGalleryFilter { collection, list, thumbnail }

class NftGalleryController extends GetxController {
  RxInt selectedGalleryIndex = 0.obs;
  RxList<NftGalleryModel> nftGalleryList = <NftGalleryModel>[].obs;
  var selectedNftGallery = NftGalleryModel().obs;

  List<NftTokenModel> nftList = [];

  NftGalleryController(int selectedGalleryIndex, this.nftGalleryList) {
    this.selectedGalleryIndex.value = selectedGalleryIndex;
    selectedNftGallery.value = nftGalleryList[selectedGalleryIndex];
  }
  TextEditingController searchController = TextEditingController();

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
    await fetchAllNftForGallery();
  }

  Future<void> searchNftGallery(String searchText) async {
    searchNfts.value = {};
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

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
