import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

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
      height: 275,
      bottomSheetWidgets: [
        Center(
          child: Text(
            'Do you want to remove“${contactModel.name}”\nfrom your contacts?',
            style: labelMedium.copyWith(color: ColorConst.textGrey1),
            textAlign: TextAlign.center,
          ),
        ),
        0.025.vspace,
        Column(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () async {
                var accountController = Get.find<TransactionController>();
                accountController.contacts.value = accountController.contacts
                    .where((item) => item.address != contactModel.address)
                    .toList();
                accountController.contacts.refresh();
                await UserStorageService()
                    .updateContactList(accountController.contacts);
                accountController.updateSavedContacts();
                Get
                  ..back()
                  ..back();
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
                  "Remove Contact",
                  style: labelMedium.apply(color: ColorConst.Error.shade60),
                ),
              ),
            ),
            0.016.vspace,
            InkWell(
              splashColor: Colors.transparent,
              onTap: () async {
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
                  "Cancel",
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
