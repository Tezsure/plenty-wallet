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
import '../../../../../utils/constants/path_const.dart';
import '../account_summary_view.dart';
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
  List<TxHistoryModel> searchResult = [];

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
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
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
                    0.01.vspace,
                    Center(
                      child: Container(
                        height: 5,
                        width: 36,
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
                        SizedBox(
                          height: 0.06.height,
                          width: 0.7.width,
                          child: TextFormField(
                            controller: searchController,
                            textAlignVertical: TextAlignVertical.top,
                            textAlign: TextAlign.start,
                            style: const TextStyle(color: Colors.white),
                            focusNode: focusNode,
                            onChanged: ((value) {
                              setState(() {
                                searchResult =
                                    controller.searchTransactionHistory(
                                        value.toLowerCase());
                              });
                            }),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ColorConst.NeutralVariant.shade60
                                  .withOpacity(0.2),
                              prefixIcon: Icon(
                                Icons.search,
                                color: ColorConst.NeutralVariant.shade60,
                                size: 22,
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
                              hintStyle: bodySmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade70),
                              labelStyle: labelSmall,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
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
                    0.03.vspace,
                    searchController.text.isEmpty && searchResult.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                  "Try searching for token,\n protocols, and tags",
                                  textAlign: TextAlign.center,
                                  style: bodySmall.copyWith(
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
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        index == 0
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top: 16.sp,
                                                    left: 16.sp,
                                                    bottom: 16.sp),
                                                child: Text(
                                                  DateFormat.yMMMEd()
                                                      // displaying formatted date
                                                      .format(DateTime.parse(
                                                          searchResult[index]
                                                              .timestamp!)),
                                                  style: labelMedium,
                                                ),
                                              )
                                            : DateTime.parse(searchResult[index]
                                                        .timestamp!)
                                                    .isSameDate(DateTime.parse(
                                                        searchResult[index == 0
                                                                ? 0
                                                                : index - 1]
                                                            .timestamp!))
                                                ? const SizedBox()
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 16.sp,
                                                        left: 16.sp,
                                                        bottom: 16.sp),
                                                    child: Text(
                                                      DateFormat.yMMMEd().format(
                                                          DateTime.parse(
                                                              searchResult[
                                                                      index]
                                                                  .timestamp!)),
                                                      style: labelMedium,
                                                    ),
                                                  ),
                                        HistoryTile(
                                          tokenName: controller.userTransactionHistory[index].amount !=
                                                      null &&
                                                  controller.userTransactionHistory[index].amount! >
                                                      0 &&
                                                  controller.userTransactionHistory[index].parameter ==
                                                      null
                                              ? "Tezos"
                                              : controller.userTransactionHistory[index].amount ==
                                                          0 &&
                                                      controller
                                                              .userTransactionHistory[
                                                                  index]
                                                              .parameter
                                                              ?.entrypoint ==
                                                          "transfer"
                                                  ? controller.tokensList
                                                      .where((p0) => p0
                                                          .tokenAddress!
                                                          .contains(controller
                                                              .userTransactionHistory[index]
                                                              .target!
                                                              .address!))
                                                      .first
                                                      .name!
                                                  : "NFTs",
                                          tokenIconUrl: controller
                                                          .userTransactionHistory[
                                                              index]
                                                          .amount !=
                                                      null &&
                                                  controller
                                                          .userTransactionHistory[
                                                              index]
                                                          .amount! >
                                                      0 &&
                                                  controller
                                                          .userTransactionHistory[
                                                              index]
                                                          .parameter ==
                                                      null
                                              ? '${PathConst.SVG}tez.svg'
                                              : controller.tokensList
                                                  .where((p0) => p0
                                                      .tokenAddress!
                                                      .contains(controller
                                                          .userTransactionHistory[
                                                              index]
                                                          .target!
                                                          .address!))
                                                  .first
                                                  .thumbnailUri!,
                                          userAccountAddress: controller
                                              .userAccount.value.publicKeyHash!,
                                          xtzPrice: controller.xtzPrice.value,
                                          historyModel: searchResult[index],
                                          onTap: () => Get.bottomSheet(
                                              TransactionDetailsBottomSheet(
                                            transactionModel:
                                                searchResult[index],
                                          )),
                                          status: HistoryStatus.receive,
                                        ),
                                      ],
                                    );
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
}
