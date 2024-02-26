import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:plenty_wallet/app/data/services/foundation_service/art_foundation_handler.dart';
import 'package:plenty_wallet/app/data/services/re_service/re_service.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:simple_gql/simple_gql.dart';

import '../../../data/services/rpc_service/http_service.dart';

class SplashPageController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();

    bool firstRun = await IsFirstRun.isFirstRun();

    if (firstRun) {
      await ServiceConfig().clearStorage();
    }
    // check for device is secure
    if ((await ReService().checkIfDeviceRunningSercure()) == false) {
      // show device is insecure dialog and timer closing app in 10 seconds
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.arP)),
          backgroundColor: ColorConst.darkGrey,
          title: Text(
            "Sorry! Looks like your device is not secure.",
            style: titleMedium,
          ),
          content: const Text("Closing app in 10 seconds..."),
        ),
        barrierDismissible: false,
      );
      await Future.delayed(const Duration(seconds: 10));
      exit(0);
    }

    await ServiceConfig.hiveStorage.init();
    //await ServiceConfig().clearStorage();
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      var updateInfo = await fetchUpdateInfo();

      if (updateInfo != false) {
        if (isUpdateRequired(
            packageInfo.version, updateInfo["minimum_version"])) {
          Get.offAndToNamed(
            Routes.FORCED_UPDATE_PAGE,
            arguments: [
              updateInfo["update_text"],
            ],
          );
          return;
        }
      }

      // throw Exception();
      ServiceConfig.currentSelectedNode = (await RpcService.getCurrentNode()) ??
          ServiceConfig.currentSelectedNode;
      // try {
      //   await DataHandlerService().initDataServices();
      // } catch (e) {}

      ServiceConfig.currentNetwork = (await RpcService.getCurrentNetworkType());
      try {
        ServiceConfig.ipfsUrl = (await RpcService.getIpfsUrl()).trim();
      } catch (e) {}
      try {
        ServiceConfig.isIAFWidgetVisible = false;
        ServiceConfig.isTezQuakeWidgetVisible = false;
        ServiceConfig.isVCAWidgetVisible = false;
        ServiceConfig.isTeztownWidgetVisible = false;
        ServiceConfig.isAdmireArtWidgetVisible =
            (await getWidgetVisibility('admire-art-visible'));

        ServiceConfig.nftClaimWidgets = await getNftClaimWidgets();

        // ServiceConfig.isVCARedeemPOAPWidgetVisible =
        //     (await getWidgetVisibility('vca-redeem-poap-nft-widget-visiable'));
        // ServiceConfig.isVCAExploreNFTWidgetVisible = (await getWidgetVisibility(
        //     'vca-explore-and-buy-nft-widget-visiable'));
      } catch (e) {
        debugPrint("error a : $e");
      }
      try {
        AppConstant.naanCollection =
            (await ArtFoundationHandler.getCollectionNfts(
                "tz1YNsgF2iJUwuJf1SVNFjNfnzqDAdx6HNP8"));
      } catch (e) {}

      // VCA stuff

      // ServiceConfig.randomVcaNft = await randomVCA();
      try {
        AppConstant.tfCollection =
            (await ArtFoundationHandler.getCollectionNfts(
                "tz1XTEx1VGj6pm7Wh2Ni2hKQCWYSBxjnEsE1"));
      } catch (e) {}

      try {
        AppConstant.admireArtCollection =
            (await ArtFoundationHandler.getCollectionNfts(
                (await getAdmireArtCollection('admire-art-collection'))));

        ServiceConfig.admireArtUrl =
            (await getAdmireArtCollection('admire-art-url'));
      } catch (e) {}
      ServiceConfig.currency = await UserStorageService.getCurrency();
      // ServiceConfig.language =
      //     Language.values.byName(await UserStorageService.readLanguage());

      ServiceConfig.inr = await UserStorageService.getINR();
      ServiceConfig.eur = await UserStorageService.getEUR();
      ServiceConfig.aud = await UserStorageService.getAUD();

      var walletAccountsLength =
          (await UserStorageService().getAllAccount()).length;
      var watchAccountsLength =
          (await UserStorageService().getAllAccount(watchAccountsList: true))
              .length;

      Get.put(NftGalleryWidgetController(), permanent: true);
      Get.put(HomePageController(), permanent: true);

      if (walletAccountsLength != 0 || watchAccountsLength != 0) {
        bool isPasscodeSet = await AuthService().getIsPassCodeSet();

        // start data services

        if ((await ServiceConfig.secureLocalStorage
                    .readRaw(key: ServiceConfig.passCodeStorage) ??
                "")
            .toString()
            .contains("passcode_hash")) {
          await DataHandlerService().initDataServices();
        }

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
    } catch (e) {
      Zone.current.handleUncaughtError(e, StackTrace.current);
      Get.dialog(
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SplashWarningWidget(),
          ],
        ),
        barrierDismissible: false,
      );
      // Phoenix.rebirth(Get.context!);
    }
  }

  Future<bool> getWidgetVisibility(String id) async {
    String? response;
    try {
      response = await HttpService.performGetRequest(
          "https://cdn.naan.app/widgets_visibility");
      if (response.isNotEmpty && jsonDecode(response).length != 0) {
        return jsonDecode(response)[id] == 1;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> fetchUpdateInfo() async {
    String? response;
    try {
      response = await HttpService.performGetRequest(
          "https://cdn.naan.app/forced_update");
      if (response.isNotEmpty && jsonDecode(response).length != 0) {
        return jsonDecode(response);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  bool isUpdateRequired(String currentVersion, String minVersion) {
    List<int> currentParts =
        currentVersion.split('.').map((e) => int.parse(e)).toList();
    List<int> minParts =
        minVersion.split('.').map((e) => int.parse(e)).toList();

    for (int i = 0; i < 3; i++) {
      if (currentParts[i] < minParts[i]) {
        return true;
      } else if (currentParts[i] > minParts[i]) {
        return false;
      }
    }
    return false;
  }

  Future<String> getAdmireArtCollection(String id) async {
    String? response;
    try {
      response = await HttpService.performGetRequest(
          "https://cdn.naan.app/widgets_visibility");
      if (response.isNotEmpty && jsonDecode(response).length != 0) {
        return jsonDecode(response)[id];
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  Future<List> getNftClaimWidgets() async {
    String? response;
    try {
      response =
          await HttpService.performGetRequest("https://cdn.naan.app/campaigns");
      if (response.isNotEmpty && jsonDecode(response).length != 0) {
        return jsonDecode(response)["campaigns"];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // static randomVCA() async {
  //   var response =
  //       await HttpService.performGetRequest("${ServiceConfig.naanApis}/vca");

  //   var x = jsonDecode(response)["gallery"];
  //   int random = Random().nextInt(x.length);
  //   List<String> mainUrl = x[random]["url"]
  //       .toString()
  //       .replaceFirst("https://objkt.com/asset/", '')
  //       .split("/");
  //   return NftTokenModel(
  //     faContract: mainUrl[0],
  //     tokenId: mainUrl[1],
  //   );
  // }

  static printPk() async {
    {
      var response = await HttpService.performGetRequest(
          "${ServiceConfig.naanApis}/generate_pk");

      if (response.isNotEmpty) {
        var x = jsonDecode(response)["gallery"];
        x.forEach((e) async {
          List<String> mainUrl = e
              .toString()
              .replaceFirst("https://objkt.com/asset/", '')
              .split("/");
          GQLResponse response;
          if (mainUrl[0].startsWith('KT1')) {
            response = await GQLClient(
              'https://data.objkt.com/v3/graphql',
            ).query(
              query: r'''
          query NftDetails($address: String!, $tokenId: String!) {
            token(where: {token_id: {_eq: $tokenId}, fa_contract: {_eq: $address}}) {
              pk
            }
          }
      ''',
              variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
            );
          } else {
            response = await GQLClient(
              'https://data.objkt.com/v3/graphql',
            ).query(
              query: r'''
            query NftDetails($address: String!, $tokenId: String!) {
              token(where: {token_id: {_eq: $tokenId}, fa: {path: {_eq: $address}}}) {
                pk
              }
            }
      ''',
              variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
            );
          }
          debugPrint(
              "{\"url\":$e ,\"pk\":${response.data["token"][0]["pk"]}},");
        });
      }
    }
  }
}

class SplashWarningWidget extends StatelessWidget {
  const SplashWarningWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.arP)),
      backgroundColor: ColorConst.darkGrey,
      title: Text(
        "Sorry! Looks like an error has occurred.",
        style: titleMedium,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'We apologize for the inconvenience. This issue is currently affecting some of our users. To resolve the problem, please try the following steps:\n\n1. Long press on the Plenty Wallet app icon and select "App Info."\n2. Navigate to "Storage."\n3. Attempt to clear the app cache and open the app again.\n4. If step 3 doesn\'t work, try clearing the app data and opening the app. (Note: If you haven\'t backed up your seed phrase, don\'t perform this step as clearing app data will delete all data.)\n\nWe are actively working on a solution and will address this issue in our next update. Thank you for your patience.',
            style: bodyMedium,
          ),
          0.02.vspace,
        ],
      ),
    );
  }
}
