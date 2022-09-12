import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class AddContactBottomSheet extends StatelessWidget {
  final String contactName;
  const AddContactBottomSheet({
    Key? key,
    required this.contactName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        NaanTextfield(hint: 'Enter Name'),
        0.025.vspace,
        Text(
          contactName,
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
              'Add contact',
              style: titleSmall,
            )),
          ),
        ),
    
      ],
    );
  }
}
