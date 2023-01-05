import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/widgets/crypto_tab_widgets/token_checkbox.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/controllers/buy_nft_controller.dart';

import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/styles/styles.dart';

class ChoosePaymentMethod extends StatelessWidget {
  ChoosePaymentMethod({super.key});

  final List<String> displayCoins = [
    "tezos",
    'USDt',
    'uUSD',
    'kUSD',
    'EURL',
    "ctez",
  ];
  @override
  Widget build(BuildContext context) {
    final buyNftController = Get.put(BuyNFTController());
    final controller = Get.put(AccountSummaryController());
    return SizedBox(
      height: 0.7.height,
      child: NaanBottomSheet(
        height: 0.7.height,
        isScrollControlled: true,
        title: "Choose payment",
        bottomSheetHorizontalPadding: 16.arP,
        bottomSheetWidgets: [
          ListTile(
            onTap: buyNftController.buyWithCreditCard,
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: SvgPicture.asset("assets/svg/credit-card.svg"),
            title: Text(
              "Credit card",
              style: labelLarge,
            ),
            subtitle: Text(
              "Powered by wert.io",
              style: bodySmall.copyWith(color: ColorConst.textGrey1),
            ),
          ),
          const Divider(
            color: ColorConst.darkGrey,
            thickness: 1,
          ),
          Obx(
            () => controller.userTokens.isEmpty
                ? Container()
                : ListView.builder(
                    itemCount: displayCoins.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final token = controller.tokensList.firstWhereOrNull(
                          (p0) =>
                              displayCoins[index].toLowerCase() ==
                              p0.symbol!.toLowerCase());

                      var accountToken = controller.userTokens.firstWhereOrNull(
                          (p0) =>
                              displayCoins[index].toLowerCase() ==
                              p0.symbol!.toLowerCase());
                      if (token != null && accountToken == null) {
                        accountToken = AccountTokenModel(
                            name: token.name!,
                            symbol: token.symbol!,
                            iconUrl: token.thumbnailUri,
                            balance: 0,
                            currentPrice: token.currentPrice,
                            contractAddress: token.tokenAddress!,
                            tokenId: token.tokenId!,
                            decimals: token.decimals!);
                      }

                      if (displayCoins[index].toLowerCase() == "tezos") {
                        accountToken = controller.userTokens.firstWhereOrNull(
                                (element) =>
                                    element.symbol!.toLowerCase() == "tezos") ??
                            AccountTokenModel(
                                name: "Tezos",
                                symbol: "Tezos",
                                iconUrl: "assets/tezos_logo.png",
                                balance: 0,
                                currentPrice: controller.xtzPrice.value,
                                contractAddress: "xtz",
                                tokenId: "0",
                                decimals: 6);
                      }
                      return accountToken == null
                          ? Container()
                          : Obx(
                              () => _tokenBox(accountToken!, index,
                                  buyNftController, controller.xtzPrice.value),
                            );
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget noTokens() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        0.02.vspace,
        SvgPicture.asset(
          "assets/empty_states/empty1.svg",
          height: 120.aR,
        ),
        0.03.vspace,
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "No token found\n",
                style: titleLarge.copyWith(
                    fontWeight: FontWeight.w700, fontSize: 22.aR),
                children: [
                  WidgetSpan(child: 0.04.vspace),
                  TextSpan(
                      text:
                          "Buy or Transfer token from another\n wallet or elsewhere",
                      style: labelMedium.copyWith(
                          fontSize: 12.aR,
                          color: ColorConst.NeutralVariant.shade60))
                ])),
      ],
    );
  }

  Widget _tokenBox(AccountTokenModel token, int index,
          BuyNFTController buyNftController, double xtzPrice) =>
      TokenCheckbox(
        xtzPrice: xtzPrice,
        tokenModel: token,
        isEditable: false,
        onCheckboxTap: () => {buyNftController.selectMethod(token)},
      );
}
