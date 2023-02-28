import 'dart:convert';

import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/pair_request/views/pair_request_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/scanQR/permission_sheet.dart';
import 'package:naan_wallet/app/modules/send_page/views/send_page.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../send_page/controllers/send_page_controller.dart';

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
    // controller.value.resumeCamera();
    controller.value.scannedDataStream.listen((scanData) async {
      if ((scanData.code?.startsWith('tz1') ?? false) ||
          (scanData.code?.startsWith('tz2') ?? false)) {
        if (result != null) return;
        result = scanData;
        Get.back();
        final home = Get.find<HomePageController>();
        CommonFunctions.bottomSheet(
          const SendPage(),
          settings: RouteSettings(
            arguments: home.userAccounts[home.selectedIndex.value],
          ),
        );
        Future.delayed(const Duration(milliseconds: 300), () async {
          Get.find<SendPageController>().scanner(scanData.code!);
        });
      }
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
    try {
      controller.value.resumeCamera();
    } catch (e) {}
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      Get.back();
      CommonFunctions.bottomSheet(
        const CameraPermissionHandler(),
      );
    }
  }
}
