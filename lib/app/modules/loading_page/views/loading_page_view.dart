import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/modules/loading_page/controllers/loading_page_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class LoadingPageView extends GetView<LoadingPageController> {
  const LoadingPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as List;
    String loadingAsset = args[0] as String;
    controller.fromRoute = args[1] as String;
    controller.nextRoute = args[2] as String;
    controller.startLodingProcess();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 1.height,
            width: 1.width,
            color: Colors.black,
          ),
          Align(
            alignment: Alignment.center,
            child: LottieBuilder.asset(
              loadingAsset, //'assets/create_wallet/lottie/wallet_success.json',
              fit: BoxFit.contain,
              height: 0.5.height,
              width: 0.5.width,
              frameRate: FrameRate(60),
            ),
          ),
        ],
      ),
    );
  }
}
