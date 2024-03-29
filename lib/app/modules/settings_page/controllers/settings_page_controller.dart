import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beacon_flutter/models/connected_peers.dart';
import 'package:beacon_flutter/models/p2p_peer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:plenty_wallet/app/data/services/patch_sesrvice/patch_service.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:plenty_wallet/app/modules/backup_wallet_page/views/backup_wallet_view.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/teztown/controllers/teztown_controller.dart';
import 'package:plenty_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:plenty_wallet/app/modules/settings_page/widget/backup/backup_page.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:web3auth_flutter/enums.dart';
import '../../../data/services/enums/enums.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../../data/services/service_models/account_model.dart';
import '../../../data/services/service_models/rpc_node_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';
import '../../home_page/controllers/home_page_controller.dart';

class SettingsPageController extends GetxController {
  final homePageController = Get.find<
      HomePageController>(); // Home Page controller for accessing user accounts list
  final beaconPlugin = Get.find<BeaconService>()
      .beaconPlugin; // Getting beacon plugin to get connected apps
  late Rx<NodeSelectorModel> nodeModel =
      NodeSelectorModel().obs; // Node selector model
  Rx<NodeModel> selectedNode = NodeModel().obs; // Node Model
  Rx<NetworkType> networkType = NetworkType.mainnet.obs; // Network type
  RxList<P2PPeer> dapps = <P2PPeer>[].obs;

  Rx<ScrollController> scrollcontroller = ScrollController().obs;
  TextEditingController accountNameController =
      TextEditingController(); // Account name controller, to edit user account name
  AccountProfileImageType currentSelectedType =
      AccountProfileImageType.assets; // Profile Image type

  RxString selectedImagePath = "".obs; // Selected image path

  RxBool isScrolling = false.obs; // Scroll status
  RxBool isRearranging = false.obs; // For Reordering accounts list
  RxBool copyToClipboard = false.obs; // Copy to clipboard status
  RxBool fingerprint = false.obs; // Is Biometric enabled
  RxBool isWalletBackup = true.obs; // Is wallet backed-up
  RxString enteredPassCode = "".obs; // Entered passcode
  RxBool verifyPassCode = false.obs; // Verify passcode status
  RxBool confirmPasscode = false.obs; // confirm new passcode status
  RxString newPasscode = "".obs;
  RxBool inAppReviewAvailable =
      true.obs; // Check if in app purchase is available
  RxBool supportBiometric = true.obs;
  RxBool isPasscodeSet = true.obs;

  RxString passcodeError = "".obs; // Passcode error

  RxString selectedCurrency = ServiceConfig.currency.name.obs;
  RxString selectedWrongAttempts = "Disabled".obs;
  RxString selectedLanguage = ServiceConfig.language.name.obs;

  final InAppReview inAppReview = InAppReview.instance;

  RxBool isPasscodeLock = false.obs;
  RxString lockTimeTitle = "".obs;
  RxInt safetyResetAttempts = 0.obs;
  RxBool isPassCodeWrong = false.obs;

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

