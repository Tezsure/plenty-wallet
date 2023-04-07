import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/account_summary/models/token_info.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import 'transaction_details.dart';

class TransactionFeeDetailShet extends StatelessWidget {
  final TxHistoryModel transactionModel;
  TokenInfo tokenInfo;
  final String userAccountAddress;
  final double xtzPrice;
  TransactionFeeDetailShet(
      {super.key,
      required this.tokenInfo,
      required this.transactionModel,
      required this.userAccountAddress,
      required this.xtzPrice});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      // bottomSheetHorizontalPadding: 0,
      title: "Fees",
      isScrollControlled: true,
      bottomSheetWidgets: [
        0.02.vspace,
        TxTokenInfo(
          showAmount: false,
          tokenInfo: tokenInfo,
          userAccountAddress: userAccountAddress,
          xtzPrice: xtzPrice,
        ),
        _buildAmount(),
        SizedBox(
          height: 8.arP,
        ),
        _buildFeeDetail(
            title: "Storage fee",
            subtitle:
                "Storage fees refer to the cost of storing data on the blockchain network",
            amount: 0.00181),
        BottomButtonPadding()
      ],
    );
  }

  Column _buildFeeDetail(
      {required String title,
      required String subtitle,
      required double amount}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 12.arP,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: labelMedium.copyWith(
                  color: ColorConst.NeutralVariant.shade60),
            ),
            Text(
              amount.roundUpDollar(xtzPrice, decimals: 6),
              style: labelMedium,
            )
          ],
        ),
        SizedBox(
          height: 8.arP,
        ),
        Text(
          subtitle,
          style: bodySmall.copyWith(color: ColorConst.NeutralVariant.shade60),
        )
      ],
    );
  }

  Container _buildAmount() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 22.arP, horizontal: 12.arP),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.arP),
        color: const Color(0xff1E1C1F),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              tokenInfo.isNft
                  ? tokenInfo.name
                  : tokenInfo.token!.sender!.address!
                          .contains(userAccountAddress)
                      ? '- ${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}'
                      : '+${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: bodyLarge.copyWith(
                  color: tokenInfo.token!.sender!.address!
                          .contains(userAccountAddress)
                      ? ColorConst.NeutralVariant.shade60
                      : ColorConst.naanCustomColor)),
          Text(
            tokenInfo.token!.operationStatus != "applied"
                ? "failed"
                : tokenInfo.dollarAmount.roundUpDollar(xtzPrice, decimals: 6),
            style: bodyLarge.copyWith(
              color: tokenInfo.token!.operationStatus != "applied"
                  ? ColorConst.NaanRed
                  : Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
