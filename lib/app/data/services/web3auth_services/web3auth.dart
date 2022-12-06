import 'dart:collection';
import 'dart:io';

import 'package:dartez/helper/generateKeys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';
import 'package:naan_wallet/app/data/services/web3auth_services/web3AuthController.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:web3auth_flutter/enums.dart' as web3auth;
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

class Web3Auth {
  static const String clientId =
      "BE-6AIH1fhG1veGQB2tko9j5B--Y7DuXjRoA3XGJEaSUrkB7y2dUdd7XEtfYjKtLjUXd3KrWB4AofCJFTxrsSqM"; // Client ID from the developer console
  static const String redirectUriAndroid =
      "com.naan.web3auth://auth"; // Redirect Url, must be the same as the one in the web3auth server/dashboard
  static const String redirectUriIos =
      "com.naan://auth"; // Redirect Url, must be the same as the one in the web3auth server/dashboard

  /// Initializes Web3AuthFlutter package
  static Future<void> initPlatformState() async {
    HashMap themeMap = HashMap<String, String>();
    themeMap['primary'] = "#fff000";

    Web3AuthOptions web3authOptions = Web3AuthOptions(
      clientId: clientId,
      network: web3auth.Network.mainnet,
      redirectUrl: Platform.isIOS
          ? Uri.parse(redirectUriIos)
          : Uri.parse(redirectUriAndroid),
      whiteLabel: WhiteLabelData(
          dark: true, name: "Naan Wallet Social Login", theme: themeMap),
    );
    await Web3AuthFlutter.init(web3authOptions);
  }

  /// Check whether the user is logged in or not
  static VoidCallback login({required web3auth.Provider socialAppName}) {
    return () async {
      try {
        await _socialLogin(socialApp: socialAppName).then((response) async {
          Get.put(Web3AuthController());
          Web3AuthController controller = Get.find<Web3AuthController>();
          controller.privateKey = GenerateKeys.readKeysWithHint(
              Uint8List.fromList(HEX.decoder.convert(response.privKey!)),
              GenerateKeys.keyPrefixes[PrefixEnum.spsk]!);
          Get.toNamed(
            Routes.PASSCODE_PAGE,
            arguments: [
              false,
              Routes.BIOMETRIC_PAGE,
            ],
          );
          Get.rawSnackbar(
            message:
                "Successfully logged-in using ${response.userInfo?.typeOfLogin}",
            shouldIconPulse: true,
            backgroundColor: ColorConst.Primary,
            snackPosition: SnackPosition.BOTTOM,
            maxWidth: 0.9.width,
            margin: EdgeInsets.only(
              bottom: 20.aR,
            ),
            duration: const Duration(milliseconds: 1000),
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
      await Web3AuthFlutter.logout();
    } on UserCancelledException {
      debugPrint("User cancelled.");
    } on UnKnownException {
      debugPrint("Unknown exception occurred");
    }
  }

  /// Authenticate the user with the social app which can be passed as parameter
  static Future<Web3AuthResponse> _socialLogin(
      {required web3auth.Provider socialApp}) {
    LoginParams loginParams = LoginParams(
      loginProvider: socialApp,
      curve: web3auth.Curve.secp256k1,
      mfaLevel: web3auth.MFALevel.MANDATORY,
      extraLoginOptions: ExtraLoginOptions(
        display: web3auth.Display.wap,
      ),
    );
    return Web3AuthFlutter.login(loginParams);
  }
}
