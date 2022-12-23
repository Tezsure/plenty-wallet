import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';

class SplashPageController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    await Future.delayed(Duration(milliseconds: 1800));
    // un-comment below line to test onboarding flow multiple time

    // await ServiceConfig().clearStorage();

    ServiceConfig.currentSelectedNode = (await RpcService.getCurrentNode()) ??
        ServiceConfig.currentSelectedNode;
    await DataHandlerService().initDataServices();

    var walletAccountsLength =
        (await UserStorageService().getAllAccount()).length;
    var watchAccountsLength =
        (await UserStorageService().getAllAccount(watchAccountsList: true))
            .length;

    if (walletAccountsLength != 0 || watchAccountsLength != 0) {
      bool isPasscodeSet = await AuthService().getIsPassCodeSet();

      /// ask for auth and redirect to home page
      Get.offAllNamed(
        Routes.PASSCODE_PAGE,
        arguments: [
          isPasscodeSet,
          Routes.HOME_PAGE,
        ],
      );
    } else {
      Get.offAndToNamed(
        Routes.ONBOARDING_PAGE,
      );
      // Future.delayed(
      //   const Duration(seconds: 1),
      //   () => Get.offAndToNamed(
      //     Routes.ONBOARDING_PAGE,
      //   ),
      // );
    }
  }
}
