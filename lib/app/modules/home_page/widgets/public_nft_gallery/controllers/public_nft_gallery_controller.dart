import 'package:get/get.dart';

class PublicNFTgalleryController extends GetxController {

  final RxInt selectedIndex = 0.obs; // Current Visible Account Container

  /// Change the current index to the new index of visible account container
  void onPageChanged(int index) {
    selectedIndex.value = index;
  }
}
