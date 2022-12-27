import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/fees_summary.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

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
                  child: CachedNetworkImage(
                    imageUrl: controller.selectedNFT.value?.artifactUri ?? "",
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
              ),
              0.02.vspace,
              Text(
                "\$${(controller.selectedNFT.value?.lowestAsk * homeController.xtzPrice.value).toStringAsFixed(2)}",
                style: headlineLarge,
              ),
              0.008.vspace,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _imageAvatar(controller.selectedToken.value?.iconUrl ?? ""),
                  Text(
                    "  ${controller.selectedNFT.value?.lowestAsk.toStringAsFixed(2)} ${controller.selectedToken.value?.symbol?.toUpperCase() ?? ""}",
                    style: titleMedium.copyWith(
                        color: ColorConst.textGrey1,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              0.02.vspace,
              _buildAccount(),
              0.04.vspace,
              _builButtons(),
              0.04.vspace,
              _buildFees()
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFees() {
    return GestureDetector(
      onTap: () {
        controller.openFeeSummary();
      },
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Estimate fee",
                style: bodySmall.copyWith(color: ColorConst.grey),
              ),
              Row(
                children: [
                  Text(
                    "\$0.00018",
                    style: labelMedium,
                  ),
                  0.01.hspace,
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: ColorConst.NeutralVariant.shade60,
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Balance",
                style: bodySmall.copyWith(color: ColorConst.grey),
              ),
              Text(
                "100 TEZ",
                style: labelMedium,
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
          'Account',
          style: bodySmall.copyWith(color: ColorConst.grey),
        ),
        0.008.vspace,
        Obx(() => Container(
              height: 42.arP,
              padding: EdgeInsets.symmetric(horizontal: 20.arP),
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
                      height: 0.06.width,
                      width: 0.06.width,
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
            borderColor: ColorConst.Neutral.shade80,
            textColor: ColorConst.Neutral.shade80,
            title: "Cancel",
            primaryColor: Colors.transparent,
          ),
        ),
        0.024.hspace,
        Expanded(
          child: SolidButton(
            title: "Confirm",
            onPressed: () {
              controller.openSuccessSheet();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
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
                  "Confirm",
                  style: titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConst.Neutral.shade100),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
