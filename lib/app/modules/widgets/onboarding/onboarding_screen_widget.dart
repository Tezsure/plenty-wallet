import 'package:flutter/material.dart';
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
          return Container(
            height: 400,
            width: 400,
            color: widget.controller.colorList[index],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Lottie.asset(
                    widget.controller.onboardingMessages.keys.elementAt(index),
                    animate: true,
                    frameRate: FrameRate(30),
                    height: 517),
              ],
            ),
          );
        });
  }
}
