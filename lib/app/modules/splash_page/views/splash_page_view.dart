import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/splash_page_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class SplashPageView extends GetView<SplashPageController> {
  const SplashPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 1.width,
            height: 1.width,
            child: Center(
              child: Lottie.asset(
                "assets/onboarding_page/lottie/splash.json",
                animate: true,
                frameRate: FrameRate.max,
                fit: BoxFit.contain,
                // ignore: avoid_print
                onWarning: (p) => print(p),
                // alignment: Alignment.center,
                repeat: false, width: 1.width,
                height: 1.width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
