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

class SelectCurrencyBottomSheet extends StatefulWidget {
  SelectCurrencyBottomSheet({Key? key}) : super(key: key);

  @override
  State<SelectCurrencyBottomSheet> createState() =>
      _SelectCurrencyBottomSheetState();
}

class _SelectCurrencyBottomSheetState extends State<SelectCurrencyBottomSheet> {
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
      title: "Currency",
      leading: backButton(
          lastPageName: "Settings", ontap: () => Navigator.pop(context)),
      height: AppConstant.naanBottomSheetChildHeight,
      // bottomSheetHorizontalPadding: 0,
      bottomSheetWidgets: [
        Column(
          children: [
            0.02.vspace,
            optionMethod(
              value: "tez",
              title: "Tezos (Tez)",
            ),
            const Divider(
              color: Colors.black,
              height: 1,
              thickness: 1,
            ),
            optionMethod(
              value: "usd",
              title: "United States Dollar (USD)",
            ),
            const Divider(
              color: Colors.black,
              height: 1,
              thickness: 1,
            ),
            optionMethod(
              value: "inr",
              title: "Indian Rupee(INR)",
            ),
            const Divider(
              color: Colors.black,
              height: 1,
              thickness: 1,
            ),
            optionMethod(
              value: "eur",
              title: "Euro (EUR)",
            ),
            const Divider(
              color: Colors.black,
              height: 1,
              thickness: 1,
            ),
            optionMethod(
              value: "aud",
              title: "Australian Dollar (AUD)",
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
              selectedCurrency = value;
            });
            controller.changeCurrency(value);
            Navigator.pop(context);
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
