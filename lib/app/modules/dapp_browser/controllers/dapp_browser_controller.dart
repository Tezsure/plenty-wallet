import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:plenty_wallet/utils/common_functions.dart';

import 'package:simple_gql/simple_gql.dart';

import '../../home_page/widgets/account_switch_widget/account_switch_widget.dart';
import '../../home_page/widgets/objkt_nft_widget/widgets/choose_payment_method.dart';

class DappBrowserController extends GetxController {
  InAppWebViewController? webViewController;
  WebStorageManager webStorageManager = WebStorageManager.instance();
  RxBool showButton = false.obs;
  RxBool isScrolling = false.obs;
  RxInt offset = 0.obs;
  String initUrl = Get.arguments;
  RxString url = ''.obs;
  RxString fa = ''.obs;
  RxString tokenId = ''.obs;
  RxInt scrollY = 0.obs;
  Timer? t;
  var canGoBack = false.obs;
  var canGoForward = false.obs;
  var progress = 0.0.obs;
  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;

  setCanGoBackForward() async {
    canGoBack.value = await webViewController?.canGoBack() ?? false;
    canGoForward.value = await webViewController?.canGoForward() ?? false;
  }

  @override
  void onInit() {
    super.onInit();
    t = Timer.periodic(const Duration(milliseconds: 250), (c) {
      if (isScrolling.value == true) {
        isScrolling.value = false;
      }
    });
  }

  void naanBuy(String url) {
    //Get.put(AccountSummaryController());
    CommonFunctions.bottomSheet(
      AccountSwitch(
        title: "Buy NFT",
        subtitle:
            'This module will be powered by wert.io and you will be using wert’s interface.',
        onNext: ({String senderAddress = ""}) {
/*           final controller = Get.put(AccountSummaryController());

          List<String> displayCoins = [
            "tezos",
            'USDt',
            'uUSD',
            'kUSD',
            'EURL',
            "ctez",
          ];
          final accountTokens = <AccountTokenModel>[];
          for (int index = 0; index < displayCoins.length; index++) {
            final token = controller.tokensList.firstWhereOrNull((p0) =>
                displayCoins[index].toLowerCase() == p0.symbol!.toLowerCase());

            var accountToken = controller.userTokens.firstWhereOrNull((p0) =>
                displayCoins[index].toLowerCase() == p0.symbol!.toLowerCase());

            if (token != null && accountToken == null) {
              accountToken = AccountTokenModel(
                  name: token.name!,
                  symbol: token.symbol!,
                  iconUrl: token.thumbnailUri,
                  balance: 0,
                  currentPrice: token.currentPrice,
                  contractAddress: token.tokenAddress!,
                  tokenId: token.tokenId!,
                  decimals: token.decimals!);
            }

            if (displayCoins[index].toLowerCase() == "tezos") {
              accountToken = controller.userTokens.firstWhereOrNull(
                      (element) => element.symbol!.toLowerCase() == "tezos") ??
                  AccountTokenModel(
                      name: "Tezos",
                      symbol: "Tezos",
                      iconUrl: "assets/tezos_logo.png",
                      balance: 0,
                      currentPrice: controller.xtzPrice.value,
                      contractAddress: "xtz",
                      tokenId: "0",
                      decimals: 6);
            }

            if (accountToken != null) {
              accountTokens.add(accountToken);
            }
          } */

          CommonFunctions.bottomSheet(
            ChoosePaymentMethod(
              senderAddress: senderAddress,
            ),
            settings: RouteSettings(
              arguments: url,
            ),
          );
        },
      ),
    );
  }

  void onUrlUpdate(url) async {
    this.url.value = url.toString();
    if (url.toString().startsWith("https://objkt.com/asset/")) {
      var mainUrl = url
          .toString()
          .replaceFirst("https://objkt.com/asset/", '')
          .split("/");
      var response;
      if (mainUrl[0].startsWith('KT1')) {
        response = await GQLClient(
          'https://data.objkt.com/v3/graphql',
        ).query(
          query: r'''
                              query NftDetails($address: String!, $tokenId: String!) {
                                token(where: {token_id: {_eq: $tokenId}, fa_contract: {_eq: $address}}) {
                                  listings(limit: 1, order_by: {price: asc}, where: {status: {_eq: "active"}}) {
                                    bigmap_key
                                    price
                                    marketplace_contract
                                  }
                                }
                              }
                          ''',
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      } else {
        response = await GQLClient(
          'https://data.objkt.com/v3/graphql',
        ).query(
          query: r'''
                              query NftDetails($address: String!, $tokenId: String!) {
                                token(where: {token_id: {_eq: $tokenId}, fa: {path: {_eq: $address}}}) {
                                  listings(limit: 1, order_by: {price: asc}, where: {status: {_eq: "active"}}) {
                                    bigmap_key
                                    price
                                    marketplace_contract
                                  }
                                }
                              }
                          ''',
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      }
      if (response.data["token"][0]["listings"].length == 1 &&
          response.data["token"][0]["listings"][0]["marketplace_contract"] ==
              "KT1WvzYHCNBvDSdwafTHv7nJ1dWmZ8GCYuuC") {
        fa.value = mainUrl[0];
        tokenId.value = mainUrl[1];
        showButton.value = true;
      } else {
        showButton.value = false;
      }
    } else {
      showButton.value = false;
    }
  }
}
