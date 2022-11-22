import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../data/services/service_models/nft_token_model.dart';

class NFTwidget extends StatelessWidget {
  final NftTokenModel nfTmodel;
  final Function(NftTokenModel) onTap;
  String? nftArtifactUrl;
  NFTwidget({super.key, required this.nfTmodel, required this.onTap}) {
    nftArtifactUrl =
        "https://assets.objkt.media/file/assets-003/${nfTmodel.faContract}/${nfTmodel.tokenId.toString()}/thumb400";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(nfTmodel),
      child: Container(
        width: 0.44.width,
        padding: const EdgeInsets.all(10),
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
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    nftArtifactUrl!,
                  ),
                ),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              nfTmodel.name!,
              style: labelMedium,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              nfTmodel.description ?? "",
              maxLines: 1,
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
          ],
        ),
      ),
    );
  }
}