import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

class CreateWalletPageController extends GetxController {
  @override
  void onInit() {
    initPlatformState();
    super.onInit();
  }

  /// Initializes Web3AuthFlutter package
  Future<void> initPlatformState() async {
    HashMap themeMap = HashMap<String, String>();
    themeMap['primary'] = "#fff000";

    await Web3AuthFlutter.init(
      clientId:
          "BE-6AIH1fhG1veGQB2tko9j5B--Y7DuXjRoA3XGJEaSUrkB7y2dUdd7XEtfYjKtLjUXd3KrWB4AofCJFTxrsSqM",
      // Client ID from the developer console
      network: Network.testnet,
      redirectUri: "com.naan.web3auth://auth",
      // Redirect Url, must be the same as the one in the web3auth server/dashboard
      whiteLabelData: WhiteLabelData(
          dark: true, name: "Web3Auth Social Login", theme: themeMap),
    );
  }

  VoidCallback login({required Provider socialAppName}) {
    return () async {
      try {
        final Web3AuthResponse response =
            await _socialLogin(socialApp: socialAppName);
        String result = response.toString();
        print(result);
      } on UserCancelledException {
        print("User cancelled.");
      } on UnKnownException {
        print("Unknown exception occurred");
      }
    };
  }

  VoidCallback signOut() {
    return () async {
      try {
        await Web3AuthFlutter.logout();

        String result = '<empty>';
      } on UserCancelledException {
        print("User cancelled.");
      } on UnKnownException {
        print("Unknown exception occurred");
      }
    };
  }

  Future<Web3AuthResponse> _socialLogin({required Provider socialApp}) {
    return Web3AuthFlutter.login(
        provider: socialApp, mfaLevel: MFALevel.MANDATORY);
  }
}
