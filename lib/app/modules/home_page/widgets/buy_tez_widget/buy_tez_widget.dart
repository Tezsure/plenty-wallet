import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/account_selector.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/widgets/account_selector/account_selector.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../dapp_browser/views/dapp_browser_view.dart';

class BuyTezWidget extends StatelessWidget {
  const BuyTezWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.put(AccountSummaryController());
        HomePageController home = Get.find<HomePageController>();
/*         Get.bottomSheet(
          AccountSelectorSheet(
            onNext: () {
              HomePageController home = Get.find<HomePageController>();

              String url =
                  "https://wert.naan.app?address=${home.userAccounts[home.selectedIndex.value].publicKeyHash}";

              print(url);
              Get.bottomSheet(
                const DappBrowserView(),
                barrierColor: Colors.white.withOpacity(0.09),
                settings: RouteSettings(
                  arguments: url,
                ),
                isScrollControlled: true,
              );
            },
          ),
          isScrollControlled: true,
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
        ); */
        Get.bottomSheet(
          AccountSwitch(controller: home),
          isScrollControlled: true,
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
        );
      },
      child: Container(
        height: 0.405.width,
        width: 0.405.width,
        margin: EdgeInsets.only(left: 24.sp),
        decoration: BoxDecoration(
          gradient: appleYellow,
          borderRadius: BorderRadius.circular(22.sp),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset("${PathConst.HOME_PAGE.SVG}buy_tez.svg"),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Buy Tez",
                        style: headlineSmall.copyWith(fontSize: 20.sp)),
                    Text(
                      "with credit card",
                      style: bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountSwitch extends StatefulWidget {
  const AccountSwitch({super.key, required this.controller});
  final HomePageController controller;
  @override
  State<AccountSwitch> createState() => _AccountSwitchState();
}

class _AccountSwitchState extends State<AccountSwitch> {
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(height: 0.45.height, bottomSheetHorizontalPadding: 0,
        // width: 1.width,

        // decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        //     color: Colors.black),
        bottomSheetWidgets: [
          Container(
            height: 0.4.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 0.005.vspace,
                // Container(
                //   height: 5,
                //   width: 36,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5),
                //     color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                //   ),
                // ),
                // 0.04.vspace,
                0.04.vspace,
                Text(
                  "Buy Tez",
                  style: titleLarge,
                ),

                0.01.vspace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.arP),
                  child: Text(
                    'This module will be powered by wert.io and you will be using wert’s interface.',
                    style: bodySmall.copyWith(
                      color: ColorConst.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                0.04.vspace,
                Text(
                  'Choose Account',
                  style: bodySmall.copyWith(color: ColorConst.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: InkWell(
                    onTap: () async {
                      final selectedIndex = await Get.bottomSheet(
                        AccountSelector(
                          accountModels: widget.controller.userAccounts,
                          index: widget.controller.selectedIndex.value,
                        ),
                        enterBottomSheetDuration:
                            const Duration(milliseconds: 180),
                        exitBottomSheetDuration:
                            const Duration(milliseconds: 150),
                        barrierColor: Colors.white.withOpacity(0.09),
                        isScrollControlled: true,
                      );
                      if (selectedIndex != null) {
                        widget.controller.selectedIndex.value = selectedIndex;
                      }
                    },
                    child: Obx(() => Container(
                          height: 42.arP,
                          width: 0.5.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorConst.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            color: ColorConst.darkGrey,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  height: 0.06.width,
                                  width: 0.06.width,
                                  alignment: Alignment.bottomRight,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: widget
                                                  .controller
                                                  .userAccounts[widget
                                                      .controller
                                                      .selectedIndex
                                                      .value]
                                                  .imageType ==
                                              AccountProfileImageType.assets
                                          ? AssetImage(widget
                                              .controller
                                              .userAccounts[widget.controller
                                                  .selectedIndex.value]
                                              .profileImage
                                              .toString())
                                          : FileImage(
                                              File(
                                                widget
                                                    .controller
                                                    .userAccounts[widget
                                                        .controller
                                                        .selectedIndex
                                                        .value]
                                                    .profileImage
                                                    .toString(),
                                              ),
                                            ) as ImageProvider,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                  widget
                                      .controller
                                      .userAccounts[
                                          widget.controller.selectedIndex.value]
                                      .name
                                      .toString(),
                                  style: titleSmall.copyWith(
                                      fontWeight: FontWeight.w500)),
                              const Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: Colors.white,
                              )
                            ],
                          ),
                        )),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0.arP),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: SolidButton(
                              primaryColor: Colors.black,
                              borderColor: ColorConst.Primary.shade60,
                              borderWidth: 1.5,
                              onPressed: () {
                                Get.back();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  'Cancel',
                                  style: bodyMedium.copyWith(
                                      color: ColorConst.Primary.shade60),
                                ),
                              ),
                            ),
                          ),
                          0.04.hspace,
                          Expanded(
                            child: SolidButton(
                              title: "Proceed",
                              onPressed: () {
                                Get.back();
                                String url =
                                    "https://wert.naan.app?address=${widget.controller.userAccounts[widget.controller.selectedIndex.value].publicKeyHash}";
                                Get.bottomSheet(
                                  const DappBrowserView(),
                                  barrierColor: Colors.white.withOpacity(0.09),
                                  settings: RouteSettings(
                                    arguments: url,
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
          )
        ]);
  }
}
