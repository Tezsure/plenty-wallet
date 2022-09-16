import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/nft_gallery_controller.dart';
import 'nft_collection_view.dart';
import 'nft_detail_view.dart';

class NftGalleryView extends GetView<NftGalleryController> {
  NftGalleryView({super.key});
  @override
  final controller = Get.put(NftGalleryController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => IndexedStack(
          index: controller.currentPageIndex.value,
          children: [
            const NFTCollectionView(),
            NFTDetailView(
              onBackTap: () => controller.currentPageIndex.value = 0,
            ),
          ],
        ));
  }
}
