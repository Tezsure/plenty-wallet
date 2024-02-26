import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:plenty_wallet/app/modules/import_wallet_page/controllers/import_wallet_page_controller.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

import '../../home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';

class PasscodePageController extends GetxController {
  /// define whether the redirected from new wallet or to verify the passcode <br>
  /// which will decide to write new passcode or check the already stored passcode
  RxBool isToVerifyPassCode = false.obs;
  String? nextPageRoute;
  RxString confirmPasscode = "".obs;
  RxString enteredPassCode = "".obs;
  RxInt wrongPasscodeLimit = 0.obs;
  RxBool isPassCodeWrong = false.obs;

  RxString passCodeError = "".obs;

  RxString resetString = "".obs;
  RxString newPasscode = "".obs;
  RxBool isPasscodeSet = false.obs;
  Rx<TextEditingController> phraseTextController = TextEditingController().obs;

  RxBool confirmPasscodeReset = false.obs;
  RxBool isAccountAlreadyPresent = false.obs;

  RxBool isPasscodeLock = false.obs;
  RxString lockTimeTitle = "".obs;
  RxInt safetyResetAttempts = 0.obs;

  void onTextChange(String value) async {
    await checkResetType(value);
    resetString.value = value;
  }

  void onInit() async {
    super.onInit();
    isPasscodeSet.value = await AuthService().getIsPassCodeSet();

    // check for lock and start timer
    await checkForPasscodeLock();
  }

  Future<void> checkForPasscodeLock() async {
    Duration? lockoutDuration = await AuthService().getLockDuration();
    safetyResetAttempts.value = await AuthService().getTotalWrongAttemptsLeft();

    if (safetyResetAttempts.value == 0) {
      debugPrint("Resetting the App");

      await ServiceConfig().clearStorage();
      Get.offAllNamed(Routes.SAFETY_RESET_PAGE);
      return;
    }

    if (lockoutDuration != null) {
      enteredPassCode.value = "";
      _startTimer(lockoutDuration, (durationinSec) {
        if (durationinSec <= 0) {
          isPasscodeLock.value = false;
          enteredPassCode.value = "";
          isPassCodeWrong.value = false;
          lockTimeTitle.value = "";
        } else {
          enteredPassCode.value = "";

          isPasscodeLock.value = true;
          // convert seconds to minutes and seconds
          var minutes = (durationinSec / 60).floor();
          var seconds = durationinSec % 60;

          lockTimeTitle.value =
              "Try again after ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
        }
      });
    }
  }

