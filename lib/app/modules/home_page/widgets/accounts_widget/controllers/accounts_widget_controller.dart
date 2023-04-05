import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/wallet_service/wallet_service.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';

class AccountsWidgetController extends GetxController {
  final homeController = Get.find<HomePageController>();
  Rx<PageController> pageController = PageController(
    keepPage: true,
    viewportFraction: 1,
    initialPage: 0,
  ).obs;
  final List<String> imagePath = [
    'assets/svg/accounts/account_1.svg',
    'assets/svg/accounts/account_2.svg',
    'assets/svg/accounts/account_3.svg'
  ]; // Background Images for Accounts container

  RxInt currIndex = 0.obs; // Current Visible Account Container
  @override
  void onInit() async {
    currIndex.value = homeController.selectedIndex.value;
    pageController.value = PageController(
      keepPage: true,
      viewportFraction: 1,
      initialPage: currIndex.value,
    );
    await Future.delayed(const Duration(milliseconds: 300)).then((value) {
      onPageChanged(homeController.selectedIndex.value);
    });
    super.onInit();
  }

  /// Change the current index to the new index of visible account container
  void onPageChanged(int index) {
    try {
      if (pageController.value.page != index) {
        pageController.value.jumpToPage(
          index,
          // duration: const Duration(milliseconds: 100),
          // curve: Curves.easeIn,
        );
      }
      //homeController.selectedIndex.value = index;
      // if (currIndex.value != index) {
      // print("onPageChanged: $index");
      currIndex.value = index;
    } catch (e) {}
    // }
    // update();
  }

  /// add account functions
  TextEditingController accountNameController = TextEditingController();
  AccountProfileImageType currentSelectedType = AccountProfileImageType.assets;
  RxString phrase = "".obs;

  RxString selectedImagePath = "".obs;

  RxBool isPrimaryAccount = false.obs;
  RxBool isHiddenAccount = false.obs;

  RxBool isCreatingNewAccount = false.obs;
  FocusNode accountNameFocus = FocusNode();
  void initAddAccount() {
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
    accountNameController.text =
        "Account ${homeController.userAccounts.isEmpty ? 1 : homeController.userAccounts.length + 1}";
    // set selection at the end of the text
    accountNameController.selection = TextSelection.fromPosition(
      TextPosition(offset: accountNameController.text.length),
    );
    phrase.value = accountNameController.text.toString();
    accountNameFocus.requestFocus();
  }

  void closeAddAccount() {
    accountNameController.clear();
    accountNameFocus.unfocus();
  }

  void resetCreateNewWallet() {
    accountNameController = TextEditingController();
    currentSelectedType = AccountProfileImageType.assets;
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
    isCreatingNewAccount.value = false;
  }

  /// if no account exist then create otherwise import using same account mnemonic and +1derivationPath
  void createNewWallet() async {
    final account = await WalletService().createNewAccount(
      accountNameController.text,
      currentSelectedType,
      selectedImagePath.value,
    );
    if (account == null) return;
    resetCreateNewWallet();
    Get.back();
  }
}
