import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/wallet_service/wallet_service.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';

class AccountsWidgetController extends GetxController {
  final homeController = Get.find<HomePageController>();
  PageController pageController = PageController(
    viewportFraction: 1,
    initialPage: 0,
  );
  final List<String> imagePath = [
    'assets/svg/accounts/account_1.svg',
    'assets/svg/accounts/account_2.svg',
    'assets/svg/accounts/account_3.svg'
  ]; // Background Images for Accounts container

  final RxInt currIndex = 0.obs; // Current Visible Account Container

  /// Change the current index to the new index of visible account container
  void onPageChanged(int index) {
    if (pageController.page != index) {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
    }
    print("onPageChanged: $index");
    homeController.selectedIndex.value = index;
    currIndex.value = index;
    update();
  }

  /// add account functions
  TextEditingController accountNameController = TextEditingController();
  AccountProfileImageType currentSelectedType = AccountProfileImageType.assets;
  RxString phrase = "".obs;

  RxString selectedImagePath = "".obs;

  RxBool isPrimaryAccount = false.obs;
  RxBool isHiddenAccount = false.obs;

  RxBool isCreatingNewAccount = false.obs;

  void initAddAccount() {
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
  }

  void closeAddAccount() {
    accountNameController.clear();
  }

  void resetCreateNewWallet() {
    accountNameController = TextEditingController();
    currentSelectedType = AccountProfileImageType.assets;
    selectedImagePath.value = ServiceConfig.allAssetsProfileImages[0];
    isCreatingNewAccount.value = false;
  }

  /// if no account exist then create otherwise import using same account mnemonic and +1derivationPath
  void createNewWallet() async {
    await WalletService().createNewAccount(
      accountNameController.text,
      currentSelectedType,
      selectedImagePath.value,
    );
    resetCreateNewWallet();
    Get.back();
  }
}
