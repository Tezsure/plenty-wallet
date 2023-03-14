import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/fees_summary.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../controllers/buy_nft_controller.dart';

class ReviewNFTSheet extends StatelessWidget {
  ReviewNFTSheet({super.key});
  final controller = Get.find<BuyNFTController>();
  final homeController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      isScrollControlled: true,
      // height: 1.height,
      bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        SafeArea(
          child: Column(
            children: [
              0.02.vspace,
              SizedBox(
                height: 0.12.height,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.arP),
                  child: controller.selectedNFT.value != null
                      ? NFTImage(
                          nftTokenModel: controller.selectedNFT.value!
                            ..tokenId = controller.mainUrl[1],
                        )
                      : CachedNetworkImage(
                          imageUrl: controller.selectedNFT.value != null
                              ? "https://assets.objkt.media/file/assets-003/${controller.selectedNFT.value!.faContract}/${controller.mainUrl[1].toString()}/thumb400"
                              : "",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Text(
                "Objkt",
                style: titleMedium.copyWith(color: ColorConst.textGrey1),
              ),
              Text(
                controller.selectedNFT.value?.name ?? "",
                style: headlineSmall,
                textAlign: TextAlign.center,
              ),
              0.02.vspace,
              Obx(
                () => Text(
                  controller.selectedToken.value!.symbol!.toLowerCase() ==
                          "Tezos".toLowerCase()
                      ? (double.parse(controller.priceInToken.value) *
                              homeController.xtzPrice.value)
                          .roundUpDollar(homeController.xtzPrice.value)
                      : ((double.parse(controller.priceInToken.value) *
                              controller.selectedToken.value!.currentPrice! *
                              homeController.xtzPrice.value)
                          .roundUpDollar(homeController.xtzPrice.value)),
                  style: headlineLarge,
                ),
              ),
              0.008.vspace,
              Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _imageAvatar(controller.selectedToken.value?.iconUrl ?? ""),
                    Text(
                      "  ${double.parse(controller.priceInToken.value).toStringAsFixed(3)} ${controller.selectedToken.value?.symbol!.toUpperCase()}",
                      style: titleMedium.copyWith(
                          color: ColorConst.textGrey1,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              0.02.vspace,
              _buildAccount(),
              0.04.vspace,
              Obx(() => Container(
                    child: controller.error.value.trim().isEmpty
                        ? _builButtons()
                        : Text(
                            '${'Transaction is likely to fail:'.tr} ${controller.error.value.length > 100 ? controller.error.value.replaceRange(100, controller.error.value.length, '...') : controller.error.value}',
                            style:
                                bodyMedium.copyWith(color: ColorConst.NaanRed),
                            textAlign: TextAlign.center,
                          ),
                  )),
              0.04.vspace,
              _buildFees()
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFees() {
    return BouncingWidget(
      onPressed: () {
        controller.openFeeSummary();
      },
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Estimate fee".tr,
                style: bodySmall.copyWith(color: ColorConst.grey),
              ),
              Obx(
                () => Row(
                  children: [
                    Text(
                      controller.fees["totalFee"] == "calculating..."
                          ? "calculating..."
                          : double.parse(controller.fees["totalFee"]!)
                              .roundUpDollar(controller.xtzPrice.value,
                                  decimals: 4),
                      style: labelMedium,
                    ),
                    0.01.hspace,
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: ColorConst.NeutralVariant.shade60,
                    ),
                  ],
                ),
              )
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Balance".tr,
                style: bodySmall.copyWith(color: ColorConst.grey),
              ),
              Text(
                "${controller.selectedToken.value!.balance.toStringAsFixed(3)} ${controller.selectedToken.value!.symbol}",
                style: labelMedium.copyWith(
                    color: controller.error.isEmpty
                        ? Colors.white
                        : ColorConst.NaanRed),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _imageAvatar(String url) => CircleAvatar(
        radius: 12.aR,
        backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        child: url.startsWith("assets")
            ? Image.asset(
                url,
                fit: BoxFit.cover,
              )
            : url.endsWith(".svg")
                ? SvgPicture.network(
                    url,
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(url.startsWith("ipfs")
                              ? "https://ipfs.io/ipfs/${url.replaceAll("ipfs://", '')}"
                              : url)),
                    ),
                  ),
      );
  Widget _buildAccount() {
    return Column(
      children: [
        Text(
          'Account'.tr,
          style: bodySmall.copyWith(color: ColorConst.grey),
        ),
        0.008.vspace,
        Obx(() => Container(
              // height: 42.arP,
              padding:
                  EdgeInsets.symmetric(horizontal: 20.arP, vertical: 10.arP),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorConst.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(30),
                color: ColorConst.darkGrey,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0.arP),
                    child: Container(
                      height: 24.arP,
                      width: 24.arP,
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: homeController
                                      .userAccounts[
                                          homeController.selectedIndex.value]
                                      .imageType ==
                                  AccountProfileImageType.assets
                              ? AssetImage(homeController
                                  .userAccounts[
                                      homeController.selectedIndex.value]
                                  .profileImage
                                  .toString())
                              : FileImage(
                                  File(
                                    homeController
                                        .userAccounts[
                                            homeController.selectedIndex.value]
                                        .profileImage
                                        .toString(),
                                  ),
                                ) as ImageProvider,
                        ),
                      ),
                    ),
                  ),
                  Text(
                      homeController
                          .userAccounts[homeController.selectedIndex.value].name
                          .toString(),
                      style: labelMedium),
                ],
              ),
            )),
      ],
    );
  }

  Widget _builButtons() {
    return Row(
      children: [
        Expanded(
          child: SolidButton(
            onPressed: Get.back,
            borderWidth: 1,
            borderColor: ColorConst.Neutral.shade80,
            textColor: ColorConst.Neutral.shade80,
            title: "Cancel",
            primaryColor: Colors.transparent,
          ),
        ),
        0.024.hspace,
        Expanded(
          child: Obx(
            () => SolidButton(
              title: "Confirm",
              onPressed: () {
                if (controller.operation.isNotEmpty) {
                  controller.openSuccessSheet();
                }
              },
              child: controller.operation.isEmpty
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20.arP,
                          width: 20.arP,
                          child: Platform.isAndroid
                              ? SvgPicture.asset(
                                  "${PathConst.SVG}fingerprint.svg",
                                  color: ColorConst.Neutral.shade100,
                                )
                              : SvgPicture.asset(
                                  "${PathConst.SVG}faceid.svg",
                                  color: ColorConst.Neutral.shade100,
                                ),
                        ),
                        0.02.hspace,
                        Text(
                          "Confirm".tr,
                          style: titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConst.Neutral.shade100),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
