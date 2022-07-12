import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/onboarding_page/controllers/onboarding_page_controller.dart';
import 'package:naan_wallet/app/modules/widgets/onboarding/onboarding_screen_widget.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPageView extends GetView<OnboardingPageController> {
  const OnboardingPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OnboardingWidget(
            controller: controller,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Obx(() => AnimatedSmoothIndicator(
                      activeIndex: controller.count(),
                      count: 5,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.white,
                        dotColor: Colors.white,
                      ),
                    )),
                20.vspace,
                Padding(
                  padding: EdgeInsets.only(bottom: Get.height * 0.05),
                  child: MaterialButton(
                    onPressed: () {},
                    minWidth: 326,
                    height: 48,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
