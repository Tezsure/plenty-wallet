import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class SelectLanguageBottomSheet extends StatefulWidget {
  SelectLanguageBottomSheet({Key? key}) : super(key: key);

  @override
  State<SelectLanguageBottomSheet> createState() =>
      _SelectLanguageBottomSheetState();
}

class _SelectLanguageBottomSheetState extends State<SelectLanguageBottomSheet> {
  final SettingsPageController controller = Get.find<SettingsPageController>();
  late String selectedCurrency;
  @override
  void initState() {
    selectedCurrency = controller.selectedCurrency.value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      prevPageName: "Settings",
      title: "Language",
      leading: backButton(
          lastPageName: "Settings", ontap: () => Navigator.pop(context)),
      height: AppConstant.naanBottomSheetChildHeight,
      bottomSheetHorizontalPadding: 0,
      bottomSheetWidgets: [
        Column(
          children: [
            SizedBox(
              height: 30.aR,
            ),
            optionMethod(
              value: "usd",
              title: "English (US)",
            ),
            // const Divider(
            //   color: Colors.black,
            //   height: 1,
            //   thickness: 1,
            // ),
            // optionMethod(
            //   value: "inr",
            //   title: "Indian Rupee(INR)",
            // ),
            // const Divider(
            //   color: Colors.black,
            //   height: 1,
            //   thickness: 1,
            // ),
            // optionMethod(
            //   value: "eur",
            //   title: "Euro (EUR)",
            // ),

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
              selectedCurrency = value;
            });
            controller.changeCurrency(value);
            Get.back();
          },
      child: SizedBox(
        width: double.infinity,
        height: 54.arP,
        child: Row(
          children: [
            Image.asset(
              "${PathConst.SETTINGS_PAGE}currencies/$value.png",
              height: 40.arP,
              fit: BoxFit.contain,
            ),
            SizedBox(
              width: 20.arP,
            ),
            Text(
              title,
              style: labelMedium,
            ),
            const Spacer(),
            if (selectedCurrency.toLowerCase() == value.toLowerCase())
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
