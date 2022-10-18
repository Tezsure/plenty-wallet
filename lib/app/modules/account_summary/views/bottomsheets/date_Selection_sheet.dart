import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/history_filter_controller.dart';

import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

enum SelectDateType { from, to }

class DateSelectionSheet extends StatelessWidget {
  DateSelectionSheet({
    Key? key,
  }) : super(key: key);

  final Rx<SelectDateType> _selectDateType = SelectDateType.from.obs;
  Rx<DateTime> fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .obs;
  Rx<DateTime> toDate = DateTime.now().obs;

  final controller = Get.put(HistoryFilterController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NaanBottomSheet(
        height: 425,
        bottomSheetHorizontalPadding: 15,
        crossAxisAlignment: CrossAxisAlignment.center,
        bottomSheetWidgets: [
          Text(
            'Select Start Date',
            style: labelMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dateBox(SelectDateType.from,
                  fromDate.value.toString().substring(0, 11)),
              Text(
                "to",
                style: bodyMedium,
              ),
              dateBox(
                  SelectDateType.to, toDate.value.toString().substring(0, 11)),
            ],
          ),
          Expanded(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: labelMedium.apply(
                          color: ColorConst.NeutralVariant.shade60))),
              child: CupertinoDatePicker(
                onDateTimeChanged: (date) {
                  _selectDateType == SelectDateType.from
                      ? fromDate.value = date
                      : toDate.value = date;
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
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  MaterialButton confirmButton() {
    return MaterialButton(
        height: 48,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        minWidth: double.infinity,
        onPressed: () {
          controller.setDate(DateType.customDate,
              from: fromDate.value, to: toDate.value);

          Get.back();
        },
        color: ColorConst.Primary,
        splashColor: ColorConst.Primary.shade60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Text(
          "Confirm",
          style: titleSmall.apply(color: ColorConst.Primary.shade90),
        ));
  }

  Widget dateBox(SelectDateType selectDateType, String date) {
    return GestureDetector(
      onTap: () {
        _selectDateType.value = selectDateType;
      },
      child: Container(
        alignment: Alignment.center,
        height: 52,
        width: 149,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
        child: Text(date,
            style: bodyMedium.apply(
                color: _selectDateType == selectDateType
                    ? ColorConst.Primary.shade60
                    : Colors.white)),
      ),
    );
  }
}
