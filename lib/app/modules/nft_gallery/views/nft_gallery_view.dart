import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/colors/colors.dart';
import '../controllers/nft_gallery_controller.dart';

class NftGalleryView extends GetView<NftGalleryController> {
  const NftGalleryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.9.height,
      width: 1.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        gradient: GradConst.GradientBackground,
      ),
    );
  }
}
