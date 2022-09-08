import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../data/services/service_models/nft_model.dart';

class NFTwidget extends StatelessWidget {
  final NFTmodel nfTmodel;
  final GestureTapCallback? onTap;
  const NFTwidget({super.key, required this.nfTmodel, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 0.45.width,
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
                  image: AssetImage(
                    nfTmodel.nftPath,
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
              nfTmodel.title,
              style: labelMedium,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              nfTmodel.name,
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
          ],
        ),
      ),
    );
  }
}
