import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/history_filter_sheet.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/styles/styles.dart';
import '../account_summary_view.dart';
import '../bottomsheets/transaction_details.dart';
import '../widgets/history_tab_widgets/history_tile.dart';

class HistoryPage extends GetView<AccountSummaryController> {
  final bool isNftTransaction;
  final GestureTapCallback? onTap;
  const HistoryPage({super.key, this.isNftTransaction = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.userTransactionHistory.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              0.03.vspace,
              SvgPicture.asset(
                "${PathConst.EMPTY_STATES}empty3.svg",
                height: 240.sp,
              ),
              0.03.vspace,
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "No transactions\n",
                      style: titleLarge.copyWith(fontWeight: FontWeight.w700),
                      children: [
                        WidgetSpan(child: 0.04.vspace),
                        TextSpan(
                            text:
                                "Your crypto and NFT activity will appear\nhere once you start using your wallet",
                            style: labelMedium.copyWith(
                                color: ColorConst.NeutralVariant.shade60))
                      ])),
            ],
          )
        : CustomScrollView(
            controller: controller.paginationController.value,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.02.width),
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
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ColorConst.NeutralVariant.shade60
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: ColorConst.NeutralVariant.shade60,
                                    size: 22,
                                  ),
                                  0.02.hspace,
                                  Text(
                                    'Search',
                                    style: bodySmall.copyWith(
                                        color:
                                            ColorConst.NeutralVariant.shade70),
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
                              '${PathConst.SVG}filter.svg',
                              fit: BoxFit.contain,
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
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // print(
                    //     "target  ${controller.userTransactionHistory[index].type}");
                    // if (controller.userTransactionHistory[index].type!
                    //     .contains("transaction")) {
                    //   print(
                    //       jsonEncode(controller.userTransactionHistory[index]));
                    // }
                    // print(
                    //     "Has Internals ${controller.userTransactionHistory[index].hasInternals}");

                    // print(
                    //     "Parameters are: ${controller.userTransactionHistory[index].parameter}");
                    // print(controller.userTransactionHistory[index].hash);

                    // controller.userTransactionHistory[index].
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
                                        top: 16.sp, left: 16.sp, bottom: 16.sp),
                                    child: Text(
                                      DateFormat.yMMMEd().format(DateTime.parse(
                                          controller
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
          ));
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
