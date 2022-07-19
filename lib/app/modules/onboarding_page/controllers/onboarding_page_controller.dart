import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPageController extends GetxController {
  late final _pageController = PageController(
    initialPage: 0,
  ); // PageView Pagecontroller

  late final List<Color> _colorList = [
    const Color(0xffFFC93E),
    const Color(0xff9961EC),
    const Color(0xffFD3289),
    const Color(0xffFA6163),
    const Color(0xffF77A3A),
  ]; // Onboarding screens background colors

  late final Map<String, String> _onboardingMessages = {
    'assets/onboarding_page/lottie/Onboarding_1.json':
        "All your Tezos\nassets in one\nplace",
    'assets/onboarding_page/lottie/Onboarding_2.json':
        "Flex your NFTs\nand explore\ngalleries",
    'assets/onboarding_page/lottie/Onboarding_3.json':
        "Buy tez with\nyour credit\ncard",
    'assets/onboarding_page/lottie/Onboarding_4.json':
        "Discover DApps\nin the Tezos\necosystem",
    'assets/onboarding_page/lottie/Onboarding_5.json':
        "Earn high APR\nwith Liquidity\nBaking",
  }; // Onboarding screens lottie animation paths & messages

  PageController get pageController => _pageController;
  Map<String, String> get onboardingMessages => _onboardingMessages;
  List<Color> get colorList => _colorList;

  var pageIndex = 0.obs; // Incrementing the page index

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  /// Increments page index by the value
  void onPageChanged(int value) => pageIndex(value);

  /// Animates the page transition from current to next page
  void animateSlider() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      int nextPage = _pageController.page!.round() + 1;
      if (nextPage == onboardingMessages.keys.length) {
        nextPage = 0;
      }
      _pageController
          .animateToPage(nextPage,
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastOutSlowIn)
          .then((_) => animateSlider());
    });
  }
}
