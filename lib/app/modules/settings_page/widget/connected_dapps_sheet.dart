import 'package:beacon_flutter/models/p2p_peer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class ConnectedDappBottomSheet extends StatelessWidget {
  ConnectedDappBottomSheet({Key? key}) : super(key: key);

  final SettingsPageController controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NaanBottomSheet(
        blurRadius: 5,
        height: 0.87.height,
        isScrollControlled: true,
        title: controller.dapps.isEmpty ? "" : "Connected apps",
        bottomSheetHorizontalPadding: 16.arP,
        bottomSheetWidgets: [
          SizedBox(
            height: 20.arP,
          ),
          Obx(
            () {
              if (controller.dapps.isEmpty) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 32.arP),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 1.width,
                      ),
                      SvgPicture.asset(
                        "${PathConst.SVG}no_apps.svg",
                        width: 249.arP,
                      ),
                      0.03.vspace,
                      Text(
                        "No connected apps",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.arP,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: List.generate(
                    controller.dapps.length,
                    (index) => controller.dapps[index].isPaired!
                        ? dappWidgetMethod(
                            dappModel: controller.dapps[index], index: index)
                        : const SizedBox()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget dappWidgetMethod({
    required P2PPeer dappModel,
    required int index,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.arP),
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: dappModel.icon != null
                ? ColorConst.NeutralVariant.shade60.withOpacity(0.2)
                : ColorConst.Primary,
            backgroundImage: CachedNetworkImageProvider(dappModel.icon ?? ""),
            child: dappModel.icon == null
                ? Text(
                    dappModel.name.substring(0, 1).toUpperCase(),
                    style: titleMedium.copyWith(color: Colors.white),
                  )
                : Container(),
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
        Column(
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
        height: 50.arP,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
