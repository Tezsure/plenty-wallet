import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import '../controllers/safety_reset_page_controller.dart';

class SafetyResetPageView extends GetView<SafetyResetPageController> {
  const SafetyResetPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 1.height,
            width: 1.width,
            color: Colors.black,
            alignment: Alignment.center,
            // padding: EdgeInsets.only(top: 0.175.height),
            child: LottieBuilder.asset(
              'assets/create_wallet/lottie/loading_animation.json',
              fit: BoxFit.contain,
              // height: 0.75.height,
              width: 1.width,
              repeat: false,
              frameRate: FrameRate(60),
            ),
          ),

          /// title : Your wallet is resetting
          Positioned(
            bottom: 0.25.height,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Obx(
                  () => Text(
                    controller.isLoadingDone.value
                        ? "Your wallet is reset"
                        : "Your wallet is resetting",
                    style: TextStyle(
                      fontSize: 18.aR,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.01.height,
                ),
                Text(
                  "You have exceeded the maximum\nnumber of attempts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.aR,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFFF3030),
                  ),
                ),
              ],
            ),
          ),

          Obx(
            () => !controller.isLoadingDone.value
                ? Container()
                : Positioned(
                    bottom: 46.arP,
                    left: 32.arP,
                    right: 32.arP,
                    child: SolidButton(
                      onPressed: () async {
                        // restart app
                        await Get.deleteAll(force: true);

                        Phoenix.rebirth(Get.context!);
                        Get.reset();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Continue".tr,
                            style: titleSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
