import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/contact_page/models/contact_model.dart';
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
    return NaanBottomSheet(
      height: 233,
      bottomSheetWidgets: [
        Center(
          child: Text(
            'Are you sure you want to delete\n“${contactModel.name}” from your contacts?',
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
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 54,
                  alignment: Alignment.center,
                  child: Text(
                    "Delete Contact",
                    style: labelMedium.apply(color: ColorConst.Error.shade60),
                  ),
                ),
              ),
              const Divider(
                color: Color(0xff4a454e),
                height: 1,
                thickness: 1,
              ),
              GestureDetector(
                onTap: () async {
                  Get.back();
                },
                child: Container(
                  width: double.infinity,
                  height: 54,
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel",
                    style: labelMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
