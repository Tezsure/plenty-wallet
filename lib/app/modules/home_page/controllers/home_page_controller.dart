// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/account_selector.dart';
import 'package:naan_wallet/app/modules/backup_wallet_page/views/backup_wallet_view.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/beta_tag_widget/beta_tag_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/scanQR/scan_qr.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/styles/styles.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/bottom_sheet.dart';
import '../../common_widgets/solid_button.dart';

import 'package:permission_handler/permission_handler.dart';

import '../widgets/scanQR/permission_sheet.dart';

class HomePageController extends GetxController {
  // RxBool showBottomSheet = false.obs;
  RxInt selectedIndex = 0.obs;

  // Liquidity Baking
  RxBool isEnabled = false.obs; // To animate LB Button
  final Duration animationDuration =
      const Duration(milliseconds: 100); // Toggle LB Button Animation Duration
  RxDouble sliderValue = 0.0.obs;

  RxDouble xtzPrice = 0.0.obs;
  RxDouble dayChange = 0.0.obs;

  RxList<AccountModel> userAccounts = <AccountModel>[].obs;
  @override
  void onInit() async {
    super.onInit();
    try {
      Get.put(BeaconService(), permanent: true);
    } catch (e) {}

    selectedIndex.listen((index) {
      print("${selectedIndex.value}${index}selectedIndex called");
    });
    DataHandlerService()
        .renderService
        .accountUpdater
        .registerCallback((accounts) async {
      List<AccountModel> account =
          (accounts ?? (<AccountModel>[])) as List<AccountModel>;
      // print("accountUpdater".toUpperCase());
      // print("${userAccounts.value.hashCode == accounts.hashCode}");
      if ((account.length) != userAccounts.length) {
        // userAccounts.value = [...(accounts ?? [])];
        account.sort((a, b) =>
            a.importedAt!.millisecondsSinceEpoch -
            b.importedAt!.millisecondsSinceEpoch);
        List temp = [];
        account.forEach((element) {
          if (!element.isWatchOnly) {
            temp.add(element);
          }
        });
        account.forEach((element) {
          if (element.isWatchOnly) {
            temp.add(element);
          }
        });
        int index = temp.indexWhere((element) {
          return !userAccounts.any(
              (element2) => element2.publicKeyHash == element.publicKeyHash);
        });
        userAccounts.value = [...temp];
        // Future.delayed(
        //   Duration(milliseconds: 100),
        // ).then((value) {
        try {
          if (Get.isRegistered<AccountsWidgetController>() && index != -1) {
            Get.find<AccountsWidgetController>().onPageChanged(index);
            changeSelectedAccount(index);
          }
        } catch (e) {
          log(e.toString());
        }
        // });
      } else {
        userAccounts.value = [...accounts];
      }
      try {
        if (userAccounts.where((p0) => !p0.isWatchOnly).isNotEmpty) {
          Future.delayed(const Duration(seconds: 1), () async {
            userAccounts[0].delegatedBakerAddress =
                await Get.put(DelegateWidgetController())
                    .getCurrentBakerAddress(userAccounts[0].publicKeyHash!);
            print("baker address :${userAccounts[0].delegatedBakerAddress}");
          });
        }
      } catch (e) {
        log(e.toString());
      }
    });

    // .registerVariable(userAccounts);

    DataHandlerService()
        .renderService
        .xtzPriceUpdater
        .registerCallback((value) {
      xtzPrice.value = value;
      print("xtzPrice: $value");
      //update();
    });

    DataHandlerService()
        .renderService
        .dayChangeUpdater
        .registerCallback((value) {
      dayChange.value = value;
      print("dayChange: $value");
      //update();
    });

    // DataHandlerService().renderService.accountNft.registerCallback((data) {
    //   print("Nft data");
    //   print(jsonEncode(data));
    // });
  }

  void resetUserAccounts() {
    userAccounts.clear();
    userAccounts.refresh();
    selectedIndex.value = 0;
  }

  @override
  void onReady() async {
    super.onReady();

    if (Get.currentRoute == Routes.HOME_PAGE) {
      if (Get.arguments != null &&
          Get.arguments.length == 2 &&
          Get.arguments[1].toString().isNotEmpty) {
        showBackUpWalletBottomSheet(Get.arguments[1].toString());
      }
      await UserStorageService.getBetaTagAgree().then((value) async {
        if (!value && Platform.isAndroid) {
          await CommonFunctions.bottomSheet(
            BetaTagSheet(),
          );
        }
      });
    }
  }

  void onTapLiquidityBaking() {
    isEnabled.value = !isEnabled.value;
  }

  void changeSelectedAccount(int index) async {
    print("On PAGECHANGED");
    // Get.find<AccountsWidgetController>().onPageChanged(index);
    if (userAccounts.isNotEmpty && userAccounts.length > index) {
      selectedIndex.value = index;

      userAccounts[index].delegatedBakerAddress =
          await Get.put(DelegateWidgetController())
              .getCurrentBakerAddress(userAccounts[index].publicKeyHash!);
      //Get.find<AccountsWidgetController>().onPageChanged(index);
      print("baker address :${userAccounts[index].delegatedBakerAddress}");
    }
  }

  void onSliderChange(double value) {
    sliderValue.value = value;
  }

  Future<void> showBackUpWalletBottomSheet(String seedPhrase) async {
    await CommonFunctions.bottomSheet(
      BackupWalletBottomSheet(seedPhrase: seedPhrase),
    );
  }

  Future<void> openScanner() async {
    if (userAccounts[selectedIndex.value].isWatchOnly) {
      return CommonFunctions.bottomSheet(AccountSelectorSheet(
        onNext: () {
          Get.back();
          openScanner();
        },
      ), fullscreen: true);
    }
    await Permission.camera.request();
    final status = await Permission.camera.status;

    if (status.isPermanentlyDenied) {
      CommonFunctions.bottomSheet(
        CameraPermissionHandler(
          callback: openScanner,
        ),
      );

      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    } else {
      CommonFunctions.bottomSheet(const ScanQrView(), fullscreen: true);
    }
  }

  // void onIndicatorTapped(int index) => selectedIndex.value = index;
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
      // gradientStartingOpacity: 1,
      // blurRadius: 5,
      height: 350.arP,
      bottomSheetWidgets: [
        0.03.vspace,
        Text(
          'Backup your wallet'.tr,
          style: titleLarge,
        ),
        0.012.vspace,
        Text(
          'With no backup losing your device will result in the loss of access forever. The only way to guard against losses is to backup your wallet.'
              .tr,
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
                NaanAnalytics.logEvent(NaanAnalyticsEvents.BACKUP_FROM_HOME);
                CommonFunctions.bottomSheet(
                    BackupWalletView(
                      seedPhrase: seedPhrase,
                    ),
                    fullscreen: true);
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
              onPressed: () {
                NaanAnalytics.logEvent(NaanAnalyticsEvents.BACKUP_SKIP);

                Get.back();
              }),
        ),
        BottomButtonPadding()
      ],
    );
  }
}
