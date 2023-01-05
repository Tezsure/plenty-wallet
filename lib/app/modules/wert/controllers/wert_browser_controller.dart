import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:simple_gql/simple_gql.dart';

import '../../home_page/controllers/home_page_controller.dart';
import '../../home_page/widgets/account_switch_widget/account_switch_widget.dart';
import '../../home_page/widgets/objkt_nft_widget/widgets/choose_payment_method.dart';

class WertBrowserController extends GetxController {
  InAppWebViewController? webViewController;
  WebStorageManager webStorageManager = WebStorageManager.instance();

  RxInt offset = 0.obs;
  String initUrl = Get.arguments;
  RxString url = ''.obs;

  var canGoBack = false.obs;
  var canGoForward = false.obs;
  var progress = 0.0.obs;
  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;
  void setCanGoBackForward() async {
    canGoBack.value = await webViewController?.canGoBack() ?? false;
    canGoForward.value = await webViewController?.canGoForward() ?? false;
  }

  void onUrlUpdate(url) async {
    this.url.value = url.toString();
  }
}
