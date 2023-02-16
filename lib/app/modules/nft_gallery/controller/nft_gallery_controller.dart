import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:simple_gql/simple_gql.dart';

import '../../../data/services/service_config/service_config.dart';
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
  int offsetContract = 0;

  RxMap<String, List<NftTokenModel>> galleryNfts =
      <String, List<NftTokenModel>>{}.obs;

  RxMap<String, List<NftTokenModel>> searchNfts =
      <String, List<NftTokenModel>>{}.obs;

  List contracts = [];
  bool loadingMore = false;

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
  onInit() {
    super.onInit();
    selectedGalleryIndex.value = Get.arguments[0];
    nftGalleryList.value = Get.arguments[1];
    selectedNftGallery.value = nftGalleryList[selectedGalleryIndex.value];
  }

  @override
  onReady() async {
    super.onReady();
    fetchAllNftForGallery();
  }

  changeSelectedNftGallery(int index) async {
    selectedGalleryIndex.value = index;
    selectedNftGallery.value = nftGalleryList[index];
    galleryNfts.value = {};
    offsetContract = 0;
    contracts = [];
    await fetchAllNftForGallery();
  }

  Future<void> searchNftGallery(String searchText) async {
    searchNfts.value = {};
    this.searchText.value = searchText;
    if (searchText.isNotEmpty) {
      List<NftTokenModel> filteredNfts = nftList
          .where((element) =>
              (element.name?.toLowerCase().contains(searchText) ?? false) ||
              (element.tokenId?.toLowerCase().contains(searchText) ?? false) ||
              (element.fa?.name?.toLowerCase().contains(searchText) ?? false) ||
              (element.fa?.contract?.toLowerCase().contains(searchText) ??
                  false) ||
              ((element.creators!.isNotEmpty) &&
                  ((element.creators![0].holder?.alias ??
                              element.creators![0].holder?.address!.tz1Short())
                          ?.toLowerCase()
                          .contains(searchText) ??
                      false)))
          .toList();

      for (var i = 0; i < filteredNfts.length; i++) {
        searchNfts[filteredNfts[i].faContract!] =
            (searchNfts[filteredNfts[i].faContract!] ?? [])
              ..add(filteredNfts[i]);
      }
    }
  }

  Future<void> fetchAllNftForGallery() async {
    loadingMore = true;
    if (contracts.isEmpty) {
      await getContractsStorage(selectedNftGallery.value.publicKeyHashs);
    }

    nftList = await compute(
        fetchAllNft,
        [
          selectedNftGallery.value.publicKeyHashs!,
          contracts.skip(offsetContract).take(10).toList()
        ],
        debugLabel: "fetchNFTs");

    offsetContract += 10;

    for (var i = 0; i < nftList.length; i++) {
      galleryNfts[nftList[i].faContract!] =
          (galleryNfts[nftList[i].faContract!] ?? [])..add(nftList[i]);
    }
    loadingMore = false;
  }

  getContractsStorage(List<String>? publicKeyHashs) async {
    if (publicKeyHashs == null) return;

    var allContracts = [];
    for (var publicKeyHash in publicKeyHashs) {
      List contracts = jsonDecode((await ServiceConfig.localStorage
                  .read(key: "${ServiceConfig.nftStorage}_$publicKeyHash") ??
              "[]")
          .toString());
      allContracts.addAll(contracts);
    }
    contracts = allContracts.toSet().toList();
  }

  Future<void> removeGallery(int galleryIndex) async {
    await UserStorageService().removeGallery(galleryIndex);
    // await fetchAllNftForGallery();
    Get.find<NftGalleryWidgetController>().fetchNftGallerys();
    print("nfts left: ${nftGalleryList.length}");
    if (nftGalleryList.isEmpty) {
      Get.back();
    } else {
      selectedGalleryIndex.value = 0;
      selectedNftGallery.value = nftGalleryList[0];
      galleryNfts.value = {};
      offsetContract = 0;
      contracts = [];
      fetchAllNftForGallery();
    }

    Get.back();
  }

  Future<NftTokenModel> getNFT(int pk) async {
    final response = await GQLClient(
      'https://data.objkt.com/v3/graphql',
    ).query(
      query: ServiceConfig.getNFTfromPk,
      variables: {
        'pk': pk,
        'addresses': selectedNftGallery.value.publicKeyHashs,
      },
    );
    return (await json(response.data['token']))[0];
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
    offsetContract = 0;
    contracts = [];
    await fetchAllNftForGallery();
  }

/*   static Future<void> _fetchAllNftForGallery(List<dynamic> args) async {
    Map<String, List<NftTokenModel>> galleryNfts =
        <String, List<NftTokenModel>>{};
    for (var i = 0; i < args[0].length; i++) {
      galleryNfts[args[0][i].fa!.contract!] =
          (args[1][args[0][i].fa!.contract!] ?? [])..add(args[0][i]);
    }

    args[2].send(galleryNfts);
  } */

  static Future<List<NftTokenModel>> fetchAllNft(
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
        nfts = [...nfts, ...json(response.data['token'])];
        offset += 500;
        if (response.data['token'].length != 500) {
          break;
        }
      }
      return nfts;
    }

/*     return <NftTokenModel>[
      for (var publicKeyHash in publicKeyHashs!)
        ...(await compute(
            json,
            (await ServiceConfig.localStorage
                    .read(key: "${ServiceConfig.nftStorage}_$publicKeyHash") ??
                "[]"),
            debugLabel: "fetchAllNft"))
    ]; */
  }
}

List<NftTokenModel> json(x) {
  return x.map<NftTokenModel>((e) => NftTokenModel.fromJson(e)).toList();
}
