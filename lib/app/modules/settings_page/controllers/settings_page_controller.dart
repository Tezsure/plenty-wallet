import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/models/dapp_model.dart';
import 'package:naan_wallet/app/modules/settings_page/models/node_model.dart';

import '../../../data/services/enums/enums.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../../data/services/service_models/account_model.dart';
import '../../../data/services/user_storage_service/user_storage_service.dart';
import '../../home_page/controllers/home_page_controller.dart';

class SettingsPageController extends GetxController {
  final homePageController = Get.find<HomePageController>();
  RxBool backup = true.obs;
  RxBool fingerprint = false.obs;
  Rx<NetworkType> networkType = NetworkType.mainNet.obs;
  RxList<NodeModel> nodes = <NodeModel>[].obs;
  Rx<NodeModel> selectedNode =
      NodeModel(title: "title1", address: "address1").obs;
  RxList<DappModel> dapps = List.generate(
      4,
      (index) => DappModel(
          imgUrl: "", name: "dapp", networkType: NetworkType.mainNet)).obs;

  Rx<ScrollController> scrollcontroller = ScrollController().obs;

  TextEditingController accountNameController = TextEditingController();

  AccountProfileImageType currentSelectedType = AccountProfileImageType.assets;

  RxString selectedImagePath = "".obs;

  RxBool isScrolling = false.obs;
  RxBool isRearranging = false.obs;
  RxBool copyToClipboard = false.obs;

  @override
  void onInit() {
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
    super.onInit();
  }

  /// Make the account primary and move it to the top of the list,if it's already primary do nothing i.e. return
  void makePrimaryAccount(int index) {
    for (var element in homePageController.userAccounts) {
      element.isAccountPrimary = false;
    }
    AccountModel account = homePageController.userAccounts[index];
    account.isAccountPrimary = true;
    homePageController.userAccounts
      ..removeAt(index)
      ..insert(0, account);
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

  void editPrimaryAccountStatus(int index) {
    homePageController.userAccounts[index].isAccountPrimary =
        !homePageController.userAccounts[index].isAccountPrimary!;
    makePrimaryAccount(index);
    Get.back();
  }

  /// Changes the user account to hidden state on the home page
  void editHideThisAccountStatus(int index) {
    homePageController.userAccounts[index].isAccountHidden =
        !homePageController.userAccounts[index].isAccountHidden!;
    _updateUserAccountsValue();
  }

  /// Updates the user accounts list with the latest modifications
  Future<void> _updateUserAccountsValue() async {
    await UserStorageService().updateAccounts(homePageController.userAccounts);
    await UserStorageService().getAllAccount();
  }

  /// Updates the user accounts profile name with the latest name changes
  void editAccountName(int index, String name) {
    homePageController.userAccounts[index].name = name;
    _updateUserAccountsValue();
  }

  void switchFingerprint(bool value) => fingerprint.value = value;
  void switchbackup() => backup.value = !backup.value;

  SettingsPageController() {
    nodes.value = List.generate(5,
        (index) => NodeModel(title: "title$index", address: "address$index"));

    selectedNode.value = nodes[0];
  }

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
    super.dispose();
  }
}
