import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/modules/backup_wallet_page/views/backup_wallet_view.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/models/dapp_model.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/backup/backup_page.dart';
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
  late Rx<NodeSelectorModel> nodeModel =
      NodeSelectorModel().obs; // Node selector model
  Rx<NodeModel> selectedNode = NodeModel().obs; // Node Model
  Rx<NetworkType> networkType = NetworkType.mainnet.obs; // Network type
  RxList<DappModel> dapps = List.generate(
      4,
      (index) => DappModel(
          imgUrl: "", name: "dapp", networkType: NetworkType.mainnet)).obs;

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
  RxBool isWalletBackup = false.obs; // Is wallet backed-up
  RxString enteredPassCode = "".obs; // Entered passcode
  RxBool verifyPassCode = false.obs; // Verify passcode status
  RxBool inAppReviewAvailable =
      true.obs; // Check if in app purchase is available

  final InAppReview inAppReview = InAppReview.instance;

  /// To change the app passcode and verify the passcode if fails, redirects to verify passcode screen otherwise changes the passcode
  void changeAppPasscode(String passCode) async {
    if (verifyPassCode.isTrue) {
      await AuthService()
          .setNewPassCode(passCode)
          .whenComplete(() => Get.back())
          .whenComplete(() {
        verifyPassCode.value = false;
        enteredPassCode.value = "";
      });
    } else {
      await AuthService().verifyPassCode(passCode).then((value) {
        if (value) {
          verifyPassCode.value = true;
        }
        enteredPassCode.value = "";
      });
    }
  }

  /// Changes the node selector and parse that node to the node selector model
  Future<void> changeNodeSelector() async {
    String nodeSelector =
        await rootBundle.loadString(ServiceConfig.nodeSelector);
    // await HttpService.performGetRequest(ServiceConfig.nodeSelector); // Uncomment to parse remote json url
    Map<String, dynamic> json = jsonDecode(nodeSelector);

    nodeModel.value = NodeSelectorModel.fromJson(json);
  }

  @override
  void onInit() async {
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
    fingerprint.value = await AuthService().getBiometricAuth();
    isWalletBackup.value = await AuthService().getIsWalletBackup();
    networkType.value = await RpcService.getCurrentNetworkType();
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
    });
    inAppReviewAvailable.value = await inAppReview.isAvailable();

    super.onInit();
  }

  /// Change Network
  Future<void> changeNetwork(NetworkType value) async {
    await RpcService.setNetworkType(value);
    networkType.value = value;
  }

  /// Change Node
  Future<void> changeNode(NodeModel value) async {
    selectedNode.value = value;
    ServiceConfig.currentSelectedNode = value.url!;
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
  void removeAccount(int index) {
    if (homePageController.userAccounts.length > 1) {
      homePageController
        ..userAccounts.removeAt(index)
        ..userAccounts[0].isAccountPrimary = true;
      _updateUserAccountsValue();
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

  /// Updates the user accounts list with the latest modifications
  Future<void> _updateUserAccountsValue() async {
    await UserStorageService().updateAccounts(homePageController.userAccounts);
    homePageController.userAccounts.value =
        await UserStorageService().getAllAccount();
  }

  /// Updates the user accounts profile name with the latest name changes
  void editAccountName(int index, String name) {
    homePageController.userAccounts[index].name = name;
    _updateUserAccountsValue();
  }

  void switchFingerprint(bool value) => fingerprint.value = value;
  void checkWalletBackup() async {
    if (isWalletBackup.value) {
      Get.bottomSheet(BackupPage(), isScrollControlled: true);
    } else {
      final seedPhrase = await UserStorageService()
          .readAccountSecrets(
              Get.find<HomePageController>().userAccounts[0].publicKeyHash!)
          .then((value) {
        return value?.seedPhrase ?? "";
      });
      Get.bottomSheet(
              BackupWalletView(
                seedPhrase: seedPhrase,
              ),
              barrierColor: Colors.transparent,
              enterBottomSheetDuration: const Duration(milliseconds: 180),
              exitBottomSheetDuration: const Duration(milliseconds: 150),
              isScrollControlled: true)
          .whenComplete(() async =>
              isWalletBackup.value = await AuthService().getIsWalletBackup());
    }
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
        Get.showSnackbar(const GetSnackBar(
          message: "Copied to clipboard",
          duration: Duration(seconds: 2),
        ));
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
