import 'dart:developer';

import 'package:dartez/dartez.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/enums/enums.dart';
import 'package:plenty_wallet/app/data/services/service_models/account_model.dart';
import 'package:plenty_wallet/app/data/services/tezos_domain_service/tezos_domain_service.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/data/services/wallet_service/eth_account_helper.dart';
import 'package:plenty_wallet/app/data/services/wallet_service/wallet_service.dart';
import 'package:plenty_wallet/app/modules/create_profile_page/controllers/create_profile_page_controller.dart';
import 'package:plenty_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';

import '../../create_profile_page/views/create_profile_page_view.dart';

class ImportWalletPageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  //? VARIABLES
  Rx<bool> showSuccessAnimation = false.obs; // to show success animation
  Rx<TextEditingController> phraseTextController = TextEditingController().obs;
  Rx<String> phraseText = "".obs; // to store phrase text
  RxList<AccountModel> generatedAccountsTz1 = <AccountModel>[].obs;
  RxList<AccountModel> generatedAccountsTz2 = <AccountModel>[].obs;
  RxList<AccountModel> generatedAccountsLegacy = <AccountModel>[].obs;
  RxList<AccountModel> genratedEthAccounts = <AccountModel>[].obs;
  RxBool isTz1Selected = true.obs;
  RxBool isLegacySelected = false.obs;
  RxBool isEvmSelected = false.obs;

  RxList<AccountModel> get generatedAccounts => isTz1Selected.value
      ? generatedAccountsTz1
      : tabController!.index == 3
          ? genratedEthAccounts
          : generatedAccountsTz2;

  // accounts imported;
  RxList<AccountModel> selectedAccountsTz1 = <AccountModel>[].obs;
  RxList<AccountModel> selectedLegacyAccount = <AccountModel>[].obs;

  RxList<AccountModel> selectedAccountsTz2 =
      <AccountModel>[].obs; // accounts selected;
  RxList<AccountModel> selectedEthAccounts = <AccountModel>[].obs;
  RxBool isExpanded = false.obs;

  ImportWalletDataType? importWalletDataType;

  TabController? tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController!.addListener(() {
      isTz1Selected.value = tabController!.index == 0;
      isLegacySelected.value = tabController!.index == 2;
      isEvmSelected.value = tabController!.index == 3;
    });
  }

  /// To paste the phrase from clipboard
  void paste() async {
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) {
      checkImportType(cdata.text!);
      phraseTextController.value.text = cdata.text!.trim();
      phraseText.value = cdata.text!.trim();
    }
  }

  /// To assign the phrase text to the phrase text variable
  void onTextChange(String value) {
    checkImportType(value);
    phraseText.value = value;
  }

  /// define based on phraseText.value that if it's mnemonic, private key or watch address
  void checkImportType(String value) {
    value = value.trim();
    importWalletDataType =
        (value.startsWith('edsk') || value.startsWith('spsk')) &&
                value.split(" ").length == 1
            ? ImportWalletDataType.privateKey
            : value.startsWith("tz1") ||
                    value.startsWith("tz2") ||
                    value.startsWith("tz3")
                ? ImportWalletDataType.watchAddress
                : value.split(" ").length == 12 || value.split(" ").length == 24
                    ? ImportWalletDataType.mnemonic
                    : value.endsWith('.tez')
                        ? ImportWalletDataType.tezDomain
                        : EthPrivateKeyValidator.isValid(value)
                            ? ImportWalletDataType.ethPrivateKey
                            : ImportWalletDataType.none;
  }

  List<AccountModel> selectedAccounts = [];
  Future<void> redirectBasedOnImportWalletType(
      [String? pageRoute, bool isWatchAddress = false]) async {
    if (isWatchAddress) {
      if (importWalletDataType == ImportWalletDataType.tezDomain) {
        var cModels =
            await TezosDomainService().searchUsingText(phraseText.value.trim());
        if (cModels.isNotEmpty) {
          var cModel = cModels[0];
          phraseText.value = cModel.address;
          importWalletDataType = ImportWalletDataType.watchAddress;
          // checkImportType(phraseText.value);
          final controller = Get.put(CreateProfilePageController());
          controller.selectedImagePath.value = cModel.imagePath;
          controller.accountNameController.value =
              TextEditingValue(text: cModel.name);
          controller.currentSelectedType = AccountProfileImageType.assets;
        } else {
          transactionStatusSnackbar(
            duration: const Duration(seconds: 2),
            status: TransactionStatus.error,
            tezAddress: "Invalid tezos domain.",
            transactionAmount: 'Cannot import',
          );
          return;
        }
      }
      if (importWalletDataType == ImportWalletDataType.watchAddress) {
        if ((await checkIfAlreadyPresent())) {
          return;
        }

        return Get.toNamed(Routes.CREATE_PROFILE_PAGE, arguments: [pageRoute]);
      }
    }
    if (importWalletDataType == ImportWalletDataType.tezDomain) {
      var cModels =
          await TezosDomainService().searchUsingText(phraseText.value.trim());
      if (cModels.isNotEmpty) {
        var cModel = cModels[0];
        phraseText.value = cModel.address;
        importWalletDataType = ImportWalletDataType.watchAddress;
        // checkImportType(phraseText.value);
        final controller = Get.put(CreateProfilePageController());
        controller.selectedImagePath.value = cModel.imagePath;
        controller.accountNameController.value =
            TextEditingValue(text: cModel.name);
        controller.currentSelectedType = AccountProfileImageType.assets;
      } else {
        transactionStatusSnackbar(
          duration: const Duration(seconds: 2),
          status: TransactionStatus.error,
          tezAddress: "Invalid tezos domain.",
          transactionAmount: 'Cannot import',
        );
        return;
      }
    }
    if (importWalletDataType == ImportWalletDataType.privateKey ||
        importWalletDataType == ImportWalletDataType.ethPrivateKey ||
        importWalletDataType == ImportWalletDataType.watchAddress) {
      if ((await checkIfAlreadyPresent())) {
        return;
      }
      var isPassCodeSet = await AuthService().getIsPassCodeSet();
      var previousRoute = pageRoute ?? Get.previousRoute;

      if (pageRoute == Routes.ACCOUNT_SUMMARY) {
        return CommonFunctions.bottomSheet(
            const CreateProfilePageView(isBottomSheet: true),
            fullscreen: true,
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
      var accountLength = ([
            ...(await UserStorageService().getAllAccount()),
            ...(await UserStorageService()
                .getAllAccount(watchAccountsList: true))
          ]).length +
          1;

      selectedAccounts = [
        ...selectedAccountsTz1,
        ...selectedAccountsTz2,
        ...selectedLegacyAccount
      ];

      for (var i = 0; i < selectedAccounts.length; i++) {
        selectedAccounts[i] = selectedAccounts[i]
          ..importedAt = DateTime.now()
          ..name = "Wallet ${accountLength + i}";
      }

      selectedAccounts = [
        ...selectedAccounts,
        ...selectedEthAccounts
            .map((element) => element
              ..importedAt = DateTime.now()
              ..name =
                  "Wallet ${accountLength + selectedAccounts.length} (EVM)")
            .toList()
      ];

      selectedAccounts.sort((a, b) =>
          b.importedAt!.millisecondsSinceEpoch -
          a.importedAt!.millisecondsSinceEpoch);
      Get.back();
      var isPassCodeSet = await AuthService().getIsPassCodeSet();
      var previousRoute = Get.previousRoute;

      if (pageRoute == Routes.ACCOUNT_SUMMARY) {
        return CommonFunctions.bottomSheet(
            const CreateProfilePageView(isBottomSheet: true),
            fullscreen: true,
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

  Future<bool> checkIfAlreadyPresent() async {
    UserStorageService userStorageService = UserStorageService();

    List<AccountModel> accounts = [
      ...(await userStorageService.getAllAccount(watchAccountsList: true)),
      ...(await userStorageService.getAllAccount()),
    ];
    if (importWalletDataType == ImportWalletDataType.watchAddress) {
      if (accounts.any((element) =>
          element.publicKeyHash!.toLowerCase() ==
          phraseText.value.toLowerCase())) {
        transactionStatusSnackbar(
          duration: const Duration(seconds: 2),
          status: TransactionStatus.error,
          tezAddress: 'Wallet with same address already exists',
          transactionAmount: 'Cannot import wallet',
        );
        return true;
      }
    } else if (importWalletDataType == ImportWalletDataType.privateKey) {
      final publicKeyHash =
          Dartez.getKeysFromSecretKey(phraseText.value).publicKeyHash;
      if (accounts.any((element) =>
          element.publicKeyHash!.toLowerCase() ==
          publicKeyHash.toLowerCase())) {
        transactionStatusSnackbar(
          duration: const Duration(seconds: 2),
          status: TransactionStatus.error,
          tezAddress: 'Wallet with same private key already exists',
          transactionAmount: 'Cannot import wallet',
        );
        return true;
      }
    }

    return false;
  }

  Future<AccountModel?> getAccountModelIndexAt(int index) async {
    var account = await WalletService().genAccountFromMnemonic(
        phraseText.value.trim().toLowerCase(), index, !isTz1Selected.value);
    return account;
  }

  Future<AccountModel?> getEthAccountModelIndexAt(int index) async {
    var account = await WalletService().genEthAccountFromMnemonic(
        phraseText.value.trim().toLowerCase(), index);
    return account;
  }

  Future<AccountModel?> genLegacyAccount() async {
    var account =
        await WalletService().genLegacy(phraseText.value.trim().toLowerCase());
    return account;
  }

  RxBool isLoading = false.obs;
  Future<void> genAndLoadMoreAccounts(int startIndex, int size,
      [bool isEvm = false]) async {
    if (startIndex == 0) {
      generatedAccounts.value = <AccountModel>[];
      generatedAccounts.add((await genLegacyAccount())!);
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    for (var i = startIndex; i < startIndex + size; i++) {
      log("1:${DateTime.now().microsecondsSinceEpoch}");

      final account = isEvm
          ? await getEthAccountModelIndexAt(i)
          : await getAccountModelIndexAt(i);
      if (account == null) continue;
      generatedAccounts.add(account);
      log("2:${DateTime.now().microsecondsSinceEpoch}");

      // log("$i: ${generatedAccounts[i].publicKeyHash}");
    }
    isLoading.value = false;

    generatedAccounts.value = [...generatedAccounts];
  }

  Future<void> toggleLoaderOverlay(Function() asyncFunction) async {
    await Get.showOverlay(
        asyncFunction: () async => await asyncFunction(),
        loadingWidget: const SizedBox(
          height: 50,
          width: 50,
          child: Center(
              child: CupertinoActivityIndicator(
            color: ColorConst.Primary,
          )),
        ));
    // if (Get.isOverlaysOpen) {
    //   Get.back();
    // }
  }

  @override
  void dispose() {
    phraseTextController.value.dispose();
    super.dispose();
  }
}
