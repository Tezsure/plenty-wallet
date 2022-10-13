import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/pages/history_tab.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../../utils/colors/colors.dart';
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
  AccountSummaryController controller = Get.find<AccountSummaryController>();

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
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
          height: 0.95.height,
          width: 1.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            // gradient: GradConst.GradientBackground,
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
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
              ),
              0.03.vspace,
              Center(
                child: SizedBox(
                  height: 0.06.height,
                  width: 0.9.width,
                  child: Center(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.start,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                        prefixIcon: Icon(
                          Icons.search,
                          color: ColorConst.NeutralVariant.shade60,
                          size: 22,
                        ),
                        counterStyle:
                            const TextStyle(backgroundColor: Colors.white),
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
                ),
              ),
              0.03.vspace,
              Expanded(
                  child: CustomScrollView(
                // controller: controller.paginationController.value,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return
                            // controller.userTransactionHistory[index].type!
                            //         .contains("transaction")
                            //     ?
                            Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index == 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: 16.sp, left: 16.sp, bottom: 16.sp),
                                    child: Text(
                                      DateFormat.yMMMEd()
                                          // displaying formatted date
                                          .format(DateTime.parse(controller
                                              .userTransactionHistory[index]
                                              .timestamp!)),
                                      style: labelMedium,
                                    ),
                                  )
                                : DateTime.parse(controller
                                            .userTransactionHistory[index]
                                            .timestamp!)
                                        .isSameDate(DateTime.parse(controller
                                            .userTransactionHistory[
                                                index == 0 ? 0 : index - 1]
                                            .timestamp!))
                                    ? const SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            top: 16.sp,
                                            left: 16.sp,
                                            bottom: 16.sp),
                                        child: Text(
                                          DateFormat.yMMMEd().format(
                                              DateTime.parse(controller
                                                  .userTransactionHistory[index]
                                                  .timestamp!)),
                                          style: labelMedium,
                                        ),
                                      ),
                            HistoryTile(
                              userAccountAddress:
                                  controller.userAccount.value.publicKeyHash!,
                              xtzPrice: controller.xtzPrice.value,
                              historyModel:
                                  controller.userTransactionHistory[index],
                              onTap: () =>
                                  Get.bottomSheet(TransactionDetailsBottomSheet(
                                transactionModel:
                                    controller.userTransactionHistory[index],
                              )),
                              status: HistoryStatus.receive,
                            ),
                          ],
                        );
                        // : const NftHistoryTile(
                        //     status: HistoryStatus.inProgress,
                        //   );
                      },
                      childCount: controller.userTransactionHistory.length,
                    ),
                  ),
                ],
              ))

              //     CustomScrollView(
              //   slivers: [
              //     focusNode.hasFocus
              //         ? SliverList(
              //             delegate: SliverChildBuilderDelegate(
              //               (context, index) {
              //                 return (index % 3 == 0)
              //                     ? Padding(
              //                         padding: EdgeInsets.only(
              //                             top: 16.sp,
              //                             left: 16.sp,
              //                             bottom: 16.sp),
              //                         child: Text(
              //                           'August 15, 2022',
              //                           style: labelMedium,
              //                         ),
              //                       )
              //                     : HistoryTile(
              //                         historyModel: TxHistoryModel(),
              //                         status: index.isEven
              //                             ? HistoryStatus.receive
              //                             : HistoryStatus.sent,
              //                       );
              //               },
              //               childCount: 20,
              //             ),
              //           )
              //         : SliverToBoxAdapter(
              //             child: Center(
              //                 child: Padding(
              //               padding:
              //                   EdgeInsets.symmetric(vertical: 0.03.height),
              //               child: Text(
              //                   'Try searching for token,\nprotocols, and tags',
              //                   textAlign: TextAlign.center,
              //                   style: bodyMedium.copyWith(
              //                     color: ColorConst.NeutralVariant.shade70,
              //                   )),
              //             )),
              //           ),
              //   ],
              // )),
            ],
          )),
    );
  }
}
