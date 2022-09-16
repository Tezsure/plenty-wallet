import 'dart:math';

import 'package:get/get.dart';

import '../../../../utils/constants/path_const.dart';

class NftGalleryController extends GetxController {
  RxInt currentSelectedCategoryIndex = 0.obs;
  RxInt currentPageIndex = 0.obs;
  RxBool searchNft = false.obs;
  RxString selectedNFTPath = '${PathConst.TEMP}nft_pic.png'.obs;
  List<String> nftChips = const [
    'Art',
    'Collectibles',
    'Domain Names',
    'Music',
    'Sports',
  ];

  RxBool isExpanded = false.obs;

  void changeCurrentSelectedCategoryIndex(int index) {
    currentSelectedCategoryIndex.value = index;
  }

  void searchNftToggle() {
    searchNft.value = !searchNft.value;
  }

  void toggleExpanded(bool val) {
    isExpanded.value = val;
  }

  void selectedNFTImage(String path) {
    selectedNFTPath.value = path;
    currentPageIndex.value = 1;
  }

  static const List<String> listofImages = [
    '${PathConst.TEMP}1.png',
    '${PathConst.TEMP}2.png',
    '${PathConst.TEMP}3.png',
    '${PathConst.TEMP}4.png',
    '${PathConst.TEMP}5.png',
    '${PathConst.TEMP}6.png',
    '${PathConst.TEMP}7.png',
    '${PathConst.TEMP}8.png',
    '${PathConst.TEMP}9.png',
    '${PathConst.TEMP}10.png',
    '${PathConst.TEMP}11.png',
    '${PathConst.TEMP}12.png',
    '${PathConst.TEMP}13.png',
  ];

  RxList<CollectibleModel> collectibles = List.generate(
    20,
    (index) => CollectibleModel(
      name: "tezos",
      collectibleProfilePath: '${PathConst.TEMP}nft_details.png',
      nfts: List.generate(
        Random().nextInt(listofImages.length) + 1,
        (index) => NFTmodel(
            title: "Flowers & Bytes",
            name: "Felix le peintre",
            nftPath: listofImages[Random().nextInt(listofImages.length)]),
      ),
    ),
  ).obs; //
}

// TODO Remove this models after merging with the send flow branch
class NFTmodel {
  final String title;
  final String name;
  final String nftPath;
  NFTmodel({required this.title, required this.name, required this.nftPath});
}

class CollectibleModel {
  final String name;
  final List<NFTmodel> nfts;
  final String collectibleProfilePath;

  CollectibleModel({
    required this.name,
    required this.nfts,
    required this.collectibleProfilePath,
  });
}
