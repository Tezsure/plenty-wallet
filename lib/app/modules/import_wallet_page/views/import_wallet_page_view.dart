import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/widgets/accounts_widget.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../common_widgets/back_button.dart';
import '../controllers/import_wallet_page_controller.dart';
import '../widgets/custom_tab_indicator.dart';

class ImportWalletPageView extends GetView<ImportWalletPageController> {
  final bool isBottomSheet;
  const ImportWalletPageView({super.key, this.isBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    isBottomSheet ? Get.put(ImportWalletPageController()) : null;
    return DraggableScrollableSheet(
      initialChildSize: isBottomSheet ? 0.9 : 1,
      minChildSize: isBottomSheet ? 0.9 : 1,
      maxChildSize: isBottomSheet ? 0.95 : 1,
      builder: (context, scrollController) => Scaffold(
        resizeToAvoidBottomInset: isBottomSheet ? false : true,
        body: Container(
          decoration: const BoxDecoration(color: Colors.black),
          width: 1.width,
          height: 1.height,
          padding: EdgeInsets.symmetric(horizontal: 14.sp),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                0.03.vspace,
                Row(
                  children: [
                    backButton(),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          infoBottomSheet(),
                          isScrollControlled: true,
                          barrierColor: Colors.white.withOpacity(0.2),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "info",
                            style: labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorConst.NeutralVariant.shade60),
                          ),
                          0.01.hspace,
                          Icon(
                            Icons.info_outline,
                            color: ColorConst.NeutralVariant.shade60,
                            size: 16.sp,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        0.05.vspace,
                        Text(
                          "Import wallet",
                          style: titleLarge,
                        ),
                        0.04.vspace,
                        Material(
                          borderRadius: BorderRadius.circular(8.sp),
                          shadowColor: Colors.white.withOpacity(0.2),
                          color: const Color(0xff1E1C1F),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 0.02.height,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 0.18.height,
                              child: Obx(
                                () => Column(
                                  children: [
                                    0.02.vspace,
                                    Expanded(
                                      child: TextFormField(
                                        cursorColor: ColorConst.Primary,
                                        expands: true,
                                        controller: controller
                                            .phraseTextController.value,
                                        style: bodyMedium,
                                        onChanged: (value) {
                                          controller.onTextChange(value);
                                        },
                                        maxLines: null,
                                        minLines: null,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                            hintStyle: bodyMedium.apply(
                                                color: Colors.white
                                                    .withOpacity(0.2)),
                                            hintText:
                                                "Paste your secret phrase, private key\nor watch address",
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    controller.phraseText.isNotEmpty ||
                                            controller.phraseText.value != ""
                                        ? Align(
                                            alignment: Alignment.bottomRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                controller
                                                        .importWalletDataType =
                                                    ImportWalletDataType.none;
                                                controller.phraseTextController
                                                    .value.text = "";
                                                controller.phraseText.value =
                                                    "";
                                              },
                                              child: Text(
                                                "Clear",
                                                style: titleSmall.apply(
                                                    color: ColorConst.Primary),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    0.01.vspace,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => controller.phraseText.isEmpty ||
                          controller.phraseText.value == ""
                      ? pasteButton()
                      : importButton(),
                ),
                0.05.vspace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center pasteButton() {
    return Center(
      child: SolidButton(
        height: 40.sp,
        width: 326.sp,
        onPressed: controller.paste,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "${PathConst.SVG}paste.svg",
              fit: BoxFit.contain,
              height: 16.sp,
            ),
            0.02.hspace,
            Text(
              "Paste",
              style: titleSmall,
            )
          ],
        ),
      ),
    );
  }

  Widget importButton() {
    return Obx(
      () => Center(
        child: SolidButton(
          height: 50.sp,
          width: 326.sp,
          onPressed: () async {
            if (controller.importWalletDataType ==
                ImportWalletDataType.mnemonic) {
              controller.generatedAccountsTz1.value = <AccountModel>[];
              controller.generatedAccountsTz2.value = <AccountModel>[];
              controller.isTz1Selected.value = true;
              controller.tabController!.animateTo(0);
              controller.genAndLoadMoreAccounts(0, 3);
              Get.bottomSheet(
                AccountBottomSheet(
                  controller: controller,
                ),
                settings: RouteSettings(arguments: Get.arguments),
                isScrollControlled: true,
                barrierColor: Colors.white.withOpacity(0.2),
              );
            } else {
              // var pageRouteArgument = Get.arguments;
              // if (pageRouteArgument == Routes.ACCOUNT_SUMMARY) {
              //   controller.redirectBasedOnImportWalletType(pageRouteArgument);
              // } else {
              //   controller.redirectBasedOnImportWalletType();
              // }
            }
          },
          active: controller.phraseText.split(" ").join().length >= 2 &&
              controller.importWalletDataType != ImportWalletDataType.none,
          inActiveChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "${PathConst.SVG}import.svg",
                fit: BoxFit.scaleDown,
                height: 16.sp,
                color: Colors.white,
              ),
              0.03.hspace,
              Text(
                "Import",
                style:
                    titleSmall.apply(color: ColorConst.NeutralVariant.shade60),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "${PathConst.SVG}import.svg",
                fit: BoxFit.contain,
                height: 16.sp,
                color: Colors.white,
              ),
              0.03.hspace,
              Text(
                controller.importWalletDataType ==
                        ImportWalletDataType.privateKey
                    ? "Import using private key"
                    : controller.importWalletDataType ==
                            ImportWalletDataType.mnemonic
                        ? "Import using seed phrase"
                        : controller.importWalletDataType ==
                                ImportWalletDataType.watchAddress
                            ? "Import watch address"
                            : "Import",
                style: titleSmall,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget infoBottomSheet() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 1,
        minChildSize: 0.85,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xff07030c).withOpacity(0.49),
                  const Color(0xff2d004f),
                ],
              ),
            ),
            width: 1.width,
            padding: EdgeInsets.symmetric(horizontal: 0.05.width),
            child: Column(
              children: [
                0.005.vspace,
                Container(
                  height: 5,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
                0.05.vspace,
                Text(
                  "Wallets ready to import",
                  textAlign: TextAlign.start,
                  style: titleLarge,
                ),
                0.05.vspace,
                Expanded(
                  child: RawScrollbar(
                    controller: scrollController,
                    radius: const Radius.circular(2),
                    trackRadius: const Radius.circular(2),
                    thickness: 4,
                    thumbVisibility: true,
                    thumbColor: ColorConst.NeutralVariant.shade60,
                    trackColor:
                        ColorConst.NeutralVariant.shade60.withOpacity(0.4),
                    trackBorderColor:
                        ColorConst.NeutralVariant.shade60.withOpacity(0.4),
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        controller: scrollController,
                        padding: EdgeInsets.only(right: 0.03.width),
                        itemBuilder: (_, index) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$index. What is Secret Phrase?",
                                  style: bodyMedium,
                                ),
                                0.012.vspace,
                                Text(
                                  "Secret Recovery Phrase is a unique 12-word phrase that is generated when you first set up MetaMask. Your funds are connected to that phrase. If you ever lose your password, your Secret Recovery Phrase allows you to recover your wallet and your funds. Write it down on paper and hide it somewhere, put it in a safety deposit box, or use a secure password manager. Some users even engrave their phrases into metal plates!",
                                  style: bodySmall.apply(
                                      color: ColorConst.NeutralVariant.shade60),
                                ),
                              ],
                            ),
                        separatorBuilder: (_, index) => 0.04.vspace,
                        itemCount: 5),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class AccountBottomSheet extends StatelessWidget {
  const AccountBottomSheet({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ImportWalletPageController controller;

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: 5,
      height: 0.85.height,
      bottomSheetWidgets: [
        Text(
          "Select addresses",
          textAlign: TextAlign.start,
          style: titleLarge,
        ),
        0.014.vspace,
        Text(
          "Multiple addresses can be selected",
          style: bodySmall.apply(color: ColorConst.NeutralVariant.shade60),
        ),
        0.03.vspace,
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => TabBar(
                    isScrollable: true,
                    indicatorColor: ColorConst.Primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 4,
                    indicatorPadding: EdgeInsets.zero,
                    indicator: const MaterialIndicator(
                      color: ColorConst.Primary,
                      height: 4,
                      topLeftRadius: 4,
                      topRightRadius: 4,
                      strokeWidth: 4,
                    ),
                    controller: controller.tabController,
                    labelPadding: EdgeInsets.zero,
                    tabs: [
                      Tab(
                        child: SizedBox(
                          width: controller.selectedAccountsTz1.isNotEmpty
                              ? 84
                              : 61,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Tz1"),
                              if (controller.selectedAccountsTz1.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: ColorConst.Primary,
                                    child: Text(
                                        controller.selectedAccountsTz1.length
                                            .toString(),
                                        style: labelSmall),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: controller.selectedAccountsTz2.isNotEmpty
                              ? 84
                              : 61,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Tz2"),
                              if (controller.selectedAccountsTz2.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: ColorConst.Primary,
                                    child: Text(
                                        controller.selectedAccountsTz2.length
                                            .toString(),
                                        style: labelSmall),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                0.015.vspace,
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [AccountWidget(), AccountWidget()],
                  ),
                )
              ],
            ),
          ),
        ),
        0.03.vspace,
        SolidButton(
          onPressed: () {
            controller.redirectBasedOnImportWalletType();
          },
          title: "Import",
        ),
        0.05.vspace
      ],
    );
  }
}
