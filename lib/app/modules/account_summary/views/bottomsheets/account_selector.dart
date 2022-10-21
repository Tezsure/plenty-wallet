import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/views/import_wallet_page_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/colors/colors.dart';
import '../../../../../utils/constants/path_const.dart';
import '../../../../../utils/styles/styles.dart';
import '../../../../data/services/service_models/account_model.dart';
import '../../../common_widgets/bottom_sheet.dart';
import '../../../home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import '../../../send_page/views/pages/contact_page_view.dart';
import '../../../settings_page/controllers/settings_page_controller.dart';
import 'edit_account.dart';

class AccountSelectorSheet extends StatefulWidget {
  final AccountModel selectedAccount;
  const AccountSelectorSheet({
    super.key,
    required this.selectedAccount,
  });

  @override
  State<AccountSelectorSheet> createState() => _AccountSelectorSheetState();
}

class _AccountSelectorSheetState extends State<AccountSelectorSheet> {
  final AccountSummaryController _controller =
      Get.find<AccountSummaryController>();
  final SettingsPageController _settingsController =
      Get.put(SettingsPageController());

  @override
  void initState() {
    _controller.isAccountEditable.value = false;
    _controller.selectedAccountIndex.value = _controller
        .homePageController.userAccounts
        .indexOf(widget.selectedAccount);
    super.initState();
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.sp, sigmaY: 10.sp),
      child: Container(
        height: 666.sp,
        width: 1.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            color: Colors.black),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.01.width),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              0.01.vspace,
              Center(
                child: Container(
                  height: 5.sp,
                  width: 36.sp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
              ),
              0.01.vspace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  0.15.hspace,
                  Text(
                    'Accounts',
                    style: titleLarge,
                  ),
                  Obx(() => TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent,
                            ),
                            overlayColor: MaterialStateProperty.all<Color>(
                                Colors.transparent)),
                        onPressed: _controller.editAccount,
                        child: Text(
                          _controller.isAccountEditable.value ? "Done" : "Edit",
                          style:
                              labelMedium.copyWith(color: ColorConst.Primary),
                        ),
                      )),
                ],
              ),
              0.01.vspace,
              Obx(
                () => Expanded(
                  child: ListView.builder(
                      itemCount:
                          _controller.homePageController.userAccounts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 2,
                            right: 2,
                            bottom: 4,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                                onTap: () => setState(() {
                                      _controller.onAccountTap(index);
                                    }),
                                dense: true,
                                leading: CustomImageWidget(
                                  imageType: _controller.homePageController
                                      .userAccounts[index].imageType!,
                                  imagePath: _controller.homePageController
                                      .userAccounts[index].profileImage!,
                                  imageRadius: 20.sp,
                                ),
                                title: Text(
                                  '${_controller.homePageController.userAccounts[index].name}',
                                  style: labelMedium,
                                ),
                                subtitle: Text(
                                  '${_controller.homePageController.userAccounts[index].accountDataModel?.xtzBalance} tez',
                                  style: bodySmall.copyWith(
                                      color: ColorConst.NeutralVariant.shade60),
                                ),
                                trailing: Obx(() => Visibility(
                                      visible:
                                          _controller.isAccountEditable.isFalse,
                                      replacement: PopupMenuButton(
                                        enableFeedback: true,
                                        onCanceled: () {
                                          _controller.popupIndex.value = 0;
                                          _controller.isPopupVisible.value =
                                              false;
                                        },
                                        tooltip: "",
                                        position: PopupMenuPosition.under,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.sp)),
                                        color: const Color(0xff421121),
                                        itemBuilder: (_) {
                                          _controller.popupIndex.value = index;
                                          _controller.isPopupVisible.value =
                                              true;
                                          return <PopupMenuEntry>[
                                            CustomPopupMenuItem(
                                              width: 140.sp,
                                              height: 30.sp,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 11.sp),
                                              onTap: () {
                                                Get.bottomSheet(
                                                  EditAccountBottomSheet(
                                                    accountIndex: index,
                                                  ),
                                                  isScrollControlled: true,
                                                  barrierColor:
                                                      Colors.transparent,
                                                );
                                              },
                                              child: Text(
                                                "Edit",
                                                style: labelMedium,
                                              ),
                                            ),
                                            CustomPopupMenuDivider(
                                              height: 1,
                                              color: ColorConst.Neutral.shade50,
                                              thickness: 1,
                                            ),
                                            CustomPopupMenuItem(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 11.sp),
                                              width: 140.sp,
                                              height: 30.sp,
                                              onTap: () {
                                                Get.bottomSheet(
                                                  removeAccountBottomSheet(
                                                    index,
                                                    accountName: _controller
                                                        .homePageController
                                                        .userAccounts[index]
                                                        .name!,
                                                    onPressed: () {
                                                      _controller
                                                          .removeAccount(index);
                                                      _settingsController
                                                          .removeAccount(index);
                                                    },
                                                  ),
                                                  barrierColor:
                                                      Colors.transparent,
                                                );
                                              },
                                              child: Text(
                                                "Remove",
                                                style: labelMedium.apply(
                                                    color: ColorConst
                                                        .Error.shade60),
                                              ),
                                            ),
                                          ];
                                        },
                                        child: Container(
                                          height: 24.sp,
                                          width: 24.sp,
                                          decoration: BoxDecoration(
                                              color: _controller.isPopupVisible
                                                          .value &&
                                                      index ==
                                                          _controller
                                                              .popupIndex.value
                                                  ? const Color(0xff421121)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Icon(
                                            Icons.more_horiz,
                                            size: 20.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      child: index ==
                                              _controller
                                                  .selectedAccountIndex.value
                                          ? Container(
                                              height: 14.sp,
                                              width: 14.sp,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: ColorConst.Primary),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 12.sp,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ))),
                          ),
                        );
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 52.sp, left: 15.sp),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    Obx(() => InkWell(
                          onTap: (() {
                            if (_controller.isAccountEditable.isFalse) {
                              Get.bottomSheet(AddNewAccountBottomSheet(),
                                      barrierColor: Colors.transparent,
                                      isScrollControlled: true)
                                  .whenComplete(() {
                                Get.find<AccountsWidgetController>()
                                    .resetCreateNewWallet();
                              });
                            }
                          }),
                          child: Row(
                            children: [
                              Image.asset(
                                _controller.isAccountEditable.isFalse
                                    ? "${PathConst.EMPTY_STATES}plus.png"
                                    : "${PathConst.EMPTY_STATES}plus_faded.png",
                                scale: 1,
                              ),
                              0.02.hspace,
                              Text(
                                "Create a new account",
                                style: labelLarge.copyWith(
                                    color: _controller.isAccountEditable.isFalse
                                        ? ColorConst.Primary
                                        : ColorConst.NeutralVariant.shade60,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )),
                    0.028.vspace,
                    Obx(() => InkWell(
                          onTap: () {
                            if (_controller.isAccountEditable.isFalse) {
                              Get.bottomSheet(
                                  const ImportWalletPageView(
                                      isBottomSheet: true),
                                  isScrollControlled: true,
                                  useRootNavigator: true,
                                  settings: const RouteSettings(
                                      arguments: Routes.ACCOUNT_SUMMARY));
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                _controller.isAccountEditable.isFalse
                                    ? "${PathConst.EMPTY_STATES}union.png"
                                    : "${PathConst.EMPTY_STATES}union_faded.png",
                                scale: 1,
                              ),
                              0.02.hspace,
                              Text(
                                "Add an existing account",
                                style: labelLarge.copyWith(
                                    color: _controller.isAccountEditable.isFalse
                                        ? ColorConst.Primary
                                        : ColorConst.NeutralVariant.shade60,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ))
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget removeAccountBottomSheet(int index,
    {required String accountName, required Function() onPressed}) {
  return NaanBottomSheet(
    bottomSheetHorizontalPadding: 32.sp,
    blurRadius: 5,
    titleAlignment: Alignment.center,
    height: 300.sp,
    bottomSheetWidgets: [
      0.015.vspace,
      Center(
        child: Text(
          'Remove Account',
          style: titleLarge.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
      ),
      0.02.vspace,
      Center(
        child: Text(
          'Do you want to remove “$accountName”\nfrom your account list?',
          style: bodySmall.copyWith(color: ColorConst.NeutralVariant.shade60),
          textAlign: TextAlign.center,
        ),
      ),
      0.03.vspace,
      Column(
        children: [
          SolidButton(
            width: 326.sp,
            height: 50.sp,
            primaryColor: const Color(0xff1E1C1F),
            onPressed: onPressed,
            title: "Remove Account",
            textColor: ColorConst.Primary,
            titleStyle: labelLarge.copyWith(color: ColorConst.Error.shade60),
          ),
          0.01.vspace,
          SolidButton(
            width: 326.sp,
            height: 50.sp,
            primaryColor: const Color(0xff1E1C1F),
            onPressed: Get.back,
            title: "Cancel",
            titleStyle: labelLarge,
          ),
        ],
      ),
      0.04.vspace
    ],
  );
}
