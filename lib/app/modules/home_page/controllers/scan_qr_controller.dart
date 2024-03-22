import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:plenty_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/custom_gallery/widgets/custom_nft_detail_sheet.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/vca/vca_redeem_nft/controller/vca_redeem_nft_controller.dart';
import 'package:plenty_wallet/app/modules/send_page/views/send_page.dart';
import 'package:plenty_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:plenty_wallet/utils/common_functions.dart';

import '../../send_page/controllers/send_page_controller.dart';
import '../widgets/account_switch_widget/account_switch_widget.dart';
import '../widgets/vca/vca_redeem_nft/widget/vca_redeem_nft_sheet.dart';
import 'package:crypto/crypto.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

class ScanQRController extends GetxController with WidgetsBindingObserver {
  // RxBool flash = false.obs;
  late MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  Rx<Barcode?> barcode = Rx<Barcode?>(null);

  Rx<BarcodeCapture?> barcodeCapture = Rx<BarcodeCapture?>(null);

  Rx<MobileScannerArguments?> arguments = Rx<MobileScannerArguments?>(null);
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
    controller.dispose();
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

  void onQRViewCreated(BarcodeCapture c) async {
    // controller.value.resumeCamera();
    barcodeCapture.value = c;
    barcode.value = c.barcodes.first;
    final List<Barcode> barcodes = c.barcodes;
    final Uint8List? image = c.image;
    for (final barcode in barcodes) {
      if ((barcode.rawValue?.startsWith('tz1') ?? false) ||
          (barcode.rawValue?.startsWith('tz2') ?? false)) {
        if (result != null) return;
        result = barcode;
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
          Get.find<SendPageController>().scanner(barcode.rawValue!);
        });
      }
      if ((barcode.rawValue?.startsWith('tezos://') ?? false) ||
          (barcode.rawValue?.startsWith('naan://') ?? false)) {
        if (result != null) return;

        result = barcode;
        String code = barcode.rawValue ?? "";
        code = code.substring(code.indexOf("data=") + 5, code.length);

        try {
          bs58check.decode(code);
        } catch (e) {
          return;
        }

        var s = Get.find<BeaconService>();

        await s.beaconPlugin.pair(pairingRequest: code);
        Get.back();
      }
      if (barcode.rawValue != null) {
        try {
          if (barcode.rawValue?.startsWith('https://objkt.com/asset/') ??
              false) {
            result = barcode;
            Get.back();
            log("=================================");
            controller.stop();
            CommonFunctions.bottomSheet(
                CustomNFTDetailBottomSheet(
                  nftUrl: barcode.rawValue,
                ),
                fullscreen: true);
          }
        } catch (e) {}
      }
      if (barcode.rawValue!.contains("campaignId")) {
        if (result != null) return;
        controller.stop();
        result = barcode;
        String campaignId = jsonDecode(barcode.rawValue!)["campaignId"];
        debugPrint("campaignId: $campaignId");
        final campaign = jsonDecode(await HttpService.performGetRequest(
            "${ServiceConfig.claimNftAPI}campaign?campaignId=$campaignId"));
        debugPrint(campaign);
        if (!campaign["isActive"]) {
          controller.start();
          result = null;
          return;
        }
        if (campaign["isDynamicQr"]) {
          String qrHash = generateQrHash(campaignId);
          if (qrHash != jsonDecode(barcode.rawValue!)["hash"]) {
            controller.start();
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
            controller.stop();
            result = barcode;
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

            controller.start();
            result = null;
          } else {
            controller.start();
            result = null;
          }
        });

        // CommonFunctions.bottomSheet(VCARedeemSheet(), fullscreen: true);
      }
      ;
      try {
        controller.start();
      } catch (e) {}
    }
  }

/*   void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      Get.back();
      CommonFunctions.bottomSheet(
        CameraPermissionHandler(
          callback: Get.find<HomePageController>().openScanner,
        ),
      );
    }
  } */
}
