import 'dart:convert';
import 'dart:developer';

import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/account_selector.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/pair_request/views/pair_request_view.dart';
import 'package:naan_wallet/app/modules/common_widgets/success_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_switch_widget/account_switch_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/scanQR/permission_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/vca/vca_redeem_nft/widget/scanner.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/vca/vca_redeem_nft/widget/vca_redeem_nft_sheet.dart';
import 'package:naan_wallet/app/modules/send_page/views/send_page.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class VCARedeemNFTController extends GetxController
    with WidgetsBindingObserver {
  // RxBool flash = false.obs;
  late Rx<QRViewController> controller;
  // Future<void> toggleFlash() async {
  //   flash.value = !flash.value;
  //   controller.value.toggleFlash();
  // }
  final TextEditingController emailController = TextEditingController();

  RxBool isButtonEnabled = false.obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    emailController.text = "";
    isButtonEnabled = false.obs;
    isLoading = false.obs;
    super.onInit();
  }

  @override
  void dispose() {
    controller.value.dispose();
    super.dispose();
  }

  /// QR CODE
  Barcode? result;

  void onQRViewCreated(QRViewController c, BuildContext context) {
    controller = c.obs;
    // controller.value.resumeCamera();
    controller.value.scannedDataStream.listen((scanData) async {
      if (scanData.code == "https://qr.page/g/2QDaMqohAi5") {
        controller.value.pauseCamera();
        CommonFunctions.bottomSheet(AccountSwitch(
            onNext: () async {
              controller.value.pauseCamera();
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VCARedeemSheet()));
              controller.value.resumeCamera();
            },
            title: "Claim POAP NFT",
            subtitle: "Choose an account to claim your POAP NFT"));
        controller.value.resumeCamera();
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
          callback: openScanner,
        ),
      );
    }
  }

  Future<void> openScanner() async {
    final homeController = Get.find<HomePageController>();
    if (homeController
        .userAccounts[homeController.selectedIndex.value].isWatchOnly) {
      return CommonFunctions.bottomSheet(AccountSelectorSheet(
        onNext: () {
          Get.back();
          openScanner();
        },
      ), fullscreen: true);
    }
    await Permission.camera.request();
    final status = await Permission.camera.status;

    if (status.isPermanentlyDenied) {
      CommonFunctions.bottomSheet(
        CameraPermissionHandler(
          callback: openScanner,
        ),
      );

      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {
      CommonFunctions.bottomSheet(const VCARedeemNFTScanQrView(),
          fullscreen: true);
    }
  }

  /// Email verification
  void onChange(String value) {
    isButtonEnabled.value = value.isEmail;
  }

  Future<void> onSubmit() async {
    isLoading.value = true;
    final result = await validateEmail();
    isLoading.value = false;
    if (result) {
      Get.back();
      NaanAnalytics.logEvent(
        NaanAnalyticsEvents.VCA_CLAIM_NFT_SUCCESS,
      );
      CommonFunctions.bottomSheet(const NaanSuccessSheet(
        title: "Claim complete",
        subtitle:
            "Claim will be completed within 1-2 minutes.\nThe NFT can be viewed in the account\nwidget located on the home screen.",
      ));
    }
  }

  Future<bool> validateEmail() async {
    /// API call
    return true;
  }
}