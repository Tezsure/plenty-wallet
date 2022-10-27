import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/service_models/token_price_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import '../../../../data/services/service_models/nft_token_model.dart';
import '../bottomsheets/history_filter_sheet.dart';
import '../bottomsheets/transaction_details.dart';
import '../widgets/history_tab_widgets/history_tile.dart';

class HistoryPage extends GetView<AccountSummaryController> {
  final bool isNftTransaction;
  final GestureTapCallback? onTap;
  const HistoryPage({super.key, this.isNftTransaction = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomScrollView(
          controller: controller.paginationController.value,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    0.02.vspace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            height: 0.06.height,
                            width: 0.8.width,
                            padding: EdgeInsets.only(left: 14.5.sp),
                            decoration: BoxDecoration(
                              color: ColorConst.NeutralVariant.shade60
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10.sp),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: ColorConst.NeutralVariant.shade60,
                                  size: 22.sp,
                                ),
                                0.02.hspace,
                                Text(
                                  'Search',
                                  style: labelLarge.copyWith(
                                      letterSpacing: 0.25,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConst.NeutralVariant.shade70),
                                )
                              ],
                            ),
                          ),
                        ),
                        0.02.hspace,
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(HistoryFilterSheet(),
                                isScrollControlled: true);
                          },
                          child: SvgPicture.asset(
                            controller.isFilterApplied.value
                                ? "${PathConst.SVG}filter_selected.svg"
                                : '${PathConst.SVG}filter.svg',
                            fit: BoxFit.contain,
                            height: 24.sp,
                            color: ColorConst.Primary,
                          ),
                        ),
                        0.01.hspace,
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // controller.userTransactionHistory.isEmpty
            true
                ? SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        0.03.vspace,
                        SvgPicture.asset(
                          "${PathConst.EMPTY_STATES}empty3.svg",
                          height: 120.sp,
                        ),
                        0.03.vspace,
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: "No transactions\n",
                                style: titleLarge.copyWith(
                                    fontWeight: FontWeight.w700),
                                children: [
                                  WidgetSpan(child: 0.04.vspace),
                                  TextSpan(
                                      text:
                                          "Your crypto and NFT activity will appear\nhere once you start using your wallet",
                                      style: labelMedium.copyWith(
                                          color: ColorConst
                                              .NeutralVariant.shade60))
                                ])),
                      ],
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        late TokenInfo token;
                        token = tokenInfo(index);
                        controller.tokenInfoList.addIf(
                            !controller.tokenInfoList.any((element) =>
                                element.id == null
                                    ? true
                                    : element.id!.isEqual(controller
                                        .userTransactionHistory[index]
                                        .lastid!)),
                            token);

                        return token.isNft
                            ? nftLoader(index)
                            : token.skip
                                ? const SizedBox()
                                : index == 0
                                    ? tokenLoader(token)
                                    : controller.isHashSame(index)
                                        ? const SizedBox()
                                        : tokenLoader(token);
                      },
                      childCount: controller.userTransactionHistory.length,
                    ),
                  ),
          ],
        ));
  }

  TokenInfo tokenInfo(int index) {
    if (controller.isTezosTransaction(index)) {
      return TokenInfo(
        id: controller.userTransactionHistory[index].lastid,
        index: index,
        tokenSymbol: "tez",
        tokenAmount: controller.userTransactionHistory[index].amount! / 1e6,
        dollarAmount: (controller.userTransactionHistory[index].amount! / 1e6) *
            controller.xtzPrice.value,
      );
    } else if (controller.isAnyTokenOrNFTTransaction(index)) {
      if (controller.isFa2Token(index)) {
        if (controller.isFa2TokenListEmpty(index)) {
          return TokenInfo(isNft: true, index: index);
        } else {
          TokenPriceModel fa2Token = controller.fa2TokenName(index);

          String amount =
              controller.userTransactionHistory[index].parameter?.value is List
                  ? controller.userTransactionHistory[index].parameter?.value[0]
                      ['txs'][0]['amount']
                  : jsonDecode(controller.userTransactionHistory[index]
                      .parameter!.value)[0]['txs'][0]['amount'];

          return TokenInfo(
              id: controller.userTransactionHistory[index].lastid,
              index: index,
              name: fa2Token.name!,
              dollarAmount: double.parse(amount) /
                  pow(10, fa2Token.decimals!) *
                  fa2Token.currentPrice!,
              tokenSymbol: fa2Token.symbol!,
              tokenAmount: double.parse(amount) / pow(10, fa2Token.decimals!),
              imageUrl: controller.getImageUrl(index));
        }
      } else {
        TokenPriceModel faToken = controller.fa1TokenName(index);
        late String amount = "0";
        if (controller.userTransactionHistory[index].parameter!.value is Map) {
          amount = controller
              .userTransactionHistory[index].parameter!.value['value'];
        } else if (controller.userTransactionHistory[index].parameter!.value
            is String) {
          var decodedString = jsonDecode(
              controller.userTransactionHistory[index].parameter!.value);
          amount = decodedString['value'];
        }

        return TokenInfo(
            index: index,
            id: controller.userTransactionHistory[index].lastid,
            name: faToken.name!,
            dollarAmount: (double.parse(amount) /
                pow(10, faToken.decimals!) *
                faToken.currentPrice!),
            tokenSymbol: faToken.symbol!,
            tokenAmount: double.parse(amount) / pow(10, faToken.decimals!),
            imageUrl: controller.getImageUrl(index));
      }
    } else {
      return TokenInfo(
        skip: true,
        index: index,
      );
    }
  }

  Widget tokenLoader(TokenInfo token) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          token.index == 0
              ? Padding(
                  padding:
                      EdgeInsets.only(top: 16.sp, left: 16.sp, bottom: 16.sp),
                  child: Text(
                    DateFormat.yMMMEd()
                        // displaying formatted date
                        .format(DateTime.parse(controller
                            .userTransactionHistory[token.index].timestamp!)),
                    style: labelMedium,
                  ),
                )
              : DateTime.parse(controller
                          .userTransactionHistory[token.index].timestamp!)
                      .isSameDate(DateTime.parse(controller
                          .userTransactionHistory[
                              token.index == 0 ? 0 : token.index - 1]
                          .timestamp!))
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: 16.sp, left: 16.sp, bottom: 16.sp),
                      child: Text(
                        DateFormat.yMMMEd()
                            // displaying formatted date
                            .format(DateTime.parse(controller
                                .userTransactionHistory[token.index]
                                .timestamp!)),
                        style: labelMedium,
                      ),
                    ),
          HistoryTile(
            tokenSymbol: token.tokenSymbol,
            dollarAmount: token.dollarAmount,
            tezAmount: token.tokenAmount,
            tokenName: token.name,
            tokenIconUrl: token.imageUrl,
            userAccountAddress: controller.userAccount.value.publicKeyHash!,
            xtzPrice: controller.xtzPrice.value,
            historyModel: controller.userTransactionHistory[token.index],
            onTap: () => Get.bottomSheet(TransactionDetailsBottomSheet(
              tokenInfo: token,
              userAccountAddress: controller.userAccount.value.publicKeyHash!,
              transactionModel: controller.userTransactionHistory[token.index],
            )),
          ),
        ],
      );

  Widget nftLoader(int index) => FutureBuilder(
      future: ObjktNftApiService().getTransactionNFT(
          controller.userTransactionHistory[index].target!.address!,
          controller.userTransactionHistory[index].parameter?.value[0]["txs"][0]
              ["token_id"]),
      builder: ((context, AsyncSnapshot<NftTokenModel> snapshot) {
        if (!snapshot.hasData) {
          // while data is loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          TokenInfo token = TokenInfo(
              index: index,
              isNft: true,
              id: controller.userTransactionHistory[index].lastid,
              tokenSymbol: snapshot.data!.fa!.name!,
              dollarAmount: snapshot.data!.lowestAsk / 1e6,
              tokenAmount: snapshot.data!.lowestAsk != null &&
                      snapshot.data!.lowestAsk != 0
                  ? snapshot.data!.lowestAsk / 1e6
                  : 0,
              name: snapshot.data!.name!,
              imageUrl: snapshot.data!.displayUri!);

          controller.tokenInfoList.addIf(
              !controller.tokenInfoList.any((element) => element.id == null
                  ? true
                  : element.id!.isEqual(
                      controller.userTransactionHistory[index].lastid!)),
              token);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 16.sp, left: 16.sp, bottom: 16.sp),
                child: Text(
                  DateFormat.yMMMEd()
                      // displaying formatted date
                      .format(DateTime.parse(
                          controller.userTransactionHistory[index].timestamp!)),
                  style: labelMedium,
                ),
              ),
              HistoryTile(
                tokenSymbol: token.tokenSymbol,
                isNft: token.isNft,
                dollarAmount: token.dollarAmount,
                tezAmount: token.tokenAmount,
                tokenName: token.name,
                tokenIconUrl: token.imageUrl,
                userAccountAddress: controller.userAccount.value.publicKeyHash!,
                xtzPrice: controller.xtzPrice.value,
                historyModel: controller.userTransactionHistory[index],
                onTap: () => Get.bottomSheet(TransactionDetailsBottomSheet(
                  tokenInfo: token,
                  userAccountAddress:
                      controller.userAccount.value.publicKeyHash!,
                  transactionModel: controller.userTransactionHistory[index],
                )),
              ),
            ],
          );
        }
      }));
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class TokenInfo {
  final String name;
  final String imageUrl;
  final bool isNft;
  final bool skip;
  final int index;
  final double tokenAmount;
  final double dollarAmount;
  final String tokenSymbol;
  final int? id;

  TokenInfo(
      {this.name = "Tezos",
      this.imageUrl = "${PathConst.ASSETS}tezos_logo.png",
      this.isNft = false,
      this.skip = false,
      this.dollarAmount = 0,
      this.tokenSymbol = "tez",
      this.tokenAmount = 0,
      this.id,
      required this.index});
}