  _startTimer(Duration tillTime, callback) {
    int durationinSec = tillTime.inSeconds;

    // periodic timer every seconds and check if time is up and callback()
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (durationinSec <= 0) {
        timer.cancel();
        callback(durationinSec);
      } else {
        durationinSec--;
        callback(durationinSec);
      }
    });
  }

  Rx<ImportWalletDataType?> resetDataType = ImportWalletDataType.none.obs;

  checkResetType(String value) async {
    value = value.trim();
    isAccountAlreadyPresent.value = false;
    resetDataType.value =
        (value.startsWith('edsk') || value.startsWith('spsk')) &&
                value.split(" ").length == 1
            ? ImportWalletDataType.privateKey
            : value.split(" ").length == 12 || value.split(" ").length == 24
                ? ImportWalletDataType.mnemonic
                : ImportWalletDataType.none;

    if (resetDataType.value != ImportWalletDataType.none) {
      debugPrint("resetDataType.value ${resetDataType.value}");
      UserStorageService userStorageService = UserStorageService();
      var storedAccounts = await userStorageService.getAllAccount(
        isSecretDataRequired: true,
      );

      for (var element in storedAccounts) {
        AccountSecretModel? secret =
            await userStorageService.readAccountSecrets(element.publicKeyHash!);
        if (secret?.secretKey!.trim() == value ||
            secret?.seedPhrase!.trim() == value) {
          isAccountAlreadyPresent.value = true;
        }
      }
    }
  }

  changeAppPasscode(String value) async {
    if (confirmPasscodeReset.value == false) {
      if (!AuthService().checkPasscodeStrength(value)) {
        passCodeError.value = "Passcode is weak, please try again";
        enteredPassCode.value = "";
        await HapticFeedback.vibrate();
        return;
      }

      confirmPasscodeReset.value = true;
      newPasscode.value = value;
      enteredPassCode.value = "";
      passCodeError.value = "";
      return;
    }

    if (value != newPasscode.value) {
      newPasscode.value = "";
      confirmPasscodeReset.value = false;
      enteredPassCode.value = "";
      Get.rawSnackbar(
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
        padding: const EdgeInsets.only(bottom: 60, left: 40, right: 40),
        messageText: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: ColorConst.Neutral.shade10,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Passwords do not match",
                style: labelSmall,
              )
            ],
          ),
        ),
      );
      await HapticFeedback.vibrate();
      return;
    }

    await AuthService().setNewPassCode(value).whenComplete(() async {
      await HapticFeedback.heavyImpact();
      Get.back();
      Get.back();
      Get.rawSnackbar(
        backgroundColor: Colors.transparent,
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
        padding: const EdgeInsets.only(bottom: 60, left: 40, right: 40),
        messageText: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 31, 87, 3),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.done,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Password changed successfully",
                style: labelSmall,
              )
            ],
          ),
        ),
      );
    }).whenComplete(() {
      confirmPasscodeReset.value = false;
      newPasscode.value = "";
      enteredPassCode.value = "";
    });
  }

  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      await checkResetType(cdata.text!);
      phraseTextController.value.text = cdata.text!.trim();
      resetString.value = cdata.text!.trim();
    }
  }

  /// This will check based on isToVerifyPassCode whether to redirect to next page or pop with return data<br>
  /// return data of pop will be whether the entered passcode is valid or not
  Future<void> checkOrWriteNewAndRedirectToNewPage(String passCode) async {
    AuthService authService = AuthService();
    var previousRoute = Get.previousRoute;
    if (isToVerifyPassCode.value) {
      /// verify the passcode here
      var checkPassCode = await AuthService().verifyPassCode(passCode);

      if (nextPageRoute == null && checkPassCode) {
        await ServiceConfig.secureLocalStorage.initMoveToEncryptedStorage();
        Get.back(result: true);
      }
      if (checkPassCode && nextPageRoute != null) {
        await ServiceConfig.secureLocalStorage.initMoveToEncryptedStorage();
        if (nextPageRoute == Routes.LOCKED) {
          Get.back();
        } else {
          Get.offAllNamed(nextPageRoute!);
        }
      } else {
        enteredPassCode.value = "";
        isPassCodeWrong.value = true;
        await checkForPasscodeLock();
        await HapticFeedback.vibrate();
      }
    }

    /// check if passcode is weak
    else if (!authService.checkPasscodeStrength(passCode)) {
      confirmPasscode.value = "";
      enteredPassCode.value = "";
      passCodeError.value = "Passcode is weak, please try again";
      await HapticFeedback.vibrate();
    } else if (nextPageRoute != null &&
        nextPageRoute == Routes.BIOMETRIC_PAGE &&
        previousRoute == Routes.ONBOARDING_PAGE) {
      await authService.setNewPassCode(passCode);
      var isBioSupported =
          await authService.checkIfDeviceSupportBiometricAuth();

      Get.toNamed(isBioSupported ? Routes.BIOMETRIC_PAGE : Routes.HOME_PAGE,
          arguments: isBioSupported
              ? [
                  previousRoute,
                  Routes.HOME_PAGE,
                ]
              : null);
    } else if (nextPageRoute != null &&
        nextPageRoute == Routes.BIOMETRIC_PAGE &&
        previousRoute == Routes.CREATE_WALLET_PAGE) {
      /// set a new passcode and redirect to biometric page if supported else redirect /create-profile-page
      await authService.setNewPassCode(passCode);
      var isBioSupported =
          await authService.checkIfDeviceSupportBiometricAuth();

      /// arguments here defines that whether it's from create new wallet or import new wallet
      Get.toNamed(
        isBioSupported ? Routes.BIOMETRIC_PAGE : Routes.CREATE_PROFILE_PAGE,
        arguments: isBioSupported
            ? [
                previousRoute,
                Routes.CREATE_PROFILE_PAGE,
              ]
            : [previousRoute],
      );
    } else if (nextPageRoute != null &&
        nextPageRoute == Routes.BIOMETRIC_PAGE &&
        previousRoute == Routes.IMPORT_WALLET_PAGE) {
      await authService.setNewPassCode(passCode);
      var isBioSupported =
          await authService.checkIfDeviceSupportBiometricAuth();
      ImportWalletPageController importWalletPageController =
          Get.find<ImportWalletPageController>();
      if (importWalletPageController.importWalletDataType ==
          ImportWalletDataType.mnemonic) {
        Get.toNamed(
            isBioSupported ? Routes.BIOMETRIC_PAGE : Routes.LOADING_PAGE,
            arguments: isBioSupported
                ? [
                    previousRoute,
                    Routes.LOADING_PAGE,
                  ]
                : [
                    'assets/create_wallet/lottie/loading_animation.json',
                    previousRoute,
                    Routes.HOME_PAGE,
                  ]);
      } else {
        Get.toNamed(
          isBioSupported ? Routes.BIOMETRIC_PAGE : Routes.CREATE_PROFILE_PAGE,
          arguments: isBioSupported
              ? [
                  previousRoute,
                  Routes.CREATE_PROFILE_PAGE,
                ]
              : [previousRoute],
        );
      }
    } else if (nextPageRoute != null &&
        nextPageRoute == Routes.ADD_NEW_WALLET) {
      await authService.setNewPassCode(passCode);
      var isBioSupported =
          await authService.checkIfDeviceSupportBiometricAuth();

      /// arguments here defines that whether it's from create new wallet or import new wallet
      if (isBioSupported) {
        Get.back();
        Get.toNamed(
          Routes.BIOMETRIC_PAGE,
          arguments: [
            previousRoute,
            Routes.ADD_NEW_WALLET,
          ],
        );
      } else {
        Get.back();
        CommonFunctions.bottomSheet(AddNewAccountBottomSheet(),
                fullscreen: true)
            .whenComplete(() {
          Get.find<AccountsWidgetController>().resetCreateNewWallet();
        });
      }
    } else {
      /// if it's not to verify a passcode and not being redirected from create wallet page or import page<br>
      /// overwrite the new passcode and pop with value true

      if (Get.previousRoute == Routes.SPLASH_PAGE) {
        await authService.setNewPassCode(passCode);
        var isBioSupported =
            await authService.checkIfDeviceSupportBiometricAuth();

        /// arguments here defines that whether it's from create new wallet or import new wallet
        Get.toNamed(
          isBioSupported ? Routes.BIOMETRIC_PAGE : Routes.HOME_PAGE,
          arguments: isBioSupported
              ? [
                  previousRoute,
                  Routes.HOME_PAGE,
                ]
              : [previousRoute],
        );
      }
    }
  }

  @override
  void onReady() async {
    debugPrint(
      "onReady ${isToVerifyPassCode.value}",
    );
    if (isToVerifyPassCode.value) {
      verifyPassCodeOrBiomatrics();
    }
  }

  verifyPassCodeOrBiomatrics() async {
    AuthService authService = AuthService();
    var isBioEnable = await authService.getBiometricAuth();
    if (isBioEnable) {
      bool result = await authService.verifyBiometric();
      if (result) {
        await ServiceConfig.secureLocalStorage.initMoveToEncryptedStorage();
        if (nextPageRoute == null) {
          Get.back(result: true);
        } else if (nextPageRoute != null && nextPageRoute == Routes.LOCKED) {
          Get.back();
        } else {
          Get.offAllNamed(nextPageRoute!);
        }
      }
    }
  }
}
