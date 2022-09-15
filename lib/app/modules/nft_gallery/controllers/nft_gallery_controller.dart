import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NftGalleryController extends GetxController {
  DraggableScrollableController scrollController =
      DraggableScrollableController();
  List<String> nftChips = const [
    'Art',
    'Collectibles',
    'Domain Names',
    'Music',
    'Sports',
  ];

  RxBool isExpanded = false.obs;

  void toggleExpanded(bool val) {
    isExpanded.value = val;
  }
}
