import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPageController extends GetxController {
  late final _pageController = PageController(
    initialPage: 0,
  );
  PageController get pageController => _pageController;

  final List<Color> colorList = [
    const Color(0xffFFC93E),
    const Color(0xff9961EC),
    const Color(0xffFD3289),
    const Color(0xffFA6163),
    const Color(0xffF77A3A),
  ];
  final Map<String, String> onboardingMessages = {
    'assets/onboarding_page/lottie/Onboarding_1.json':
        "All your Tezos\nassets in one\nplace",
    'assets/onboarding_page/lottie/Onboarding_2.json':
        "Flex your NFTs\nand explore\ngalleries",
    'assets/onboarding_page/lottie/Onboarding_3.json':
        "Buy tez with\nyour credit\ncard",
    'assets/onboarding_page/lottie/Onboarding_4-2.json':
        "Discover DApps\nin the Tezos\necosystem",
    'assets/onboarding_page/lottie/Onboarding_5.json':
        "Earn high APR\nwith Liquidity\nBaking",
  };

  var count = 0.obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void increment(int val) => count(val);

  void animateSlider() {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      int nextPage = pageController.page!.round() + 1;

      if (nextPage == onboardingMessages.keys.length) {
        nextPage = 0;
      }

      pageController
          .animateToPage(nextPage,
              duration: const Duration(seconds: 1),
              curve: Curves.fastLinearToSlowEaseIn)
          .then((_) => animateSlider());
    });
  }
}
