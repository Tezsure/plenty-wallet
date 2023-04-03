import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';

import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/teztown/controllers/teztown_controller.dart';

import 'package:simple_gql/simple_gql.dart';

enum NftGalleryFilter { collection, list, thumbnail }

enum NFTGalleryType { fromPKs, fromGalleryAddress }

class CustomNFTGalleryController extends GetxController {
  final NFTGalleryType nftGalleryType;
  final NftGalleryFilter? nftGalleryFilter;
  CustomNFTGalleryController(
      {required this.nftGalleryType, this.nftGalleryFilter}) {
    selectedGalleryFilter =
        nftGalleryFilter?.obs ?? NftGalleryFilter.collection.obs;
  }

  RxList<NftGalleryModel> nftGalleryList = <NftGalleryModel>[].obs;

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
  RxBool search = false.obs;
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
      List<NftTokenModel> filteredNfts = [];
      switch (nftGalleryType) {
        case NFTGalleryType.fromPKs:
          filteredNfts = [
            ...(await compute(searchFromPKs, [NFTsPk, searchText],
                debugLabel: "searchNFTsfromGalleryAddress"))
          ];
          break;
        case NFTGalleryType.fromGalleryAddress:
          filteredNfts = [
            ...(await compute(
                searchFromAddress,
                [
                  Get.find<TeztownController>()
                      .teztownData
                      .value
                      .galleryAddress,
                  searchText
                ],
                debugLabel: "searchNFTsfromGalleryAddress"))
          ];
          break;
        default:
      }

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

    switch (nftGalleryType) {
      case NFTGalleryType.fromPKs:
        if (NFTsPk.isEmpty) {
          await getGalleryNFTsPk();
        }
        nftList = await compute(
          fetchAllNftFromPks,
          [NFTsPk.skip(offsetNFT).take(15).toList()],
          debugLabel: "fetchNFTsfromPKs",
        );
        break;
      case NFTGalleryType.fromGalleryAddress:
        nftList = await compute(
          fetchAllNftFromAddress,
          [Get.find<TeztownController>().teztownData.value.galleryAddress],
          debugLabel: "fetchNFTsfromGalleryAddress",
        );
        break;
      default:
    }

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

  static Future<List<NftTokenModel>> fetchAllNftFromPks(
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

  static Future<List<NftTokenModel>> fetchAllNftFromAddress(
      /* int offsetContract,
      List<String> publicKeyHashes, List<String> contracts */
      List data) async {
    int offset = 0;
    String address = data[0];
    List<NftTokenModel> nfts = [];
    while (true) {
      final response = await ObjktNftApiService().getNfts(address);

      nfts = [...nfts, ...json(jsonDecode(response))];
      offset += 500;
      if (jsonDecode(response).length != 500) {
        break;
      }
    }
    return nfts;
  }

  static Future<List<NftTokenModel>> searchFromPKs(
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

  static Future<List<NftTokenModel>> searchFromAddress(
      /* int offsetContract,
      List<String> publicKeyHashes, List<String> contracts */
      List data) async {
    int offset = 0;
    final address = data[0];
    log("address:$address");
    List<NftTokenModel> nfts = [];
    while (true) {
      final response = await GQLClient(
        'https://data.objkt.com/v3/graphql',
      ).query(
        query: ServiceConfig.searchQueryFromAddress,
        variables: {
          'address': address,
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
