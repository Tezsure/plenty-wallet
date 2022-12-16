import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class SelectNetworkBottomSheet extends StatefulWidget {
  SelectNetworkBottomSheet({Key? key}) : super(key: key);

  @override
  State<SelectNetworkBottomSheet> createState() =>
      _SelectNetworkBottomSheetState();
}

class _SelectNetworkBottomSheetState extends State<SelectNetworkBottomSheet> {
  final SettingsPageController controller = Get.find<SettingsPageController>();
  late NetworkType selectedNetwork;
  @override
  void initState() {
    selectedNetwork = controller.networkType.value;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "Select Network",
      blurRadius: 5,
      height: 360.arP,
      bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        Obx(
          () => Column(
            children: [
              SizedBox(
                height: 30.aR,
              ),
              optionMethod(
                value: NetworkType.mainnet,
                title: "Main net",
              ),
              const Divider(
                color: Colors.black,
                height: 1,
                thickness: 1,
              ),
              optionMethod(
                value: NetworkType.testnet,
                title: "Test net",
              ),
              SizedBox(
                height: 30.aR,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.arP),
                child: SolidButton(
                  active: selectedNetwork != controller.networkType.value,
                  onPressed: () {
                    controller.changeNetwork(selectedNetwork);
                    Get.back();
                  },
                  title: "Apply",
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget optionMethod({
    required String title,
    GestureTapCallback? onTap,
    required NetworkType value,
  }) {
    return InkWell(
      onTap: onTap ??
          () {
            setState(() {
              selectedNetwork = value;
            });
          },
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: Row(
          children: [
            Text(
              title,
              style: labelMedium,
            ),
            const Spacer(),
            if (selectedNetwork.index == value.index)
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
