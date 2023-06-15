import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/scanQR/permission_sheet.dart';
import 'package:naan_wallet/app/modules/custom_gallery/widgets/custom_nft_detail_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/vca/vca_redeem_nft/controller/vca_redeem_nft_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/send_page.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../send_page/controllers/send_page_controller.dart';
import '../widgets/account_switch_widget/account_switch_widget.dart';
import '../widgets/vca/vca_redeem_nft/widget/vca_redeem_nft_sheet.dart';
import 'package:crypto/crypto.dart';

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

  String sha256Convert(String data) {
    final utf8Data = utf8.encode(data);
    final hashBytes = sha256.convert(utf8Data).bytes;
    final hashHex = hashBytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join('');
    return hashHex;
  }

  String generateQrHash(String campaignId) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final currentSeconds = currentTime / 1000;
    final currentMinutes = currentSeconds / 60;
    final seed = (currentMinutes / 1).floor();
    final qrData = '$seed:$campaignId';
    final qrHash = sha256Convert(qrData);
    return qrHash;
  }

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
          fullscreen: true,
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
      if (scanData.code != null) {
        try {
          if (scanData.code?.startsWith('https://objkt.com/asset/') ?? false) {
            result = scanData;
            Get.back();
            log("=================================");
            controller.value.pauseCamera();
            CommonFunctions.bottomSheet(
                CustomNFTDetailBottomSheet(
                  nftUrl: scanData.code,
                ),
                fullscreen: true);
          }
        } catch (e) {}
      }
      if (scanData.code!.contains("campaignId")) {
        if (result != null) return;
        controller.value.pauseCamera();
        result = scanData;
        String campaignId = jsonDecode(scanData.code!)["campaignId"];
        print("campaignId: $campaignId");
        final campaign = jsonDecode(await HttpService.performGetRequest(
            "${ServiceConfig.claimNftAPI}campaign?campaignId=$campaignId"));
        print(campaign);
        if (!campaign["isActive"]) {
          controller.value.resumeCamera();
          result = null;
          return;
        }
        if (campaign["isDynamicQr"]) {
          String qrHash = generateQrHash(campaignId);
          if (qrHash != jsonDecode(scanData.code!)["hash"]) {
            controller.value.resumeCamera();
            result = null;
            return;
          }
        }
        Get.back();
        await CommonFunctions.bottomSheet(AccountSwitch(
                onNext: ({String senderAddress = ""}) async {},
                title: "Claim NFT",
                subtitle: "Choose an account to claim your NFT"))
            .then((value) async {
          if (value == true) {
            controller.value.pauseCamera();
            result = scanData;
            VCARedeemNFTController redeemController =
                Get.put(VCARedeemNFTController());
            if (campaign["emailRequired"]) {
              await Navigator.push(
                  Get.context!,
                  MaterialPageRoute(
                      builder: (context) => VCARedeemSheet(
                            campaignId: campaignId,
                          )));
            } else {
              await redeemController.onSubmit(campaignId, email: false);
            }

            controller.value.resumeCamera();
            result = null;
          } else {
            controller.value.resumeCamera();
            result = null;
          }
        });

        // CommonFunctions.bottomSheet(VCARedeemSheet(), fullscreen: true);
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
        CameraPermissionHandler(
          callback: Get.find<HomePageController>().openScanner,
        ),
      );
    }
  }
}
