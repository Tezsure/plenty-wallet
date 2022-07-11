import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naan_wallet/app/modules/widgets/onboarding/onboarding_screen_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/onboarding_page_controller.dart';

class OnboardingPageView extends GetView<OnboardingPageController> {
  const OnboardingPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            OnboardingWidget(
              controller: controller,
            ),
            Positioned(
              top: 630,
              height: 1,
              width: Get.width,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, -220),
                      color: controller.colorList[controller.count()]
                          .withOpacity(0.2),
                      spreadRadius: 140,
                      blurRadius: 20,
                    ),
                  ],
                  color:
                      controller.colorList[controller.count()].withOpacity(0.4),
                ),
              ),
            ),
            Positioned(
              top: 526,
              left: 40,
              right: 52,
              child: Text(
                controller.onboardingMessages.values
                    .elementAt(controller.count()),
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              top: 702,
              left: 156,
              right: 156,
              child: AnimatedSmoothIndicator(
                activeIndex: controller.count(),
                count: 5,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 720,
              right: 32,
              left: 32,
              child: MaterialButton(
                onPressed: () {},
                minWidth: 326,
                height: 48,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
