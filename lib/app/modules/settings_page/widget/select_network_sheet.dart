import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
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

class SelectNetworkBottomSheet extends StatefulWidget {
  final String? prevPage;
  SelectNetworkBottomSheet({Key? key, this.prevPage}) : super(key: key);

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
      leading: widget.prevPage == null
          ? null
          : backButton(
              ontap: () => Navigator.pop(context),
              lastPageName: widget.prevPage),
      prevPageName: widget.prevPage,
      title: "Change network",
      height: widget.prevPage == null
          ? 360.arP
          : (AppConstant.naanBottomSheetHeight),
      bottomSheetHorizontalPadding: widget.prevPage == null ? 16.arP : 0,
      bottomSheetWidgets: [
        Obx(
          () => SizedBox(
            height: widget.prevPage == null
                ? 340.arP
                : (AppConstant.naanBottomSheetChildHeight),
            child: Column(
              children: [
                SizedBox(
                  height: 30.aR,
                ),
                optionMethod(
                  value: NetworkType.mainnet,
                  title: "Mainnet",
                ),
                const Divider(
                  color: Colors.black,
                  height: 1,
                  thickness: 1,
                ),
                optionMethod(
                  value: NetworkType.testnet,
                  title: "Testnet",
                ),
                SizedBox(
                  height: 30.aR,
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.arP),
                  child: SolidButton(
                    active: selectedNetwork != controller.networkType.value,
                    onPressed: () {
                      controller.changeNetwork(selectedNetwork);
                      if (widget.prevPage == null) {
                        Get.back();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    title: "Apply",
                  ),
                ),
                BottomButtonPadding()
              ],
            ),
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
    return BouncingWidget(
      onPressed: onTap ??
          () {
            setState(() {
              selectedNetwork = value;
            });
          },
      child: SizedBox(
        width: double.infinity,
        height: 54.arP,
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
