import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/widgets/account_selector/account_selector.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class AccountSwitch extends StatefulWidget {
  final Function() onNext;
  final String title;
  final String subtitle;
  const AccountSwitch({
    super.key,
    required this.onNext,
    required this.title,
    required this.subtitle,
  });
  // final HomePageController controller;
  @override
  State<AccountSwitch> createState() => _AccountSwitchState();
}

class _AccountSwitchState extends State<AccountSwitch> {
  final HomePageController controller = Get.find<HomePageController>();
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
                  widget.title,
                  style: titleLarge,
                ),

                0.01.vspace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.arP),
                  child: Text(
                    widget.subtitle,
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
                          accountModels: controller.userAccounts,
                          index: controller.selectedIndex.value,
                        ),
                        enterBottomSheetDuration:
                            const Duration(milliseconds: 180),
                        exitBottomSheetDuration:
                            const Duration(milliseconds: 150),
                        barrierColor: Colors.white.withOpacity(0.09),
                        isScrollControlled: true,
                      );
                      if (selectedIndex != null) {
                        controller.selectedIndex.value = selectedIndex;
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
                                      image: controller
                                                  .userAccounts[controller
                                                      .selectedIndex.value]
                                                  .imageType ==
                                              AccountProfileImageType.assets
                                          ? AssetImage(controller
                                              .userAccounts[controller
                                                  .selectedIndex.value]
                                              .profileImage
                                              .toString())
                                          : FileImage(
                                              File(
                                                controller
                                                    .userAccounts[controller
                                                        .selectedIndex.value]
                                                    .profileImage
                                                    .toString(),
                                              ),
                                            ) as ImageProvider,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                  controller
                                      .userAccounts[
                                          controller.selectedIndex.value]
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
                                  widget.onNext();
                                }),
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
