import 'dart:collection';
import 'dart:io';

import 'package:dartez/helper/generateKeys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/data/services/web3auth_services/web3AuthController.dart';
import 'package:plenty_wallet/app/modules/import_wallet_page/controllers/import_wallet_page_controller.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/env.dart'
    show web3AuthclientId, web3AuthredirectUriAndroid, web3AuthredirectUriIos;
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:web3auth_flutter/enums.dart' as web3auth;
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

class Web3Auth {
  /// Initializes Web3AuthFlutter package
  static Future<void> initPlatformState() async {
    HashMap themeMap = HashMap<String, String>();
    themeMap['primary'] = "#fff000";
    Web3AuthOptions web3authOptions = Web3AuthOptions(
      clientId: web3AuthclientId,
      network: web3auth.Network.mainnet,
      redirectUrl: Platform.isIOS
          ? Uri.parse(web3AuthredirectUriIos)
          : Uri.parse(web3AuthredirectUriAndroid),
      whiteLabel: WhiteLabelData(
          dark: true, name: "Plenty Wallet Social Login", theme: themeMap),
    );
    await Web3AuthFlutter.init(web3authOptions);
  }

  /// Check whether the user is logged in or not
  static VoidCallback login({required web3auth.Provider socialAppName}) {
    return () async {
      try {
        NaanAnalytics.logEvent(NaanAnalyticsEvents.SOCIAL_LOGIN,
            param: {"login_type": socialAppName.name});
        await _socialLogin(socialApp: socialAppName).then((response) async {
          // AuthService().setWalletBackup(true);
          Get.put(Web3AuthController());
          Web3AuthController controller = Get.find<Web3AuthController>();
          controller.privateKey = GenerateKeys.readKeysWithHint(
              Uint8List.fromList(HEX.decoder.convert(response.privKey!)),
              GenerateKeys.keyPrefixes[PrefixEnum.spsk]!);
          ImportWalletPageController importWalletPageController =
              Get.put(ImportWalletPageController());
          importWalletPageController.importWalletDataType =
              ImportWalletDataType.privateKey;
          importWalletPageController.phraseText.value =
              controller.privateKey ?? "";
          var isPassCodeSet = await AuthService().getIsPassCodeSet();
          var previousRoute = Get.previousRoute;

          Get.toNamed(
            isPassCodeSet ? Routes.CREATE_PROFILE_PAGE : Routes.PASSCODE_PAGE,
            arguments: isPassCodeSet
                ? [
                    previousRoute,
                  ]
                : [
                    false,
                    Routes.BIOMETRIC_PAGE,
                  ],
          );
          Get.rawSnackbar(
            message:
                "Successfully logged-in using ${response.userInfo?.typeOfLogin}",
            shouldIconPulse: true,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 8.arP,
            backgroundColor: const Color(0xFF421121),
            margin: const EdgeInsets.only(
              bottom: 20,
            ),
            maxWidth: 0.9.width,
            duration: const Duration(seconds: 3),
          );
        });
      } on UserCancelledException {
        debugPrint("User cancelled.");
      } on UnKnownException {
        debugPrint("Unknown exception occurred");
      }
    };
  }

  /// Logout the user & redirect to the onboarding page
  static Future<void> signOut() async {
    try {
      await initPlatformState();
      await Web3AuthFlutter.logout();
    } on UserCancelledException {
      debugPrint("User cancelled.");
    } on UnKnownException {
      debugPrint("Unknown exception occurred");
    }
  }

  /// Authenticate the user with the social app which can be passed as parameter
  static Future<Web3AuthResponse> _socialLogin(
      {required web3auth.Provider socialApp}) async {
    await initPlatformState();
    LoginParams loginParams = LoginParams(
      loginProvider: socialApp,
      curve: web3auth.Curve.secp256k1,
      mfaLevel: web3auth.MFALevel.OPTIONAL,
      extraLoginOptions: ExtraLoginOptions(
        display: web3auth.Display.wap,
      ),
    );
    return Web3AuthFlutter.login(loginParams);
  }
}
