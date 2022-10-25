import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../../account_summary_view.dart';

class HistoryTile extends StatelessWidget {
  final VoidCallback? onTap;
  final HistoryStatus status;
  final TxHistoryModel historyModel;
  final double xtzPrice;
  final String userAccountAddress;
  final String tokenName;
  final String tokenIconUrl;

  const HistoryTile(
      {super.key,
      required this.status,
      this.onTap,
      required this.historyModel,
      required this.xtzPrice,
      required this.userAccountAddress,
      required this.tokenName,
      required this.tokenIconUrl});

// xtz = amount > 0 , parameters == null
// token/nft = amount == 0 , parameters != null
// sender contract id is in current token model
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.03.width, vertical: 0.003.height),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          child: ListTile(
            dense: true,
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
                                fit: BoxFit.cover,
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
                  text: historyModel.amount != null &&
                          historyModel.amount! > 0 &&
                          historyModel.parameter == null
                      ? '${(historyModel.amount! / 1e6)} tez\n'
                      : "",
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                  children: [
                    WidgetSpan(child: 0.02.vspace),
                    TextSpan(
                      text: historyModel.amount != null &&
                              historyModel.amount! > 0 &&
                              historyModel.parameter == null
                          ? historyModel.sender!.address!
                                  .contains(userAccountAddress)
                              ? '- \$${((historyModel.amount! / 1e6) * xtzPrice).toStringAsFixed(2)}'
                              : '\$${((historyModel.amount! / 1e6) * xtzPrice).toStringAsFixed(2)}'
                          : "",
                      style: labelLarge.copyWith(
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
