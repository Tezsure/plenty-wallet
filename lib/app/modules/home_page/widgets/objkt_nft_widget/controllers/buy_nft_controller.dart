import 'package:dartez/models/key_store_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/helpers/on_going_tx_helper.dart';
import 'package:naan_wallet/app/data/services/operation_service/operation_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_batch_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/dapp_browser/controllers/dapp_browser_controller.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/buy_nft_success_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/fees_summary.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/review_nft.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_model.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:simple_gql/simple_gql.dart';

class BuyNFTController extends GetxController {
  Rx<AccountTokenModel?> selectedToken = null.obs;
  String url = "";

  List<String> mainUrl = [];
  final selectedNFT = Rxn<NftTokenModel?>();

  void selectMethod(AccountTokenModel token) async {
    selectedToken = token.obs;
    final accountToken = Get.find<AccountSummaryController>();
    Get.back();
    String priceInToken = ((((int.parse(selectedNFT.value!.lowestAsk) / 1e6) *
                    accountToken.xtzPrice.value) *
                1.1) /
            double.parse(token.currentPrice.toString()))
        .toString(); // todo check calculation
    var transactionResult;
/*     if (token.symbol == "USDt") {
      List<OperationModelBatch> opreateList = [
        OperationModelBatch(
                        destination: "KT1XnTn74bUtxHfDtBmm2bGZAQfhPbvKWR8o",
              amount: 0,
              entrypoint: "transfer",
              parameters: """[ { "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] } ] } ] ] } ]"""
        ),
                OperationModelBatch(
                        destination: "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
              amount: 0,
              entrypoint: "routerSwap",
              parameters:  """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1D1NcffeDR3xQ75fUFoJXZzD6WQp96Je3L" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
        ),

      ];
      transactionResult = await OperationService().preApplyOperationBatch(
        opreateList,
        ServiceConfig.currentSelectedNode,
                    KeyStoreModel(
              publicKey: (await UserStorageService()
                      .readAccountSecrets(accountModels.value!.publicKeyHash!))!
                  .publicKey,
              secretKey: (await UserStorageService()
                      .readAccountSecrets(accountModels.value!.publicKeyHash!))!
                  .secretKey,
              publicKeyHash: accountModels.value!.publicKeyHash!,
            ),

      );

      transactionResult = await TezsterDart.sendContractInvocationOperation(
        "https://mainnet.smartpy.io",
        transactionSigner,
        keyStore,
        [
          "KT1XnTn74bUtxHfDtBmm2bGZAQfhPbvKWR8o",
          "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
        ],
        [0, 0],
        120000,
        1000,
        100000,
        ['transfer', 'routerSwap'],
        [
          """[ { "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] } ] } ] ] } ]""",
          //"""{ "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1D1NcffeDR3xQ75fUFoJXZzD6WQp96Je3L" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "prim": "Pair", "args": [ { "int": "${(double.parse(priceInUSDT) * 1e6).toStringAsFixed(0)}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] }""",
          """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1D1NcffeDR3xQ75fUFoJXZzD6WQp96Je3L" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
          //"""{ "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "None" } ] }"""
        ],
        codeFormat: TezosParameterFormat.Micheline,
      );
      setState(() {
        loading = false;
      });
    } else if (widget.token == "uUSD") {
      priceInToken =
          (((int.parse(nft.lowestAsk) / 1e6) * tezPrice) * 1.1).toString();
      transactionResult = await TezsterDart.sendContractInvocationOperation(
        "https://mainnet.smartpy.io",
        transactionSigner,
        keyStore,
        [
          "KT1XRPEPXbZK25r3Htzp2o1x7xdMMmfocKNW",
          "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
        ],
        [0, 0],
        120000,
        1000,
        100000,
        ['transfer', 'routerSwap'],
        [
          """[ { "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken) * 1e12).toStringAsFixed(0)}" } ] } ] } ] ] } ]""",
          """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1Ji4hVDeQ5Ru7GW1Tna9buYSs3AppHLwj9" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1UsSfaXyqcjSVPeiD7U1bWgKy3taYN7NWY" }, { "int": "2" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1Dhy1gVW3PSC9cms9QJ7xPMPPpip2V9aA6" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "2" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e12).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
        ],
        codeFormat: TezosParameterFormat.Micheline,
      );
      setState(() {
        loading = false;
      });
    } else if (widget.token == "kUSD") {
      priceInToken =
          (((int.parse(nft.lowestAsk) / 1e6) * tezPrice) * 1.1).toString();
      transactionResult = await TezsterDart.sendContractInvocationOperation(
        "https://mainnet.smartpy.io",
        transactionSigner,
        keyStore,
        [
          "KT1K9gCRgaLRFKTErYt1wVxA3Frb9FjasjTV",
          "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
        ],
        [0, 0],
        120000,
        1000,
        100000,
        ['transfer', 'routerSwap'],
        [
          """{ "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "int": "${(double.parse(priceInToken) * 1e18).toStringAsFixed(0)}" } ] } ] }""",
          """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1HgFcDE8ZXNdT1aXXKpMbZc6GkUS2VHiPo" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1UsSfaXyqcjSVPeiD7U1bWgKy3taYN7NWY" }, { "int": "2" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1Dhy1gVW3PSC9cms9QJ7xPMPPpip2V9aA6" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "2" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e18).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
        ],
        codeFormat: TezosParameterFormat.Micheline,
      );
      setState(() {
        loading = false;
      });
    } else if (widget.token == "EURL") {
      priceInToken =
          (((int.parse(nft.lowestAsk) / 1e6) * tezPrice) * 1.1).toString();
      transactionResult = await TezsterDart.sendContractInvocationOperation(
        "https://mainnet.smartpy.io",
        transactionSigner,
        keyStore,
        [
          "KT1JBNFcB5tiycHNdYGYCtR3kk6JaJysUCi8",
          "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
        ],
        [0, 0],
        120000,
        1000,
        100000,
        ['transfer', 'routerSwap'],
        [
          """[ { "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, [ { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "prim": "Pair", "args": [ { "int": "0" }, { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] } ] } ] ] } ]""",
          """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1LqEgLikLE2obnyzgPJA6vMtnnG5agXVCn" }, { "int": "0" } ] }, { "prim": "Pair", "args": [ { "string": "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4" }, { "int": "0" } ] } ] } ] }, { "prim": "Elt", "args": [ { "int": "1" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
        ],
        codeFormat: TezosParameterFormat.Micheline,
      );
      setState(() {
        loading = false;
      });
    } else if (widget.token == "ctez") {
      priceInToken =
          (((int.parse(nft.lowestAsk) / 1e6) * tezPrice) * 1.1).toString();
      transactionResult = await TezsterDart.sendContractInvocationOperation(
        "https://mainnet.smartpy.io",
        transactionSigner,
        keyStore,
        [
          "KT1SjXiUX63QvdNMcM2m492f7kuf8JxXRLp4",
          "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4",
        ],
        [0, 0],
        120000,
        1000,
        100000,
        ['transfer', 'routerSwap'],
        [
          """{ "prim": "Pair", "args": [ { "string": "${keyStore.publicKeyHash}" }, { "prim": "Pair", "args": [ { "string": "KT1JoZgGSgiW4xWLMRgcN1GgqZNwCHsxkjQ4" }, { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] } ] }""",
          """{ "prim": "Pair", "args": [ { "prim": "Pair", "args": [ [ { "prim": "Elt", "args": [ { "int": "0" }, { "prim": "Pair", "args": [ { "prim": "Pair", "args": [ { "string": "KT1CAYNQGvYSF5UvHK21grMrKpe2563w9UcX" }, { "int": "${nft.lowestAsk}" } ] }, { "prim": "Pair", "args": [ { "string": "KT1BG1oEqQckYBRBCyaAcq1iQXkp8PVXhSVr" }, { "int": "0" } ] } ] } ] } ], { "int": "${(double.parse(priceInToken) * 1e6).toStringAsFixed(0)}" } ] }, { "prim": "Pair", "args": [ { "int": "${nft.buyId}" }, { "prim": "Pair", "args": [ { "int": "${nft.lowestAsk}" }, { "string": "${keyStore.publicKeyHash}" } ] } ] } ] }"""
        ],
        codeFormat: TezosParameterFormat.Micheline,
      );
      setState(() {
        loading = false;
      });
    }
    print("NFT Price in Token: $priceInToken ${token.symbol}"); */

    Get.bottomSheet(
      ReviewNFTSheet(),
      isScrollControlled: true,
      settings: RouteSettings(
        arguments: url,
      ),
    );
  }

