import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/nft_gallery/controllers/nft_filter_controller.dart';
import 'package:naan_wallet/app/modules/nft_gallery/views/nft_accounts_filter.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class NFTfilterBottomSheet extends StatelessWidget {
  NFTfilterBottomSheet({super.key});

  final controller = Get.put(NftFilterController());

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      crossAxisAlignment: CrossAxisAlignment.start,
      bottomSheetHorizontalPadding: 12,
      height: 504,
      bottomSheetWidgets: [
        Text(
          "Accounts",
          style: labelMedium,
        ),
        const SizedBox(
          height: 12,
        ),
        MaterialButton(
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            Get.bottomSheet(NFTaccountsfilterBottomSheet(),
                barrierColor: Colors.transparent, isScrollControlled: true);
          },
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: controller.selectedAccounts.isEmpty
                    ? [
                        Text(
                          "Select Accounts",
                          style: labelMedium.apply(
                              color: ColorConst.NeutralVariant.shade60),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 11,
                          color: ColorConst.NeutralVariant.shade60,
                        ),
                      ]
                    : [
                        Flexible(
                          child: Text(
                            controller.selectedAccounts
                                .map((element) => element.name)
                                .toList()
                                .join(", "),
                            style: labelMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: ColorConst.Primary,
                          child: Text(
                            controller.selectedAccounts.length.toString(),
                            style: labelSmall,
                          ),
                        )
                      ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          "Views",
          style: labelMedium,
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            viewTypeButton(
              nfTviewType: NFTviewType.collection,
              svg: PathConst.NFT_PAGE.SVG + "collection.svg",
              title: "Collection",
            ),
            viewTypeButton(
              nfTviewType: NFTviewType.list,
              svg: PathConst.NFT_PAGE.SVG + "list.svg",
              title: "list",
            ),
            viewTypeButton(
              nfTviewType: NFTviewType.thumbnail,
              svg: PathConst.NFT_PAGE.SVG + "thumbnail.svg",
              title: "thumbnail",
            ),
          ],
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          "Sort by",
          style: labelMedium,
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            sortTypeButton(NftSortBy.recentlyAdded, "Recently Added"),
            sortTypeButton(NftSortBy.oldest, "Oldest"),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            clearButton(),
            applyButton(),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget viewTypeButton({
    required NFTviewType nfTviewType,
    required String title,
    required String svg,
  }) {
    return Obx(
      () => MaterialButton(
        height: 79,
        onPressed: () {
          controller.nfTviewType.value = nfTviewType;
        },
        color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        minWidth: (1.width / 3) - 16,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
                color: controller.nfTviewType.value == nfTviewType
                    ? ColorConst.Primary
                    : ColorConst.NeutralVariant.shade60,
                width: 1.5)),
        child: Column(
          children: [
            SvgPicture.asset(svg,
                color: controller.nfTviewType.value == nfTviewType
                    ? Colors.white
                    : ColorConst.NeutralVariant.shade60),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: labelMedium.apply(
                  color: controller.nfTviewType.value == nfTviewType
                      ? Colors.white
                      : ColorConst.NeutralVariant.shade60),
            )
          ],
        ),
      ),
    );
  }

  Widget clearButton() {
    return MaterialButton(
      height: 48,
      onPressed: () {
        controller.clear();
      },
      color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      minWidth: (1.width / 2) - 16,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: ColorConst.Primary.shade80, width: 1)),
      child: Text(
        "Clear",
        style: titleSmall.apply(color: ColorConst.Primary.shade80),
      ),
    );
  }

  Widget applyButton() {
    return MaterialButton(
      height: 48,
      onPressed: () {},
      color: ColorConst.Primary,
      minWidth: (1.width / 2) - 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Apply",
        style: titleSmall,
      ),
    );
  }

  Widget sortTypeButton(NftSortBy nftSortBy, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Obx(
        () => GestureDetector(
          onTap: () {
            controller.nftsortby.value = nftSortBy;
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: controller.nftsortby.value == nftSortBy
                    ? ColorConst.Primary
                    : ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                    width: 1, color: ColorConst.NeutralVariant.shade30)),
            child: Text(
              text,
              style: labelSmall.apply(
                  color: controller.nftsortby.value == nftSortBy
                      ? Colors.white
                      : ColorConst.NeutralVariant.shade60),
            ),
          ),
        ),
      ),
    );
  }
}
