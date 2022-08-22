import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

class Web3Auth {
  static const String clientId =
      "BE-6AIH1fhG1veGQB2tko9j5B--Y7DuXjRoA3XGJEaSUrkB7y2dUdd7XEtfYjKtLjUXd3KrWB4AofCJFTxrsSqM"; // Client ID from the developer console
  static const String redirectUri =
      "com.naan.web3auth://auth"; // Redirect Url, must be the same as the one in the web3auth server/dashboard

  /// Initializes Web3AuthFlutter package
  static Future<void> initPlatformState() async {
    HashMap themeMap = HashMap<String, String>();
    themeMap['primary'] = "#fff000";
    await Web3AuthFlutter.init(
      clientId: clientId,
      network: Network.testnet,
      redirectUri: redirectUri,
      whiteLabelData: WhiteLabelData(
          dark: true, name: "Web3Auth Social Login", theme: themeMap),
    );
  }

  /// Check whether the user is logged in or not
  static VoidCallback login({required Provider socialAppName}) {
    return () async {
      try {
        final Web3AuthResponse response =
            await _socialLogin(socialApp: socialAppName)
                .whenComplete(() => Get.offAllNamed(Routes.HOME_PAGE));
        String result = response.toString();
        debugPrint(result);
      } on UserCancelledException {
        debugPrint("User cancelled.");
      } on UnKnownException {
        debugPrint("Unknown exception occurred");
      }
    };
  }

  /// Logout the user & redirect to the onboarding page
  static VoidCallback signOut() {
    return () async {
      try {
        await Web3AuthFlutter.logout()
            .whenComplete(() => Get.offAllNamed(Routes.ONBOARDING_PAGE));
        String result = '<empty>';
      } on UserCancelledException {
        debugPrint("User cancelled.");
      } on UnKnownException {
        debugPrint("Unknown exception occurred");
      }
    };
  }

  /// Authenticate the user with the social app which can be passed as parameter
  static Future<Web3AuthResponse> _socialLogin({required Provider socialApp}) {
    return Web3AuthFlutter.login(
        provider: socialApp, mfaLevel: MFALevel.MANDATORY);
  }
}
