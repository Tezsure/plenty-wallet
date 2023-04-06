import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';

class TransactionFeeDetailShet extends StatelessWidget {
  const TransactionFeeDetailShet({super.key});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      prevPageName: "Back",
      bottomSheetWidgets: [
        Column(
          children: [
            BottomSheetHeading(
              title: "Fees",
              leading: backButton(
                ontap: () {
                  Navigator.pop(context);
                },
                lastPageName: "Back",
              ),
            )
          ],
        )
      ],
    );
  }
}
