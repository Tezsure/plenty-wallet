import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../controllers/buy_nft_controller.dart';

class FeesSummarySheet extends StatelessWidget {
  FeesSummarySheet({super.key});
  final controller = Get.find<BuyNFTController>();
  final homeController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      isScrollControlled: true,
      title: "Summary",
      bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        SafeArea(
          child: Column(
            children: [
              _buildToken(),
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 22.arP, horizontal: 12.arP),
                decoration: BoxDecoration(
                    color: ColorConst.darkGrey,
                    borderRadius: BorderRadius.circular(8.arP)),
                child: Row(
                  children: [
                    Text(
                      "${double.parse(controller.priceInToken.value).toStringAsFixed(3)} ${controller.selectedToken.value?.symbol!.toUpperCase()}",
                      style: bodyLarge.copyWith(color: ColorConst.textGrey1),
                    ),
                    const Spacer(),
                    Text(
                      controller.selectedToken.value!.symbol == "Tezos"
                          ? (double.parse(controller.priceInToken.value) *
                                  homeController.xtzPrice.value)
                              .roundUpDollar(homeController.xtzPrice.value)
                          : (double.parse(controller.priceInToken.value) *
                                  controller
                                      .selectedToken.value!.currentPrice! *
                                  homeController.xtzPrice.value)
                              .roundUpDollar(homeController.xtzPrice.value),
                      style: bodyLarge,
                    )
                  ],
                ),
              ),
              _buildFeeTitle(
                  subtitle:
                      "Fee required to get the transaction added to the blockchain.",
                  title: "Network fee",
                  trailing: controller.fees["networkFee"] == "calculating..."
                      ? "calculating..."
                      : double.parse(controller.fees["networkFee"]!)
                          .roundUpDollar(controller.xtzPrice.value,
                              decimals: 4)),
              _buildFeeTitle(
                  subtitle: "Fee charged by naan.",
                  title: "Interface fee",
                  trailing: controller.fees["interfaceFee"] == "calculating..."
                      ? "calculating..."
                      : double.parse(controller.fees["interfaceFee"]!)
                          .roundUpDollar(controller.xtzPrice.value,
                              decimals: 4)),
            ],
          ),
        ),
      ],
    );
  }

  Padding _buildFeeTitle(
      {required String title,
      required String trailing,
      required String subtitle}) {
    return Padding(
      padding: EdgeInsets.only(top: 16.arP),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title.tr,
                style: labelMedium.copyWith(color: ColorConst.textGrey1),
              ),
              const Spacer(),
              Text(
                trailing.tr,
                style: labelMedium,
              ),
            ],
          ),
          SizedBox(
            height: 8.arP,
          ),
          Text(
            subtitle.tr,
            style: bodySmall.copyWith(color: ColorConst.textGrey1),
          ),
        ],
      ),
    );
  }

  Widget _buildToken() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_upward_rounded,
            color: ColorConst.textGrey1,
            size: 15,
          ),
          Text(
            'Sending'.tr,
            style: bodySmall.copyWith(
                color: ColorConst.textGrey1, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      subtitle: Text(
        '${controller.selectedToken.value!.symbol}',
        style: bodyMedium,
      ),
      leading: getTokenImage(controller.selectedToken.value!),
    );
  }

  Widget getTokenImage(AccountTokenModel tokenModel) => CircleAvatar(
        radius: 22,
        backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        child: tokenModel.iconUrl!.startsWith("assets")
            ? Image.asset(
                tokenModel.iconUrl!,
                fit: BoxFit.cover,
              )
            : tokenModel.iconUrl!.endsWith(".svg")
                ? SvgPicture.network(
                    tokenModel.iconUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(tokenModel.iconUrl!
                                  .startsWith("ipfs")
                              ? "https://ipfs.io/ipfs/${tokenModel.iconUrl!.replaceAll("ipfs://", '')}"
                              : tokenModel.iconUrl!)),
                    ),
                  ),
      );
}
