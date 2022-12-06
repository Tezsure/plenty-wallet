// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/backup_wallet_page/views/backup_wallet_view.dart';
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

  RxDouble xtzPrice = 0.0.obs;
  RxList<AccountModel> userAccounts = <AccountModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(NftGalleryWidgetController());
    DataHandlerService()
        .renderService
        .accountUpdater
        .registerVariable(userAccounts);

    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback((value) {
      xtzPrice.value = value;
      print("xtzPrice: $value");
      //update();
    });

    // DataHandlerService().renderService.accountNft.registerCallback((data) {
    //   print("Nft data");
    //   print(jsonEncode(data));
    // });
  }

  @override
  void onReady() {
    super.onReady();
    // showBackUpWalletBottomSheet(
    //     'cross boat human mammal rain twin inner garment lizard quick never lamp');
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
      BackupWalletBottomSheet(seedPhrase: seedPhrase),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      enableDrag: true,
      isDismissible: true,
      ignoreSafeArea: false,
    );
  }

  void onIndicatorTapped(int index) => selectedIndex.value = index;
}

class BackupWalletBottomSheet extends StatelessWidget {
  final String seedPhrase;
  const BackupWalletBottomSheet({
    Key? key,
    required this.seedPhrase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      gradientStartingOpacity: 1,
      blurRadius: 5,
      height: 350.arP,
      bottomSheetWidgets: [
        0.03.vspace,
        Text(
          'Backup your account',
          style: titleLarge,
        ),
        0.012.vspace,
        Text(
          'With no backup. Losing your device will result in the loss of access forever. The only way to guard against losses is to backup your wallet.',
          textAlign: TextAlign.start,
          style: bodySmall.copyWith(color: ColorConst.NeutralVariant.shade60),
        ),
        .03.vspace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.arP),
          child: SolidButton(
              width: 1.width,
              textColor: Colors.white,
              title: "Backup wallet ( ~1 min )",
              onPressed: () {
                Get.back();
                Get.bottomSheet(
                    BackupWalletView(
                      seedPhrase: seedPhrase,
                    ),
                    barrierColor: Colors.transparent,
                    enterBottomSheetDuration: const Duration(milliseconds: 180),
                    exitBottomSheetDuration: const Duration(milliseconds: 150),
                    isScrollControlled: true);
              }),
        ),
        0.012.vspace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.arP),
          child: SolidButton(
              borderWidth: 1,
              borderColor: ColorConst.Primary.shade80,
              primaryColor: Colors.transparent,
              width: 1.width,
              textColor: ColorConst.Primary.shade80,
              title: "I will risk it",
              onPressed: () => Get.back()),
        ),
        .01.vspace,
        const SafeArea(child: SizedBox.shrink())
      ],
    );
  }
}
