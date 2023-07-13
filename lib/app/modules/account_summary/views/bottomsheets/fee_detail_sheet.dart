import 'package:flutter/material.dart';
import 'package:plenty_wallet/app/modules/account_summary/models/token_info.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/utils.dart';

import '../../../../data/services/service_models/token_price_model.dart';
import 'transaction_details.dart';

class TransactionFeeDetailShet extends StatelessWidget {
  TokenInfo tokenInfo;
  final String userAccountAddress;
  final double xtzPrice;
  final List<TokenPriceModel> tokensList;
  TransactionFeeDetailShet(
      {super.key,
      required this.tokenInfo,
      required this.tokensList,
      required this.userAccountAddress,
      required this.xtzPrice});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      prevPageName: "Back",
      leading: backButton(
          ontap: () {
            Navigator.pop(context);
          },
          lastPageName: "Back"),
      // bottomSheetHorizontalPadding: 0,
      title: "Fees",
      // isScrollControlled: true,
      bottomSheetWidgets: [
        0.02.vspace,
        TxTokenInfo(
          tokensList: tokensList,
          showAmount: false,
          tokenInfo: tokenInfo,
          userAccountAddress: userAccountAddress,
          xtzPrice: xtzPrice,
        ),
        _buildAmount(),
        _buildFeeDetail(
            title: "Baker fee",
            subtitle:
                "The baker fee in Tezos is the percentage of rewards that a baker charges for delegating Tezos tokens to them.",
            amount: tokenInfo.token!.bakerFee?.toDouble()),
        _buildFeeDetail(
            title: "Storage fee",
            subtitle:
                "Storage fees refer to the cost of storing data on the blockchain network",
            amount: tokenInfo.token!.storageFee?.toDouble()),
        _buildFeeDetail(
            title: "Allocation fee",
            subtitle:
                "Allocation fees refer to one-time fee paid at the time of contract creation",
            amount: tokenInfo.token!.allocationFee?.toDouble()),
        _buildFeeDetail(
            title: "Gas fee",
            subtitle:
                "Gas fee refers to the cost necessary to perform a transaction on the network",
            amount: tokenInfo.token!.gasUsed?.toDouble()),
        const BottomButtonPadding()
      ],
    );
  }

  Widget _buildFeeDetail(
      {required String title,
      required String subtitle,
      required double? amount}) {
    if (amount == null || amount == 0.0) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.arP,
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
              (amount / 1e6).roundUpDollar(xtzPrice, decimals: 6),
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
                  : tokenInfo.source!.address!.contains(userAccountAddress)
                      ? '- ${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}'
                      : '+${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: bodyLarge.copyWith(
                  color: tokenInfo.source!.address!.contains(userAccountAddress)
                      ? ColorConst.NeutralVariant.shade60
                      : ColorConst.naanCustomColor)),
          Text(
            tokenInfo.token?.block != null &&
                    tokenInfo.token!.operationStatus != "applied"
                ? "failed"
                : tokenInfo.dollarAmount.roundUpDollar(xtzPrice, decimals: 6),
            style: bodyLarge.copyWith(
              color: tokenInfo.token?.block != null &&
                      tokenInfo.token!.operationStatus != "applied"
                  ? ColorConst.NaanRed
                  : Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
