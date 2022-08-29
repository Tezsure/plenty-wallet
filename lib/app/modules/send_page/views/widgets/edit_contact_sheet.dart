import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/contact_page/models/contact_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class EditContactBottomSheet extends StatelessWidget {
  final ContactModel contactModel;
  const EditContactBottomSheet({
    Key? key,
    required this.contactModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetWidgets: [
        Center(
          child: Text(
            'Edit Contact',
            style: titleMedium,
          ),
        ),
        0.03.vspace,
        NaanTextfield(hint: 'Enter Name',),
        0.025.vspace,
        Text(
          contactModel.address,
          style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
        ),
        0.025.vspace,
        MaterialButton(
          color: ColorConst.Primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {},
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: Center(
                child: Text(
              'Save Changes',
              style: titleSmall,
            )),
          ),
        ),
        0.05.vspace,
      ],
    );
  }
}
