import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/public_nft_gallery/controllers/public_nft_gallery_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/public_nft_gallery/models/nft_gallery_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class PublicNFTgalleryWidget extends StatelessWidget {
  const PublicNFTgalleryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PublicNFTgalleryController controller =
        Get.put<PublicNFTgalleryController>(PublicNFTgalleryController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 0.04.width),
          child: Text(
            "Public NFT Gallery",
            style: titleSmall.apply(color: ColorConst.NeutralVariant.shade50),
          ),
        ),
        0.016.vspace,
        SizedBox(
          height: 0.58.width,
          width: 1.width,
          child: PageView(
            controller: PageController(
              viewportFraction: 0.95,
            ),
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) => controller.onPageChanged(index),
            children: List.generate(
                  controller.galleries.length,
                  (index) => nftGallery(controller.galleries[index]),
                ) +
                <Widget>[addGallery()],
          ),
        ),
        0.016.vspace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.06.width),
          child: Row(
            children: [
              SizedBox(
                height: 10,
                width: 0.55.width,
                child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: ((context, index) {
                    return Obx(() => Visibility(
                          visible: index == 3,
                          replacement: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.selectedIndex.value == index
                                      ? Colors.white
                                      : ColorConst.NeutralVariant.shade40),
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            color: controller.selectedIndex.value == 3
                                ? Colors.white
                                : ColorConst.NeutralVariant.shade50,
                            size: 10,
                          ),
                        ));
                  }),
                ),
              ),
              const Spacer(),
              GestureDetector(
                child: Text(
                  "manage galleries",
                  style: labelSmall,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Container addGallery() {
    return Container(
      height: 0.58.width,
      width: 0.92.width,
      padding: EdgeInsets.only(left: 0.1.width),
      decoration: BoxDecoration(
        color: ColorConst.Secondary.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: ColorConst.Secondary.shade60,
                child: const Icon(
                  Icons.add,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              0.02.hspace,
              Text(
                "Add Gallery",
                style: bodyMedium,
              )
            ],
          ),
          SizedBox(
            height: 0.05.width,
          ),
          Text(
            "Import new gallery and add to\nthe stack",
            style: labelSmall,
          )
        ],
      ),
    );
  }

  Widget nftGallery(NFTgalleryModel nftgalleryModel) {
    return Column(
      children: [
        Container(
          width: 0.92.width,
          padding: EdgeInsets.all(0.035.width),
          decoration: BoxDecoration(
              color: ColorConst.Secondary.shade50,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8))),
          child: Row(
            children: [
              Container(
                height: 0.24.width,
                width: 0.22.width,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage(
                          'assets/temp/gallery.png',
                        )),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4)),
              ),
              0.035.hspace,
              Column(
                children: [
                  Text(
                    "TF Permanent\nArt Collection",
                    style: bodyMedium,
                  ),
                  Text(
                    "Curated by\nMisan Harriman",
                    style:
                        labelSmall.apply(color: ColorConst.Secondary.shade80),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          width: 0.92.width,
          padding: EdgeInsets.all(0.035.width),
          decoration: const BoxDecoration(
              color: ColorConst.Secondary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (index) => Container(
                height: 0.2.width,
                width: 0.16.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          'assets/temp/nft${index + 1}.png',
                        )),
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
