import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/views/import_wallet_page_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
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
      title: 'Accounts',
      action: Obx(() => TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.transparent)),
            onPressed: _controller.editAccount,
            child: Text(
              _controller.isAccountEditable.value ? "Done" : "Edit",
              style: labelMedium.copyWith(
                  color: ColorConst.Primary, fontSize: 12.aR),
            ),
          )),
      bottomSheetHorizontalPadding: 0,
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetWidgets: [
        SizedBox(
          height: AppConstant.naanBottomSheetChildHeight - 54.arP,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Expanded(
                  child: _controller.homePageController.userAccounts.isEmpty
                      ? noAccountWidget()
                      : ListView.builder(
                          itemCount: _controller
                              .homePageController.userAccounts.length,
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
                                    top: 8.aR, left: 16.aR, right: 16.aR),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  overlayColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                  onTap: () {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        0.01.hspace,
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
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                              "Watching",
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
                                                position:
                                                    PopupMenuPosition.under,
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
                                                        Get.bottomSheet(
                                                          EditAccountBottomSheet(
                                                            accountIndex: index,
                                                          ),
                                                          enterBottomSheetDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      180),
                                                          exitBottomSheetDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      150),
                                                          isScrollControlled:
                                                              true,
                                                          barrierColor: Colors
                                                              .transparent,
                                                        );
                                                      },
                                                      child: Text(
                                                        "Edit",
                                                        style: labelMedium
                                                            .copyWith(
                                                                fontSize:
                                                                    12.aR),
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12.arP,
                                                                top: 5.arP),
                                                        width: 140.aR,
                                                        height: 30.aR,
                                                        onTap: () {
                                                          Get.bottomSheet(
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
                                                            enterBottomSheetDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        180),
                                                            exitBottomSheetDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        150),
                                                            barrierColor: Colors
                                                                .transparent,
                                                          );
                                                        },
                                                        child: Text(
                                                          "Remove",
                                                          style: labelMedium
                                                              .copyWith(
                                                                  fontSize:
                                                                      12.aR,
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
                                                      height: 14.arP,
                                                      width: 14.arP,
                                                    )
                                                  : SizedBox(
                                                      height: 14.arP,
                                                      width: 14.arP,
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
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 52.arP, left: 16.arP),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    0.014.vspace,
                    Obx(() => InkWell(
                          onTap: (() {
                            if (_controller.isAccountEditable.isFalse) {
                              Get.bottomSheet(AddNewAccountBottomSheet(),
                                      enterBottomSheetDuration:
                                          const Duration(milliseconds: 180),
                                      exitBottomSheetDuration:
                                          const Duration(milliseconds: 150),
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
                                height: 16.aR,
                                fit: BoxFit.contain,
                                scale: 1,
                              ),
                              0.02.hspace,
                              Text(
                                "Create a new account",
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
                    Obx(() => InkWell(
                          onTap: () {
                            if (_controller.isAccountEditable.isFalse) {
                              Get.to(ImportWalletPageView());
                              // Get.bottomSheet(const ImportWalletPageView(),
                              //     isScrollControlled: true,
                              //     useRootNavigator: true,
                              //     enableDrag: true,
                              //     settings: const RouteSettings(
                              //         arguments: Routes.ACCOUNT_SUMMARY));
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                _controller.isAccountEditable.isFalse
                                    ? "${PathConst.EMPTY_STATES}union.png"
                                    : "${PathConst.EMPTY_STATES}union_faded.png",
                                height: 16.aR,
                                fit: BoxFit.contain,
                                scale: 1,
                              ),
                              0.02.hspace,
                              Text(
                                "Add an existing account",
                                style: labelLarge.copyWith(
                                    fontSize: 14.aR,
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
    // return BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 10.aR, sigmaY: 10.aR),
    //   child: Container(
    //     height: 0.8.height,
    //     width: 1.width,
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(10.aR)),
    //         color: Colors.black),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         0.01.vspace,
    //         Center(
    //           child: Container(
    //             height: 5.aR,
    //             width: 36.aR,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(5),
    //               color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
    //             ),
    //           ),
    //         ),
    //         0.01.vspace,
    //         Row(
    //           children: [
    //             const Spacer(),
    //             Expanded(
    //               child: Center(
    //                 child: Text(
    //                   'Accounts',
    //                   style: titleLarge.copyWith(
    //                     letterSpacing: 0.5.arP,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Expanded(
    //               child: Obx(() => Align(
    //                     alignment: Alignment.centerRight,
    //                     child: TextButton(
    //                       style: ButtonStyle(
    //                           backgroundColor: MaterialStateProperty.all<Color>(
    //                             Colors.transparent,
    //                           ),
    //                           overlayColor: MaterialStateProperty.all<Color>(
    //                               Colors.transparent)),
    //                       onPressed: _controller.editAccount,
    //                       child: Text(
    //                         _controller.isAccountEditable.value
    //                             ? "Done"
    //                             : "Edit",
    //                         style: labelMedium.copyWith(
    //                             color: ColorConst.Primary, fontSize: 12.aR),
    //                       ),
    //                     ),
    //                   )),
    //             ),
    //           ],
    //         ),
    //         0.01.vspace,
    //         Obx(
    //           () => Expanded(
    //             child: _controller.homePageController.userAccounts.isEmpty
    //                 ? noAccountWidget()
    //                 : ListView.builder(
    //                     itemCount:
    //                         _controller.homePageController.userAccounts.length,
    //                     itemBuilder: (context, index) {
    //                       return Material(
    //                         color: Colors.transparent,
    //                         shape: RoundedRectangleBorder(
    //                           side: const BorderSide(
    //                             color: Colors.transparent,
    //                           ),
    //                           borderRadius: BorderRadius.circular(10.aR),
    //                         ),
    //                         child: Padding(
    //                           padding: EdgeInsets.only(
    //                               top: 8.aR, left: 16.aR, right: 16.aR),
    //                           child: InkWell(
    //                             splashColor: Colors.transparent,
    //                             overlayColor: MaterialStateProperty.all<Color>(
    //                                 Colors.transparent),
    //                             onTap: () {
    //                               // setState(() {
    //                               print("==============");
    //                               print(index);
    //                               print("==============");

    //                               _controller.onAccountTap(index);
    //                               // });
    //                             },
    //                             child: SizedBox(
    //                               height: 48.aR,
    //                               child: Row(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.center,
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 children: [
    //                                   0.01.hspace,
    //                                   CustomImageWidget(
    //                                     imageType: _controller
    //                                         .homePageController
    //                                         .userAccounts[index]
    //                                         .imageType!,
    //                                     imagePath: _controller
    //                                         .homePageController
    //                                         .userAccounts[index]
    //                                         .profileImage!,
    //                                     imageRadius: 18.aR,
    //                                   ),
    //                                   0.03.hspace,
    //                                   RichText(
    //                                     text: TextSpan(
    //                                         text:
    //                                             '${_controller.homePageController.userAccounts[index].name}\n',
    //                                         style: labelMedium.copyWith(
    //                                             fontSize: 12.aR,
    //                                             letterSpacing: 0.4),
    //                                         children: [
    //                                           WidgetSpan(
    //                                               child: SizedBox(
    //                                             height: 18.aR,
    //                                           )),
    //                                           TextSpan(
    //                                             text:
    //                                                 '${_controller.homePageController.userAccounts[index].accountDataModel?.xtzBalance} tez',
    //                                             style: labelMedium.copyWith(
    //                                                 fontSize: 12.aR,
    //                                                 fontWeight: FontWeight.w400,
    //                                                 color: ColorConst
    //                                                     .NeutralVariant
    //                                                     .shade60),
    //                                           )
    //                                         ]),
    //                                   ),
    //                                   const Spacer(),
    //                                   if (_controller.homePageController
    //                                       .userAccounts[index].isWatchOnly)
    //                                     Container(
    //                                       margin: EdgeInsets.only(
    //                                         right: 14.arP,
    //                                       ),
    //                                       child: Text(
    //                                         "Watching",
    //                                         style: TextStyle(
    //                                           color: Colors.white,
    //                                           fontSize: 12.arP,
    //                                           fontWeight: FontWeight.w400,
    //                                           letterSpacing: 0.5.arP,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   Obx(() => Visibility(
    //                                         visible: _controller
    //                                             .isAccountEditable.isFalse,
    //                                         replacement: PopupMenuButton(
    //                                           enableFeedback: true,
    //                                           onCanceled: () {
    //                                             _controller.popupIndex.value =
    //                                                 0;
    //                                             _controller.isPopupVisible
    //                                                 .value = false;
    //                                           },
    //                                           splashRadius: 1,
    //                                           tooltip: "",
    //                                           position: PopupMenuPosition.under,
    //                                           shape: RoundedRectangleBorder(
    //                                               borderRadius:
    //                                                   BorderRadius.circular(
    //                                                       8.arP)),
    //                                           color: const Color(0xff421121),
    //                                           itemBuilder: (_) {
    //                                             _controller.popupIndex.value =
    //                                                 index;
    //                                             _controller.isPopupVisible
    //                                                 .value = true;
    //                                             return <PopupMenuEntry>[
    //                                               CustomPopupMenuItem(
    //                                                 width: 140.aR,
    //                                                 height: 30.aR,
    //                                                 padding: EdgeInsets.only(
    //                                                     left: 12.arP,
    //                                                     bottom: 5.arP),
    //                                                 onTap: () {
    //                                                   Get.bottomSheet(
    //                                                     EditAccountBottomSheet(
    //                                                       accountIndex: index,
    //                                                     ),
    //                                                     enterBottomSheetDuration:
    //                                                         const Duration(
    //                                                             milliseconds:
    //                                                                 180),
    //                                                     exitBottomSheetDuration:
    //                                                         const Duration(
    //                                                             milliseconds:
    //                                                                 150),
    //                                                     isScrollControlled:
    //                                                         true,
    //                                                     barrierColor:
    //                                                         Colors.transparent,
    //                                                   );
    //                                                 },
    //                                                 child: Text(
    //                                                   "Edit",
    //                                                   style:
    //                                                       labelMedium.copyWith(
    //                                                           fontSize: 12.aR),
    //                                                 ),
    //                                               ),
    //                                               if (_controller
    //                                                       .homePageController
    //                                                       .userAccounts
    //                                                       .length !=
    //                                                   1)
    //                                                 CustomPopupMenuDivider(
    //                                                   height: 1,
    //                                                   color: ColorConst
    //                                                       .Neutral.shade50,
    //                                                   thickness: 1,
    //                                                 ),
    //                                               if (_controller
    //                                                       .homePageController
    //                                                       .userAccounts
    //                                                       .length !=
    //                                                   1)
    //                                                 CustomPopupMenuItem(
    //                                                   padding: EdgeInsets.only(
    //                                                       left: 12.arP,
    //                                                       top: 5.arP),
    //                                                   width: 140.aR,
    //                                                   height: 30.aR,
    //                                                   onTap: () {
    //                                                     Get.bottomSheet(
    //                                                       removeAccountBottomSheet(
    //                                                         index,
    //                                                         accountName: _controller
    //                                                             .homePageController
    //                                                             .userAccounts[
    //                                                                 index]
    //                                                             .name!,
    //                                                         onPressed: () {
    //                                                           _controller
    //                                                               .removeAccount(
    //                                                                   index);
    //                                                           _settingsController
    //                                                               .removeAccount(
    //                                                                   index);
    //                                                         },
    //                                                       ),
    //                                                       enterBottomSheetDuration:
    //                                                           const Duration(
    //                                                               milliseconds:
    //                                                                   180),
    //                                                       exitBottomSheetDuration:
    //                                                           const Duration(
    //                                                               milliseconds:
    //                                                                   150),
    //                                                       barrierColor: Colors
    //                                                           .transparent,
    //                                                     );
    //                                                   },
    //                                                   child: Text(
    //                                                     "Remove",
    //                                                     style: labelMedium
    //                                                         .copyWith(
    //                                                             fontSize: 12.aR,
    //                                                             color: ColorConst
    //                                                                 .Error
    //                                                                 .shade60),
    //                                                   ),
    //                                                 ),
    //                                             ];
    //                                           },
    //                                           child: Container(
    //                                             height: 24.aR,
    //                                             width: 24.aR,
    //                                             decoration: BoxDecoration(
    //                                                 color: _controller
    //                                                             .isPopupVisible
    //                                                             .value &&
    //                                                         index ==
    //                                                             _controller
    //                                                                 .popupIndex
    //                                                                 .value
    //                                                     ? const Color(
    //                                                         0xff421121)
    //                                                     : Colors.transparent,
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         20)),
    //                                             child: Icon(
    //                                               Icons.more_horiz,
    //                                               size: 20.aR,
    //                                               color: Colors.white,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                         child: index ==
    //                                                 _homePageController
    //                                                     .selectedIndex.value
    //                                             ? SvgPicture.asset(
    //                                                 "assets/svg/check_3.svg",
    //                                                 height: 14.arP,
    //                                                 width: 14.arP,
    //                                               )
    //                                             : SizedBox(
    //                                                 height: 14.arP,
    //                                                 width: 14.arP,
    //                                               ),
    //                                       ))
    //                                 ],
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       );
    //                     }),
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.only(bottom: 52.arP, left: 16.arP),
    //           child: Align(
    //             alignment: Alignment.bottomCenter,
    //             child: Column(children: [
    //               0.014.vspace,
    //               Obx(() => InkWell(
    //                     onTap: (() {
    //                       if (_controller.isAccountEditable.isFalse) {
    //                         Get.bottomSheet(AddNewAccountBottomSheet(),
    //                                 enterBottomSheetDuration:
    //                                     const Duration(milliseconds: 180),
    //                                 exitBottomSheetDuration:
    //                                     const Duration(milliseconds: 150),
    //                                 barrierColor: Colors.transparent,
    //                                 isScrollControlled: true)
    //                             .whenComplete(() {
    //                           Get.find<AccountsWidgetController>()
    //                               .resetCreateNewWallet();
    //                         });
    //                       }
    //                     }),
    //                     child: Row(
    //                       children: [
    //                         Image.asset(
    //                           _controller.isAccountEditable.isFalse
    //                               ? "${PathConst.EMPTY_STATES}plus.png"
    //                               : "${PathConst.EMPTY_STATES}plus_faded.png",
    //                           height: 16.aR,
    //                           fit: BoxFit.contain,
    //                           scale: 1,
    //                         ),
    //                         0.02.hspace,
    //                         Text(
    //                           "Create a new account",
    //                           style: labelLarge.copyWith(
    //                               fontSize: 14.aR,
    //                               color: _controller.isAccountEditable.isFalse
    //                                   ? ColorConst.Primary
    //                                   : ColorConst.NeutralVariant.shade60,
    //                               fontWeight: FontWeight.w600),
    //                         )
    //                       ],
    //                     ),
    //                   )),
    //               0.028.vspace,
    //               Obx(() => InkWell(
    //                     onTap: () {
    //                       if (_controller.isAccountEditable.isFalse) {
    //                         Get.to(ImportWalletPageView());
    //                         // Get.bottomSheet(const ImportWalletPageView(),
    //                         //     isScrollControlled: true,
    //                         //     useRootNavigator: true,
    //                         //     enableDrag: true,
    //                         //     settings: const RouteSettings(
    //                         //         arguments: Routes.ACCOUNT_SUMMARY));
    //                       }
    //                     },
    //                     child: Row(
    //                       children: [
    //                         Image.asset(
    //                           _controller.isAccountEditable.isFalse
    //                               ? "${PathConst.EMPTY_STATES}union.png"
    //                               : "${PathConst.EMPTY_STATES}union_faded.png",
    //                           height: 16.aR,
    //                           fit: BoxFit.contain,
    //                           scale: 1,
    //                         ),
    //                         0.02.hspace,
    //                         Text(
    //                           "Add an existing account",
    //                           style: labelLarge.copyWith(
    //                               fontSize: 14.aR,
    //                               color: _controller.isAccountEditable.isFalse
    //                                   ? ColorConst.Primary
    //                                   : ColorConst.NeutralVariant.shade60,
    //                               fontWeight: FontWeight.w600),
    //                         )
    //                       ],
    //                     ),
    //                   ))
    //             ]),
    //           ),
    //         ),
    //         if (widget.onNext != null)
    //           Obx(() {
    //             return SafeArea(
    //               child: Padding(
    //                 padding: const EdgeInsets.symmetric(horizontal: 16),
    //                 child: SolidButton(
    //                   onPressed:
    //                       _controller.homePageController.userAccounts.isEmpty
    //                           ? null
    //                           : _controller
    //                                   .homePageController
    //                                   .userAccounts[_controller
    //                                       .homePageController
    //                                       .selectedIndex
    //                                       .value]
    //                                   .isWatchOnly
    //                               ? null
    //                               : widget.onNext,
    //                   title: "Next",
    //                 ),
    //               ),
    //             );
    //           }),
    //         0.01.vspace
    //       ],
    //     ),
    //   ),
    // );
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
              "No accounts found",
              textAlign: TextAlign.center,
              style: titleLarge,
            ),
            SizedBox(
              height: 12.arP,
            ),
            Text(
              "Create or import new account to proceed",
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
    title: 'Remove Account',
    bottomSheetHorizontalPadding: 32.arP,
    blurRadius: 5,
    titleAlignment: Alignment.center,
    height: 300.aR,
    bottomSheetWidgets: [
      Center(
        child: Text(
          'Do you want to remove “$accountName”\nfrom your account list?',
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
            title: "Remove Account",
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
