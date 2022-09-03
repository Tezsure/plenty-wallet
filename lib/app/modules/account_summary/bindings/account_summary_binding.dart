import 'package:get/get.dart';

import '../controllers/account_summary_controller.dart';

class AccountSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountSummaryController>(
      () => AccountSummaryController(),
    );
  }
}