  /// To change the app passcode and verify the passcode if fails, redirects to verify passcode screen otherwise changes the passcode
  void changeAppPasscode(String passCode) async {
    if (verifyPassCode.isTrue) {
      AuthService().verifyPassCode(passCode).then((value) async {
        if (value) {
          enteredPassCode.value = "";
          passcodeError.value =
              "Cannot set new passcode same as current passcode";
          HapticFeedback.heavyImpact();
        } else {
          if (!confirmPasscode.value) {
            if (!AuthService().checkPasscodeStrength(passCode)) {
              HapticFeedback.heavyImpact();
              enteredPassCode.value = "";
              passcodeError.value = "Passcode too weak, try Again!";
              return;
            }

            confirmPasscode.value = true;
            newPasscode.value = passCode;
            enteredPassCode.value = "";
            passcodeError.value = "";
            return;
          }
          if (newPasscode.value != passCode) {
            HapticFeedback.heavyImpact();
            Get.rawSnackbar(
              backgroundColor: Colors.transparent,
              snackPosition: SnackPosition.BOTTOM,
              snackStyle: SnackStyle.FLOATING,
              padding: const EdgeInsets.only(bottom: 60, left: 20, right: 20),
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
            enteredPassCode.value = "";
            return;
          }
          await AuthService()
              .setNewPassCode(passCode)
              .whenComplete(() => Get.back())
              .whenComplete(() {
            verifyPassCode.value = false;
            confirmPasscode.value = false;
            newPasscode.value = "";
            enteredPassCode.value = "";
          });
        }
      });
    } else {
      await AuthService().verifyPassCode(passCode).then((value) async {
        if (value) {
          verifyPassCode.value = true;
          resetPassCodeLock();
        } else {
          enteredPassCode.value = "";
          passcodeError.value = "Passcode doesn’t match";
          await checkForPasscodeLock();
        }
      });
    }
  }

  resetPassCodeLock() {
    isPasscodeLock.value = false;
    lockTimeTitle.value = "";
    isPassCodeWrong.value = false;
    safetyResetAttempts.value = -1;
    enteredPassCode.value = "";
    passcodeError.value = "";
  }

  resetPassCodePage() {
    isPasscodeLock.value = false;
    lockTimeTitle.value = "";
    isPassCodeWrong.value = false;
    safetyResetAttempts.value = -1;
    enteredPassCode.value = "";
    verifyPassCode.value = false;
    passcodeError.value = "";
  }

  RxList<AccountModel> oldWallets = <AccountModel>[].obs;
  Future<void> getOldWalletAccounts() async {
    oldWallets.value = await PatchService().recoverWalletsFromOldStorage();
  }

  Future<void> getAllConnectedApps() async {
    final peers = await beaconPlugin.getPeers();
    final Map<String, dynamic> requestJson =
        jsonDecode(jsonEncode(peers)) as Map<String, dynamic>;
    var seen = Set<String>();
    dapps.value = ConnectedPeers.fromJson(requestJson).peer ?? <P2PPeer>[];
    dapps.value = dapps.where((x) => seen.add(x.name)).toList();
    dapps.value = [...dapps.where((p0) => p0.isPaired!)];
  }

  Future<void> disconnectDApp(int index) async {
    beaconPlugin.removePeerUsingPublicKey(
        publicKey: dapps.value[index].publicKey);
    NaanAnalytics.logEvent(NaanAnalyticsEvents.DAPP_CLICK, param: {
      "type": "disconnect",
      "name": dapps.value[index].name,
      "address": homePageController
          .userAccounts[homePageController.selectedIndex.value].publicKeyHash
    });
    dapps.removeAt(index);
  }

  /// Changes the node selector and parse that node to the node selector model
  Future<void> changeNodeSelector() async {
    final nodeSelector =
        await HttpService.performGetRequest(ServiceConfig.nodeSelector);
    // await HttpService.performGetRequest(ServiceConfig.nodeSelector); // Uncomment to parse remote json url
    Map<String, dynamic> json = jsonDecode(nodeSelector);

    nodeModel.value = NodeSelectorModel.fromJson(json);
    await getCustomNodes();
  }

  RxList<NodeModel> customNodes = <NodeModel>[].obs;
  Future<void> getCustomNodes() async {
    customNodes.value = await RpcService.getCustomNode();
  }

  Future<void> addCustomNode(NodeModel newNode) async {
    await RpcService.setCustomNode([...customNodes, newNode]);
    NaanAnalytics.logEvent(NaanAnalyticsEvents.ADD_CUSTOM_RPC,
        param: {"name": newNode.name, "url": newNode.url});
    getCustomNodes();
    Get
      ..back()
      ..back();
  }

  Future<void> deleteCustomNode(NodeModel node) async {
    customNodes.remove(node);
    if (node.url == selectedNode.value.url) {
      selectedNode.value = networkType.value.index == NetworkType.mainnet.index
          ? nodeModel.value.mainnet!.nodes!.first
          : nodeModel.value.testnet!.nodes!.first;
    }
    await RpcService.setCustomNode([...customNodes]);
    getCustomNodes();
    Get
      ..back(result: true)
      ..back();
  }

  @override
  void onClose() {
    resetPassCodeLock();
    super.onClose();
  }

  @override
  void onInit() async {
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
    fingerprint.value = await AuthService().getBiometricAuth();
    isPasscodeSet.value = await AuthService().getIsPassCodeSet();
    selectedWrongAttempts.value =
        await AuthService().getSafetyReset() ?? "Disabled";
    getWalletBackupStatus();
    networkType.value = await RpcService.getCurrentNetworkType();
    getOldWalletAccounts();
    ServiceConfig.currentNetwork = networkType.value;

    await changeNodeSelector();
    await RpcService.getCurrentNode().then((value) {
      if (value == null) {
        selectedNode.value =
            nodeModel.value.mainnet?.nodes?.first ?? NodeModel();
      } else {
        final List<NodeModel> nodes =
            networkType.value.index == Network.mainnet.index
                ? (nodeModel.value.mainnet!.nodes!)
                : (nodeModel.value.testnet!.nodes!);
        if (nodes.any((element) => element.url == value)) {
          selectedNode.value =
              nodes.firstWhere((element) => element.url == value);
        }
      }
      ServiceConfig.currentSelectedNode =
          selectedNode.value.url ?? ServiceConfig.currentSelectedNode;
    });
    inAppReviewAvailable.value = await inAppReview.isAvailable();
    supportBiometric.value =
        await AuthService().checkIfDeviceSupportBiometricAuth();

    getAllConnectedApps();
    await checkForPasscodeLock();
    super.onInit();
  }

  /// Change Network
  Future<void> changeNetwork(NetworkType value) async {
    NaanAnalytics.logEvent(NaanAnalyticsEvents.CHANGE_NETWORK,
        param: {"name": value.name});
    await RpcService.setNetworkType(value);

    networkType.value = value;
    ServiceConfig.currentNetwork = networkType.value;
    final node = networkType.value.index == NetworkType.mainnet.index
        ? nodeModel.value.mainnet!.nodes!.first
        : nodeModel.value.testnet!.nodes!.first;
    await changeNode(node);
    Get.find<BeaconService>().stop();
    await Get.delete<BeaconService>(force: true);
    try {
      Get.find<HomePageController>().resetUserAccounts();
    } catch (e) {}
    await Get.delete<HomePageController>(force: true);
    await Get.delete<AccountsWidgetController>(force: true);
    await Get.delete<TeztownController>(force: true);
    await Get.deleteAll(force: true);

    Phoenix.rebirth(Get.context!);
    Get.reset();
  }

  /// Change Currency
  Future<void> changeCurrency(String currency) async {
    await UserStorageService.writeCurrency(currency);

    selectedCurrency.value = currency;
    ServiceConfig.currency = Currency.values.byName(currency);
/*     await Get.deleteAll(force: true);
    Phoenix.rebirth(Get.context!);
    Get.reset(); */
  }

  // Change Safety Reset
  Future<void> changeSafetyReset(String? s) async {
    await AuthService().setSafetyReset(s);

    selectedWrongAttempts.value = s ?? "Disabled";
  }

  /// Change Language
  Future<void> changeLanguage(String language) async {
    await UserStorageService.writeLanguage(language);
    Get.updateLocale(Locale(language));
    selectedLanguage.value = language;
    ServiceConfig.language = Language.values.byName(language);
  }

  /// Change Node
  Future<void> changeNode(NodeModel value) async {
    selectedNode.value = value;
    ServiceConfig.currentSelectedNode = value.url!;
    DataHandlerService().forcedUpdateData();
    NaanAnalytics.logEvent(NaanAnalyticsEvents.CHANGE_NODE,
        param: {"name": value.name, "url": value.url});

    await RpcService.setNode(value.url ?? "");
  }

  /// Change the biometric authentication
  Future<void> changeBiometricAuth(bool value) async {
    await AuthService().setBiometricAuth(value);

    fingerprint.value = value;
  }

  /// Make the account primary and move it to the top of the list,if it's already primary do nothing i.e. return
  void makePrimaryAccount(int index) {
    for (var element in homePageController.userAccounts) {
      element.isAccountPrimary = false;
    }
    AccountModel account = homePageController.userAccounts[index];
    account
      ..isAccountHidden = false
      ..isAccountPrimary = true;
    homePageController.userAccounts
      ..removeAt(index)
      ..insert(0, account);
    _updateUserAccountsValue();
  }

  /// Rearrange the accounts in the list, if new index is 0 then make it primary acount
  void reorderUserAccountsList(oldIndex, newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    AccountModel item = homePageController.userAccounts[oldIndex];
    homePageController.userAccounts.removeAt(oldIndex);
    if (newIndex == 0) {
      item.isAccountPrimary = true;
    }
    homePageController.userAccounts.insert(newIndex, item);
    _updateUserAccountsValue();
  }

  /// Remove the account and change the primary account if the primary account is removed
  void removeAccount(int index) async {
    if (homePageController.userAccounts.length > 1) {
      NaanAnalytics.logEvent(NaanAnalyticsEvents.REMOVE_ACCOUNT, param: {
        NaanAnalytics.address:
            homePageController.userAccounts[index].publicKeyHash
      });
      log("Before: ${homePageController.userAccounts.length}");
      if (homePageController.selectedIndex.value ==
          homePageController.userAccounts.length - 1) {
        Get.find<AccountsWidgetController>()
            .onPageChanged(homePageController.userAccounts.length - 2);
      }
      homePageController.userAccounts.removeAt(index);

      homePageController.userAccounts[0].isAccountPrimary = true;

      await _updateUserAccountsValue();
      log("After: ${homePageController.userAccounts.length}");
    } else {
      return;
      // Can't remove the only account
    }
  }

  /// shows the updated user profile photo
  ImageProvider showUpdatedProfilePhoto(int index) {
    return homePageController.userAccounts[index].imageType ==
            AccountProfileImageType.assets
        ? AssetImage(homePageController.userAccounts[index].profileImage!)
        : FileImage(
            File(homePageController.userAccounts[index].profileImage!),
          ) as ImageProvider;
  }

  /// Updates the user photo
  void editUserProfilePhoto({
    required AccountProfileImageType imageType,
    required int accountIndex,
    required String imagePath,
  }) {
    homePageController.userAccounts[accountIndex]
      ..imageType = imageType
      ..profileImage = imagePath;
    NaanAnalytics.logEvent(NaanAnalyticsEvents.EDIT_ACCOUNT, param: {
      "profileImage":
          homePageController.userAccounts[accountIndex].profileImage,
      "name": homePageController.userAccounts[accountIndex].name,
      NaanAnalytics.address:
          homePageController.userAccounts[accountIndex].publicKeyHash,
    });
    _updateUserAccountsValue();
  }

  /// Updates the user account to primary account
  void editPrimaryAccountStatus(int index) {
    homePageController.userAccounts[index].isAccountPrimary =
        !homePageController.userAccounts[index].isAccountPrimary!;
    makePrimaryAccount(index);
    Get.back();
  }

  /// Changes the user account to hidden state on the home page
  void editHideThisAccountStatus(int index) {
    if (index == 0) {
      Get.rawSnackbar(
        message: "Can't hide primary account",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    homePageController.userAccounts[index].isAccountHidden =
        !homePageController.userAccounts[index].isAccountHidden!;
    _updateUserAccountsValue();
  }

  Future<void> markWalletAsBackedUp(String seedPhrase) async {
    for (var i = 0; i < homePageController.userAccounts.length; i++) {
      if (homePageController.userAccounts[i].isWatchOnly) continue;
      if ((await UserStorageService().readAccountSecrets(
                  homePageController.userAccounts[i].publicKeyHash!))
              ?.seedPhrase ==
          seedPhrase) {
        homePageController.userAccounts[i].isWalletBackedUp = true;

        break;
      }
    }
    await _updateUserAccountsValue();
    getWalletBackupStatus();
  }

  /// Updates the user accounts list with the latest modifications
  Future<void> _updateUserAccountsValue() async {
    await UserStorageService().updateAccounts(homePageController.userAccounts);
    homePageController.userAccounts.value = [
      ...(await UserStorageService().getAllAccount()),
      ...(await UserStorageService().getAllAccount(watchAccountsList: true)),
    ];
  }

  /// Updates the user accounts profile name with the latest name changes
  void editAccountName(int index, String name) {
    homePageController.userAccounts[index].name = name;
    NaanAnalytics.logEvent(NaanAnalyticsEvents.EDIT_ACCOUNT, param: {
      "profileImage": homePageController.userAccounts[index].profileImage,
      "name": homePageController.userAccounts[index].name,
      NaanAnalytics.address:
          homePageController.userAccounts[index].publicKeyHash,
    });
    _updateUserAccountsValue();
  }

  void switchFingerdebugPrint(bool value) => fingerprint.value = value;
  void checkWalletBackup(BuildContext context, String? prevPage) async {
    if (isWalletBackup.value) {
      CommonFunctions.bottomSheet(BackupPage(), fullscreen: true);
    } else {
      final seedPhrase = await UserStorageService()
          .readAccountSecrets(homePageController.userAccounts
              .firstWhere((element) => !element.isWalletBackedUp)
              .publicKeyHash!)
          .then((value) {
        return value?.seedPhrase ?? "";
      });
      if (prevPage != null) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BackupWalletView(
                prevPage: prevPage,
                seedPhrase: seedPhrase,
              ),
            )).whenComplete(getWalletBackupStatus);
      } else {
        Get.back();
        CommonFunctions.bottomSheet(
                BackupWalletView(
                  prevPage: null,
                  seedPhrase: seedPhrase,
                ),
                fullscreen: true)
            .whenComplete(getWalletBackupStatus);
      }
    }
  }

  void getWalletBackupStatus() {
    isWalletBackup.value = !homePageController.userAccounts
        .any((element) => !element.isWalletBackedUp);
  }

  /// Paste the copied address to the clipboard
  Future<void> paste(String? value) async {
    if (value != null) {
      await Clipboard.setData(
        ClipboardData(
          text: value,
        ),
      ).whenComplete(() {
        copyToClipboard.value = true;
        Get.rawSnackbar(
          maxWidth: 0.45.width,
          backgroundColor: Colors.transparent,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
          padding: const EdgeInsets.only(bottom: 60),
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
                  Icons.check_circle_outline_rounded,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Copied!".tr,
                  style: labelSmall,
                )
              ],
            ),
          ),
        );
        Future.delayed(
            const Duration(seconds: 5), () => copyToClipboard.value = false);
      });
    }
  }

  @override
  void dispose() {
    accountNameController.dispose();
    scrollcontroller.value.dispose();
    super.dispose();
  }
}
