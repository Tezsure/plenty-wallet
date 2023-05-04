import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_account_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/views/import_wallet_page_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
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
  // final AccountModel selectedAccount;
  final Function()? onNext;
  const AccountSelectorSheet({
    super.key,
    this.onNext,
  });

  @override
  State<AccountSelectorSheet> createState() => _AccountSelectorSheetState();
}

class _AccountSelectorSheetState extends State<AccountSelectorSheet> {
  final AccountSummaryController _controller =
      Get.find<AccountSummaryController>();
  final HomePageController _homePageController = Get.find<HomePageController>();
  final SettingsPageController _settingsController =
      Get.put(SettingsPageController());

  @override
  void initState() {
    _controller.isAccountEditable.value = false;
    // _homePageController.changeSelectedAccount(_controller
    //     .homePageController.userAccounts
    //     .indexOf(widget.selectedAccount));
    super.initState();
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: 'Wallets',
      leading: Obx(() => BouncingWidget(
            onPressed: _controller.editAccount,
            child: Text(
              (_controller.isAccountEditable.value ? "Done" : "Edit").tr,
              style: labelMedium.copyWith(
                  color: ColorConst.Primary, fontSize: 12.aR),
            ),
          )),
      // bottomSheetHorizontalPadding: 0,
      // isScrollControlled: true,
      // height: AppConstant.naanBottomSheetChildHeight,
      isScrollControlled: true,
      bottomSheetWidgets: [
        SizedBox(
          // height: AppConstant.naanBottomSheetChildHeight - 62.arP,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              0.016.vspace,
              Obx(
                () => _controller.homePageController.userAccounts.isEmpty
                    ? noAccountWidget()
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            _controller.homePageController.userAccounts.length,
                        itemBuilder: (context, index) {
                          return Material(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(10.aR),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8.aR,
                              ),
                              child: BouncingWidget(
                                onPressed: () {
                                  // setState(() {
                                  print("==============");
                                  print(index);
                                  print("==============");

                                  _controller.onAccountTap(index);
                                  // });
                                },
                                child: SizedBox(
                                  height: 48.aR,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomImageWidget(
                                        imageType: _controller
                                            .homePageController
                                            .userAccounts[index]
                                            .imageType!,
                                        imagePath: _controller
                                            .homePageController
                                            .userAccounts[index]
                                            .profileImage!,
                                        imageRadius: 18.aR,
                                      ),
                                      0.03.hspace,
                                      RichText(
                                        text: TextSpan(
                                            text:
                                                '${_controller.homePageController.userAccounts[index].name}\n',
                                            style: labelMedium.copyWith(
                                                fontSize: 12.aR,
                                                letterSpacing: 0.4),
                                            children: [
                                              WidgetSpan(
                                                  child: SizedBox(
                                                height: 18.aR,
                                              )),
                                              TextSpan(
                                                text:
                                                    '${_controller.homePageController.userAccounts[index].accountDataModel?.xtzBalance} tez',
                                                style: labelMedium.copyWith(
                                                    fontSize: 12.aR,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade60),
                                              )
                                            ]),
                                      ),
                                      const Spacer(),
                                      if (_controller.homePageController
                                          .userAccounts[index].isWatchOnly)
                                        Container(
                                          margin: EdgeInsets.only(
                                            right: 14.arP,
                                          ),
                                          child: Text(
                                            "Watching".tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.arP,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.5.arP,
                                            ),
                                          ),
                                        ),
                                      Obx(() => Visibility(
                                            visible: _controller
                                                .isAccountEditable.isFalse,
                                            replacement: PopupMenuButton(
                                              enableFeedback: true,
                                              onCanceled: () {
                                                _controller.popupIndex.value =
                                                    0;
                                                _controller.isPopupVisible
                                                    .value = false;
                                              },
                                              splashRadius: 1,
                                              tooltip: "",
                                              position: PopupMenuPosition.under,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.arP)),
                                              color: const Color(0xff421121),
                                              itemBuilder: (_) {
                                                _controller.popupIndex.value =
                                                    index;
                                                _controller.isPopupVisible
                                                    .value = true;
                                                return <PopupMenuEntry>[
                                                  CustomPopupMenuItem(
                                                    width: 140.aR,
                                                    height: 30.aR,
                                                    padding: EdgeInsets.only(
                                                        left: 12.arP,
                                                        bottom: 5.arP),
                                                    onTap: () {
                                                      CommonFunctions
                                                          .bottomSheet(
                                                        EditAccountBottomSheet(
                                                          accountIndex: index,
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      "Edit".tr,
                                                      style:
                                                          labelMedium.copyWith(
                                                              fontSize: 12.aR),
                                                    ),
                                                  ),
                                                  if (_controller
                                                          .homePageController
                                                          .userAccounts
                                                          .length !=
                                                      1)
                                                    CustomPopupMenuDivider(
                                                      height: 1,
                                                      color: ColorConst
                                                          .Neutral.shade50,
                                                      thickness: 1,
                                                    ),
                                                  if (_controller
                                                          .homePageController
                                                          .userAccounts
                                                          .length !=
                                                      1)
                                                    CustomPopupMenuItem(
                                                      padding: EdgeInsets.only(
                                                          left: 12.arP,
                                                          top: 5.arP),
                                                      width: 140.aR,
                                                      height: 30.aR,
                                                      onTap: () {
                                                        CommonFunctions
                                                            .bottomSheet(
                                                          removeAccountBottomSheet(
                                                            index,
                                                            accountName: _controller
                                                                .homePageController
                                                                .userAccounts[
                                                                    index]
                                                                .name!,
                                                            onPressed: () {
                                                              _controller
                                                                  .removeAccount(
                                                                      index);
                                                              _settingsController
                                                                  .removeAccount(
                                                                      index);
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        "Remove".tr,
                                                        style: labelMedium
                                                            .copyWith(
                                                                fontSize: 12.aR,
                                                                color: ColorConst
                                                                    .Error
                                                                    .shade60),
                                                      ),
                                                    ),
                                                ];
                                              },
                                              child: Container(
                                                height: 24.aR,
                                                width: 24.aR,
                                                decoration: BoxDecoration(
                                                    color: _controller
                                                                .isPopupVisible
                                                                .value &&
                                                            index ==
                                                                _controller
                                                                    .popupIndex
                                                                    .value
                                                        ? const Color(
                                                            0xff421121)
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  size: 20.aR,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            child: index ==
                                                    _homePageController
                                                        .selectedIndex.value
                                                ? SvgPicture.asset(
                                                    "assets/svg/check_3.svg",
                                                    height: 16.arP,
                                                    width: 16.arP,
                                                  )
                                                : SizedBox(
                                                    height: 16.arP,
                                                    width: 16.arP,
                                                  ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
              ),
              0.02.vspace,
              Padding(
                padding: EdgeInsets.only(bottom: 52.arP, left: 16.arP),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    0.014.vspace,
                    Obx(() => BouncingWidget(
                          onPressed: (() {
                            if (_controller.isAccountEditable.isFalse) {
                              CommonFunctions.bottomSheet(
                                const AddAccountSheet(warning: null),
                              );
                              // Get.bottomSheet(AddNewAccountBottomSheet(),
                              //         enterBottomSheetDuration:
                              //             const Duration(milliseconds: 180),
                              //         exitBottomSheetDuration:
                              //             const Duration(milliseconds: 150),
                              //         barrierColor: Colors.transparent,
                              //         isScrollControlled: true)
                              //     .whenComplete(() {
                              //   Get.find<AccountsWidgetController>()
                              //       .resetCreateNewWallet();
                              // });
                            }
                          }),
                          child: Row(
                            children: [
                              Image.asset(
                                _controller.isAccountEditable.isFalse
                                    ? "${PathConst.EMPTY_STATES}plus.png"
                                    : "${PathConst.EMPTY_STATES}plus_faded.png",
                                height: 16.aR,
                                fit: BoxFit.contain,
                                scale: 1,
                              ),
                              0.02.hspace,
                              Text(
                                "Add wallet".tr,
                                style: labelLarge.copyWith(
                                    fontSize: 14.aR,
                                    color: _controller.isAccountEditable.isFalse
                                        ? ColorConst.Primary
                                        : ColorConst.NeutralVariant.shade60,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )),
                    0.028.vspace,
                  ]),
                ),
              ),
              if (widget.onNext != null)
                Obx(() {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SolidButton(
                        onPressed:
                            _controller.homePageController.userAccounts.isEmpty
                                ? null
                                : _controller
                                        .homePageController
                                        .userAccounts[_controller
                                            .homePageController
                                            .selectedIndex
                                            .value]
                                        .isWatchOnly
                                    ? null
                                    : widget.onNext,
                        title: "Next",
                      ),
                    ),
                  );
                }),
              0.01.vspace
            ],
          ),
        ),
      ],
    );
  }
}

Widget noAccountWidget() => SizedBox(
      height: 0.87.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "${PathConst.EMPTY_STATES}no_accounts.svg",
              height: 175.arP,
              width: 175.arP,
            ),
            0.05.vspace,
            Text(
              "No wallets found".tr,
              textAlign: TextAlign.center,
              style: titleLarge,
            ),
            SizedBox(
              height: 12.arP,
            ),
            Text(
              "Create or import new wallet to proceed".tr,
              textAlign: TextAlign.center,
              style: bodySmall.copyWith(color: ColorConst.textGrey1),
            ),
          ],
        ),
      ),
    );

Widget removeAccountBottomSheet(int index,
    {required String accountName, required Function() onPressed}) {
  return NaanBottomSheet(
    title: 'Remove Wallet',
    bottomSheetHorizontalPadding: 32.arP,
    blurRadius: 5,
    titleAlignment: Alignment.center,
    height: 300.aR,
    bottomSheetWidgets: [
      Center(
        child: Text(
          '${'Do you want to remove'.tr} “$accountName”\n${'from your wallet list?'.tr}',
          style: bodySmall.copyWith(
              color: ColorConst.NeutralVariant.shade60, fontSize: 14.aR),
          textAlign: TextAlign.center,
        ),
      ),
      0.02.vspace,
      Column(
        children: [
          SolidButton(
            // width: 326.arP,
            height: 50.aR,
            primaryColor: const Color(0xff1E1C1F).withOpacity(0.8),
            onPressed: onPressed,
            title: "Remove Wallet",
            textColor: ColorConst.Primary,
            titleStyle: labelLarge.copyWith(
                color: ColorConst.Error.shade60, fontSize: 14.aR),
          ),
          0.012.vspace,
          SolidButton(
            // width: 326.arP,
            height: 50.aR,
            primaryColor: const Color(0xff1E1C1F).withOpacity(0.8),
            onPressed: () {
              Get.back();
            },
            title: "Cancel",
            titleStyle: labelLarge.copyWith(fontSize: 14.aR),
          ),
        ],
      ),
      0.04.vspace
    ],
  );
}
