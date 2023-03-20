import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/transaction_details.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../../utils/colors/colors.dart';
import '../../controllers/transaction_controller.dart';
import '../widgets/history_tab_widgets/history_tile.dart';

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  FocusNode focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  TransactionController controller = Get.find<TransactionController>();
  ScrollController paginationController = ScrollController();
  String searchQuery = '';

  @override
  void initState() {
    paginationController.removeListener(() {});
    paginationController.addListener(() async {
      if (paginationController.position.pixels ==
          paginationController.position.maxScrollExtent) {
        await controller.loadSearchResults(searchQuery);
        setState(() {});
      }
    });
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
    return Material(
      type: MaterialType.transparency,
      child: NaanBottomSheet(
        leading: Padding(
          padding: EdgeInsets.only(left: 16.arP),
          child: backButton(
              ontap: () => Navigator.pop(context), lastPageName: "Accounts"),
        ),
        // title: "",
        height: AppConstant.naanBottomSheetHeight,
        // isScrollControlled: true,
        // height: AppConstant.naanBottomSheetHeight -
        //     MediaQuery.of(context).viewInsets.bottom,
        bottomSheetHorizontalPadding: 0,
        prevPageName: "Accounts",
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight -
                MediaQuery.of(context).viewInsets.bottom,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.arP),
                  child: BottomSheetHeading(
                    title: "",
                    leading: backButton(
                        ontap: () {
                          Navigator.pop(context);
                        },
                        lastPageName: "Accounts"),
                  ),
                ),
                0.02.vspace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16.arP,
                        ),
                        child: SizedBox(
                          height: 50.arP,
                          child: TextFormField(
                            autofocus: true,
                            cursorColor: ColorConst.Primary,
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
                                  const Duration(milliseconds: 250), () async {
                                searchQuery = value.toLowerCase().trim();
                                await controller
                                    .searchTransactionHistory(searchQuery);
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
                                size: 18.arP,
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
                                  horizontal: 10.arP, vertical: 20.arP),
                            ),
                          ),
                        ),
                      ),
                    ),
                    BouncingWidget(
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                          focusNode.unfocus();
                          controller.searchTransactionList.clear();
                        });
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.arP, left: 8.arP),
                        child: Text(
                          "Cancel".tr,
                          style:
                              labelMedium.copyWith(color: ColorConst.Primary),
                        ),
                      ),
                    ),
                  ],
                ),
                0.03.vspace,
                searchController.text.isEmpty ||
                        controller.searchTransactionList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 44.arP),
                          child: Text(
                              "Try searching for token,\n protocols, and tags"
                                  .tr,
                              textAlign: TextAlign.center,
                              style: labelLarge.copyWith(
                                  letterSpacing: 0.25,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConst.NeutralVariant.shade70)),
                        ),
                      )
                    : Expanded(
                        child: CustomScrollView(
                        controller: paginationController,
                        physics: AppConstant.scrollPhysics,
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return controller.searchTransactionList[index]
                                            .skip ||
                                        controller.searchTransactionList[index]
                                                .isHashSame ==
                                            true
                                    ? const SizedBox()
                                    : tokenLoader(index);
                              },
                              childCount:
                                  controller.searchTransactionList.length,
                            ),
                          ),
                        ],
                      ))
              ],
            ),
          )
        ],
      ),
    );
    // return BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 20.arP, sigmaY: 20.arP),
    //   child: DraggableScrollableSheet(
    //       maxChildSize: 0.95,
    //       initialChildSize: 0.9,
    //       minChildSize: 0.9,
    //       builder: (context, scrollController) {
    //         return Container(
    //             height: 0.95.height,
    //             width: 1.width,
    //             decoration: const BoxDecoration(
    //               borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    //               color: Colors.black,
    //             ),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 0.02.vspace,
    //                 Center(
    //                   child: Container(
    //                     height: 5.arP,
    //                     width: 36.arP,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(5),
    //                       color: ColorConst.NeutralVariant.shade60
    //                           .withOpacity(0.3),
    //                     ),
    //                   ),
    //                 ),
    //                 0.03.vspace,
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Flexible(
    //                       child: Padding(
    //                         padding: EdgeInsets.only(
    //                           left: 16.arP,
    //                         ),
    //                         child: SizedBox(
    //                           height: 50.arP,
    //                           child: TextFormField(
    //                             controller: searchController,
    //                             textAlignVertical: TextAlignVertical.top,
    //                             textAlign: TextAlign.start,
    //                             style: const TextStyle(color: Colors.white),
    //                             focusNode: focusNode,
    //                             onChanged: ((value) {
    //                               if (controller.searchDebounceTimer != null) {
    //                                 controller.searchDebounceTimer!.cancel();
    //                               }
    //                               controller.searchDebounceTimer =
    //                                   Timer(const Duration(milliseconds: 250),
    //                                       () async {
    //                                 searchQuery = value.toLowerCase().trim();
    //                                 await controller
    //                                     .searchTransactionHistory(searchQuery);
    //                                 setState(() {});
    //                               });
    //                             }),
    //                             decoration: InputDecoration(
    //                               filled: true,
    //                               fillColor: ColorConst.NeutralVariant.shade60
    //                                   .withOpacity(0.2),
    //                               prefixIcon: Icon(
    //                                 Icons.search,
    //                                 color: ColorConst.NeutralVariant.shade60,
    //                                 size: 18.arP,
    //                               ),
    //                               counterStyle: const TextStyle(
    //                                   backgroundColor: Colors.white),
    //                               border: OutlineInputBorder(
    //                                 borderRadius: BorderRadius.circular(8),
    //                                 borderSide: BorderSide.none,
    //                               ),
    //                               focusedBorder: OutlineInputBorder(
    //                                   borderRadius: BorderRadius.circular(8),
    //                                   borderSide: BorderSide.none),
    //                               hintText: 'Search',
    //                               hintStyle: labelMedium.copyWith(
    //                                   fontWeight: FontWeight.w500,
    //                                   letterSpacing: 0.25,
    //                                   color: ColorConst.NeutralVariant.shade70),
    //                               labelStyle: labelSmall,
    //                               contentPadding: EdgeInsets.symmetric(
    //                                   horizontal: 10.arP, vertical: 20.arP),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     Center(
    //                       // height: 0.06.height,
    //                       // width: 0.18.width,
    //                       child: TextButton(
    //                         style: ButtonStyle(
    //                             overlayColor: MaterialStateProperty.all(
    //                                 Colors.transparent),
    //                             enableFeedback: true,
    //                             padding:
    //                                 MaterialStateProperty.all(EdgeInsets.zero),
    //                             tapTargetSize:
    //                                 MaterialTapTargetSize.shrinkWrap),
    //                         onPressed: () {
    //                           setState(() {
    //                             searchController.clear();
    //                             focusNode.unfocus();
    //                             controller.searchTransactionList.clear();
    //                           });
    //                           Get.back();
    //                         },
    //                         child: Text(
    //                           "Cancel",
    //                           style: labelMedium.copyWith(
    //                               color: ColorConst.Primary),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 0.03.vspace,
    //                 searchController.text.isEmpty ||
    //                         controller.searchTransactionList.isEmpty
    //                     ? Center(
    //                         child: Padding(
    //                           padding: EdgeInsets.only(top: 44.arP),
    //                           child: Text(
    //                               "Try searching for token,\n protocols, and tags",
    //                               textAlign: TextAlign.center,
    //                               style: labelLarge.copyWith(
    //                                   letterSpacing: 0.25,
    //                                   fontWeight: FontWeight.w400,
    //                                   color:
    //                                       ColorConst.NeutralVariant.shade70)),
    //                         ),
    //                       )
    //                     : Expanded(
    //                         child: CustomScrollView(
    //                         controller: paginationController,
    //                         physics: const BouncingScrollPhysics(),
    //                         slivers: [
    //                           SliverList(
    //                             delegate: SliverChildBuilderDelegate(
    //                               (context, index) {
    //                                 return controller
    //                                             .searchTransactionList[index]
    //                                             .skip ||
    //                                         controller
    //                                                 .searchTransactionList[
    //                                                     index]
    //                                                 .isHashSame ==
    //                                             true
    //                                     ? const SizedBox()
    //                                     : tokenLoader(index);
    //                               },
    //                               childCount:
    //                                   controller.searchTransactionList.length,
    //                             ),
    //                           ),
    //                         ],
    //                       ))
    //               ],
    //             ));
    //       }),
    // );
  }

  Widget tokenLoader(int index) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          index == 0
              ? Padding(
                  padding: EdgeInsets.only(
                      top: 24.arP, left: 16.arP, bottom: 16.arP),
                  child: Text(
                    DateFormat.MMMM()
                        // displaying formatted date
                        .format(DateTime.parse(controller
                            .searchTransactionList[index].token!.timestamp!)),
                    style: labelLarge,
                  ),
                )
              : DateTime.parse(controller
                          .searchTransactionList[index].token!.timestamp!)
                      .isSameMonth(DateTime.parse(controller
                          .searchTransactionList[index == 0 ? 0 : index - 1]
                          .token!
                          .timestamp!))
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: 20.arP, left: 16.arP, bottom: 12.arP),
                      child: Text(
                        DateFormat.MMMM()
                            // displaying formatted date
                            .format(DateTime.parse(controller
                                .searchTransactionList[index]
                                .token!
                                .timestamp!)),
                        style: labelLarge,
                      ),
                    ),
          HistoryTile(
            tokenInfo: controller.searchTransactionList[index],
            xtzPrice: controller.accController.xtzPrice.value,
            onTap: () => CommonFunctions.bottomSheet(
              TransactionDetailsBottomSheet(
                xtzPrice: controller.accController.xtzPrice.value,
                tokenInfo: controller.searchTransactionList[index],
                userAccountAddress: controller
                    .accController.selectedAccount.value.publicKeyHash!,
                transactionModel:
                    controller.searchTransactionList[index].token!,
              ),
            ),
          ),
        ],
      );
}
