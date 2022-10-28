import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class DappBrowserController extends GetxController {
  InAppWebViewController? webViewController;
  RxString url = ''.obs;
  var canGoBack = false.obs;
  var canGoForward = false.obs;
  var progress = 0.0.obs;
  void setCanGoBackForward() async {
    canGoBack.value = await webViewController?.canGoBack() ?? false;
    canGoForward.value = await webViewController?.canGoForward() ?? false;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
