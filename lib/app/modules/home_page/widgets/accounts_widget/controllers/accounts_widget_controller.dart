import 'package:get/get.dart';

class AccountsWidgetController extends GetxController {
  final List<String> imagePath = [
    'assets/svg/accounts/account_1.svg',
    'assets/svg/accounts/account_2.svg',
    'assets/svg/accounts/account_3.svg'
  ]; // Background Images for Accounts container

  final RxInt selectedAccountIndex = 0.obs; // Current Visible Account Container

  /// Change the current index to the new index of visible account container
  void onPageChanged(int index) {
    selectedAccountIndex.value = index;
  }
}
