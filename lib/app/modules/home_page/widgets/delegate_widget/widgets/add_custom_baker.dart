import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_textfield.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../controllers/delegate_widget_controller.dart';

class AddCustomBakerBottomSheet extends StatefulWidget {
  AddCustomBakerBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddCustomBakerBottomSheet> createState() =>
      _AddCustomBakerBottomSheetState();
}

class _AddCustomBakerBottomSheetState extends State<AddCustomBakerBottomSheet> {
  final TextEditingController _address = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: 'Add custom baker',

      // bottomSheetHorizontalPadding: 32.arP,
      height: .32.height,
      bottomSheetWidgets: [
        Column(
          children: [
            0.03.vspace,
            NaanTextfield(
              autofocus: true,
              onTextChange: (_) {
                setState(() {});
              },
              controller: _address,
              height: 50.arP,
              hint: "Baker's address",
              hintTextSyle: labelLarge.copyWith(
                  color: ColorConst.lightGrey, fontWeight: FontWeight.w400),
              backgroundColor:
                  ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            ),
            0.025.vspace,
            0.025.vspace,
            SolidButton(
                isLoading: isLoading.obs,
                width: 1.width - 64.arP,
                title: "Add baker",
                onPressed: (!_address.text.isValidWalletAddress)
                    ? null
                    : () async {
                        isLoading = true;
                        setState(() {});
                        await Get.find<DelegateWidgetController>()
                            .addCustomBaker(_address.text);
                        isLoading = false;
                        setState(() {});
                      }),
          ],
        )
      ],
    );
  }
}
