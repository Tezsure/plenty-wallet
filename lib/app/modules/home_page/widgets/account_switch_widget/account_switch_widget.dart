import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/widgets/account_selector/account_selector.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
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
  void initState() {
    super.initState();
    if (controller.userAccounts[controller.selectedIndex.value].isWatchOnly) {
      controller.selectedIndex.value =
          controller.userAccounts.indexWhere((element) => !element.isWatchOnly);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
        // height: 0.38.height,
        // bottomSheetHorizontalPadding: 0,
        title: widget.title,
        isScrollControlled: true,

        // width: 1.width,

        // decoration: const BoxDecoration(
        //     borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        //     color: Colors.black),
        bottomSheetWidgets: [
          Container(
              height: 0.3.height,
              constraints:
                  BoxConstraints(maxHeight: .7.height, minHeight: .3.height),
              child: Container(
                height: 0.3.height,
                child: SafeArea(
                  child: Column(
                    children: [
                      0.002.vspace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.arP),
                        child: Text(
                          widget.subtitle.tr,
                          style: bodySmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      0.04.vspace,
                      Text(
                        'Choose account'.tr,
                        style: bodySmall.copyWith(color: ColorConst.grey),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.arP),
                        child: BouncingWidget(
                          onPressed: () async {
                            final selectedIndex =
                                await CommonFunctions.bottomSheet(
                              AccountSwitchSelector(
                                accountModels: controller.userAccounts
                                    .where((e) => !e.isWatchOnly)
                                    .toList(),
                                index: controller
                                        .userAccounts[
                                            controller.selectedIndex.value]
                                        .isWatchOnly
                                    ? 0
                                    : controller.selectedIndex.value,
                              ),
                            );
                            if (selectedIndex != null) {
                              controller.changeSelectedAccount(selectedIndex);
                              try {
                                Get.find<AccountsWidgetController>()
                                    .onPageChanged(selectedIndex);
                              } catch (e) {}
                              // controller.selectedIndex.value = selectedIndex;
                            }
                          },
                          child: Obx(() => Container(
                                // height: 42.arP,
                                // width: 0.45.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorConst.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  color: ColorConst.darkGrey,
                                ),
                                margin: EdgeInsets.only(
                                  left: 32.arP,
                                  right: 32.arP,
                                ),
                                padding: EdgeInsets.only(
                                    left: 16.arP,
                                    right: 16.arP,
                                    top: 8.arP,
                                    bottom: 8.arP),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        height: 24.arP,
                                        width: 24.arP,
                                        alignment: Alignment.bottomRight,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: controller
                                                        .userAccounts[controller
                                                                .userAccounts[
                                                                    controller
                                                                        .selectedIndex
                                                                        .value]
                                                                .isWatchOnly
                                                            ? 0
                                                            : controller
                                                                .selectedIndex
                                                                .value]
                                                        .imageType ==
                                                    AccountProfileImageType
                                                        .assets
                                                ? AssetImage(
                                                    controller
                                                            .userAccounts[
                                                                controller
                                                                    .selectedIndex
                                                                    .value]
                                                            .isWatchOnly
                                                        ? controller
                                                            .userAccounts[0]
                                                            .profileImage
                                                            .toString()
                                                        : controller
                                                            .userAccounts[
                                                                controller
                                                                    .selectedIndex
                                                                    .value]
                                                            .profileImage
                                                            .toString(),
                                                  )
                                                : FileImage(
                                                    File(
                                                      controller
                                                              .userAccounts[
                                                                  controller
                                                                      .selectedIndex
                                                                      .value]
                                                              .isWatchOnly
                                                          ? controller
                                                              .userAccounts[0]
                                                              .profileImage
                                                              .toString()
                                                          : controller
                                                              .userAccounts[
                                                                  controller
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
                                        controller
                                                .userAccounts[controller
                                                    .selectedIndex.value]
                                                .isWatchOnly
                                            ? controller.userAccounts[0].name
                                                .toString()
                                            : controller
                                                .userAccounts[controller
                                                    .selectedIndex.value]
                                                .name
                                                .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
                      0.02.vspace,
                      Expanded(
                          child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: SolidButton(
                                  primaryColor: Colors.black,
                                  // borderColor: ColorConst.Primary.shade60,
                                  borderColor: const Color(0xFFE8A2B9),
                                  borderWidth: 1.5,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Text(
                                      'Cancel'.tr,
                                      style: bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(
                                          0xFFE8A2B9,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              0.016.hspace,
                              Expanded(
                                child: SolidButton(
                                    title: "Proceed",
                                    onPressed: () {
                                      Get.back(result: true);
                                      widget.onNext();
                                    }),
                              ),
                            ],
                          )
                        ],
                      )),
                      const BottomButtonPadding()
                    ],
                  ),
                ),
              ))
        ]);
  }
}
