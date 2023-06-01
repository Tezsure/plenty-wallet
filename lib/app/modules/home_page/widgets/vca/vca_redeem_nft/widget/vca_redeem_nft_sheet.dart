import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controller/vca_redeem_nft_controller.dart';

class VCARedeemSheet extends StatefulWidget {
  final String campaignId;
  const VCARedeemSheet({super.key, required this.campaignId});

  @override
  State<VCARedeemSheet> createState() => _VCARedeemSheetState();
}

class _VCARedeemSheetState extends State<VCARedeemSheet> {
  final controller = Get.find<VCARedeemNFTController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      height: AppConstant.naanBottomSheetHeight -
          MediaQuery.of(context).viewInsets.bottom,
      bottomSheetWidgets: [
        BottomSheetHeading(
          leading: backButton(
              ontap: () {
                controller.onInit();
                Navigator.pop(context);
              },
              lastPageName: "Scan QR"),
          title: "Claim",
        ),
        Obx(() {
          return SizedBox(
            height: AppConstant.naanBottomSheetChildHeight -
                MediaQuery.of(context).viewInsets.bottom,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                0.05.vspace,

                // 0.016.vspace,

                _buildTextField(),
                0.018.vspace,

                const Spacer(),
                Center(
                  child: SolidButton(
                    width: 1.width - 64.arP,
                    isLoading: controller.isLoading,
                    active: controller.isButtonEnabled.value,
                    onPressed: () async {
                      controller.onSubmit(widget.campaignId);
                    },
                    title: "Claim NFT",
                  ),
                ),
                const BottomButtonPadding()
              ],
            ),
          );
        })
      ],
    );
  }

  Widget _buildTextField() {
    return Center(
      child: SizedBox(
        // height: 0.06.height,
        width: 1.width,
        child: TextFormField(
          style: bodyMedium.copyWith(color: Colors.white),
          onChanged: (input) {
            // if (controller.isVerified.value != null) {
            //   controller.isVerified.value = null;
            //   // setState(() {});
            // }
            controller.onChange(input);
          },
          inputFormatters: [FilteringTextInputFormatter.deny(" ")],
          controller: controller.emailController,
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          cursorColor: ColorConst.Primary,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            isDense: true,
            counterStyle: const TextStyle(backgroundColor: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.arP),
              borderSide: BorderSide(
                  width: 2.arP,
                  color: const Color(
                    0xFF252525,
                  )),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.arP),
              borderSide: BorderSide(
                color: ColorConst.NaanRed,
                width: 1.3.arP,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.arP),
              borderSide: BorderSide(
                  width: 2.arP,
                  color: const Color(
                    0xFF252525,
                  )),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.arP),
              borderSide: BorderSide(
                  width: 2.arP,
                  color: const Color(
                    0xFF252525,
                  )),
            ),
            hintText: 'Email',
            hintStyle: bodyMedium.copyWith(
              // ignore: prefer_const_constructors
              color: Color(
                0xFF7B757F,
              ),
            ),
            labelStyle: bodyMedium,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.arP, vertical: 16.arP),
          ),
        ),
      ),
    );
  }
}
