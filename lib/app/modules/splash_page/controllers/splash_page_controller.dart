import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/foundation_service/art_foundation_handler.dart';
import 'package:naan_wallet/app/data/services/iaf/iaf_service.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:simple_gql/simple_gql.dart';

import '../../../data/services/rpc_service/http_service.dart';

class SplashPageController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      ServiceConfig.currentSelectedNode = (await RpcService.getCurrentNode()) ??
          ServiceConfig.currentSelectedNode;
      try {
        await DataHandlerService().initDataServices();
      } catch (e) {}

      ServiceConfig.currentNetwork = (await RpcService.getCurrentNetworkType());
      try {
        ServiceConfig.ipfsUrl = (await RpcService.getIpfsUrl()).trim();
      } catch (e) {}
      try {
        ServiceConfig.isIAFWidgetVisible =
            (await getWidgetVisibility('IAF-widget-visiable'));
        ServiceConfig.isTezQuakeWidgetVisible =
            (await getWidgetVisibility('tezquakeaid-widget-visiable'));
        ServiceConfig.isVCAWidgetVisible =
            (await getWidgetVisibility('vca-website-widget-visiable'));
        ServiceConfig.isTeztownWidgetVisible =
            (await getWidgetVisibility('sprint-fever-visible'));
        // ServiceConfig.isVCARedeemPOAPWidgetVisible =
        //     (await getWidgetVisibility('vca-redeem-poap-nft-widget-visiable'));
        // ServiceConfig.isVCAExploreNFTWidgetVisible = (await getWidgetVisibility(
        //     'vca-explore-and-buy-nft-widget-visiable'));
      } catch (e) {}
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
        SplashWarningWidget(),
        barrierDismissible: false,
      );
      // Phoenix.rebirth(Get.context!);
    }
  }

  String? response;
  Future<bool> getWidgetVisibility(String id) async {
    try {
      response ??= await HttpService.performGetRequest(
          "https://cdn.naan.app/widgets_visibility");
      if (response!.isNotEmpty && jsonDecode(response!).length != 0) {
        return jsonDecode(response!)[id] == 1;
      }
      return false;
    } catch (e) {
      return false;
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
          var response;
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
          print("{\"url\":$e ,\"pk\":${response.data["token"][0]["pk"]}},");
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
        "Something went wrong!",
        style: titleMedium,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1. Open "Settings".\n2. Select "Apps".\n3. Tap "naan" to clear cache.\n4. Select "Storage".\n5. Tap "Clear cache".',
            style: bodyMedium,
          ),
          0.02.vspace,
          Text(
            "If you've backed-up your wallet, we recommend to reset naan",
            style: bodyMedium.copyWith(color: ColorConst.NaanRed),
          ),
          0.02.vspace,
          optionMethod(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hold to reset naan".tr,
                    style: labelMedium.apply(color: ColorConst.Error.shade60),
                  ),
                ],
              ),
              onLongPress: () async {
                NaanAnalytics.logEvent(NaanAnalyticsEvents.RESET_NAAN);
                await ServiceConfig().clearStorage();
                Get.offAllNamed(Routes.ONBOARDING_PAGE);
              }),
        ],
      ),
    );
  }

  Widget optionMethod({
    Widget? child,
    GestureTapCallback? onTap,
    GestureTapCallback? onLongPress,
  }) {
    return Center(
      child: SolidButton(
        width: 1.width - 64.arP,
        primaryColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        onLongPressed: onLongPress,
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
