import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

/// Displays the token selection page. This page is used to select the token/nft to send.
///
/// The page is divided into two parts. The first part is the token selection part. The second part is the nft selection part.
///
/// If [showNFTPage] is set to false. The token selection part is displayed. Where [tokenImageUrl] can't be null.
///
/// If [showNFTPage] is set to true. The nft selection part is displayed. Where [nftImageUrl], [nftCollectibleName] & [nftCollectibleGroupName] can't be null.
// ignore: must_be_immutable
class TokenSelector extends StatelessWidget {
  TokenSelector({
    super.key,
    this.onTap,
    this.controller,
  });

  final GestureTapCallback? onTap;
  SendPageController? controller;

  @override
  Widget build(BuildContext context) {
    return controller!.selectedTokenModel != null ||
            controller!.selectedNftModel != null
        ? ListTile(
            onTap: onTap,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            dense: true,
            leading: controller!.isNFTPage.value
                ? getNftImage()
                : getTokenImage(controller!.selectedTokenModel!),
            title: Text(
              controller!.isNFTPage.value
                  ? controller!.selectedNftModel!.name!
                  : controller!.selectedTokenModel!.symbol!,
              style: TextStyle(
                color: const Color(0xFF7B757F),
                fontSize: 13.arP,
                letterSpacing: 0.4.arP,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              controller!.isNFTPage.value
                  ? controller!.selectedNftModel!.fa!.name!
                  : '${controller!.selectedTokenModel!.balance.toStringAsFixed(6)} ${controller!.selectedTokenModel!.symbol!.toUpperCase()} available',
              style: TextStyle(
                color: const Color(0xFF958E99),
                fontSize: 12.arP,
                letterSpacing: 0.5.arP,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color(0xFF332F37)),
              // ignore: prefer_const_constructors
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: ColorConst.textGrey1,
                size: 12,
              ),
            ),
          )
        : Container();
  }

  Widget getNftImage() {
    var logo = controller!.selectedNftModel!.fa!.logo!;
    if (logo.startsWith("ipfs://")) {
      logo = "https://ipfs.io/ipfs/${logo.replaceAll("ipfs://", "")}";
    }
    return CircleAvatar(
      radius: 22,
      foregroundImage: NetworkImage(logo),
    );
  }

  Widget getTokenImage(tokenModel) => CircleAvatar(
        radius: 22,
        backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        child: tokenModel.iconUrl!.startsWith("assets")
            ? Image.asset(
                tokenModel.iconUrl!,
                fit: BoxFit.cover,
              )
            : tokenModel.iconUrl!.endsWith(".svg")
                ? SvgPicture.network(
                    tokenModel.iconUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(tokenModel.iconUrl!
                                  .startsWith("ipfs")
                              ? "https://ipfs.io/ipfs/${tokenModel.iconUrl!.replaceAll("ipfs://", '')}"
                              : tokenModel.iconUrl!)),
                    ),
                  ),
      );
}
