import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../../../models/token_info.dart';

class HistoryTile extends StatelessWidget {
  final VoidCallback? onTap;
  final double xtzPrice;
  final TokenInfo tokenInfo;

  const HistoryTile({
    super.key,
    this.onTap,
    required this.xtzPrice,
    required this.tokenInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 16.arP, right: 16.arP, bottom: 10.arP),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.arP),
          ),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          child: SizedBox(
            height: 61.arP,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 12.arP, right: 9.arP, top: 10.arP, bottom: 10.arP),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20.arP,
                    backgroundColor: Colors.black,
                    child: tokenInfo.imageUrl.startsWith("assets")
                        ? tokenInfo.imageUrl.endsWith(".svg")
                            ? SvgPicture.asset(
                                tokenInfo.imageUrl,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                tokenInfo.imageUrl,
                                cacheHeight: 82,
                                cacheWidth: 82,
                                fit: BoxFit.cover,
                              )
                        : tokenInfo.imageUrl.endsWith(".svg")
                            ? SvgPicture.network(
                                tokenInfo.imageUrl,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: tokenInfo.isNft
                                      ? Border.all(
                                          width: 1.5.arP,
                                          color:
                                              ColorConst.NeutralVariant.shade60,
                                        )
                                      : const Border(),
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: tokenInfo.imageUrl
                                            .startsWith("ipfs")
                                        ? "https://ipfs.io/ipfs/${tokenInfo.imageUrl.replaceAll("ipfs://", '')}"
                                        : tokenInfo.imageUrl,
                                    memCacheHeight: 82,
                                    memCacheWidth: 82,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                  ),
                  0.02.hspace,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                              tokenInfo.isSent
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 14.arP,
                              color: ColorConst.NeutralVariant.shade60),
                          Text(tokenInfo.isSent ? ' Sent' : ' Received',
                              style: labelMedium.copyWith(
                                  color: ColorConst.NeutralVariant.shade60,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.arP),
                        child: SizedBox(
                          width: 180.arP,
                          child: Text(
                            tokenInfo.name,
                            style: labelLarge.copyWith(
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w400),
                            softWrap: false,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            tokenInfo.isNft
                                ? tokenInfo.tokenSymbol
                                : "${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}",
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: labelSmall.copyWith(
                                color: ColorConst.NeutralVariant.shade60)),
                        Text(
                          tokenInfo.token!.operationStatus == 'applied'
                              ? tokenInfo.name == "tez"
                                  ? tokenInfo.isSent
                                      ? '- \$${(tokenInfo.dollarAmount).toStringAsFixed(2)}'
                                      : '\$${(tokenInfo.dollarAmount).toStringAsFixed(2)}'
                                  : ""
                              : "failed",
                          style: labelLarge.copyWith(
                              fontWeight: FontWeight.w400,
                              color:
                                  tokenInfo.token!.operationStatus == 'applied'
                                      ? tokenInfo.isSent
                                          ? Colors.white
                                          : ColorConst.naanCustomColor
                                      : ColorConst.NaanRed),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  )),
/*                   RichText(
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: tokenInfo.isNft
                            ? "${tokenInfo.tokenSymbol}\n"
                            : "${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}\n",
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60),
                        children: [
                          WidgetSpan(child: 0.02.vspace),
                          TextSpan(
                            text: tokenInfo.isSent
                                ? '- \$${(tokenInfo.dollarAmount).toStringAsFixed(2)}'
                                : '\$${(tokenInfo.dollarAmount).toStringAsFixed(2)}',
                            style: labelLarge.copyWith(
                                fontWeight: FontWeight.w400,
                                color: tokenInfo.isSent
                                    ? Colors.white
                                    : ColorConst.naanCustomColor),
                          )
                        ]),
                  ), */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
