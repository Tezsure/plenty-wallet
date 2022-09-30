import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

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
      color: Color(0xffFF5449));

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
      child: LottieBuilder.asset(
        status.lottiePath,
        frameRate: FrameRate(60),
        fit: BoxFit.cover,
        repeat: true,
        height: 40.sp,
        width: 40.sp,
      ),
    ),

    barBlur: 1,
    onTap: (val) {},
    borderRadius: 8,
    maxWidth: 8.width,
    isDismissible: true,
    margin: EdgeInsets.only(bottom: 30.sp, left: 15.sp, right: 15.sp),
    messageText: Padding(
      padding: EdgeInsets.only(left: 20.sp),
      child: SizedBox(
        height: 0.05.height,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Align(
                alignment: const Alignment(1, -2),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.sp),
                  child: MaterialButton(
                    padding: EdgeInsets.only(left: 90.sp),
                    height: 2,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const CircleBorder(),
                    onPressed: () {},
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: ColorConst.NeutralVariant.shade60,
                    ),
                  ),
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sent to $tezAddress",
                      style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
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
                                    borderRadius: BorderRadius.circular(35))),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(status.color)),
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
