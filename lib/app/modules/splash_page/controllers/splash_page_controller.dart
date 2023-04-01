import 'dart:async';
import 'dart:convert';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/foundation_service/art_foundation_handler.dart';
import 'package:naan_wallet/app/data/services/iaf/iaf_service.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/controller/nft_gallery_widget_controller.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
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

      await DataHandlerService().initDataServices();

      ServiceConfig.currentNetwork = (await RpcService.getCurrentNetworkType());
      try {
        ServiceConfig.ipfsUrl = (await RpcService.getIpfsUrl()).trim();
      } catch (e) {}
      try {
        ServiceConfig.isIAFWidgetVisible =
            (await getWidgetVisibility('IAF-widget-visiable'));
        ServiceConfig.isTezQuakeWidgetVisible =
            (await getWidgetVisibility('tezquakeaid-widget-visiable'));
        ServiceConfig.isVCAWebsiteWidgetVisible =
            (await getWidgetVisibility('vca-website-widget-visiable'));
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
      Phoenix.rebirth(Get.context!);
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
      var response =
          await HttpService.performGetRequest("${ServiceConfig.naanApis}/vca");

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
