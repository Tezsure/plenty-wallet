import 'package:beacon_flutter/models/p2p_peer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/enums/network_enum.dart';
import 'package:naan_wallet/app/modules/settings_page/models/dapp_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
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
      isScrollControlled: true,
      title: "Connected apps",
      bottomSheetHorizontalPadding: 13,
      bottomSheetWidgets: [
        Obx(
          () {
            if (controller.dapps.isEmpty) {
              return Center(
                child: Text(
                  "No Dapp connected",
                  style: bodySmall.copyWith(
                    color: ColorConst.textGrey1,
                  ),
                ),
              );
            }
            return Column(
              children: List.generate(
                  controller.dapps.length,
                  (index) => dappWidgetMethod(
                      dappModel: controller.dapps[index], index: index)),
            );
          },
        ),
      ],
    );
  }

  Widget dappWidgetMethod({
    required P2PPeer dappModel,
    required int index,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(dappModel.icon ?? ""),
            radius: 22,
            backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          ),
          0.045.hspace,
          Text(
            dappModel.name,
            style: labelLarge,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Get.bottomSheet(disconnectDappBottomSheet(index),
                  enterBottomSheetDuration: const Duration(milliseconds: 180),
                  exitBottomSheetDuration: const Duration(milliseconds: 150),
                  barrierColor: Colors.transparent);
            },
            icon: SvgPicture.asset(
              "${PathConst.SVG}trash.svg",
              // color: ColorConst.Neutral.shade100,
              width: 20.sp,
            ),
            color: ColorConst.Primary,
          )
        ],
      ),
    );
  }

  Widget disconnectDappBottomSheet(int index) {
    return NaanBottomSheet(
      title: "Disconnect app",
      blurRadius: 5,
      height: 275,
      bottomSheetWidgets: [
        Center(
          child: Text(
            "You can reconnect to this app later",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
        ),
        0.03.vspace,
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Column(
            children: [
              optionMethod(
                  child: Text(
                    "Disconnect",
                    style: labelMedium.apply(color: ColorConst.Error.shade60),
                  ),
                  onTap: () {
                    controller.disconnectDApp(index);
                    Get.back();
                  }),
              SizedBox(
                height: 16.arP,
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

  Widget optionMethod({Widget? child, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        ),
        width: double.infinity,
        height: 54,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
