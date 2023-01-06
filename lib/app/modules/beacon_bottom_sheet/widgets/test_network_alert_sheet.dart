import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/rpc_service/rpc_service.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/pair_request/views/pair_request_view.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/settings_page/controllers/settings_page_controller.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/select_network_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/styles/styles.dart';
import '../opreation_request/views/opreation_request_view.dart';
import '../payload_request/views/payload_request_view.dart';

class TestNetworkBottomSheet extends StatefulWidget {
  BeaconRequest request;
  TestNetworkBottomSheet({super.key, required this.request});

  @override
  State<TestNetworkBottomSheet> createState() => _TestNetworkBottomSheetState();
}

class _TestNetworkBottomSheetState extends State<TestNetworkBottomSheet> {
  String networkType = "mainnet";

  void getNetworkType() async {
    networkType = (await RpcService.getCurrentNetworkType()).toString();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getNetworkType();
  }

  @override
  Widget build(BuildContext context) {
    final settingController = Get.put(SettingsPageController());
    return Obx(() {
      return NaanBottomSheet(
        height: 0.5.height,
        bottomSheetWidgets: [
          Container(
            height: 0.45.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                0.05.vspace,
                SvgPicture.asset(
                  "${PathConst.SETTINGS_PAGE.SVG}node.svg",
                  width: 45.arP,
                ),
                0.03.vspace,
                Text(
                  "Connection Failed",
                  style: titleSmall.copyWith(color: ColorConst.Error),
                ),
                0.01.vspace,
                Text(
                  "Your app network is not the same as the network required by the dApp",
                  style: labelMedium.copyWith(
                    color: ColorConst.textGrey1,
                  ),
                  textAlign: TextAlign.center,
                ),
                0.032.vspace,
                Text(
                  "Network",
                  style: labelMedium.copyWith(color: ColorConst.textGrey1),
                ),
                0.008.vspace,
                InkWell(
                  onTap: () async {
                    await Get.bottomSheet(
                      SelectNetworkBottomSheet(),
                      enterBottomSheetDuration:
                          const Duration(milliseconds: 180),
                      exitBottomSheetDuration:
                          const Duration(milliseconds: 150),
                    );
                    networkType =
                        (await RpcService.getCurrentNetworkType()).toString();
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorConst.textGrey1),
                        color: ColorConst.darkGrey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          settingController
                                  .networkType.value.name.capitalizeFirst ??
                              "",
                          style: labelMedium,
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.white,
                          size: 20.aR,
                        )
                      ],
                    ),
                  ),
                ),
                0.05.vspace,
                Row(
                  children: [
                    Expanded(
                      child: SolidButton(
                        onPressed: Get.back,
                        borderColor: ColorConst.Neutral.shade80,
                        textColor: ColorConst.Neutral.shade80,
                        title: "Cancel",
                        primaryColor: Colors.transparent,
                      ),
                    ),
                    0.016.hspace,
                    Expanded(
                      child: SolidButton(
                        onPressed: networkType.toString() ==
                                widget.request.request!.network!.type.toString()
                            ? () {
                                Get.back();
                                switch (widget.request.type!) {
                                  case RequestType.permission:
                                    //print("Permission requested");
                                    Get.bottomSheet(const PairRequestView(),
                                        enterBottomSheetDuration:
                                            const Duration(milliseconds: 180),
                                        exitBottomSheetDuration:
                                            const Duration(milliseconds: 150),
                                        barrierColor:
                                            Colors.white.withOpacity(0.09),
                                        isScrollControlled: true,
                                        settings: RouteSettings(
                                            arguments: widget.request));
                                    break;
                                  case RequestType.signPayload:
                                    //print("payload request $widget.request");
                                    Get.bottomSheet(const PayloadRequestView(),
                                        enterBottomSheetDuration:
                                            const Duration(milliseconds: 180),
                                        exitBottomSheetDuration:
                                            const Duration(milliseconds: 150),
                                        barrierColor:
                                            Colors.white.withOpacity(0.09),
                                        isScrollControlled: true,
                                        settings: RouteSettings(
                                            arguments: widget.request));
                                    break;
                                  case RequestType.operation:
                                    //print("operation request $widget.request");
                                    Get.bottomSheet(
                                        const OpreationRequestView(),
                                        enterBottomSheetDuration:
                                            const Duration(milliseconds: 180),
                                        exitBottomSheetDuration:
                                            const Duration(milliseconds: 150),
                                        barrierColor:
                                            Colors.white.withOpacity(0.09),
                                        isScrollControlled: true,
                                        settings: RouteSettings(
                                            arguments: widget.request));
                                    break;
                                  case RequestType.broadcast:
                                    //print("broadcast request $widget.request");
                                    break;
                                }
                              }
                            : null,
                        title: "Proceed",
                      ),
                    ),
                  ],
                ),
                0.01.vspace
              ],
            ),
          )
        ],
      );
    });
  }
}
