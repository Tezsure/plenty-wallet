import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/data/services/wallet_service/wallet_service.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

import '../../create_profile_page/views/create_profile_page_view.dart';

class ImportWalletPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //? VARIABLES
  Rx<bool> showSuccessAnimation = false.obs; // to show success animation
  Rx<TextEditingController> phraseTextController = TextEditingController().obs;
  Rx<String> phraseText = "".obs; // to store phrase text
  RxList<AccountModel> generatedAccountsTz1 = <AccountModel>[].obs;
  RxList<AccountModel> generatedAccountsTz2 = <AccountModel>[].obs;

  RxBool isTz1Selected = true.obs;

  RxList<AccountModel> get generatedAccounts =>
      isTz1Selected.value ? generatedAccountsTz1 : generatedAccountsTz2;

  // accounts imported;
  RxList<AccountModel> selectedAccountsTz1 = <AccountModel>[].obs;

  RxList<AccountModel> selectedAccountsTz2 =
      <AccountModel>[].obs; // accounts selected;
  RxBool isExpanded = false.obs;

  ImportWalletDataType? importWalletDataType;

  TabController? tabController;

  //? FUNCTION

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController!.addListener(() {
      isTz1Selected.value = tabController!.index == 0;
    });
  }

  /// To paste the phrase from clipboard
  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      checkImportType(cdata.text!);
      phraseTextController.value.text = cdata.text!;
      phraseText.value = cdata.text!;
    }
  }

  /// To assign the phrase text to the phrase text variable
  void onTextChange(String value) {
    checkImportType(value);
    phraseText.value = value;
  }

  /// define based on phraseText.value that if it's mnemonic, private key or watch address
  void checkImportType(value) => importWalletDataType =
      value.startsWith('edsk') || value.startsWith('spsk')
          ? ImportWalletDataType.privateKey
          : value.startsWith("tz1") ||
                  value.startsWith("tz2") ||
                  value.startsWith("tz3")
              ? ImportWalletDataType.watchAddress
              : value.split(" ").length == 12
                  ? ImportWalletDataType.mnemonic
                  : ImportWalletDataType.none;

  Future<void> redirectBasedOnImportWalletType([String? pageRoute]) async {
    if (importWalletDataType == ImportWalletDataType.privateKey ||
        importWalletDataType == ImportWalletDataType.watchAddress) {
      var isPassCodeSet = await AuthService().getIsPassCodeSet();
      var previousRoute = pageRoute ?? Get.previousRoute;

      if (pageRoute == Routes.ACCOUNT_SUMMARY) {
        return Get.bottomSheet(const CreateProfilePageView(isBottomSheet: true),
            enterBottomSheetDuration: const Duration(milliseconds: 180),
            exitBottomSheetDuration: const Duration(milliseconds: 150),
            isScrollControlled: true,
            settings: RouteSettings(arguments: [pageRoute]));
      }

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
    } else if (importWalletDataType == ImportWalletDataType.mnemonic) {
      var accountLength = (await UserStorageService().getAllAccount()).length;

      var selectedAccounts = selectedAccountsTz1 + selectedAccountsTz2;

      for (var i = 0; i < selectedAccounts.length; i++) {
        selectedAccounts[i] = selectedAccounts[i]
          ..name = "Account ${accountLength + i}";
      }
      selectedAccounts.value = selectedAccounts.value;
      Get.back();
      var isPassCodeSet = await AuthService().getIsPassCodeSet();
      var previousRoute = Get.previousRoute;

      if (pageRoute == Routes.ACCOUNT_SUMMARY) {
        return Get.bottomSheet(const CreateProfilePageView(isBottomSheet: true),
            enterBottomSheetDuration: const Duration(milliseconds: 180),
            exitBottomSheetDuration: const Duration(milliseconds: 150),
            isScrollControlled: true,
            settings: RouteSettings(arguments: [pageRoute]));
      }
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
    }
  }

  Future<AccountModel> getAccountModelIndexAt(int index) async {
    var account = await WalletService().genAccountFromMnemonic(
        phraseText.value.trim(), index, !isTz1Selected.value);
    return account;
  }

  Future<void> genAndLoadMoreAccounts(int startIndex, int size) async {
    if (startIndex == 0) generatedAccounts.value = <AccountModel>[];
    // toggleLoaderOverlay(() async {
    for (var i = startIndex; i < startIndex + size; i++) {
      generatedAccounts.add(await getAccountModelIndexAt(i));
      generatedAccounts.value = [...generatedAccounts];
    }
    // });
  }

  Future<void> toggleLoaderOverlay(Function() asyncFunction) async {
    await Get.showOverlay(
        asyncFunction: () async => await asyncFunction(),
        loadingWidget: const SizedBox(
          height: 50,
          width: 50,
          child: Center(
              child: CircularProgressIndicator(
            color: ColorConst.Primary,
          )),
        ));
    // if (Get.isOverlaysOpen) {
    //   Get.back();
    // }
  }

  /// load acounts
  void showMoreAccounts() {
    if (generatedAccounts.length + 4 < 100) {
      for (var i = 0; i < 4; i++) {
        // accounts.add(
        //   AccountModel(address: "tezdnenfjeb", balance: 60),
        // );
      }
    } else if (generatedAccounts.length < 100) {
      for (var i = 0; i < 2; i++) {
        // accounts.add(
        //   AccountModel(address: "tezdnenfjeb", balance: 60),
        // );
      }
    }
  }

  @override
  void dispose() {
    phraseTextController.value.dispose();
    super.dispose();
  }
}
