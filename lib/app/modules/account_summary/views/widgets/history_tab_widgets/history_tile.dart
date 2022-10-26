import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';

class HistoryTile extends StatelessWidget {
  final VoidCallback? onTap;
  final TxHistoryModel historyModel;
  final double xtzPrice;
  final String userAccountAddress;
  final String tokenName;
  final String tokenIconUrl;
  final double tezAmount;
  final double dollarAmount;
  final String tokenSymbol;
  final bool isNft;

  const HistoryTile({
    super.key,
    this.onTap,
    required this.historyModel,
    required this.xtzPrice,
    required this.userAccountAddress,
    required this.tokenName,
    required this.tokenIconUrl,
    required this.tezAmount,
    required this.dollarAmount,
    required this.tokenSymbol,
    this.isNft = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 16.sp, vertical: 0.003.height),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          child: ListTile(
            dense: true,
            enableFeedback: true,
            leading: CircleAvatar(
              radius: 20.sp,
              backgroundColor: ColorConst.NeutralVariant.shade60,
              child: tokenIconUrl.startsWith("assets")
                  ? Image.asset(
                      tokenIconUrl,
                      fit: BoxFit.cover,
                    )
                  : tokenIconUrl.endsWith(".svg")
                      ? SvgPicture.network(
                          tokenIconUrl,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(tokenIconUrl
                                        .startsWith("ipfs")
                                    ? "https://ipfs.io/ipfs/${tokenIconUrl.replaceAll("ipfs://", '')}"
                                    : tokenIconUrl)),
                          ),
                        ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                    historyModel.sender!.address!.contains(userAccountAddress)
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 18.sp,
                    color: ColorConst.NeutralVariant.shade60),
                Text(
                    historyModel.sender!.address!.contains(userAccountAddress)
                        ? ' Sent'
                        : ' Received',
                    style: labelLarge.copyWith(
                        color: ColorConst.NeutralVariant.shade60,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            subtitle: Text(
              tokenName,
              style: labelLarge,
            ),
            trailing: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                  text: isNft
                      ? "$tokenSymbol\n"
                      : "${tezAmount.toStringAsFixed(6)} $tokenSymbol\n",
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                  children: [
                    WidgetSpan(child: 0.02.vspace),
                    TextSpan(
                      text: historyModel.sender!.address!
                              .contains(userAccountAddress)
                          ? '- \$${(dollarAmount).toStringAsFixed(2)}'
                          : '\$${(dollarAmount).toStringAsFixed(2)}',
                      style: labelLarge.copyWith(
                          fontWeight: FontWeight.w400,
                          color: historyModel.sender!.address!
                                  .contains(userAccountAddress)
                              ? Colors.white
                              : ColorConst.naanCustomColor),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
