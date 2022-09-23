import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/public_nft_gallery/models/nft_gallery_model.dart';

class PublicNFTgalleryController extends GetxController {
  final RxInt selectedIndex = 0.obs; // Current Visible Account Container
  final RxList<NFTgalleryModel> galleries = List.generate(
      1,
      (index) => NFTgalleryModel(
          artistName: "Misan Harriman", name: "TF Permanent")).obs;

  void onPageChanged(int index) {
    selectedIndex.value = index;
  }
}
