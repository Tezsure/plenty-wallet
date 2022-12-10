import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/effects/expanding_dots_effects.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/smooth_page_indicator.dart';
import 'package:naan_wallet/app/modules/onboarding_page/controllers/onboarding_page_controller.dart';
import 'package:naan_wallet/app/modules/onboarding_page/widgets/onboarding_screen_widget.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

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
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  return SafeArea(
                    child: AnimatedContainer(
                      margin: EdgeInsets.symmetric(horizontal: 32.sp),

                      duration: const Duration(milliseconds: 1000),
                      alignment: Alignment.bottomLeft,
                      // alignment: const Alignment(-0.1, 0.6),
                      child: Text(
                        controller.onboardingMessages.values
                            .elementAt(controller.pageIndex()),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          color: Colors.white,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
                Obx(() => AnimatedSmoothIndicator(
                      activeIndex: controller.pageIndex(),
                      count: 4,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.white,
                        dotColor: Colors.white,
                      ),
                    )),
                0.0.vspace,
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.sp),
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        controller.navigateToLogin();
                      },
                      minWidth: double.infinity,
                      height: 0.06.height,
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                0.02.vspace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
