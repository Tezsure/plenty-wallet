import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/modules/account_summary/models/token_info.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/transaction_details.dart';
import 'package:naan_wallet/app/modules/account_summary/views/pages/crypto_tab.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  TransactionController controller = Get.find<TransactionController>();
  // ScrollController paginationController = ScrollController();
  String searchQuery = '';

  @override
  void initState() {
    // paginationController.removeListener(() {});
    // paginationController.addListener(() async {
    //   if (paginationController.position.pixels ==
    //       paginationController.position.maxScrollExtent) {
    //     await controller.loadSearchResults(searchQuery);
    //     setState(() {});
    //   }
    // });
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
    controller.searchController.clear();
    focusNode.dispose();
    super.dispose();
  }

  RefreshController refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      leading: Padding(
        padding: EdgeInsets.only(left: 16.arP),
        child: backButton(
            ontap: () {
              controller.searchController.clear();
              Navigator.pop(context);
            },
            lastPageName: "Accounts"),
      ),
      // title: "",
      height: AppConstant.naanBottomSheetHeight -
          MediaQuery.of(context).viewInsets.bottom,
      // isScrollControlled: true,
      // height: AppConstant.naanBottomSheetHeight -
      //     MediaQuery.of(context).viewInsets.bottom,
      bottomSheetHorizontalPadding: 0,
      prevPageName: "Accounts",
      bottomSheetWidgets: [
        SizedBox(
          height: AppConstant.naanBottomSheetHeight -
              MediaQuery.of(context).viewInsets.bottom -
              16.arP,
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
                        setState(() {
                          controller.searchController.clear();
                          focusNode.unfocus();
                          controller.searchTransactionList.clear();
                        });
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
                          controller: controller.searchController,
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
                        controller.searchController.clear();
                        focusNode.unfocus();
                        controller.searchTransactionList.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.arP, left: 8.arP),
                      child: Text(
                        "Cancel".tr,
                        style: labelMedium.copyWith(color: ColorConst.Primary),
                      ),
                    ),
                  ),
                ],
              ),
              0.03.vspace,
              Obx(() {
                return Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    enableTwoLevel: true,
                    controller: refreshController,
                    onLoading: () async {
                      await controller
                          .loadSearchResults(controller.searchController.text);

                      refreshController.loadComplete();
                    },
                    onRefresh: () async {
                      await controller.searchTransactionHistory(
                          controller.searchController.text);
                      refreshController.refreshCompleted();
                      refreshController.resetNoData();
                    },
                    child: controller.searchTransactionList.isEmpty
                        ? _emptyState()
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 16.arP),
                            itemBuilder: _itemBuilder,
                            itemCount:
                                controller.searchTransactionList.length + 1,
                          ),
                  ),
                );
              }),
            ],
          ),
        )
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index == controller.searchTransactionList.length) {
      return Obx(() {
        return controller.isTransactionLoading.value
            ? const TokensSkeleton(
                isScrollable: false,
              )
            : const SizedBox();
      });
    } else {
      return controller.searchTransactionList[index].isNft
          ? _loadNFTTransaction(
              controller.searchTransactionList[index],
              index,
        )
          : _loadTokenTransaction(
              controller.searchTransactionList[index],
              index,
            );
    }
  }

  Center _emptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 44.arP),
        child: Text("Try searching for token,\n protocols, and tags".tr,
            textAlign: TextAlign.center,
            style: labelLarge.copyWith(
                letterSpacing: 0.25,
                fontWeight: FontWeight.w400,
                color: ColorConst.NeutralVariant.shade70)),
      ),
    );
  }

  Widget _loadTokenTransaction(TokenInfo token, int index,) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // index == 0
          //     ? Padding(
          //         padding:
          //             EdgeInsets.only(top: 8.arP, left: 16.arP, bottom: 16.arP),
          //         child: Text(
          //           token.timeStamp!.relativeDate(),
          //           style: labelLarge,
          //         ),
          //       )
          //     : displayDate
          //         ? Padding(
          //             padding: EdgeInsets.only(
          //                 top: 20.arP, left: 16.arP, bottom: 12.arP),
          //             child: Text(
          //               token.timeStamp!.relativeDate(),
          //               style: labelLarge,
          //             ),
          //           )
          //         : const SizedBox(),
          HistoryTile(
            tokenInfo: token,
            xtzPrice: controller.accController.xtzPrice.value,
            onTap: () => CommonFunctions.bottomSheet(
                TransactionDetailsBottomSheet(
                  xtzPrice: controller.accController.xtzPrice.value,
                  tokenInfo: token,
                  userAccountAddress: controller
                      .accController.selectedAccount.value.publicKeyHash!,
                ),
                fullscreen: true),
          ),
        ],
      );

  Widget _loadNFTTransaction(TokenInfo token, int index, ) {
    final tokenList = controller.tokensList;
    if (token.token != null) {
      final transactionInterface = token.token!.transactionInterface(tokenList);
      token = token.copyWith(
          nftTokenId: transactionInterface.tokenID,
          address: transactionInterface.contractAddress);
    }
    return FutureBuilder(
        future: ObjktNftApiService()
            .getTransactionNFT(token.nftContractAddress!, token.nftTokenId!),
        builder: ((context, AsyncSnapshot<NftTokenModel> snapshot) {
          if (!snapshot.hasData) {
            return const TokensSkeleton(
              itemCount: 1,
              isScrollable: false,
            );
          } else if (snapshot.data!.name == null) {
            return Container();
          } else {
            token = token.copyWith(
                isNft: true,
                tokenSymbol: snapshot.data!.fa!.name.toString(),
                dollarAmount: (snapshot.data!.lowestAsk == null
                        ? 0
                        : (snapshot.data!.lowestAsk / 1e6)) *
                    controller.accController.xtzPrice.value,
                tokenAmount: snapshot.data!.lowestAsk != null &&
                        snapshot.data!.lowestAsk != 0
                    ? snapshot.data!.lowestAsk / 1e6
                    : 0,
                name: snapshot.data!.name.toString(),
                imageUrl: snapshot.data!.displayUri);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // index == 0
                //     ? Padding(
                //         padding: EdgeInsets.only(
                //             top: 8.arP, left: 16.arP, bottom: 16.arP),
                //         child: Text(
                //           token.timeStamp!.relativeDate(),
                //           style: labelLarge,
                //         ),
                //       )
                //     : displayDate
                //         ? Padding(
                //             padding: EdgeInsets.only(
                //                 top: 20.arP, left: 16.arP, bottom: 12.arP),
                //             child: Text(
                //               token.timeStamp!.relativeDate(),
                //               style: labelLarge,
                //             ),
                //           )
                //         : const SizedBox(),
                HistoryTile(
                  tokenInfo: token,
                  xtzPrice: controller.accController.xtzPrice.value,
                  onTap: () => CommonFunctions.bottomSheet(
                      TransactionDetailsBottomSheet(
                        xtzPrice: controller.accController.xtzPrice.value,
                        tokenInfo: token,
                        userAccountAddress: controller
                            .accController.selectedAccount.value.publicKeyHash!,
                      ),
                      fullscreen: true),
                ),
              ],
            );
          }
        }));
  }
}
