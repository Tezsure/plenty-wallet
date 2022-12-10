import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/web3auth_services/web3auth.dart';
import 'package:web3auth_flutter/enums.dart';

class CreateWalletPageController extends GetxController {
  @override
  void onInit() {
    Web3Auth.initPlatformState();
    super.onInit();
  }

  VoidCallback login({required Provider socialAppName}) {
    NaanAnalytics.logEvent(NaanAnalyticsEvents.SOCIAL_LOGIN,
        param: {"login_type": socialAppName.name});
    return Web3Auth.login(socialAppName: socialAppName);
  }
}
