import 'package:get/get.dart';

import '../controllers/delegate_widget_controller.dart';

class DelegateWidgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DelegateWidgetController>(
      () => DelegateWidgetController(),
    );
  }
}
