import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/enums/enums.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/widgets/accounts_widget.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/widgets/custom_tab_indicator.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../controllers/import_wallet_page_controller.dart';

class ImportWalletPageView extends GetView<ImportWalletPageController> {
  bool isBottomSheet;
  bool isWatchAddress;
  ImportWalletPageView({
    Key? key,
    this.isBottomSheet = false,
    this.isWatchAddress = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ImportWalletPageController());
    if (isBottomSheet) {
      return NaanBottomSheet(
        // bottomSheetHorizontalPadding: 16.arP,
        // isScrollControlled: true,
        height: AppConstant.naanBottomSheetHeight,
        bottomSheetWidgets: [
          SizedBox(
              height: AppConstant.naanBottomSheetChildHeight -
                  MediaQuery.of(context).viewInsets.bottom +
                  63.arP,
              child: _buildBody(context,
                  isWatchAddress: isWatchAddress, isBottomSheet: isBottomSheet))
        ],
      );
    }
    return OverrideTextScaleFactor(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.arP),
          child: SafeArea(bottom: false, child: _buildBody(context)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context,
      {bool isWatchAddress = false, bool isBottomSheet = false}) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.02.vspace,
          Row(
            children: [
              !isBottomSheet ? backButton() : const SizedBox(),
              // GestureDetector(
              //   onTap: () => Get.back(),
              //   child: SvgPicture.asset(
              //     "${PathConst.SVG}arrow_back.svg",
              //     fit: BoxFit.scaleDown,
              //   ),
              // ),
              const Spacer(),
              InfoButton(
                onPressed: () {
                  CommonFunctions.bottomSheet(
                    InfoBottomSheet(isWatchAddress: isWatchAddress),
                  );
                },
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.bottomSheet(
              //       const InfoBottomSheet(),
              //       isScrollControlled: true,
              //       barrierColor: Colors.white.withOpacity(0.2),
              //     );
              //   },
              //   child: Row(
              //     children: [
              //       Text(
              //         "info",
              //         style: titleMedium.copyWith(
              //             fontWeight: FontWeight.w600,
              //             color: ColorConst.NeutralVariant.shade60),
              //       ),
              //       0.01.hspace,
              //       Icon(
              //         Icons.info_outline,
              //         color: ColorConst.NeutralVariant.shade60,
              //         size: 16,
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: isWatchAddress
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  0.05.vspace,
                  Text(
                    isWatchAddress ? "Add a watch address" : "Import account",
                    style: titleLarge,
                  ),
                  0.023.vspace,
                  Material(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.2),
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny("  "),
                                    // FilteringTextInputFormatter.deny(".")
                                  ],
                                  controller:
                                      controller.phraseTextController.value,
                                  style: bodyMedium,
                                  onChanged: (value) {
                                    controller.onTextChange(value);
                                  },
                                  maxLines: null,
                                  minLines: null,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(0),
                                      hintStyle: bodyMedium.apply(
                                          color: Colors.white.withOpacity(0.2)),
                                      hintText: isWatchAddress
                                          ? "Enter wallet address or tezos domain "
                                          : "Paste your secret phrase, private key\nor watch address",
                                      border: InputBorder.none),
                                ),
                              ),
                              controller.phraseText.isNotEmpty ||
                                      controller.phraseText.value != ""
                                  ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.importWalletDataType =
                                              ImportWalletDataType.none;
                                          controller.phraseTextController.value
                                              .text = "";
                                          controller.phraseText.value = "";
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
          Center(
            child: Obx(
              () => controller.phraseText.isEmpty ||
                      controller.phraseText.value == ""
                  ? pasteButton()
                  : importButton(
                      isWatchAddress: isWatchAddress,
                    ),
            ),
          ),
          const BottomButtonPadding()
          // SizedBox(
          //   height: MediaQuery.of(context).viewInsets.bottom,
          // )
        ],
      ),
    );
  }

  SolidButton pasteButton() {
    return SolidButton(
      width: 1.width - 64.arP,
      onPressed: controller.paste,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "${PathConst.SVG}paste.svg",
            color: Colors.white,
            fit: BoxFit.scaleDown,
          ),
          0.02.hspace,
          Text(
            "Paste",
            style: titleSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget importButton({bool isWatchAddress = false}) {
    return Obx(
      () {
        controller.phraseText.value;
        return SolidButton(
          title: "Import",
          width: 1.width - 64.arP,
          onPressed: () async {
            controller.phraseText.value = controller.phraseText.value.trim();
            if (controller.importWalletDataType ==
                    ImportWalletDataType.mnemonic &&
                !isWatchAddress) {
              controller.generatedAccountsTz1.value = <AccountModel>[];
              controller.generatedAccountsTz2.value = <AccountModel>[];
              controller.isTz1Selected.value = true;
              controller.tabController!.animateTo(0);
              controller.genAndLoadMoreAccounts(0, 3);
              CommonFunctions.bottomSheet(
                AccountBottomSheet(controller: controller),
              );
            } else {
              controller.redirectBasedOnImportWalletType(
                  Routes.NFT_GALLERY_CREATE, isWatchAddress);
            }
          },
          // active: isImportActive(),
          active:
              // (controller.phraseText.trim().split(" ").join().length >= 2 &&
              //         controller.importWalletDataType !=
              //             ImportWalletDataType.none) &&
              isImportActive(isWatchAddress),
          // inActiveChild: Text(
          //   "Import",
          //   style: titleSmall,
          // ),
          // child: Text(
          //   "Import",
          //   style: titleSmall,
          // )
        );
      },
    );
  }

  bool isImportActive(bool isWatchAddress) {
    if (isWatchAddress) {
      if ((controller.importWalletDataType ==
                  ImportWalletDataType.watchAddress &&
              controller.phraseText.value.isValidWalletAddress) ||
          controller.importWalletDataType == ImportWalletDataType.tezDomain) {
        return true;
      } else {
        return false;
      }
    }
    if (controller.importWalletDataType == ImportWalletDataType.watchAddress &&
        controller.phraseText.value.isValidWalletAddress) return true;
    return controller.importWalletDataType != ImportWalletDataType.none &&
        controller.importWalletDataType != ImportWalletDataType.watchAddress;
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
        0.04.vspace,
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
            length: 3,
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
                                _buildCount(
                                    controller.selectedAccountsTz1.length)
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: controller.selectedAccountsTz2.isNotEmpty
                              ? 84.arP
                              : 61.arP,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Tz2"),
                              if (controller.selectedAccountsTz2.isNotEmpty)
                                _buildCount(
                                    controller.selectedAccountsTz2.length)
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox(
                          width: controller.selectedLegacyAccount.isNotEmpty
                              ? 84
                              : 61,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Legacy"),
                              if (controller.selectedLegacyAccount.isNotEmpty)
                                _buildCount(
                                    controller.selectedLegacyAccount.length)
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
                    children: [
                      AccountWidget(),
                      AccountWidget(),
                      AccountWidget()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        0.03.vspace,
        Obx(
          () => SolidButton(
            active: controller.selectedAccountsTz1.isNotEmpty ||
                controller.selectedAccountsTz2.isNotEmpty ||
                controller.selectedLegacyAccount.isNotEmpty,
            onPressed: () {
              controller.redirectBasedOnImportWalletType();
            },
            title: "Import",
          ),
        ),
        0.05.vspace
      ],
    );
  }

  Widget _buildCount(int count) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: EdgeInsets.all(4.arP),
      decoration: const BoxDecoration(
          color: ColorConst.Primary, shape: BoxShape.circle),
      child: Text(count.toString(), style: labelSmall),
    );
  }
}
