import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/models/dapp_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class ConnectedDappBottomSheet extends StatelessWidget {
  ConnectedDappBottomSheet({Key? key}) : super(key: key);

  final SettingsPageController controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: 5,
      height: 0.87.height,
      bottomSheetHorizontalPadding: 13,
      bottomSheetWidgets: [
        Center(
          child: Text(
            'Connected Applications',
            style: titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        0.03.vspace,
        Obx(
          () => Column(
            children: List.generate(
                controller.dapps.length,
                (index) => dappWidgetMethod(
                    dappModel: controller.dapps[index], index: index)),
          ),
        ),
      ],
    );
  }

  Widget dappWidgetMethod({
    required DappModel dappModel,
    required int index,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          ),
          0.045.hspace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                dappModel.name!,
                style: labelLarge,
              ),
              Text(
                // ignore: prefer_interpolation_to_compose_strings
                "Network: " +
                    (dappModel.networkType == NetworkType.mainNet
                        ? "Mainnet"
                        : "Testnet"),
                style:
                    labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
              )
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Get.bottomSheet(disconnectDappBottomSheet(index),
                  barrierColor: Colors.transparent);
            },
            icon: Icon(Icons.delete_outline_sharp),
            color: ColorConst.Primary,
          )
        ],
      ),
    );
  }

  Widget disconnectDappBottomSheet(int index) {
    return NaanBottomSheet(
      blurRadius: 5,
      height: 247,
      bottomSheetWidgets: [
        Text(
          'Disconnect DApp',
          style: labelMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "You can reconnect to this DApp later",
          style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
        ),
        0.03.vspace,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          ),
          child: Column(
            children: [
              optionMethod(
                  child: Text(
                    "Disconnect",
                    style: labelMedium.apply(color: ColorConst.Error.shade60),
                  ),
                  onTap: () {
                    controller.dapps.removeAt(index);
                    Get.back();
                  }),
              const Divider(
                color: Color(0xff4a454e),
                height: 1,
                thickness: 1,
              ),
              optionMethod(
                  child: Text(
                    "Cancel",
                    style: labelMedium,
                  ),
                  onTap: () {
                    Get.back();
                  }),
            ],
          ),
        ),
      ],
    );
  }

  InkWell optionMethod({Widget? child, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
