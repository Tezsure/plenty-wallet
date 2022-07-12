import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/modules/onboarding_page/controllers/onboarding_page_controller.dart';

class OnboardingWidget extends StatefulWidget {
  final OnboardingPageController controller;
  const OnboardingWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.controller.animateSlider());
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: widget.controller.pageController,
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        onPageChanged: (val) => widget.controller.increment(val),
        itemBuilder: (_, index) {
          return AnnotatedRegion(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: widget.controller.colorList[index],
            ),
            child: Container(
              color: widget.controller.colorList[index],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Lottie.asset(
                        widget.controller.onboardingMessages.keys
                            .elementAt(index),
                        animate: true,
                        frameRate: FrameRate(30),
                        height: Get.height * 0.65,
                      ),
                      Positioned(
                        bottom: 0,
                        right: Get.width * 0.3,
                        left: Get.width * 0.3,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, -Get.height * 0.14),
                                color: widget.controller.colorList[index]
                                    .withOpacity(0.5),
                                spreadRadius: Get.height * 0.14,
                                blurRadius: 20,
                              ),
                            ],
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      widget.controller.onboardingMessages.values
                          .elementAt(index),
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
