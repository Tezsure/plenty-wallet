import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/collectible_model.dart';
import 'package:naan_wallet/app/modules/token_and_collection_page/models/nft_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class CollectibleWidget extends StatefulWidget {
  const CollectibleWidget({Key? key, required this.collectibleModel})
      : super(key: key);

  final CollectibleModel collectibleModel;

  @override
  State<CollectibleWidget> createState() => _CollectibleWidgetState();
}

class _CollectibleWidgetState extends State<CollectibleWidget> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              ),
              0.04.hspace,
              Text(
                widget.collectibleModel.name,
                style: labelLarge,
              ),
              Spacer(),
              expandButton(),
            ],
          ),
          if (isExpanded)
            SizedBox(
              height: 16,
            ),
          if (isExpanded)
            Wrap(
              spacing: 0.03.width,
              runSpacing: 0.03.width,
              children: widget.collectibleModel.nfts
                  .map((nfTmodel) => NFTwidget(nfTmodel))
                  .toList(),
            )
        ],
      ),
    );
  }

  Container NFTwidget(NFTmodel nfTmodel) {
    return Container(
      width: 0.45.width,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 0.42.width,
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8)),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            nfTmodel.title,
            style: labelMedium,
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            nfTmodel.name,
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
        ],
      ),
    );
  }

  Widget expandButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        height: 24,
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.collectibleModel.nfts.length.toString(),
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
            SizedBox(
              width: 2,
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
              color: ColorConst.NeutralVariant.shade60,
              size: 10,
            )
          ],
        ),
      ),
    );
  }
}
