import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/text_scale_factor.dart';
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
    return OverrideTextScaleFactor(
      child: Scaffold(
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
                  // Obx(() {
                  //   return SafeArea(
                  //     child: AnimatedContainer(
                  //       margin: EdgeInsets.symmetric(horizontal: 32.arP),
    
                  //       duration: const Duration(milliseconds: 1000),
                  //       alignment: Alignment.bottomLeft,
                  //       // alignment: const Alignment(-0.1, 0.6),
                  //       child: Text(
                  //         controller.onboardingMessages.values
                  //             .elementAt(controller.pageIndex()),
                  //         textAlign: TextAlign.start,
                  //         style: TextStyle(
                  //           fontFamily: 'Space Grotesk',
                  //           color: Colors.white,
                  //           fontSize: 40.arP,
                  //           fontWeight: FontWeight.w400,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }),
                  Obx(() => AnimatedSmoothIndicator(
                        activeIndex: controller.pageIndex(),
                        count: controller.onboardingMessages.keys.length,
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
                        padding: EdgeInsets.symmetric(horizontal: 32.arP),
                        child: SolidButton(
                          title: 'Get started',
                          onPressed: () {
                            controller.navigateToLogin();
                          },
                          primaryColor: Colors.black,
                        )),
                  ),
                  0.02.vspace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
