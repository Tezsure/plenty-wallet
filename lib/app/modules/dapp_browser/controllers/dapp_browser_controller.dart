import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';

class DappBrowserController extends GetxController {
  InAppWebViewController? webViewController;
  RxString url = ''.obs;
  var canGoBack = false.obs;
  var canGoForward = false.obs;
  var progress = 0.0.obs;
  final beaconPlugin = Get.find<BeaconService>().beaconPlugin;
  void setCanGoBackForward() async {
    canGoBack.value = await webViewController?.canGoBack() ?? false;
    canGoForward.value = await webViewController?.canGoForward() ?? false;
  }
}
