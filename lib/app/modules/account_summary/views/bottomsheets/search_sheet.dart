import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/transaction_details.dart';
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
  List<TokenInfo?> searchResult = [];

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
                    searchController.text.isEmpty || searchResult.isEmpty
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
                                      return searchResult[index]!.skip ||
                                              searchResult[index]!.isHashSame ==
                                                  true
                                          ? const SizedBox()
                                          : tokenLoader(index);
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

  Widget tokenLoader(int index) => Column(
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
                        .format(DateTime.parse(
                            searchResult[index]!.token!.timestamp!)),
                    style: labelLarge,
                  ),
                )
              : DateTime.parse(searchResult[index]!.token!.timestamp!)
                      .isSameMonth(DateTime.parse(
                          searchResult[index == 0 ? 0 : index - 1]!
                              .token!
                              .timestamp!))
                  ? const SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: 20.sp, left: 16.sp, bottom: 12.sp),
                      child: Text(
                        DateFormat.MMMM()
                            // displaying formatted date
                            .format(DateTime.parse(
                                searchResult[index]!.token!.timestamp!)),
                        style: labelLarge,
                      ),
                    ),
          HistoryTile(
            tokenInfo: searchResult[index]!,
            xtzPrice: controller.accController.xtzPrice.value,
            onTap: () => Get.bottomSheet(TransactionDetailsBottomSheet(
              tokenInfo: searchResult[index]!,
              userAccountAddress:
                  controller.accController.userAccount.value.publicKeyHash!,
              transactionModel: searchResult[index]!.token!,
            )),
          ),
        ],
      );
}
