import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        height: 0.95.height,
        width: 1.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        child: Column(
          children: [
            0.005.vspace,
            Container(
              height: 5,
              width: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
              ),
            ),
            0.017.vspace,
            Text(
              'Receive',
              style: titleLarge,
            ),
            0.01.vspace,
            Text(
              'You can receive tez or any other Tezos\nbased assets on this address by\nsharing this QR code.',
              textAlign: TextAlign.center,
              style: bodySmall.apply(color: ColorConst.NeutralVariant.shade60),
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
                    style: titleLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                  0.01.vspace,
                  Text(
                    tz1Shortner(
                      controller.userAccount!.publicKeyHash!,
                    ),
                    style: bodySmall.apply(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                ],
              ),
            ),
            0.047.vspace,
            shareButton(),
            0.06.vspace,
          ],
        ),
      ),
    );
  }

  Container qrCode() {
    return Container(
      height: 0.3.height,
      width: 0.3.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      alignment: Alignment.center,
      child: QrImage(
        data: controller.userAccount!.publicKeyHash!,
        padding: const EdgeInsets.all(20),
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
        height: 0.06.height,
        width: 0.35.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.share_sharp,
              size: 20,
              color: Colors.white,
            ),
            0.04.hspace,
            Text(
              'Share',
              style: titleSmall.copyWith(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
