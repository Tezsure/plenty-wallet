import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/history_filter_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/date_Selection_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class HistoryFilterSheet extends StatelessWidget {
  HistoryFilterSheet({super.key});

  final controller = Get.put(HistoryFilterController());
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetHorizontalPadding: 15,
      height: 561,
      crossAxisAlignment: CrossAxisAlignment.start,
      bottomSheetWidgets: [
        Text(
          "Asset type",
          style: labelMedium,
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            assetTypeButton(
              assetType: AssetType.token,
              svg: PathConst.ACCOUNT_SUMMARY.SVG + "token.svg",
              title: "Tokens",
            ),
            assetTypeButton(
              assetType: AssetType.nft,
              svg: PathConst.ACCOUNT_SUMMARY.SVG + "nft.svg",
              title: "NFTs",
            ),
          ],
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          "Asset type",
          style: labelMedium,
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            transactionTypeButton(
              transactionType: TransactionType.delegation,
              svg: PathConst.ACCOUNT_SUMMARY.SVG + "delegation.svg",
              title: "Delegation",
            ),
            transactionTypeButton(
              transactionType: TransactionType.send,
              svg: PathConst.ACCOUNT_SUMMARY.SVG + "send.svg",
              title: "Send",
            ),
            transactionTypeButton(
              transactionType: TransactionType.receive,
              svg: PathConst.ACCOUNT_SUMMARY.SVG + "receive.svg",
              title: "Receive",
            ),
          ],
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          "Date",
          style: labelMedium,
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            dateTypeButton(DateType.today, "Today"),
            dateTypeButton(DateType.currentMonth, "Current Month"),
            dateTypeButton(DateType.last3Months, "Last 3 Months"),
          ],
        ),
        SizedBox(
          height: 32,
        ),
        dateRangeButton(),
        Spacer(),
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

  Widget assetTypeButton({
    required AssetType assetType,
    required String title,
    required String svg,
  }) {
    return Obx(
      () => MaterialButton(
        height: 79,
        onPressed: () {
          controller.assetType.value = assetType;
        },
        color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        minWidth: (1.width - 45) / 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
                color: controller.assetType.value == assetType
                    ? ColorConst.Primary
                    : ColorConst.NeutralVariant.shade60,
                width: 1.5)),
        child: Column(
          children: [
            SvgPicture.asset(svg,
                color: controller.assetType.value == assetType
                    ? Colors.white
                    : ColorConst.NeutralVariant.shade60),
            SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: labelMedium.apply(
                  color: controller.assetType.value == assetType
                      ? Colors.white
                      : ColorConst.NeutralVariant.shade60),
            )
          ],
        ),
      ),
    );
  }

  Widget transactionTypeButton({
    required TransactionType transactionType,
    required String title,
    required String svg,
  }) {
    return Obx(
      () => MaterialButton(
        height: 79,
        onPressed: () {
          controller.transactionType.value = transactionType;
        },
        color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        minWidth: (1.width / 3) - 16,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
                color: controller.transactionType.value == transactionType
                    ? ColorConst.Primary
                    : ColorConst.NeutralVariant.shade60,
                width: 1.5)),
        child: Column(
          children: [
            SvgPicture.asset(svg,
                color: controller.transactionType.value == transactionType
                    ? Colors.white
                    : ColorConst.NeutralVariant.shade60),
            SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: labelMedium.apply(
                  color: controller.transactionType.value == transactionType
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
      minWidth: (1.width - 45) / 2,
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
      minWidth: (1.width - 45) / 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "Apply",
        style: titleSmall,
      ),
    );
  }

  Widget dateTypeButton(DateType dateType, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Obx(
        () => GestureDetector(
          onTap: () {
            controller.setDate(dateType);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: controller.dateType.value == dateType
                    ? ColorConst.Primary
                    : ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                    width: 1, color: ColorConst.NeutralVariant.shade30)),
            child: Text(
              text,
              style: labelSmall.apply(
                  color: controller.dateType.value == dateType
                      ? Colors.white
                      : ColorConst.NeutralVariant.shade60),
            ),
          ),
        ),
      ),
    );
  }

  Widget dateRangeButton() {
    return Obx(
      () => GestureDetector(
        onTap: () {
          Get.bottomSheet(
            DateSelectionSheet(),
            barrierColor: Colors.transparent,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: controller.dateType.value == DateType.customDate
                  ? ColorConst.Primary
                  : ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                  width: 1, color: ColorConst.NeutralVariant.shade30)),
          child: Text(
            controller.dateType.value == DateType.customDate
                ? "${controller.fromDate.value.year}/${controller.fromDate.value.month}/${controller.fromDate.value.day} - ${controller.toDate.value.year}/${controller.toDate.value.month}/${controller.toDate.value.day}"
                : "Select Date Range",
            style: labelSmall.apply(
                color: controller.dateType.value == DateType.customDate
                    ? Colors.white
                    : ColorConst.NeutralVariant.shade60),
          ),
        ),
      ),
    );
  }
}
