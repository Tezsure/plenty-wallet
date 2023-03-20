import 'package:beacon_flutter/models/p2p_peer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class ConnectedDappBottomSheet extends StatelessWidget {
  final String? prevPage;
  ConnectedDappBottomSheet({Key? key, this.prevPage}) : super(key: key);

  final SettingsPageController controller = Get.find<SettingsPageController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NaanBottomSheet(
        prevPageName: prevPage,
        // blurRadius: 5,
        height: controller.dapps.isEmpty
            ? AppConstant.naanBottomSheetChildHeight / 1.5
            : (AppConstant.naanBottomSheetHeight -
                (prevPage == null ? 0 : 064.arP)),
        leading: prevPage == null
            ? null
            : backButton(
                ontap: () => Navigator.pop(context), lastPageName: prevPage),
        // isScrollControlled: true,
        title: controller.dapps.isEmpty ? "" : "Connected apps",
        // bottomSheetHorizontalPadding: prevPage == null ? 16.arP : 0,
        bottomSheetWidgets: [
          0.02.vspace,
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
                        "No connected apps".tr,
                        style: titleLarge,
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
    return BouncingWidget(
      onPressed: () {
        CommonFunctions.bottomSheet(
          disconnectDappBottomSheet(index),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.arP),
        width: double.infinity,
        child: Row(
          children: [
            _buildImage(dappModel),
            0.045.hspace,
            Text(
              dappModel.name,
              style: labelLarge,
            ),
            const Spacer(),
            SvgPicture.asset(
              "${PathConst.SVG}trash.svg",
              // color: ColorConst.Neutral.shade100,
              width: 20.arP,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(P2PPeer dappModel) {
    return SizedBox(
      width: 44.arP,
      height: 44.arP,
      child: ClipOval(
          child: dappModel.icon?.contains(".svg") ?? false
              ? SvgPicture.network(
                  dappModel.icon ?? "",
                )
              : Image.network(
                  dappModel.icon ?? "",
                  errorBuilder: (context, error, stackTrace) {
                    return _errorBuilder(dappModel);
                  },
                )),
    );
  }

  Container _errorBuilder(P2PPeer dappModel) {
    return Container(
      padding: EdgeInsets.all(6.arP),
      alignment: Alignment.center,
      color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      child: Container(
        width: 24.aR,
        height: 24.aR,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            dappModel.name.substring(0, 1),
            style: bodySmall.copyWith(
              color: ColorConst.NeutralVariant.shade60,
            ),
          ),
        ),
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
            "You can reconnect to this app later".tr,
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
        ),
        0.03.vspace,
        Column(
          children: [
            optionMethod(
                child: Text(
                  "Disconnect".tr,
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
                  "Cancel".tr,
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
    return BouncingWidget(
      onPressed: onTap,
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
