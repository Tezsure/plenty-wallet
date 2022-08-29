import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

/// Displays the token selection page. This page is used to select the token/nft to send.
///
/// The page is divided into two parts. The first part is the token selection part. The second part is the nft selection part.
///
/// If [showNFTPage] is set to false. The token selection part is displayed. Where [tokenImageUrl] can't be null.
///
/// If [showNFTPage] is set to true. The nft selection part is displayed. Where [nftImageUrl], [nftCollectibleName] & [nftCollectibleGroupName] can't be null.
class TokenSelector extends StatelessWidget {
  const TokenSelector({
    super.key,
    required this.showNFTPage,
    this.nftImageUrl = 'assets/temp/nft_thumbnail.png',
    required this.totalTez,
    this.tokenImageUrl = 'assets/svg/tez.svg',
    required this.tokenName,
    required this.nftCollectibleName,
    required this.nftCollectibleGroupName,
  })  : assert(showNFTPage ? nftImageUrl != null : tokenImageUrl != null),
        assert(showNFTPage
            ? nftCollectibleName != '' && nftCollectibleGroupName != ''
            : tokenName != '');

  final bool showNFTPage;
  final String? nftImageUrl;
  final String totalTez;
  final String? tokenImageUrl;
  final String tokenName;
  final String nftCollectibleName;
  final String nftCollectibleGroupName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      dense: true,
      leading: Visibility(
        replacement: SvgPicture.asset(tokenImageUrl!),
        visible: showNFTPage,
        child: Image.asset(nftImageUrl!),
      ),
      title: Text(
        showNFTPage ? nftCollectibleName : tokenName,
        style: bodySmall.copyWith(color: ColorConst.Primary.shade60),
      ),
      subtitle: Text(
          showNFTPage ? nftCollectibleGroupName : '$totalTez available',
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
