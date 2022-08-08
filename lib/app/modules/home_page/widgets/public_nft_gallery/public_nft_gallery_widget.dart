import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class PublicNFTgalleryWidget extends StatelessWidget {
  const PublicNFTgalleryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(
      viewportFraction: 0.95,
    );
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
            controller: controller,
            scrollDirection: Axis.horizontal,
            children: List.generate(
                  3,
                  (index) => NFTgallery(),
                ) +
                <Widget>[addGallery()],
          ),
        ),
        0.016.vspace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.04.width),
          child: Row(
            children: [
              Spacer(),
              Text(
                "manage galleries",
                style: labelSmall,
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
                child: Icon(
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

  Widget NFTgallery() {
    return Column(
      children: [
        Container(
          width: 0.92.width,
          padding: EdgeInsets.all(0.035.width),
          decoration: BoxDecoration(
              color: ColorConst.Secondary.shade50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
          child: Row(
            children: [
              Container(
                height: 0.24.width,
                width: 0.22.width,
                decoration: BoxDecoration(
                    color: Colors.white,
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
          decoration: BoxDecoration(
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
