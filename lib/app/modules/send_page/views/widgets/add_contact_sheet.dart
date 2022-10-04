import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

// ignore: must_be_immutable
class AddContactBottomSheet extends StatelessWidget {
  final ContactModel contactModel;
  AddContactBottomSheet({
    Key? key,
    required this.contactModel,
  }) : super(key: key);

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (nameController.text.isEmpty) {
      nameController.text = contactModel.name;
      nameController.selection = TextSelection.fromPosition(
          TextPosition(offset: nameController.text.length));
    }
    return NaanBottomSheet(
      height: 262,
      bottomSheetHorizontalPadding: 32,
      blurRadius: 5,
      bottomSheetWidgets: [
        Text(
          'Add Contact',
          style: titleMedium,
        ),
        0.03.vspace,
        NaanTextfield(
          hint: 'Enter Name',
          controller: nameController,
        ),
        0.025.vspace,
        Text(
          contactModel.address,
          style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
        ),
        0.025.vspace,
        MaterialButton(
          color: ColorConst.Primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () async {
            await UserStorageService().writeNewContact(
                contactModel.copyWith(name: nameController.text.trim()));
            await Get.find<SendPageController>().updateSavedContacts();
            Get.back();
          },
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: Center(
                child: Text(
              'Add contact',
              style: titleSmall,
            )),
          ),
        ),
      ],
    );
  }
}
