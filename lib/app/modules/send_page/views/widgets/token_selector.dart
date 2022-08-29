import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class TokenSelector extends StatelessWidget {
  const TokenSelector({
    super.key,
    required this.showNFTPage,
    required this.nftImageUrl,
    required this.totalTez,
  });

  final bool showNFTPage;
  final String? nftImageUrl;
  final String totalTez;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      dense: true,
      leading: showNFTPage
          ? Image.asset(
              nftImageUrl ?? 'assets/temp/nft_thumbnail.png',
            )
          : SvgPicture.asset('assets/svg/tez.svg'),
      title: Text(
        showNFTPage ? 'Unstable #5' : 'Tezos',
        style: bodySmall.copyWith(color: ColorConst.Primary.shade60),
      ),
      subtitle: Text(showNFTPage ? 'Unstable dreams' : '$totalTez available',
          style: labelSmall.copyWith(color: ColorConst.NeutralVariant.shade60)),
      trailing: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: ColorConst.Neutral.shade80.withOpacity(0.2)),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: ColorConst.Primary.shade60,
          size: 12,
        ),
      ),
    );
  }
}
