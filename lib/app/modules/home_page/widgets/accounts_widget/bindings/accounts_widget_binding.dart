import 'package:get/get.dart';

import '../controllers/accounts_widget_controller.dart';

class AccountsWidgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccountsWidgetController>(
      () => AccountsWidgetController(),
    );
  }
}
