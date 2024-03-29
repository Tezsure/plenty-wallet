import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/service_models/contact_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:plenty_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class DeleteContactBottomSheet extends StatelessWidget {
  final ContactModel contactModel;
  const DeleteContactBottomSheet({
    Key? key,
    required this.contactModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountSummaryController());
    Get.put(TransactionController());
    return NaanBottomSheet(
      title: 'Delete contact',
      bottomSheetHorizontalPadding: 32.arP,
      height: 275.arP,
      bottomSheetWidgets: [
        0.01.vspace,
        Center(
          child: Text(
            '${'Do you want to remove'.tr}“${contactModel.name}”\n${'from your contacts?'.tr}',
            style: labelMedium.copyWith(
                fontSize: 12.aR,
                fontWeight: FontWeight.w400,
                color: ColorConst.NeutralVariant.shade60),
            textAlign: TextAlign.center,
          ),
        ),
        0.025.vspace,
        Column(
          children: [
            BouncingWidget(
              onPressed: () async {
                var accountController = Get.find<TransactionController>();
                accountController.contacts.value = accountController.contacts
                    .where((item) => item.address != contactModel.address)
                    .toList();
                accountController.contacts.refresh();
                await UserStorageService()
                    .updateContactList(accountController.contacts);
                accountController.updateSavedContacts();
                Get.back();
                // ..back();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                ),
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  "Remove Contact".tr,
                  style: labelMedium.apply(color: ColorConst.Error.shade60),
                ),
              ),
            ),
            0.016.vspace,
            BouncingWidget(
              onPressed: () async {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                ),
                width: double.infinity,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  "Cancel".tr,
                  style: labelMedium,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