  @override
  void onInit() async {
    super.onInit();
    await getNFTdata();
  }

  getNFTdata() async {
    try {
      DappBrowserController dappBrowserController =
          Get.find<DappBrowserController>();
      url = dappBrowserController.url.value;
      mainUrl = url
          .toString()
          .replaceFirst("https://objkt.com/asset/", '')
          .split("/");
      var response;
      if (mainUrl[0].startsWith('KT1')) {
        response = await GQLClient(
          'https://data.objkt.com/v2/graphql',
        ).query(
          query: r'''
          query NftDetails($address: String!, $tokenId: String!) {
            token(where: {token_id: {_eq: $tokenId}, fa_contract: {_eq: $address}}) {
              description
              name
              fa_contract
              asks(limit: 1,where: {status: {_eq: "active"}}, order_by: {price: asc}) {
                id
                price
              }
            }
          }
      ''',
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      } else {
        response = await GQLClient(
          'https://data.objkt.com/v2/graphql',
        ).query(
          query: r'''
          query NftDetails($address: String!, $tokenId: String!) {
            token(where: {token_id: {_eq: $tokenId}, fa: {path: {_eq: $address}}}) {
              description
              asks(limit: 1,where: {status: {_eq: "active"}}, order_by: {price: asc}) {
                id
                price
              }
              name
              fa_contract
            }
          }
      ''',
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      }
      print("nft response ${response}");
      selectedNFT.value = NftTokenModel(
          tokenId: response.data["token"][0]["asks"][0]["id"]
              .toString(), //cheat just for this module( Assiging buyId to tokenId)

          lowestAsk: response.data["token"][0]["asks"][0]["price"].toString(),
          name: response.data["token"][0]["name"],
          description: response.data["token"][0]["description"],
          faContract: response.data["token"][0]["fa_contract"]);
    } catch (e) {
      print("yo");
      print(e);
    }
  }

  void buyWithCreditCard() {
    print("buy with credit card");
    if (selectedNFT.value == null) return;
    Get.back();
/*     Get.bottomSheet(
      const DappBrowserView(
        tagString: "2",
      ),
      settings: RouteSettings(
        arguments:
            "https://naan-nft-credit-card.netlify.app/?fa=${mainUrl[0]}&tokenId=${mainUrl[1]}&address=tz1WDRu8H4dHbUwygocLsmaXgHthGiV6JGJG&askId=${selectedNFT.value!.tokenId}&askPrice=${selectedNFT.value!.lowestAsk}&name=${selectedNFT.value!.name}",
      ),
      enterBottomSheetDuration: const Duration(milliseconds: 180),
      exitBottomSheetDuration: const Duration(milliseconds: 150),
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      barrierColor: const Color.fromARGB(09, 255, 255, 255),
    ); */
    DappBrowserController dappBrowserController =
        Get.find<DappBrowserController>();

    dappBrowserController.webViewController!.loadUrl(
        urlRequest: URLRequest(
            url: Uri.parse(
                "https://naan-nft-credit-card.netlify.app/?fa=${mainUrl[0]}&tokenId=${mainUrl[1]}&address=tz1WDRu8H4dHbUwygocLsmaXgHthGiV6JGJG&askId=${selectedNFT.value!.tokenId}&askPrice=${selectedNFT.value!.lowestAsk}&name=${selectedNFT.value!.name}")));
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

  Future<void> onConfirm(OperationModel operationModel, String opHash) async {
    DataHandlerService().onGoingTxStatusHelpers.add(OnGoingTxStatusHelper(
        opHash: opHash,
        status: TransactionStatus.pending,
        transactionAmount: operationModel.amount == 0.0
            ? "1 ${operationModel.model.nodes}"
            : operationModel.amount!.toStringAsFixed(6).removeTrailing0 +
                " " +
                (operationModel.model as AccountTokenModel).symbol!,
        tezAddress: operationModel.receiveAddress!.tz1Short()));
    transactionStatusSnackbar(
      status: TransactionStatus.pending,
      tezAddress: operationModel.receiveAddress!.tz1Short(),
      transactionAmount: operationModel.amount == 0.0
          ? "1 ${operationModel.model.nodes}"
          : operationModel.amount!.toStringAsFixed(6).removeTrailing0 +
              " " +
              (operationModel.model as AccountTokenModel).symbol!,
    );
  }
}
