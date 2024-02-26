import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/vca/vca_redeem_nft/controller/vca_redeem_nft_controller.dart';

import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class VCARedeemNFTScanQrView extends StatefulWidget {
  const VCARedeemNFTScanQrView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VCARedeemNFTScanQrViewState();
}

class _VCARedeemNFTScanQrViewState extends State<VCARedeemNFTScanQrView> {
  // Barcode? result;
  // QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final controller = Get.put(VCARedeemNFTController());
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.controller.stop();
    }
    try {
      controller.controller.start();
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<VCARedeemNFTController>();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverrideTextScaleFactor(
      child: SizedBox(
        height: AppConstant.naanBottomSheetHeight,
        child: Navigator(onGenerateRoute: (context) {
          return MaterialPageRoute(builder: (context) {
            return Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              // appBar: AppBar(
              //   elevation: 0,
              //   leading: SizedBox.shrink(),
              //   backgroundColor: Colors.transparent,
              // ),
              // height: 01.height,
              body: ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(36.arP)),
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
                                      borderRadius:
                                          BorderRadius.circular(5.arP),
                                      color: ColorConst.NeutralVariant.shade60,
                                    ),
                                  ),
                                ),
                              ),
                              0.01.vspace,
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.arP),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 30.arP,
                                          width: 30.arP,
                                        ),
                                        Text(
                                          "Scan QR",
                                          style: titleSmall,
                                        ),
                                        closeButton(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16.arP,
                                    ),
                                    Text(
                                      "Scan the QR at the venue to\nclaim your Souvenir NFT",
                                      textAlign: TextAlign.center,
                                      style: bodySmall,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            );
          });
        }),
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
    return MobileScanner(
      key: qrKey,
      onDetect: (ctlr) => controller.onQRViewCreated(ctlr, context),
      controller: controller.controller,
/*       scanWindow: Rect.fromCenter(
        center: MediaQuery.of(context).size.center(Offset.zero),
        width: (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 250.0.arP
            : 230.0.arP,
        height: (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 250.0.arP
            : 230.0.arP,
      ), */

/*       overlay: QrScannerOverlayShape(
          // overlayColor: ColorConst.darkGrey.withOpacity(0.9),
          borderColor: ColorConst.Primary,
          borderRadius: 26.arP,
          borderLength: 40.arP,
          borderWidth: 7.arP,
          cutOutSize: scanArea), */
/*       onPermissionSet: (ctrl, p) =>
          controller.onPermissionSet(context, ctrl, p), */
    );
  }
}
