import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/scan_qr_controller.dart';
import 'package:plenty_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:plenty_wallet/app/modules/settings_page/widget/connected_dapps_sheet.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
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
    try {
      controller.controller.value.resumeCamera();
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverrideTextScaleFactor(
      child: SizedBox(
        height: AppConstant.naanBottomSheetHeight,
        child: Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          // appBar: AppBar(
          //   elevation: 0,
          //   leading: SizedBox.shrink(),
          //   backgroundColor: Colors.transparent,
          // ),
          // height: 01.height,
          body: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(36.arP)),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Stack(
                  children: [
                    _buildQrView(context),
                    SafeArea(
                      child: Column(
                        children: [
                          0.02.vspace,
                          Container(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 5.arP,
                                width: 36.arP,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.arP),
                                  color: ColorConst.NeutralVariant.shade60,
                                ),
                              ),
                            ),
                          ),
                          0.01.vspace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              closeButton(),
                              SizedBox(
                                width: 16.arP,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0.arP
        : 230.0.arP;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: controller.onQRViewCreated,
            overlay: QrScannerOverlayShape(
                overlayColor: ColorConst.darkGrey.withOpacity(0.8),
                borderColor: ColorConst.Primary,
                borderRadius: 26.arP,
                borderLength: 40.arP,
                borderWidth: 7.arP,
                cutOutSize: scanArea),
            onPermissionSet: (ctrl, p) =>
                controller.onPermissionSet(context, ctrl, p),
          ),
          SafeArea(
            child: GestureDetector(
              onTap: () {
                CommonFunctions.bottomSheet(
                  ConnectedDappBottomSheet(),
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
                      radius: 10.arP,
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
                      "Connected apps".tr,
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
            ),
          )
        ],
      ),
    );
  }
}
