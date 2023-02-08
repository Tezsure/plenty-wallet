import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/receive_page_controller.dart';

class ReceivePageView extends GetView<ReceivePageController> {
  const ReceivePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final ReceivePageController controller = Get.put(ReceivePageController());
    return NaanBottomSheet(
      isScrollControlled: true,
      // height: AppConstant.naanBottomSheetHeight,
      title: "Receive",
      bottomSheetWidgets: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(),
            0.01.vspace,
            Text(
              'You can receive tez or any other Tezos\nbased assets on this address by\nsharing this QR code.',
              textAlign: TextAlign.center,
              style: bodySmall.copyWith(
                  fontSize: 12.aR, color: ColorConst.NeutralVariant.shade60),
            ),
            0.05.vspace,
            qrCode(),
            0.047.vspace,
            GestureDetector(
              onTap: () {
                controller.copyAddress(controller.userAccount!.publicKeyHash!);
              },
              child: Column(
                children: [
                  Text(
                    controller.userAccount!.name!,
                    style: titleLarge.copyWith(fontSize: 22.aR),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.arP),
                    child: Text(
                      tz1Shortner(
                        controller.userAccount!.publicKeyHash!,
                      ),
                      style: bodySmall.apply(
                          color: ColorConst.NeutralVariant.shade60),
                    ),
                  ),
                ],
              ),
            ),
            0.04.vspace,
            shareButton(),
            0.1.vspace,
            BottomButtonPadding()
          ],
        ),
      ],
    );
    // return BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //   child: Container(
    //     height: 0.9.height,
    //     width: 1.width,
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(10.aR)),
    //         color: Colors.black),
    //     child: Column(
    //       children: [
    //         0.005.vspace,
    //         Container(
    //           height: 5.aR,
    //           width: 36.aR,
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(5),
    //             color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
    //           ),
    //         ),
    //         0.036.vspace,
    //         Text(
    //           'Receive',
    //           style: titleLarge.copyWith(letterSpacing: 0.15.aR),
    //         ),
    //         0.01.vspace,
    //         Text(
    //           'You can receive tez or any other Tezos\nbased assets on this address by\nsharing this QR code.',
    //           textAlign: TextAlign.center,
    //           style: bodySmall.copyWith(
    //               fontSize: 12.aR, color: ColorConst.NeutralVariant.shade60),
    //         ),
    //         0.05.vspace,
    //         qrCode(),
    //         0.047.vspace,
    //         GestureDetector(
    //           onTap: () {
    //             controller.copyAddress(controller.userAccount!.publicKeyHash!);
    //           },
    //           child: Column(
    //             children: [
    //               Text(
    //                 controller.userAccount!.name!,
    //                 style: titleLarge.copyWith(fontSize: 22.aR),
    //               ),
    //               Padding(
    //                 padding: EdgeInsets.only(top: 8.arP),
    //                 child: Text(
    //                   tz1Shortner(
    //                     controller.userAccount!.publicKeyHash!,
    //                   ),
    //                   style: bodySmall.apply(
    //                       color: ColorConst.NeutralVariant.shade60),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         0.04.vspace,
    //         shareButton(),
    //         0.06.vspace,
    //       ],
    //     ),
    //   ),
    // );
  }

  Container qrCode() {
    return Container(
      height: 0.3.height,
      width: 0.3.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.arP), color: Colors.white),
      alignment: Alignment.center,
      child: QrImage(
        data: controller.userAccount!.publicKeyHash!,
        padding: EdgeInsets.all(20.arP),
        gapless: false,
        eyeStyle:
            const QrEyeStyle(eyeShape: QrEyeShape.circle, color: Colors.black),
        embeddedImageEmitsError: true,
        embeddedImageStyle: QrEmbeddedImageStyle(size: const Size(48, 48)),
        dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.circle, color: Colors.black),
      ),
    );
  }

  Widget shareButton() {
    return GestureDetector(
      onTap: () {
        Share.share(controller.userAccount!.publicKeyHash!);
      },
      child: Container(
        height: 50.aR,
        alignment: Alignment.center,
        width: 150.aR,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.aR),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.aR),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.share_sharp,
              size: 16.aR,
              color: Colors.white,
            ),
            0.04.hspace,
            Text(
              'Share',
              style: titleSmall.copyWith(
                  fontWeight: FontWeight.w500, fontSize: 14.aR),
            )
          ],
        ),
      ),
    );
  }
}
