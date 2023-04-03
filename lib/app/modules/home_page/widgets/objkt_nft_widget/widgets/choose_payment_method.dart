import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/widgets/crypto_tab_widgets/token_checkbox.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/list_tile.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/controllers/buy_nft_controller.dart';

import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/styles/styles.dart';

class ChoosePaymentMethod extends StatelessWidget {
  ChoosePaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSummaryController = Get.put(AccountSummaryController());

    final buyNftController = Get.put(BuyNFTController());
    return SizedBox(
      // height: 0.7.height,
      child: Obx(() {
        return NaanBottomSheet(
          // height: 0.7.height,
          isScrollControlled: true,
          title: "Choose payment",
          // bottomSheetHorizontalPadding: 16.arP,
          bottomSheetWidgets: [
            0.012.vspace,
            _buildBuyWithCreditCard(buyNftController, accountSummaryController),
            const Divider(
              color: ColorConst.darkGrey,
              thickness: 1,
            ),
            Obx(
              () => buyNftController.accountTokens.isEmpty
                  ? Center(child: noTokens())
                  : ListView.builder(
                      itemCount: buyNftController.accountTokens.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Obx(
                          () => _tokenBox(
                            accountSummaryController.xtzPrice.value,
                            buyNftController.accountTokens[index],
                            index,
                            buyNftController,
                          ),
                        );
                      },
                    ),
            ),
            BottomButtonPadding()
          ],
        );
      }),
    );
  }

  Widget _buildBuyWithCreditCard(BuyNFTController buyNftController,
      AccountSummaryController accountSummaryController) {
    if (buyNftController.selectedNFT.value == null) return Container();
    double priceInDollars =
        (double.parse(buyNftController.selectedNFT.value!.lowestAsk) / 1e6) *
            accountSummaryController.xtzPrice.value;
    if (priceInDollars < 5) {
      return NaanListTile(
        // onTap: buyNftController.buyWithCreditCard,
        // dense: true,
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset(
          "assets/svg/credit-card.svg",
          color: ColorConst.darkGrey,
        ),
        title: Text(
          "Credit card".tr,
          style: labelLarge.copyWith(color: ColorConst.NeutralVariant.shade60),
        ),
        subtitle: Text(
          "Credit card can’t be used for transactions less than \$5. You can purchase tez using credit card from “Buy Tez” widget on home page and come back here to buy the NFT.",
          style: bodySmall.copyWith(color: ColorConst.textGrey1),
        ),
      );
    }
    return NaanListTile(
      onTap: buyNftController.buyWithCreditCard,
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: SvgPicture.asset("assets/svg/credit-card.svg"),
      title: Text(
        "Credit card".tr,
        style: labelLarge,
      ),
      subtitle: Text(
        "${"Powered by".tr} wert.io",
        style: bodySmall.copyWith(color: ColorConst.textGrey1),
      ),
    );
  }

  Widget noTokens() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        CupertinoActivityIndicator(
          color: ColorConst.Primary,
        )
      ],
    );
  }

  Widget _tokenBox(double xtzPrice, AccountTokenModel token, int index,
          BuyNFTController buyNftController) =>
      TokenCheckbox(
        xtzPrice: xtzPrice,
        tokenModel: token,
        isEditable: false,
        onCheckboxTap: () => {buyNftController.selectMethod(token)},
      );
}
