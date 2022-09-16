import 'package:get/get.dart';

class NftGalleryController extends GetxController {
  RxInt currentPageIndex = 0.obs;
  RxBool searchNft = false.obs;
  List<String> nftChips = const [
    'Art',
    'Collectibles',
    'Domain Names',
    'Music',
    'Sports',
  ];

  RxBool isExpanded = false.obs;

  void searchNftToggle() {
    searchNft.value = !searchNft.value;
  }

  void toggleExpanded(bool val) {
    isExpanded.value = val;
  }
}
