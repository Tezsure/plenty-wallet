import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/scan_qr_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/connected_dapps_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQrView extends StatefulWidget {
  const ScanQrView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQrViewState();
}

class _ScanQrViewState extends State<ScanQrView> {
  // Barcode? result;
  // QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final controller = Get.put(ScanQRController());
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.controller.value.pauseCamera();
    }
    controller.controller.value.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: backButton(),
        backgroundColor: Colors.transparent,
      ),
      // height: 01.height,
      body: Column(
        children: <Widget>[
          Expanded(child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 230.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: controller.onQRViewCreated,
          overlay: QrScannerOverlayShape(
              overlayColor: ColorConst.darkGrey.withOpacity(0.8),
              borderColor: ColorConst.Primary,
              borderRadius: 24,
              borderLength: 40,
              borderWidth: 7,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) =>
              controller.onPermissionSet(context, ctrl, p),
        ),
        SafeArea(
          child: Obx(() {
            return GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  ConnectedDappBottomSheet(),
                  enterBottomSheetDuration: const Duration(milliseconds: 180),
                  exitBottomSheetDuration: const Duration(milliseconds: 150),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 40.arP),
                padding:
                    EdgeInsets.symmetric(vertical: 12.arP, horizontal: 20.arP),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade800, width: 2),
                    color: ColorConst.darkGrey,
                    borderRadius: BorderRadius.circular(50.arP)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorConst.Primary,
                      radius: 10,
                      child: Text(
                        Get.find<SettingsPageController>()
                            .dapps
                            .length
                            .toString(),
                        style: labelSmall,
                      ),
                    ),
                    SizedBox(
                      width: 8.arP,
                    ),
                    Text(
                      "Connected apps",
                      style: labelSmall,
                    ),
                    SizedBox(
                      width: 8.arP,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 15.arP,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
