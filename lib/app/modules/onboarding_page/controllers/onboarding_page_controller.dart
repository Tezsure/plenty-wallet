import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';

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
    // const Color(0xffF77A3A),
  ]; // Onboarding screens background colors

  late final Map<String, String> _onboardingMessages = {
    'assets/onboarding_page/lottie/Onboarding_1.json':
        "Manage your\nTezos assets in\none place",
    'assets/onboarding_page/lottie/Onboarding_2.json':
        "Flex your NFTs\nand explore\ngalleries",
    'assets/onboarding_page/lottie/Onboarding_3.json':
        "Buy tez with\nyour credit\ncard",
    'assets/onboarding_page/lottie/Onboarding_4.json':
        "Discover apps\nin the Tezos\necosystem",
    'assets/onboarding_page/lottie/Onboarding_6.json':
        "Collect NFTs\nwith your credit card and stable coins"
    // 'assets/onboarding_page/lottie/Onboarding_5.json':
    //     "Earn high APR\nwith Liquidity\nBaking",
  }; // Onboarding screens lottie animation paths & messages

  PageController get pageController => _pageController;
  Map<String, String> get onboardingMessages => _onboardingMessages;
  List<Color> get colorList => _colorList;

  var pageIndex = 0.obs; // Incrementing the page index
  Timer? _timer;
  @override
  void onClose() {
    pageController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  /// Increments page index by the value
  void onPageChanged(int value) => pageIndex(value);
  void pause() {
    _timer?.cancel();
  }

  void play() {
    pause();
    animateSlider();
  }

  /// Animates the page transition from current to next page
  void animateSlider() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      animateToNextPage();
    });
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      animateToNextPage();
    });
  }

  void animateToNextPage() {
    int nextPage = _pageController.page!.round() + 1;
    if (nextPage == onboardingMessages.keys.length) {
      nextPage = 0;
    }
    _pageController.animateToPage(nextPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn);
  }

  void navigateToLogin() {
    NaanAnalytics.logEvent(NaanAnalyticsEvents.GET_STARTED, param: {
      "intro_page_name": _onboardingMessages.values.toList()[pageIndex.value]
    });
    Get.offAllNamed(Routes.CREATE_WALLET_PAGE);
  }
}
