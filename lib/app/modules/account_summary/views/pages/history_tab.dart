import 'dart:convert';

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
                    if (controller.userTransactionHistory[index].amount == 0) {
                      /// For NFTs :- Target Alias is null &&
                      if (controller.userTransactionHistory[index].parameter
                              ?.entrypoint ==
                          "transfer") {
                        // print(
                        //     "Debug ${controller.userTransactionHistory[index].target!.alias}");
                        var value = controller
                            .userTransactionHistory[index].parameter?.value;
                        // print(
                        //     "Entry Point ${controller.userTransactionHistory[index].parameter?.value}");
                        // print(
                        //     "${controller.tokensList.where((p0) => p0.tokenAddress!.contains(controller.userTransactionHistory[index].target!.address!)).first.name}");
                        if (value is Map<String, dynamic>) {
                          // print("Value Map $value");
                        } else if (value is List) {
                          // print("Value List $value");
                          // print(
                          //     "fa2 token are ${controller.tokensList.firstWhere((p0) => (p0.tokenAddress!.contains(controller.userTransactionHistory[index].target!.address!)) && p0.tokenId!.contains("${value[0]["txs"][0]["token_id"]}")).name}");
                        } else {
                          var data = json.decode(value);

                          // print("Decoded json $data");

                          if (data is Map<String, dynamic>) {
                            // print("data map json $data");

                            // print("Is Converted to map");
                          } else if (data is List<dynamic>) {
                            // print("data List json $data");
                          }
                        }
                      }
                    }
                    return controller.userTransactionHistory[index].hash!
                                .contains(controller
                                    .userTransactionHistory[index - 1].hash!) &&
                            controller.userTransactionHistory[index].hash!
                                .contains(controller
                                    .userTransactionHistory[controller
                                                    .userTransactionHistory
                                                    .length -
                                                1 ==
                                            index
                                        ? index
                                        : index + 1]
                                    .hash!)
                        ? const SizedBox()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    .userTransactionHistory[
                                                        index]
                                                    .timestamp!)),
                                            style: labelMedium,
                                          ),
                                        ),
                              HistoryTile(
                                tokenName: controller.userTransactionHistory[index].amount != null &&
                                        controller.userTransactionHistory[index].amount! >
                                            0 &&
                                        controller.userTransactionHistory[index]
                                                .parameter ==
                                            null
                                    ? "Tezos"
                                    : controller.userTransactionHistory[index].parameter != null &&
                                            controller.userTransactionHistory[index].parameter?.entrypoint ==
                                                "transfer"
                                        ? controller
                                                .userTransactionHistory[index]
                                                .parameter!
                                                .value is List
                                            ? controller.tokensList
                                                    .where((p0) =>
                                                        (p0.tokenAddress!
                                                            .contains(controller
                                                                .userTransactionHistory[index]
                                                                .target!
                                                                .address!)) &&
                                                        p0.tokenId!.contains(controller.userTransactionHistory[index].parameter?.value[0]["txs"][0]["token_id"]))
                                                    .isEmpty
                                                ? controller.tokensList.firstWhere((p0) => (p0.tokenAddress!.contains(controller.userTransactionHistory[index].target!.address!))).name!
                                                : controller.tokensList.firstWhere((p0) => (p0.tokenAddress!.contains(controller.userTransactionHistory[index].target!.address!)) && p0.tokenId!.contains(controller.userTransactionHistory[index].parameter?.value[0]["txs"][0]["token_id"])).name!
                                            : controller.tokensList.where((p0) => (p0.tokenAddress!.contains(controller.userTransactionHistory[index].target!.address!))).first.name!
                                        : "Can be nfts",
                                tokenIconUrl: controller
                                                .userTransactionHistory[index]
                                                .amount !=
                                            null &&
                                        controller.userTransactionHistory[index].amount! >
                                            0 &&
                                        controller.userTransactionHistory[index].parameter ==
                                            null
                                    ? '${PathConst.ASSETS}tezos_logo.png'
                                    : controller.userTransactionHistory[index].target == null ||
                                            controller.tokensList
                                                .where((p0) => p0.tokenAddress!
                                                    .contains(controller
                                                        .userTransactionHistory[
                                                            index]
                                                        .target!
                                                        .address!))
                                                .isEmpty
                                        ? '${PathConst.ASSETS}tezos_logo.png'
                                        : controller.tokensList
                                            .where((p0) => p0.tokenAddress!.contains(controller.userTransactionHistory[index].target!.address!))
                                            .first
                                            .thumbnailUri!,
                                userAccountAddress:
                                    controller.userAccount.value.publicKeyHash!,
                                xtzPrice: controller.xtzPrice.value,
                                historyModel:
                                    controller.userTransactionHistory[index],
                                onTap: () => Get.bottomSheet(
                                    TransactionDetailsBottomSheet(
                                  transactionModel:
                                      controller.userTransactionHistory[index],
                                )),
                                status: HistoryStatus.receive,
                              ),
                            ],
                          );
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

extension TokenNameCheck on dynamic {
  String getTokenId() {
    print(this);
    if (this is Map<String, dynamic>) {
      return this["token_id"] == null
          ? this["token_info"]["name"]
          : this["token_info"]["name"];
    } else if (this is List<dynamic>) {
      return this[0]["txs"][0]["token_id"] == null
          ? this[0]["txs"][0]["token_id"]
          : "Unknown";
    } else {
      return "";
    }
  }
}
