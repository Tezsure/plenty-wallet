import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/foundation_service/art_foundation_handler.dart';
import 'package:naan_wallet/app/data/services/iaf/iaf_service.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/constants/constants.dart';

import '../../../data/services/rpc_service/http_service.dart';

class SplashPageController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
/*     try {
      await Get.updateLocale(Locale("en", "US"));
      print("languageCode: ${Get.locale?.languageCode}");
    } catch (e) {} */
    await Future.delayed(const Duration(milliseconds: 1800));
    // un-comment below line to test onboarding flow multiple time

    // await ServiceConfig().clearStorage();

    ServiceConfig.currentSelectedNode = (await RpcService.getCurrentNode()) ??
        ServiceConfig.currentSelectedNode;
    await DataHandlerService().initDataServices();
    ServiceConfig.currentNetwork = (await RpcService.getCurrentNetworkType());
    ServiceConfig.ipfsUrl = (await RpcService.getIpfsUrl()).trim();
    ServiceConfig.isIAFWidgetVisible = (await IAFService.getWidgetVisibility());
    ServiceConfig.isTezQuakeWidgetVisible =
        (await getWidgetVisibility('tezquakeaid-widget-visiable'));
    AppConstant.naanCollection = (await ArtFoundationHandler.getCollectionNfts(
        "tz1YNsgF2iJUwuJf1SVNFjNfnzqDAdx6HNP8"));

    AppConstant.tfCollection = (await ArtFoundationHandler.getCollectionNfts(
        "tz1XTEx1VGj6pm7Wh2Ni2hKQCWYSBxjnEsE1"));

    ServiceConfig.currency = await UserStorageService.getCurrency();

    ServiceConfig.inr = await UserStorageService.getINR();
    ServiceConfig.eur = await UserStorageService.getEUR();

    var walletAccountsLength =
        (await UserStorageService().getAllAccount()).length;
    var watchAccountsLength =
        (await UserStorageService().getAllAccount(watchAccountsList: true))
            .length;

    Get.put(NftGalleryWidgetController(), permanent: true);

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

  static Future<bool> getWidgetVisibility(String id) async {
    try {
      var response = await HttpService.performGetRequest(
          "https://cdn.naan.app/widgets_visibility");

      if (response.isNotEmpty && jsonDecode(response).length != 0) {
        return jsonDecode(response)[id] == 1;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
