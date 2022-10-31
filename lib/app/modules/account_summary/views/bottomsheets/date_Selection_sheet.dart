import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/history_filter_controller.dart';

import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

enum SelectDateType { from, to }

class DateSelectionSheet extends StatelessWidget {
  DateSelectionSheet({
    Key? key,
  }) : super(key: key);

  final Rx<SelectDateType> _selectDateType = SelectDateType.from.obs;

  final controller = Get.find<HistoryFilterController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NaanBottomSheet(
        height: 425.aR,
        bottomSheetHorizontalPadding: 15.aR,
        crossAxisAlignment: CrossAxisAlignment.center,
        bottomSheetWidgets: [
          Text(
            'Select Start Date',
            style: labelMedium.copyWith(fontSize: 12.aR),
          ),
          SizedBox(
            height: 20.aR,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dateBox(SelectDateType.from,
                  controller.fromDate.value.toString().substring(0, 11)),
              Text(
                "to",
                style: bodyMedium.copyWith(fontSize: 14.aR),
              ),
              dateBox(SelectDateType.to,
                  controller.toDate.value.toString().substring(0, 11)),
            ],
          ),
          Expanded(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: labelMedium.copyWith(
                          fontSize: 12.aR,
                          color: ColorConst.NeutralVariant.shade60))),
              child: CupertinoDatePicker(
                onDateTimeChanged: (date) {
                  _selectDateType.value == SelectDateType.from
                      ? controller.fromDate.value = date
                      : controller.toDate.value = date;
                },
                backgroundColor: Colors.transparent,
                // maximumDate: DateTime.now(),
                // dateOrder: ,
                // minimumDate: DateTime(2018, 9),
                mode: CupertinoDatePickerMode.date,
              ),
            ),
          ),
          confirmButton(),
          SizedBox(
            height: 40.aR,
          )
        ],
      ),
    );
  }

  MaterialButton confirmButton() {
    return MaterialButton(
        height: 48.aR,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        minWidth: double.infinity,
        onPressed: () {
          controller.setDate(DateType.customDate,
              from: controller.fromDate.value, to: controller.toDate.value);
          Get.back();
        },
        color: ColorConst.Primary,
        splashColor: ColorConst.Primary.shade60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
          "Confirm",
          style: titleSmall.copyWith(
              color: ColorConst.Primary.shade90, fontSize: 14.aR),
        ));
  }

  Widget dateBox(SelectDateType selectDateType, String date) {
    return GestureDetector(
      onTap: () {
        _selectDateType.value = selectDateType;
      },
      child: Container(
        alignment: Alignment.center,
        height: 52.aR,
        width: 149.aR,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.aR),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
        child: Text(date,
            style: bodyMedium.copyWith(
                fontSize: 14.aR,
                color: _selectDateType.value == selectDateType
                    ? ColorConst.Primary.shade60
                    : Colors.white)),
      ),
    );
  }
}
