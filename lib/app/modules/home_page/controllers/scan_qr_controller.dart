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

  Barcode? result;

  void onQRViewCreated(QRViewController c) {
    controller = c.obs;

    controller.value.scannedDataStream.listen((scanData) {
      if ((scanData.code?.startsWith('tezos://') ?? false) ||
          (scanData.code?.startsWith('naan://') ?? false)) {
        if (result != null) return;
        result = scanData;
        String code = scanData.code ?? "";
        code = code.substring(code.indexOf("data=") + 5, code.length);
        final request = Get.find<BeaconService>()
            .beaconPlugin
            .pairingRequestToP2P(pairingRequest: code);
        BeaconRequest beaconRequest = BeaconRequest(
            peer: P2PPeer.fromJson(request),
            type: RequestType.permission,
            request: Request.fromJson(request));
        controller.value.pauseCamera();
        Get.bottomSheet(const PairRequestView(),
                enterBottomSheetDuration: const Duration(milliseconds: 180),
                exitBottomSheetDuration: const Duration(milliseconds: 150),
                barrierColor: Colors.white.withOpacity(0.09),
                isScrollControlled: true,
                settings: RouteSettings(arguments: beaconRequest))
            .whenComplete(() {
          result = null;
          controller.value.resumeCamera();
        });
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
