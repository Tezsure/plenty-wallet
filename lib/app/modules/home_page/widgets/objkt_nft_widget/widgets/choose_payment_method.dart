import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/widgets/crypto_tab_widgets/token_checkbox.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/controllers/buy_nft_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/review_nft.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../utils/styles/styles.dart';

class ChoosePaymentMethod extends StatelessWidget {
  ChoosePaymentMethod({super.key});
  final controller = Get.put(AccountSummaryController());
  @override
  Widget build(BuildContext context) {
    final buyNftController = Get.put(BuyNFTController());
    return NaanBottomSheet(
      isScrollControlled: true,
      title: "Choose payment",
      bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        Obx(() {
          return SafeArea(
            child: Column(
              children: [
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
                controller.userTokens.isEmpty
                    ? noTokens()
                    : ListView.builder(
                        itemCount: controller.userTokens.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _tokenBox(
                              controller.userTokens[index],
                              index,
                              buyNftController,
                            ))
              ],
            ),
          );
        })
      ],
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
          BuyNFTController buyNftController) =>
      TokenCheckbox(
        xtzPrice: controller.xtzPrice.value,
        tokenModel: token,
        isEditable: false,
        onCheckboxTap: () => {buyNftController.selectMethod(token)},
      );
}
