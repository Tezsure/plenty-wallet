import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';

class SelectSaftyResetBottomSheet extends StatefulWidget {
  SelectSaftyResetBottomSheet({Key? key}) : super(key: key);

  @override
  State<SelectSaftyResetBottomSheet> createState() =>
      _SelectSaftyResetBottomSheetState();
}

class _SelectSaftyResetBottomSheetState
    extends State<SelectSaftyResetBottomSheet> {
  final SettingsPageController controller = Get.find<SettingsPageController>();
  late String selectedWrongAttempts;
  @override
  void initState() {
    selectedWrongAttempts = controller.selectedWrongAttempts.value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      prevPageName: "Settings",
      title: "Safety Reset",
      leading: backButton(
          lastPageName: "Settings", ontap: () => Navigator.pop(context)),
      height: AppConstant.naanBottomSheetChildHeight,
      // bottomSheetHorizontalPadding: 0,
      bottomSheetWidgets: [
        Column(
          children: [
            0.02.vspace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.arP),
              child: Text(
                "Enhance your wallet's security with an option to automatically erase all data after a series of incorrect passcode attempts.",
                textAlign: TextAlign.center,
                style: labelSmall.copyWith(
                    fontSize: 12.aR, color: const Color(0xFF958E99)),
              ),
            ),
            0.02.vspace,
            optionMethod(
              value: "Disabled",
              title: "Disabled",
            ),
            const Divider(
              color: Colors.black,
              height: 1,
              thickness: 1,
            ),
            optionMethod(
              value: "10",
              title: "10 attempts",
            ),
            const Divider(
              color: Colors.black,
              height: 1,
              thickness: 1,
            ),
            optionMethod(
              value: "20",
              title: "20 attempts",
            ),
            const Divider(
              color: Colors.black,
              height: 1,
              thickness: 1,
            ),
            optionMethod(
              value: "30",
              title: "30 attempts",
            ),

/*               Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.arP),
                child: SolidButton(
                  active: selectedNetwork != controller.networkType.value,
                  onPressed: () {
                    controller.changeNetwork(selectedNetwork, context);
                    Get.back();
                  },
                  title: "Apply",
                ),
              ) */
          ],
        ),
      ],
    );
  }

  Widget optionMethod({
    required String title,
    GestureTapCallback? onTap,
    required String value,
  }) {
    return BouncingWidget(
      onPressed: onTap ??
          () {
            setState(() {
              selectedWrongAttempts = value;
            });
            // if disabled then null
            controller.changeSafetyReset(value == "Disabled" ? null : value);
            Navigator.pop(context);
          },
      child: SizedBox(
        width: double.infinity,
        height: 54.arP,
        child: Row(
          children: [
            // Image.asset(
            //   "${PathConst.SETTINGS_PAGE}currencies/$value.png",
            //   height: 40.arP,
            //   fit: BoxFit.contain,
            // ),
            SizedBox(
              width: 18.arP,
            ),
            Text(
              title,
              style: labelMedium,
            ),
            const Spacer(),
            if (selectedWrongAttempts.toLowerCase() == value.toLowerCase())
              SvgPicture.asset(
                "${PathConst.SVG}check_3.svg",
                height: 20.arP,
                fit: BoxFit.contain,
              ),
          ],
        ),
      ),
    );
  }
}
