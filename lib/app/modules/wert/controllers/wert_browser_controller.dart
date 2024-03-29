import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'package:plenty_wallet/app/data/services/beacon_service/beacon_service.dart';

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

  @override
  void onClose() async {
    if (Platform.isAndroid) {
      // if current platform is Android, delete all data.
      await webStorageManager.android.deleteAllData();
    } else if (Platform.isIOS) {
      // if current platform is iOS, delete all data
      var records = await webStorageManager.ios
          .fetchDataRecords(dataTypes: IOSWKWebsiteDataType.values);
      var recordsToDelete = <IOSWKWebsiteDataRecord>[];
      for (var record in records) {
        recordsToDelete.add(record);
      }
      await webStorageManager.ios.removeDataFor(
          dataTypes: IOSWKWebsiteDataType.values, dataRecords: recordsToDelete);
    }
  }

  void onUrlUpdate(url) async {
    this.url.value = url.toString();
  }
}
