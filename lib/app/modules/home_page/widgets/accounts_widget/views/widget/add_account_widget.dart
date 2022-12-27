import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../../../utils/colors/colors.dart';
import '../../../../../../../utils/styles/styles.dart';

class AddAccountWidget extends StatelessWidget {
  final String? warning;
  const AddAccountWidget({super.key, this.warning});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          addAccountSheet(warning),
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
          barrierColor: Colors.transparent,
        );
      },
      child: Container(
        padding: EdgeInsets.all(20.arP),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: ColorConst.darkGrey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.add_circle,
                color: ColorConst.textGrey1,
                size: 30.arP,
              ),
            ),
            Spacer(),
            Text(
              'Add more accounts',
              style: titleLarge,
            ),
            Text(
              'Use accounts to manage your\nassets separately',
              style: bodySmall.copyWith(color: ColorConst.textGrey1),
            ),
          ],
        ),
      ),
    );
  }
}

InkWell _optionMethod({Widget? child, GestureTapCallback? onTap}) {
  return InkWell(
    onTap: onTap,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    child: SizedBox(
      width: double.infinity,
      height: 54,
      child: Center(
        child: child,
      ),
    ),
  );
}

Widget addAccountSheet(warning) {
  return NaanBottomSheet(
    blurRadius: 5.sp,
    height: 217.sp,
    bottomSheetWidgets: [
      Center(
        child: Text(
          warning ?? 'Add New Account',
          style: labelMedium.copyWith(
              color: warning != null ? ColorConst.NaanRed : Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      0.03.vspace,
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        child: Column(
          children: [
            _optionMethod(
                child: Text(
                  "Create a new wallet",
                  style: labelMedium,
                ),
                onTap: () {
                  Get.back();
                  Get.bottomSheet(AddNewAccountBottomSheet(),
                          enterBottomSheetDuration:
                              const Duration(milliseconds: 180),
                          exitBottomSheetDuration:
                              const Duration(milliseconds: 150),
                          barrierColor: Colors.transparent,
                          isScrollControlled: true)
                      .whenComplete(() {
                    Get.find<AccountsWidgetController>().resetCreateNewWallet();
                  });
                }),
            const Divider(
              color: Color(0xff4a454e),
              height: 1,
              thickness: 1,
            ),
            _optionMethod(
              child: Text(
                "Add an exisitng wallet",
                style: labelMedium,
              ),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.IMPORT_WALLET_PAGE);
              },
            ),
          ],
        ),
      ),
    ],
  );
}
