import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../data/services/service_models/collectible_model.dart';
import '../../../../send_page/views/widgets/nft_widget.dart';
import 'nft_summary_sheet.dart';

class NftCollectibles extends StatefulWidget {
  final CollectibleModel collectibleModel;
  const NftCollectibles({super.key, required this.collectibleModel});

  @override
  State<NftCollectibles> createState() => _NftCollectiblesState();
}

class _NftCollectiblesState extends State<NftCollectibles> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor:
                  ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              child: Image.asset(
                widget.collectibleModel.collectibleProfilePath,
                fit: BoxFit.contain,
              ),
            ),
            onExpansionChanged: (isExpand) =>
                setState(() => isExpanded = isExpand),
            trailing: SizedBox(
              height: 0.03.height,
              width: 0.14.width,
              child: expandButton(isExpanded: isExpanded),
            ),
            title: Text(
              widget.collectibleModel.name,
              style: labelLarge,
            ),
            children: [
              const SizedBox(
                height: 16,
              ),
              Wrap(
                spacing: 0.03.width,
                runSpacing: 0.03.width,
                children: widget.collectibleModel.nfts
                    .map(
                      (nfTmodel) => NFTwidget(
                        nfTmodel: nfTmodel,
                        onTap: () => Get.bottomSheet(
                          const NFTSummaryBottomSheet(),
                          isScrollControlled: true,
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget expandButton({required bool isExpanded}) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
          const SizedBox(
            width: 2,
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
            color: ColorConst.NeutralVariant.shade60,
            size: 10,
          )
        ],
      ),
    );
  }
}
