import 'package:get/get.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';

class InitialScreenBindings implements Bindings {
  String tag;

  InitialScreenBindings({required this.tag});

  @override
  void dependencies() {
    AppPages.routes.forEach((element) {
      element.binding?.dependencies();
    });
  }
}
