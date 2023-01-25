import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/iaf/controller/iaf_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class IAFSheet extends StatelessWidget {
  IAFSheet({super.key});
  final controller = Get.find<IAFController>();
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "Enter registered email id",
      height: AppConstant.naanBottomSheetHeight -
          MediaQuery.of(context).viewInsets.bottom,
      bottomSheetWidgets: [
        Obx(() {
          return SizedBox(
            height: AppConstant.naanBottomSheetChildHeight -
                28.arP -
                MediaQuery.of(context).viewInsets.bottom,
            child: Column(
              children: [
                0.032.vspace,
                _buildTextField(),
                const Spacer(),
                SolidButton(
                  onPressed: () {
                    if (controller.isverified.value) {
                      controller.claim();
                    } else {
                      controller.verify();
                    }
                  },
                  title: controller.isverified.value ? "Claim" : "Verify",
                ),
                const BottomButtonPadding()
              ],
            ),
          );
        })
      ],
    );
  }

  SizedBox _buildTextField() {
    return SizedBox(
      height: 0.06.height,
      width: 1.width,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        onChanged: controller.onChange,
        controller: controller.emailController,
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.start,
        cursorColor: ColorConst.Primary,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          suffixIcon: Icon(
            Icons.search,
            color: ColorConst.NeutralVariant.shade60,
            size: 22,
          ),
          counterStyle: const TextStyle(backgroundColor: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ColorConst.green),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          hintText: 'example@site.com',
          hintStyle:
              bodyMedium.copyWith(color: ColorConst.NeutralVariant.shade70),
          labelStyle: labelSmall,
          // contentPadding:
          //     const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        ),
      ),
    );
  }
}
