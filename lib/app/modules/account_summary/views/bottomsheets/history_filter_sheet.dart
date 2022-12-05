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
      bottomSheetHorizontalPadding: 15.aR,
      height: 609.aR,
      crossAxisAlignment: CrossAxisAlignment.start,
      bottomSheetWidgets: [
        SizedBox(
          height: 10.aR,
        ),
        Text(
          "Asset type",
          style: titleSmall.copyWith(letterSpacing: 0.5, fontSize: 14.aR),
        ),
        SizedBox(
          height: 12.aR,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            assetTypeButton(
              assetType: AssetType.token,
              svg: "${PathConst.EMPTY_STATES}token.svg",
              title: "Tokens",
            ),
            assetTypeButton(
              assetType: AssetType.nft,
              svg: "${PathConst.EMPTY_STATES}nft.svg",
              title: "NFTs",
            ),
          ],
        ),
        SizedBox(
          height: 26.aR,
        ),
        Text(
          "Transaction type",
          style: titleSmall.copyWith(letterSpacing: 0.5, fontSize: 14.aR),
        ),
        SizedBox(
          height: 12.aR,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            transactionTypeButton(
              transactionType: TransactionType.delegation,
              svg: "${PathConst.EMPTY_STATES}delegation.svg",
              title: "Delegation",
            ),
            transactionTypeButton(
              transactionType: TransactionType.send,
              svg: "${PathConst.EMPTY_STATES}send.svg",
              title: "Send",
            ),
            transactionTypeButton(
              transactionType: TransactionType.receive,
              svg: "${PathConst.EMPTY_STATES}receive.svg",
              title: "Receive",
            ),
          ],
        ),
        SizedBox(
          height: 26.aR,
        ),
        Text(
          "Date",
          style: labelMedium.copyWith(fontSize: 12.aR),
        ),
        SizedBox(
          height: 12.aR,
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
          height: 40.aR,
        ),
        dateRangeButton(),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            clearButton(),
            applyButton(),
          ],
        ),
        SizedBox(
          height: 37.aR,
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
      () {
        final isSelected =
            controller.assetType.value.any((e) => e == assetType);
        return Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 12.aR),
            child: MaterialButton(
              height: 79.aR,
              onPressed: () {
                if (isSelected) {
                  controller.assetType.remove(assetType);
                } else {
                  controller.assetType.add(assetType);
                }
              },
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              minWidth: (1.width - 45) / 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.aR),
                  side: BorderSide(
                      color: isSelected
                          ? ColorConst.Primary
                          : ColorConst.NeutralVariant.shade60,
                      width: 1.5)),
              child: Column(
                children: [
                  SvgPicture.asset(
                    svg,
                    height: 26.aR,
                    color: isSelected
                        ? Colors.white
                        : ColorConst.NeutralVariant.shade60,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 4.aR,
                  ),
                  Text(
                    title,
                    style: labelMedium.copyWith(
                        fontSize: 12.aR,
                        color: isSelected
                            ? Colors.white
                            : ColorConst.NeutralVariant.shade60),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget transactionTypeButton({
    required TransactionType transactionType,
    required String title,
    required String svg,
  }) {
    return Obx(
      () {
        final isSelected =
            controller.transactionType.any((e) => e == transactionType);
        return Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 12.sp),
            child: MaterialButton(
              height: 79.aR,
              onPressed: () {
                if (isSelected) {
                  controller.transactionType.remove(transactionType);
                } else {
                  controller.transactionType.add(transactionType);
                }
                // controller.transactionType.value = transactionType;
              },
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              minWidth: (1.width / 3) - 16,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.aR),
                  side: BorderSide(
                      color: isSelected
                          ? ColorConst.Primary
                          : ColorConst.NeutralVariant.shade60,
                      width: 1.5)),
              child: Column(
                children: [
                  SvgPicture.asset(svg,
                      height: 26.aR,
                      fit: BoxFit.contain,
                      color: isSelected
                          ? Colors.white
                          : ColorConst.NeutralVariant.shade60),
                  SizedBox(
                    height: 4.aR,
                  ),
                  Text(
                    title,
                    style: labelMedium.copyWith(
                        fontSize: 12.aR,
                        color: isSelected
                            ? Colors.white
                            : ColorConst.NeutralVariant.shade60),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget clearButton() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(right: 12.aR),
        child: MaterialButton(
          height: 50.aR,
          onPressed: () {
            controller.clear();
          },
          color: Colors.black,
          minWidth: (1.width - 45) / 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.aR),
              side: BorderSide(color: ColorConst.Primary.shade80, width: 1)),
          child: Text(
            "Clear",
            style: titleSmall.copyWith(
                color: ColorConst.Primary.shade80, fontSize: 14.aR),
          ),
        ),
      ),
    );
  }

  Widget applyButton() {
    return Flexible(
      child: MaterialButton(
        height: 50.aR,
        onPressed: controller.apply,
        color: ColorConst.Primary,
        minWidth: (1.width - 45) / 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "Apply",
          style: titleSmall.copyWith(fontSize: 14.aR),
        ),
      ),
    );
  }

  Widget dateTypeButton(DateType dateType, String text) {
    return Padding(
      padding: EdgeInsets.only(right: 12.aR),
      child: Obx(
        () => GestureDetector(
          onTap: () {
            controller.setDate(dateType);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.aR),
            height: 32.aR,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: controller.dateType.value == dateType
                    ? ColorConst.Primary
                    : ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14.aR),
                border: Border.all(
                    width: 1.aR,
                    color: controller.dateType.value == dateType
                        ? ColorConst.Primary.shade70
                        : ColorConst.NeutralVariant.shade30)),
            child: Text(
              text,
              style: labelMedium.copyWith(
                  fontSize: 12.aR,
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
            enterBottomSheetDuration: const Duration(milliseconds: 180),
            exitBottomSheetDuration: const Duration(milliseconds: 150),
            barrierColor: Colors.transparent,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.aR),
          width: double.infinity,
          height: 32.aR,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: controller.dateType.value == DateType.customDate
                  ? ColorConst.Primary
                  : ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14.aR),
              border: Border.all(
                  width: 1,
                  color: controller.dateType.value == DateType.customDate
                      ? ColorConst.Primary.shade70
                      : ColorConst.NeutralVariant.shade30)),
          child: Text(
            controller.dateType.value == DateType.customDate
                ? "${controller.fromDate.value.year}/${controller.fromDate.value.month}/${controller.fromDate.value.day} - ${controller.toDate.value.year}/${controller.toDate.value.month}/${controller.toDate.value.day}"
                : "Select Date Range",
            style: labelMedium.copyWith(
                fontSize: 12.aR,
                color: controller.dateType.value == DateType.customDate
                    ? Colors.white
                    : ColorConst.NeutralVariant.shade60),
          ),
        ),
      ),
    );
  }
}
