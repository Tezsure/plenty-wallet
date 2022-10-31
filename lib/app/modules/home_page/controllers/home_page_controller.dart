// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/styles/styles.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/bottom_sheet.dart';
import '../../common_widgets/solid_button.dart';

class HomePageController extends GetxController with WidgetsBindingObserver {
  // RxBool showBottomSheet = false.obs;
  RxInt selectedIndex = 0.obs;

  // Liquidity Baking
  RxBool isEnabled = false.obs; // To animate LB Button
  final Duration animationDuration =
      const Duration(milliseconds: 100); // Toggle LB Button Animation Duration
  RxDouble sliderValue = 0.0.obs;

  RxList<AccountModel> userAccounts = <AccountModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(NftGalleryWidgetController());
    DataHandlerService()
        .renderService
        .accountUpdater
        .registerVariable(userAccounts);
    // DataHandlerService().renderService.accountNft.registerCallback((data) {
    //   print("Nft data");
    //   print(jsonEncode(data));
    // });
  }

  @override
  void onReady() {
    super.onReady();
    if (Get.arguments != null &&
        Get.arguments.length == 2 &&
        Get.arguments[1].toString().isNotEmpty) {
      showBackUpWalletBottomSheet(Get.arguments[1].toString());
    }
  }

  void onTapLiquidityBaking() {
    isEnabled.value = !isEnabled.value;
  }

  void onSliderChange(double value) {
    sliderValue.value = value;
  }

  void showBackUpWalletBottomSheet(String seedPhrase) {
    Get.bottomSheet(
      NaanBottomSheet(
        gradientStartingOpacity: 1,
        blurRadius: 5,
        isScrollControlled: true,
        title: 'Backup Your Wallet',
        bottomSheetWidgets: [
          Text(
            'With no backup. Losing your device will result in the loss of access forever. The only way to guard against losses is to backup your wallet.',
            textAlign: TextAlign.start,
            style: bodySmall.copyWith(color: ColorConst.NeutralVariant.shade60),
          ),
          .03.vspace,
          SolidButton(
              textColor: Colors.white,
              title: "Backup Wallet ( ~1 min )",
              onPressed: () => Get.toNamed(
                    Routes.BACKUP_WALLET,
                    arguments: seedPhrase,
                  )),
          0.012.vspace,
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            onPressed: () => Get.back(),
            child: Container(
              height: 48,
              width: 1.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ColorConst.Neutral.shade80,
                  width: 1.50,
                ),
              ),
              alignment: Alignment.center,
              child: Text("I will risk it",
                  style: titleSmall.apply(color: ColorConst.Primary.shade80)),
            ),
          ),
          .03.vspace,
        ],
      ),
      enableDrag: true,
      isDismissible: true,
      ignoreSafeArea: false,
    );
  }

  void onIndicatorTapped(int index) => selectedIndex.value = index;
}
