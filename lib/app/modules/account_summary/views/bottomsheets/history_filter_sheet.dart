import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/history_filter_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/date_Selection_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class HistoryFilterSheet extends StatelessWidget {
  HistoryFilterSheet({super.key});

  final controller = Get.put(HistoryFilterController());
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetHorizontalPadding: 32.aR,
      // height: 609.aR,
      isScrollControlled: true,
      crossAxisAlignment: CrossAxisAlignment.start,
      bottomSheetWidgets: [
        // SizedBox(
        //     height: 609.aR,
        //     child: Column(
        //       children: [],
        //     )),
        SizedBox(
          height: 16.aR,
        ),
        Text(
          "Asset type".tr,
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
          "Transaction type".tr,
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
          "Date".tr,
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
        SizedBox(
          height: 40.aR,
        ),
        // const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            clearButton(),
            0.032.hspace,
            applyButton(),
          ],
        ),
        BottomButtonPadding()
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
              height: 79.arP,
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
                        fontSize: 12.arP,
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
            padding: EdgeInsets.only(right: 12.arP),
            child: MaterialButton(
              height: 79.arP,
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
                  borderRadius: BorderRadius.circular(8.arP),
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
                    title.tr,
                    style: labelMedium.copyWith(
                        fontSize: 11.arP,
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
    return Expanded(
      child: SolidButton(
        onPressed: () {
          controller.clear();
          Get.back();
        },
        title: "Clear",
        borderColor: ColorConst.Primary.shade80,
        textColor: ColorConst.Primary.shade80,
        primaryColor: Colors.transparent,
      ),
    );
  }

  Widget applyButton() {
    return Expanded(
      child: SolidButton(
        onPressed: () {
          controller.apply();
        },
        title: "Apply",
      ),
    );
  }

  Widget dateTypeButton(DateType dateType, String text) {
    return Padding(
      padding: EdgeInsets.only(right: 12.aR),
      child: Obx(
        () => BouncingWidget(
          onPressed: () {
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
              text.tr,
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
      () => BouncingWidget(
        onPressed: () {
          CommonFunctions.bottomSheet(DateSelectionSheet());
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
                : "Select Date Range".tr,
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
