import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import '../../../../data/services/service_models/nft_token_model.dart';
import '../../controllers/transaction_controller.dart';
import '../bottomsheets/history_filter_sheet.dart';
import '../bottomsheets/search_sheet.dart';
import '../bottomsheets/transaction_details.dart';
import '../widgets/history_tab_widgets/history_tile.dart';

class HistoryPage extends GetView<TransactionController> {
  final bool isNftTransaction;
  const HistoryPage({
    super.key,
    this.isNftTransaction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomScrollView(
        controller: controller.paginationController.value,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.aR),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  0.02.vspace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: (() => Get.bottomSheet(
                              const SearchBottomSheet(),
                              isScrollControlled: true,
                            )),
                        child: Container(
                          height: 0.06.height,
                          width: 0.8.width,
                          padding: EdgeInsets.only(left: 14.5.aR),
                          decoration: BoxDecoration(
                            color: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.aR),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: ColorConst.NeutralVariant.shade60,
                                size: 22.aR,
                              ),
                              0.02.hspace,
                              Text(
                                'Search',
                                style: labelLarge.copyWith(
                                    letterSpacing: 0.25.aR,
                                    fontSize: 14.aR,
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
                          height: 24.aR,
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
          controller.userTransactionHistory.isEmpty
              ? _emptyState
              : controller.isFilterApplied.value &&
                      controller.filteredTokenList.isEmpty
                  ? _emptyState
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (controller.isFilterApplied.isTrue) {
                            return _loadTokenTransaction(
                                controller.filteredTokenList[index],
                                index,
                                controller.filteredTokenList[index].timeStamp!
                                    .isSameMonth(controller
                                        .filteredTokenList[
                                            index == 0 ? 0 : index - 1]
                                        .timeStamp!));
                          } else {
                            return controller.tokenTransactionList[index].isNft
                                ? _loadNFTTransaction(index)
                                : controller.tokenTransactionList[index].skip ||
                                        controller.tokenTransactionList[index]
                                                .isHashSame ==
                                            true
                                    ? const SizedBox()
                                    : _loadTokenTransaction(
                                        controller.tokenTransactionList[index],
                                        index,
                                        controller.tokenTransactionList[index]
                                            .timeStamp!
                                            .isSameMonth(controller
                                                .tokenTransactionList[
                                                    index == 0 ? 0 : index - 1]
                                                .timeStamp!));
                          }
                        },
                        childCount: controller.isFilterApplied.value
                            ? controller.filteredTokenList.length
                            : controller.tokenTransactionList.length,
                      ),
                    ),
        ],
      );
    });
  }

  Widget get _emptyState => SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            0.03.vspace,
            SvgPicture.asset(
              "${PathConst.EMPTY_STATES}empty3.svg",
              height: 120.aR,
            ),
            0.02.vspace,
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "No transactions\n",
                    style: titleLarge.copyWith(
                        fontSize: 22.aR, fontWeight: FontWeight.w700),
                    children: [
                      WidgetSpan(child: 0.04.vspace),
                      TextSpan(
                          text:
                              "Your crypto and NFT activity will appear\nhere once you start using your wallet",
                          style: labelMedium.copyWith(
                              fontSize: 12.aR,
                              color: ColorConst.NeutralVariant.shade60))
                    ])),
          ],
        ),
      );

  Widget _loadTokenTransaction(TokenInfo token, int index, bool sameDate) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          index == 0
              ? Padding(
                  padding:
                      EdgeInsets.only(top: 24.sp, left: 16.sp, bottom: 16.sp),
                  child: Text(
                    DateFormat.MMMM()
                        // displaying formatted date
                        .format(token.timeStamp!),
                    style: labelLarge,
                  ),
                )
              : sameDate
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: 20.sp, left: 16.sp, bottom: 12.sp),
                      child: Text(
                        DateFormat.MMMM()
                            // displaying formatted date
                            .format(token.timeStamp!),
                        style: labelLarge,
                      ),
                    ),
          HistoryTile(
            tokenInfo: token,
            xtzPrice: controller.accController.xtzPrice.value,
            onTap: () => Get.bottomSheet(TransactionDetailsBottomSheet(
              tokenInfo: token,
              userAccountAddress:
                  controller.accController.userAccount.value.publicKeyHash!,
              transactionModel: token.token!,
            )),
          ),
        ],
      );

  Widget _loadNFTTransaction(int index) {
    return FutureBuilder(
        future: ObjktNftApiService().getTransactionNFT(
            controller.tokenTransactionList[index].nftContractAddress!,
            controller.tokenTransactionList[index].nftTokenId!),
        builder: ((context, AsyncSnapshot<NftTokenModel> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            controller.tokenTransactionList[index] =
                controller.tokenTransactionList[index].copyWith(
                    isNft: true,
                    tokenSymbol: snapshot.data!.fa!.name!,
                    dollarAmount: (snapshot.data!.lowestAsk / 1e6) *
                        controller.accController.xtzPrice.value,
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
                DateTime.parse(controller
                            .tokenTransactionList[index].token!.timestamp!)
                        .isSameMonth(DateTime.parse(controller
                            .tokenTransactionList[index == 0 ? 0 : index - 1]
                            .token!
                            .timestamp!))
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(
                            top: 16.sp, left: 16.sp, bottom: 16.sp),
                        child: Text(
                          DateFormat.MMMM()
                              // displaying formatted date
                              .format(DateTime.parse(controller
                                  .tokenTransactionList[index]
                                  .token!
                                  .timestamp!)),
                          style: labelLarge,
                        ),
                      ),
                HistoryTile(
                  tokenInfo: controller.tokenTransactionList[index],
                  xtzPrice: controller.accController.xtzPrice.value,
                  onTap: () => Get.bottomSheet(TransactionDetailsBottomSheet(
                    tokenInfo: controller.tokenTransactionList[index],
                    userAccountAddress: controller
                        .accController.userAccount.value.publicKeyHash!,
                    transactionModel:
                        controller.tokenTransactionList[index].token!,
                  )),
                ),
              ],
            );
          }
        }));
  }
}
