import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/pages/history_tab.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import '../../../../data/services/service_models/nft_token_model.dart';
import '../../../../data/services/service_models/token_price_model.dart';
import '../widgets/history_tab_widgets/history_tile.dart';
import 'transaction_details.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  FocusNode focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  AccountSummaryController controller = Get.find<AccountSummaryController>();
  List<TxHistoryModel?> searchResult = [];

  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20.sp, sigmaY: 20.sp),
      child: DraggableScrollableSheet(
          maxChildSize: 0.95,
          initialChildSize: 0.9,
          minChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
                height: 0.95.height,
                width: 1.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  color: Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    0.02.vspace,
                    Center(
                      child: Container(
                        height: 5.sp,
                        width: 36.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                    0.03.vspace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.sp),
                            child: SizedBox(
                              height: 50.sp,
                              child: TextFormField(
                                controller: searchController,
                                textAlignVertical: TextAlignVertical.top,
                                textAlign: TextAlign.start,
                                style: const TextStyle(color: Colors.white),
                                focusNode: focusNode,
                                onChanged: ((value) {
                                  if (controller.searchDebounceTimer != null) {
                                    controller.searchDebounceTimer!.cancel();
                                  }
                                  controller.searchDebounceTimer = Timer(
                                      const Duration(milliseconds: 250), () {
                                    searchResult =
                                        controller.searchTransactionHistory(
                                            value.toLowerCase());
                                    setState(() {});
                                  });
                                }),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: ColorConst.NeutralVariant.shade60
                                      .withOpacity(0.2),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: ColorConst.NeutralVariant.shade60,
                                    size: 18.sp,
                                  ),
                                  counterStyle: const TextStyle(
                                      backgroundColor: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none),
                                  hintText: 'Search',
                                  hintStyle: labelMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.25,
                                      color: ColorConst.NeutralVariant.shade70),
                                  labelStyle: labelSmall,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 20.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.06.height,
                          width: 0.18.width,
                          child: TextButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                enableFeedback: true,
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                            onPressed: () {
                              setState(() {
                                searchController.clear();
                                focusNode.unfocus();
                                searchResult.clear();
                              });
                            },
                            child: Text(
                              "Cancel",
                              style: labelMedium.copyWith(
                                  color: ColorConst.Primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    searchController.text.isEmpty && searchResult.isEmpty
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 44.sp),
                              child: Text(
                                  "Try searching for token,\n protocols, and tags",
                                  textAlign: TextAlign.center,
                                  style: labelLarge.copyWith(
                                      letterSpacing: 0.25,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          ColorConst.NeutralVariant.shade70)),
                            ),
                          )
                        : Expanded(
                            child: CustomScrollView(
                            controller: scrollController,
                            // controller: controller.paginationController.value,
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    if (searchResult[index] == null) {
                                      return const SizedBox();
                                    } else {
                                      late TokenInfo token;
                                      token = tokenInfo(index);
                                      return token.isNft
                                          ? nftLoader(index)
                                          : token.skip
                                              ? const SizedBox()
                                              : tokenLoader(token);
                                    }
                                  },
                                  childCount: searchResult.length,
                                ),
                              ),
                            ],
                          ))
                  ],
                ));
          }),
    );
  }

  TokenInfo tokenInfo(int index) {
    if (searchResult[index] != null) {
      if (controller.isTezosTransaction(index)) {
        return TokenInfo(
          index: index,
          tokenSymbol: "tez",
          tokenAmount: searchResult[index]!.amount! / 1e6,
          dollarAmount:
              (searchResult[index]!.amount! / 1e6) * controller.xtzPrice.value,
        );
      } else {
        if (isTezosTransaction(index)) {
          if (isFa2Token(index)) {
            if (searchResult[index]!.isFa2TokenListEmpty()) {
              return TokenInfo(isNft: true, index: index);
            } else {
              TokenPriceModel fa2Token = searchResult[index]!.fa2TokenName();

              String amount = searchResult[index]!.parameter?.value is List
                  ? searchResult[index]!.parameter?.value[0]['txs'][0]['amount']
                  : jsonDecode(searchResult[index]!.parameter!.value)[0]['txs']
                      [0]['amount'];

              return TokenInfo(
                  index: index,
                  name: fa2Token.name!,
                  dollarAmount: double.parse(amount) /
                      pow(10, fa2Token.decimals!) *
                      fa2Token.currentPrice!,
                  tokenSymbol: fa2Token.symbol!,
                  tokenAmount:
                      double.parse(amount) / pow(10, fa2Token.decimals!),
                  imageUrl: searchResult[index]!.getImageUrl());
            }
          } else {
            if (searchResult[index]!.isFa2TokenListEmpty()) {
              return TokenInfo(
                skip: true,
                index: index,
              );
            }
            TokenPriceModel faToken = searchResult[index]!.fa1TokenName();
            late String amount = "0";
            if (searchResult[index]!.parameter!.value is Map) {
              amount = searchResult[index]!.parameter!.value['value'];
            } else if (searchResult[index]!.parameter!.value is String) {
              var decodedString =
                  jsonDecode(searchResult[index]!.parameter!.value);
              amount = decodedString['value'];
            }

            return TokenInfo(
                index: index,
                name: faToken.name!,
                dollarAmount: (double.parse(amount) /
                    pow(10, faToken.decimals!) *
                    faToken.currentPrice!),
                tokenSymbol: faToken.symbol!,
                tokenAmount: double.parse(amount) / pow(10, faToken.decimals!),
                imageUrl: searchResult[index]!.getImageUrl());
          }
        } else {
          return TokenInfo(
            skip: true,
            index: index,
          );
        }
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
                        .format(DateTime.parse(
                            searchResult[token.index]!.timestamp!)),
                    style: labelMedium,
                  ),
                )
              : DateTime.parse(searchResult[token.index]!.timestamp!)
                      .isSameDate(DateTime.parse(
                          searchResult[token.index == 0 ? 0 : token.index - 1]!
                              .timestamp!))
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: 16.sp, left: 16.sp, bottom: 16.sp),
                      child: Text(
                        DateFormat.yMMMEd()
                            // displaying formatted date
                            .format(DateTime.parse(
                                searchResult[token.index]!.timestamp!)),
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
            historyModel: searchResult[token.index]!,
            onTap: () => Get.bottomSheet(TransactionDetailsBottomSheet(
              tokenInfo: token,
              userAccountAddress: controller.userAccount.value.publicKeyHash!,
              transactionModel: searchResult[token.index]!,
            )),
          ),
        ],
      );

  Widget nftLoader(int index) => FutureBuilder(
      future: ObjktNftApiService().getTransactionNFT(
          searchResult[index]!.target!.address!,
          searchResult[index]!.parameter?.value[0]["txs"][0]["token_id"]),
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
              tokenSymbol: snapshot.data!.fa!.name!,
              dollarAmount: snapshot.data!.lowestAsk / 1e6,
              tokenAmount: snapshot.data!.lowestAsk != null &&
                      snapshot.data!.lowestAsk != 0
                  ? snapshot.data!.lowestAsk / 1e6
                  : 0,
              name: snapshot.data!.name!,
              imageUrl: snapshot.data!.displayUri!);
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
                      .format(DateTime.parse(searchResult[index]!.timestamp!)),
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
                historyModel: searchResult[index]!,
                onTap: () => Get.bottomSheet(TransactionDetailsBottomSheet(
                  tokenInfo: token,
                  userAccountAddress:
                      controller.userAccount.value.publicKeyHash!,
                  transactionModel: searchResult[index]!,
                )),
              ),
            ],
          );
        }
      }));

  bool isTezosTransaction(int index) =>
      searchResult[index]!.amount != null &&
      searchResult[index]!.amount! > 0 &&
      searchResult[index]!.parameter == null;

  bool isAnyTokenOrNftTransaction(int index) =>
      searchResult[index]!.parameter != null &&
      searchResult[index]!.parameter?.entrypoint == "transfer";

  bool isFa2Token(int index) {
    if (searchResult[index]!.parameter == null) {
      return false;
    } else if (searchResult[index]!.parameter!.value is Map) {
      return false;
    } else if (searchResult[index]!.parameter!.value is List) {
      return true;
    } else if (searchResult[index]!.parameter!.value is String) {
      var decodedString = jsonDecode(searchResult[index]!.parameter!.value);
      if (decodedString is List) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

extension SearchExtension on TxHistoryModel {
  // bool isTezosTransaction() {
  //   return amount != null && amount! > 0 && parameter == null;
  // }

  // bool isAnyTokenOrNFTTransaction() {
  //   return parameter != null && parameter?.entrypoint == "transfer";
  // }

  // bool isFa2Token() {
  //   if (parameter!.value is Map) {
  //     return false;
  //   } else if (parameter!.value is List) {
  //     return true;
  //   } else if (parameter!.value is String) {
  //     var decodedString = jsonDecode(parameter!.value);
  //     if (decodedString is List) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

  bool isFa2TokenListEmpty() => Get.find<AccountSummaryController>()
      .tokensList
      .where((p0) =>
          (p0.tokenAddress!.contains(target!.address!)) &&
          p0.tokenId!.contains(parameter!.value is List
              ? parameter?.value[0]["txs"][0]["token_id"]
              : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"]))
      .isEmpty;
  String getImageUrl() => Get.find<AccountSummaryController>()
      .tokensList
      .where((p0) => p0.tokenAddress!.contains(target!.address!))
      .first
      .thumbnailUri!;

  TokenPriceModel fa2TokenName() =>
      Get.find<AccountSummaryController>().tokensList.firstWhere((p0) =>
          (p0.tokenAddress!.contains(target!.address!)) &&
          p0.tokenId!.contains(parameter!.value is List
              ? parameter?.value[0]["txs"][0]["token_id"]
              : jsonDecode(parameter!.value)[0]["txs"][0]["token_id"]));

  TokenPriceModel fa1TokenName() => Get.find<AccountSummaryController>()
      .tokensList
      .where((p0) => (p0.tokenAddress!.contains(target!.address!)))
      .first;
  bool isTokenListEmpty() => Get.find<AccountSummaryController>()
      .tokensList
      .where((p0) => p0.tokenAddress!.contains(target!.address!))
      .isEmpty;
}
