import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/nft_gallery/controllers/nft_filter_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class NFTaccountsfilterBottomSheet extends StatelessWidget {
  NFTaccountsfilterBottomSheet({super.key});

  final controller = Get.find<NftFilterController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      crossAxisAlignment: CrossAxisAlignment.center,
      bottomSheetHorizontalPadding: 12,
      height: 0.95.height,
      bottomSheetWidgets: [
        Text(
          "Accounts",
          style: labelMedium,
        ),
        SizedBox(
          height: 12,
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, index) => accountWidget(index),
            itemCount: controller.accounts.length,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            clearButton(),
            applyButton(),
          ],
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget accountWidget(int index) {
    return Obx(
      () => ListTile(
        onTap: () {
          controller.selectedAccounts.contains(controller.accounts[index])
              ? controller.selectedAccounts.remove(controller.accounts[index])
              : controller.selectedAccounts.add(controller.accounts[index]);
        },
        leading: CircleAvatar(
          radius: 23,
          backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          backgroundImage:
              AssetImage(controller.accounts[index].profileImage ?? ""),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.accounts[index].name ?? "",
              style: bodySmall,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              tz1Shortner(controller.accounts[index].publicKey ?? ""),
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
          ],
        ),
        trailing:
            controller.selectedAccounts.contains(controller.accounts[index])
                ? SvgPicture.asset(PathConst.NFT_PAGE.SVG + "selected.svg")
                : null,
      ),
    );
  }

  Widget clearButton() {
    return Obx(
      () => MaterialButton(
        height: 48,
        onPressed: () {
          controller.clear();
        },
        minWidth: (1.width / 2) - 16,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
                color: controller.selectedAccounts.isNotEmpty
                    ? ColorConst.Primary.shade80
                    : ColorConst.NeutralVariant.shade40,
                width: 1)),
        child: Text(
          "Clear",
          style: titleSmall.apply(
              color: controller.selectedAccounts.isNotEmpty
                  ? ColorConst.Primary.shade80
                  : ColorConst.NeutralVariant.shade40),
        ),
      ),
    );
  }

  Widget applyButton() {
    return Obx(
      () => MaterialButton(
        height: 48,
        onPressed: () {},
        color: ColorConst.Primary,
        minWidth: (1.width / 2) - 16,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          controller.selectedAccounts.isNotEmpty ? "Apply" : "Selected All",
          style: titleSmall,
        ),
      ),
    );
  }
}
