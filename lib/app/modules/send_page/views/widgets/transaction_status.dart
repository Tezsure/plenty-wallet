import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

enum TransactionStatus {
  success(
      title: "Success",
      lottiePath: "${PathConst.SEND_PAGE}lottie/success.json",
      color: Color(0xff5AE200)),
  pending(
      title: "Pending",
      lottiePath: "${PathConst.SEND_PAGE}lottie/pending.json",
      color: Color(0xff4A454E)),
  failed(
      title: "Failed",
      lottiePath: "${PathConst.SEND_PAGE}lottie/failed.json",
      color: Color(0xffFF5449)),
  error(
      title: "Failed",
      lottiePath: "${PathConst.SEND_PAGE}lottie/error.svg",
      color: Color(0xffF97316));

  final String title;
  final String lottiePath;
  final Color color;
  const TransactionStatus({
    required this.title,
    required this.lottiePath,
    required this.color,
  });
}

SnackbarController transactionStatusSnackbar({
  required TransactionStatus status,
  required String transactionAmount,
  required String tezAddress,
  bool isBrowser = false,
  Duration duration = const Duration(minutes: 1),
}) {
  return Get.rawSnackbar(
    backgroundColor: ColorConst.NeutralVariant.shade20,
    boxShadows: [
      BoxShadow(
          color: Colors.white.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 5,
          offset: const Offset(0, 4)),
    ],
    icon: Padding(
      padding: EdgeInsets.only(left: 0.04.width),
      child: status.lottiePath.endsWith(".svg")
          ? SvgPicture.asset(
              status.lottiePath,
              fit: BoxFit.contain,
              height: 40.arP,
              width: 40.arP,
            )
          : LottieBuilder.asset(
              status.lottiePath,
              frameRate: FrameRate(60),
              fit: BoxFit.cover,
              repeat: status == TransactionStatus.pending ? true : false,
              height: 40.arP,
              width: 40.arP,
            ),
    ),

    barBlur: 1,
    borderRadius: 8,
    maxWidth: 8.width,
    isDismissible: true,
    margin: EdgeInsets.only(
        bottom: isBrowser ? 80.arP : 30.arP, left: 15.arP, right: 15.arP),
    messageText: Padding(
      padding: EdgeInsets.only(left: 20.arP),
      child: SizedBox(
        height: 0.05.height,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.arP),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(transactionAmount, style: labelMedium)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0, top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    tezAddress.isValidWalletAddress
                        ? Text(
                            "Sent to $tezAddress",
                            style: labelSmall.copyWith(
                              color: ColorConst.NeutralVariant.shade60,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                              top: 5.0.arP,
                            ),
                            child: Text(
                              tezAddress,
                              style: labelSmall.copyWith(
                                color: ColorConst.NeutralVariant.shade60,
                              ),
                            ),
                          ),
                    const Spacer(),
                    status == TransactionStatus.error
                        ? const SizedBox(
                            width: 40,
                            height: 20,
                          )
                        : TextButton(
                            style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                maximumSize: MaterialStateProperty.all<Size>(
                                    const Size(80, 20)),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(0)),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(40, 10)),
                                fixedSize: MaterialStateProperty.all<Size>(
                                    const Size(80, 20)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(35))),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        status.color)),
                            onPressed: () {},
                            child: Center(
                              child: Text(
                                status.title,
                                style: labelSmall,
                              ),
                            )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    // titleText: Padding(

    shouldIconPulse: false,
    snackStyle: SnackStyle.FLOATING,
    duration: duration,
    animationDuration: const Duration(seconds: 1),
    snackPosition: SnackPosition.BOTTOM,
  );
}
