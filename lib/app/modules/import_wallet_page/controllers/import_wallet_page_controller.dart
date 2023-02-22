import 'dart:developer';

import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/tezos_domain_service/tezos_domain_service.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/data/services/wallet_service/wallet_service.dart';
import 'package:naan_wallet/app/modules/create_profile_page/controllers/create_profile_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
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
  RxList<AccountModel> generatedAccountsLegacy = <AccountModel>[].obs;
  RxBool isTz1Selected = true.obs;

  RxBool isLegacySelected = false.obs;

  RxList<AccountModel> get generatedAccounts =>
      isTz1Selected.value ? generatedAccountsTz1 : generatedAccountsTz2;

  // accounts imported;
  RxList<AccountModel> selectedAccountsTz1 = <AccountModel>[].obs;
  RxList<AccountModel> selectedLegacyAccount = <AccountModel>[].obs;

  RxList<AccountModel> selectedAccountsTz2 =
      <AccountModel>[].obs; // accounts selected;
  RxBool isExpanded = false.obs;

  ImportWalletDataType? importWalletDataType;

  TabController? tabController;

  //? FUNCTION

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    tabController!.addListener(() {
      isTz1Selected.value = tabController!.index == 0;
      isLegacySelected.value = tabController!.index == 2;
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
        importWalletDataType == ImportWalletDataType.watchAddress) {
      if ((await checkIfAlreadyPresent())) {
        return;
      }
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
          ..name = "Account ${accountLength + i}";
      }
      selectedAccounts.sort((a, b) =>
          b.importedAt!.millisecondsSinceEpoch -
          a.importedAt!.millisecondsSinceEpoch);
      // selectedAccountsTz1.value = selectedAccounts;
      // selectedAccounts. = selectedAccounts.value;
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
          tezAddress: 'Account with same address already exists',
          transactionAmount: 'Cannot import account',
        );
        return true;
      }
    } else if (importWalletDataType == ImportWalletDataType.privateKey) {
      final publicKeyHash = Dartez.getKeysFromSecretKey(phraseText.value)[2];
      if (accounts.any((element) =>
          element.publicKeyHash!.toLowerCase() ==
          publicKeyHash.toLowerCase())) {
        transactionStatusSnackbar(
          duration: const Duration(seconds: 2),
          status: TransactionStatus.error,
          tezAddress: 'Account with same private key already exists',
          transactionAmount: 'Cannot import account',
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

  Future<AccountModel?> genLegacyAccount() async {
    var account =
        await WalletService().genLegacy(phraseText.value.trim().toLowerCase());
    return account;
  }

  RxBool isLoading = false.obs;
  Future<void> genAndLoadMoreAccounts(int startIndex, int size) async {
    if (startIndex == 0) {
      generatedAccounts.value = <AccountModel>[];
      generatedAccounts.add((await genLegacyAccount())!);
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    // for (var i = startIndex; i < startIndex + size; i++) {
    //   log("1:${DateTime.now().microsecondsSinceEpoch}");
    //   // if (i == 3) continue;
    //   generatedAccounts.add(await getAccountModelIndexAt(i));
    //   log("2:${DateTime.now().microsecondsSinceEpoch}");

    //   // log("$i: ${generatedAccounts[i].publicKeyHash}");
    // }
    // final response = await Future.wait<AccountModel>([
    //   ...List.generate(
    //       size, (index) => getAccountModelIndexAt(startIndex + index)).toList()
    // ]);
    // generatedAccounts.addAll(response);

    for (var i = startIndex; i < startIndex + size; i++) {
      log("1:${DateTime.now().microsecondsSinceEpoch}");
      final account = await getAccountModelIndexAt(i);
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
