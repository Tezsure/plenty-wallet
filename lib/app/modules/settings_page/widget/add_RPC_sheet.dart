import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class AddRPCbottomSheet extends StatelessWidget {
  AddRPCbottomSheet({Key? key}) : super(key: key);
  final SettingsPageController controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetWidgets: [
        Center(
          child: Text(
            'Select Network',
            style: labelMedium,
            textAlign: TextAlign.center,
          ),
        ),
        0.03.vspace,
        NaanTextfield(
          hint: "My custom network",
          hintTextSyle:
              labelMedium.apply(color: ColorConst.NeutralVariant.shade70),
          backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        0.015.vspace,
        NaanTextfield(
          hint: "http://localhost:4444",
          hintTextSyle:
              labelMedium.apply(color: ColorConst.NeutralVariant.shade70),
          backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        0.03.vspace,
        MaterialButton(
          color: ColorConst.Primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {},
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: Center(
              child: Text(
                "Add RPC",
                style: titleSmall,
              ),
            ),
          ),
        ),
        0.05.vspace
      ],
    );
  }
}
