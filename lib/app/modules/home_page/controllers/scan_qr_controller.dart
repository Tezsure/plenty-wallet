import 'dart:convert';

import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/pair_request/views/pair_request_view.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRController extends GetxController with WidgetsBindingObserver {
  // RxBool flash = false.obs;
  late Rx<QRViewController> controller;
  // Future<void> toggleFlash() async {
  //   flash.value = !flash.value;
  //   controller.value.toggleFlash();
  // }
  @override
  void onInit() {
    Get.lazyPut(() => SettingsPageController());

    super.onInit();
  }

  @override
  void dispose() {
    controller.value.dispose();
    super.dispose();
  }

  Barcode? result;

  void onQRViewCreated(QRViewController c) {
    controller = c.obs;
    controller.value.resumeCamera();
    controller.value.scannedDataStream.listen((scanData) async {
      if ((scanData.code?.startsWith('tezos://') ?? false) ||
          (scanData.code?.startsWith('naan://') ?? false)) {
        if (result != null) return;

        result = scanData;
        String code = scanData.code ?? "";
        code = code.substring(code.indexOf("data=") + 5, code.length);
        var s = Get.find<BeaconService>();

        await s.beaconPlugin.pair(pairingRequest: code);
        Get.back();
      }
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
