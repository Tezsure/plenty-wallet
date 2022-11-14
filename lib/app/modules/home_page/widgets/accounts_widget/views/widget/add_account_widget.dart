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
  const AddAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0.09.width, top: 0.09.height),
      height: 0.26.height,
      width: 0.92.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorConst.Primary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                addAccountSheet(),
                barrierColor: Colors.transparent,
              );
            },
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConst.Primary.shade60,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
                0.02.hspace,
                Text(
                  'Add Account',
                  style: labelSmall,
                ),
              ],
            ),
          ),
          0.010.vspace,
          Text(
            'Create new account and add to\nthe stack ',
            style: labelSmall,
          )
        ],
      ),
    );
  }

  Widget addAccountSheet() {
    return NaanBottomSheet(
      blurRadius: 5.sp,
      height: 217.sp,
      bottomSheetWidgets: [
        Center(
          child: Text(
            'Add New Account',
            style: labelMedium,
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
                            barrierColor: Colors.transparent,
                            isScrollControlled: true)
                        .whenComplete(() {
                      Get.find<AccountsWidgetController>()
                          .resetCreateNewWallet();
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

  Widget _addAccountSheet() {
    return NaanBottomSheet(
      blurRadius: 5,
      height: 217,
      bottomSheetWidgets: [
        Center(
          child: Text(
            'Add New Account',
            style: labelMedium,
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
                            barrierColor: Colors.transparent,
                            isScrollControlled: true)
                        .whenComplete(() {
                      Get.find<AccountsWidgetController>()
                          .resetCreateNewWallet();
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
}
