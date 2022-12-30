import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:simple_gql/simple_gql.dart';

import '../../home_page/controllers/home_page_controller.dart';
import '../../home_page/widgets/account_switch_widget/account_switch_widget.dart';
import '../../home_page/widgets/objkt_nft_widget/widgets/choose_payment_method.dart';

class DappBrowserController extends GetxController {
  InAppWebViewController? webViewController;
  WebStorageManager webStorageManager = WebStorageManager.instance();
  RxBool showButton = false.obs;
  String initUrl = Get.arguments;
  RxString url = ''.obs;
  RxString fa = ''.obs;
  RxString tokenId = ''.obs;
  var canGoBack = false.obs;
  var canGoForward = false.obs;
  var progress = 0.0.obs;
  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;
  void setCanGoBackForward() async {
    canGoBack.value = await webViewController?.canGoBack() ?? false;
    canGoForward.value = await webViewController?.canGoForward() ?? false;
  }

  void naanBuy(String url) {
    Get.put(AccountSummaryController());
    Get.bottomSheet(
      AccountSwitch(
        title: "Buy NFT",
        subtitle:
            'This module will be powered by wert.io and you will be using wert’s interface.',
        onNext: () {
          Get.bottomSheet(
            ChoosePaymentMethod(),
            settings: RouteSettings(
              arguments: url,
            ),
          );
        },
      ),
      isScrollControlled: true,
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
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
          'https://data.objkt.com/v2/graphql',
        ).query(
          query: r'''
                              query NftDetails($address: String!, $tokenId: String!) {
                                token(where: {token_id: {_eq: $tokenId}, fa_contract: {_eq: $address}}) {
                                  asks(limit: 1, order_by: {price: asc}, where: {status: {_eq: "active"}}) {
                                    id
                                    price
                                  }
                                }
                              }
                          ''',
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      } else {
        response = await GQLClient(
          'https://data.objkt.com/v2/graphql',
        ).query(
          query: r'''
                              query NftDetails($address: String!, $tokenId: String!) {
                                token(where: {token_id: {_eq: $tokenId}, fa: {path: {_eq: $address}}}) {
                                  asks(limit: 1, order_by: {price: asc}, where: {status: {_eq: "active"}}) {
                                    id
                                    price
                                  }
                                }
                              }
                          ''',
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      }
      if (response.data["token"][0]["asks"].length == 1) {
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
