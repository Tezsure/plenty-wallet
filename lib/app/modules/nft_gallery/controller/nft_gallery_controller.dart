import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_gallery_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';

enum NftGalleryFilter { collection, list, thumbnail }

class NftGalleryController extends GetxController {
  RxInt selectedGalleryIndex = 0.obs;
  RxList<NftGalleryModel> nftGalleryList = <NftGalleryModel>[].obs;
  var selectedNftGallery = NftGalleryModel().obs;

  NftGalleryController(int selectedGalleryIndex, this.nftGalleryList) {
    this.selectedGalleryIndex.value = selectedGalleryIndex;
    selectedNftGallery.value = nftGalleryList[selectedGalleryIndex];
  }

  RxMap<String, List<NftTokenModel>> galleryNfts =
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

  Future<void> fetchAllNftForGallery() async {
    List<NftTokenModel> nftList = await selectedNftGallery.value.fetchAllNft();
    for (var i = 0; i < nftList.length; i++) {
      galleryNfts[nftList[i].fa!.contract!] =
          (galleryNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
    }
  }
}
