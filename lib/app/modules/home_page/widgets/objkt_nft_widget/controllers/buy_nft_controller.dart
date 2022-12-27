import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/buy_nft_success_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/fees_summary.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/review_nft.dart';

class BuyNFTController extends GetxController {
  Rx<AccountTokenModel?> selectedToken = null.obs;
  String url = "";
  Rx<NftTokenModel?> selectedNFT = NftTokenModel(
          artifactUri:
              "https://ipfs.io/ipfs/QmdcbZTmrFnBk2vowNshC7Cr2UwQW12C1iSc25WWP9o98y",
          name: "Landscape",
          lowestAsk: 100)
      .obs;
  void selectMethod(AccountTokenModel token) {
    selectedToken = token.obs;
    Get.back();
    Get.bottomSheet(
      ReviewNFTSheet(),
      isScrollControlled: true,
      settings: RouteSettings(
        arguments: url,
      ),
    );
  }

  void openFeeSummary() {
    Get.bottomSheet(
      FeesSummarySheet(),
      settings: RouteSettings(
        arguments: url,
      ),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: const Color.fromARGB(09, 255, 255, 255),
    );
  }

  void openSuccessSheet() async {
    final verified = await AuthService().verifyBiometricOrPassCode();
    if (verified) {
      Get
        ..back()
        ..back();
      Get.bottomSheet(
        const BuyNftSuccessSheet(),
        settings: RouteSettings(
          arguments: url,
        ),
        enterBottomSheetDuration: const Duration(milliseconds: 180),
        exitBottomSheetDuration: const Duration(milliseconds: 150),
        enableDrag: true,
        isDismissible: true,
        isScrollControlled: true,
        barrierColor: const Color.fromARGB(09, 255, 255, 255),
      );
    }
  }
}
