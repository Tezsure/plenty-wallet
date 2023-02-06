import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/iaf/controller/iaf_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class IAFSheet extends StatefulWidget {
  IAFSheet({super.key});

  @override
  State<IAFSheet> createState() => _IAFSheetState();
}

class _IAFSheetState extends State<IAFSheet> {
  final controller = Get.find<IAFController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetHorizontalPadding: 0,
      title: "Claim NFT",
      height: AppConstant.naanBottomSheetHeight -
          MediaQuery.of(context).viewInsets.bottom,
      bottomSheetWidgets: [
        Obx(() {
          return SizedBox(
            height: AppConstant.naanBottomSheetChildHeight -
                32.arP -
                MediaQuery.of(context).viewInsets.bottom,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                0.02.vspace,

                // 0.016.vspace,
                Center(
                  child: Text(
                    "Enter the email ID you've submitted \nfor claiming the NFT at India Art Fair",
                    textAlign: TextAlign.center,
                    style: bodySmall.copyWith(
                      color: ColorConst.grey,
                    ),
                  ),
                ),
                0.032.vspace,
                _buildTextField(),
                0.018.vspace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.arP),
                  child: getBadge(),
                ),
                const Spacer(),
                Center(
                  child: SolidButton(
                    width: 1.width - 64.arP,
                    isLoading: controller.isLoading,
                    active: controller.isButtonEnabled.value ,
                    onPressed: () async {
                      if (controller.isVerified.value ?? false) {
                        await controller.claim();
                      } else {
                        await controller.verify();
                      }
                      setState(() {});
                    },
                    title: controller.isVerified.value ?? false
                        ? "Claim NFT"
                        : controller.isVerified.value == null
                            ? "Verify"
                            : "Enter valid  email id",
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

  Container _buildVerifiedBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.arP, vertical: 6.arP),
      decoration: BoxDecoration(
          color: Color(0xFF171717),
          borderRadius: BorderRadius.circular(16.arP)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/svg/check-circle.svg"),
          SizedBox(
            width: 8.arP,
          ),
          Text(
            "Verified",
            style: labelMedium.copyWith(color: ColorConst.green),
          )
        ],
      ),
    );
  }

  Container _buildAlertBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.arP, vertical: 6.arP),
      decoration: BoxDecoration(
          color: Color(0xFF171717),
          borderRadius: BorderRadius.circular(16.arP)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/svg/alert-circle.svg"),
          SizedBox(
            width: 8.arP,
          ),
          Text(
            "Not verified",
            style: labelMedium.copyWith(color: ColorConst.Tertiary),
          )
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return Obx(() {
      return Center(
        child: SizedBox(
          // height: 0.06.height,
          width: 1.width - 44.arP,
          child: TextFormField(
            style: bodyLarge.copyWith(color: Colors.white),
            onChanged: (input) {
              if (controller.isVerified.value != null) {
                controller.isVerified = null.obs;
                setState(() {});
              }
              controller.onChange(input);
            },
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
                borderSide: controller.isVerified.value == null
                    ? BorderSide.none
                    : BorderSide(
                        color: getColor(),
                        width: 1.3.arP,
                      ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.arP),
                borderSide: BorderSide(
                  color: ColorConst.green,
                  width: 1.3.arP,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.arP),
                borderSide: controller.isVerified.value == null
                    ? BorderSide.none
                    : BorderSide(
                        color: getColor(),
                        width: 1.3.arP,
                      ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.arP),
                borderSide: controller.isVerified.value == null
                    ? BorderSide.none
                    : BorderSide(
                        color: getColor(),
                        width: 1.3.arP,
                      ),
              ),
              hintText: 'Email',
              hintStyle: bodyLarge.copyWith(
                // ignore: prefer_const_constructors
                color: Color(
                  0xFF7B757F,
                ),
              ),
              labelStyle: labelSmall,
              // contentPadding:
              //     const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            ),
          ),
        ),
      );
    });
  }

  Color getColor() {
    if (controller.isVerified.value == null) {
      return const Color(
        0xFF252525,
      );
    }
    if (controller.isVerified.value!) return ColorConst.green;
    return ColorConst.Tertiary;
  }

  Widget getBadge() {
    if (controller.isVerified.value == null) {
      return Container();
    }
    if (controller.isVerified.value!) return _buildVerifiedBadge();
    return _buildAlertBadge();
  }
}
