import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';

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
