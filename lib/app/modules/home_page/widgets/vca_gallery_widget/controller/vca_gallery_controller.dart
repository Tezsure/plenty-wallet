import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';

import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';

import 'package:simple_gql/simple_gql.dart';

enum NftGalleryFilter { collection, list, thumbnail }

class VcaGalleryController extends GetxController {
  RxInt selectedGalleryIndex = 0.obs;
  RxList<NftGalleryModel> nftGalleryList = <NftGalleryModel>[].obs;

  RxBool isEditing = false.obs;

  RxBool isTransactionPopUpOpened = false.obs;

  List<NftTokenModel> nftList = [];

  int offsetNFT = 0;

  RxMap<String, List<NftTokenModel>> galleryNfts =
      <String, List<NftTokenModel>>{}.obs;

  List NFTsPk = [];
  bool loadingMore = false;
  Timer? debounceTimer;

  RxBool isScrollingUp = false.obs;
  var selectedGalleryFilter = NftGalleryFilter.collection.obs;

  RxMap<String, List<NftTokenModel>> searchNfts =
      <String, List<NftTokenModel>>{}.obs;
  RxBool isSearching = false.obs;
  RxString searchText = ''.obs;

  @override
  void onClose() {
    debounceTimer?.cancel();
    super.onClose();
  }

  @override
  onReady() async {
    super.onReady();
    fetchAllNftForGallery();
  }

  Future<void> searchNftGallery(String searchText) async {
    if (searchText.length < 3 && searchText.isNotEmpty) return;
    isSearching.value = true;
    searchNfts.value = {};
    this.searchText.value = searchText;
    if (searchText.isNotEmpty) {
      List<NftTokenModel> filteredNfts =
          await compute(search, [NFTsPk, searchText], debugLabel: "searchNFTs");
      for (var i = 0; i < filteredNfts.length; i++) {
        searchNfts[filteredNfts[i].faContract!] =
            (searchNfts[filteredNfts[i].faContract!] ?? [])
              ..add(filteredNfts[i]);
      }
      //isSearching.value = false;
    }
    isSearching.value = false;
  }

  Future<void> fetchAllNftForGallery() async {
    loadingMore = true;
    if (NFTsPk.isEmpty) {
      await getGalleryNFTsPk();
    }

    nftList = await compute(
        fetchAllNft, [NFTsPk.skip(offsetNFT).take(15).toList()],
        debugLabel: "fetchNFTs");

    offsetNFT += 15;

    for (var i = 0; i < nftList.length; i++) {
      galleryNfts[nftList[i].faContract!] =
          (galleryNfts[nftList[i].faContract!] ?? [])..add(nftList[i]);
    }
    loadingMore = false;
  }

  getGalleryNFTsPk() async {
    var response =
        await HttpService.performGetRequest("${ServiceConfig.naanApis}/vca");

    var x = jsonDecode(response)["gallery"];

    NFTsPk = x.map((e) => e["pk"]).toList();
  }

  Future<NftTokenModel> getNFT(int pk) async {
    final response = await GQLClient(
      'https://data.objkt.com/v3/graphql',
    ).query(
      query: ServiceConfig.getNFTfromPkwithoutHolder,
      variables: {
        'pk': pk,
      },
    );
    return (json(response.data['token']))[0];
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
    int offset = 0;
    List<NftTokenModel> nfts = [];
    while (true) {
      final response = await GQLClient(
        'https://data.objkt.com/v3/graphql',
      ).query(
        query: ServiceConfig.getNftsFromPks,
        variables: {
          'pks': data[0],
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

  static Future<List<NftTokenModel>> search(
      /* int offsetContract,
      List<String> publicKeyHashes, List<String> contracts */
      List data) async {
    int offset = 0;
    List<NftTokenModel> nfts = [];
    while (true) {
      final response = await GQLClient(
        'https://data.objkt.com/v3/graphql',
      ).query(
        query: ServiceConfig.searchQueryFromPks,
        variables: {
          'pks': data[0],
          'query': data[1],
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
}

List<NftTokenModel> json(x) {
  return x.map<NftTokenModel>((e) => NftTokenModel.fromJson(e)).toList();
}
