import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/effects/expanding_dots_effects.dart';
import 'package:naan_wallet/app/modules/custom_packages/animated_scroll_indicator/smooth_page_indicator.dart';
import 'package:naan_wallet/app/modules/onboarding_page/controllers/onboarding_page_controller.dart';
import 'package:naan_wallet/app/modules/onboarding_page/widgets/onboarding_screen_widget.dart';
import 'package:naan_wallet/app/modules/passcode_page/views/passcode_page_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class OnboardingPageView extends GetView<OnboardingPageController> {
  const OnboardingPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OnboardingWidget(
          controller: controller,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Obx(() => AnimatedSmoothIndicator(
                    activeIndex: controller.pageIndex(),
                    count: 5,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white,
                    ),
                  )),
              0.02.vspace,
              MaterialButton(
                onPressed: () {
                  Get.toNamed(Routes.CREATE_WALLET_PAGE);
                },
                minWidth: 0.8.width,
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
              0.02.vspace,
            ],
          ),
        ),
      ],
    );
  }
}
