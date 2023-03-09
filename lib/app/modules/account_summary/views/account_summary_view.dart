import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../../data/services/service_config/service_config.dart';
import '../../common_widgets/custom_image_widget.dart';
import '../../import_wallet_page/widgets/custom_tab_indicator.dart';
import '../../receive_page/views/receive_page_view.dart';
import '../../send_page/views/send_page.dart';
import '../../settings_page/enums/network_enum.dart';
import '../controllers/account_summary_controller.dart';
import 'bottomsheets/account_selector.dart';
import 'pages/crypto_tab.dart';
import 'pages/history_tab.dart';
import 'pages/nft_tab.dart';

class AccountSummaryView extends GetView<AccountSummaryController> {
  const AccountSummaryView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put((AccountSummaryController()));
    Get.put(TransactionController());
    return NaanBottomSheet(
      // isScrollControlled: true,
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetHorizontalPadding: 0,
      bottomSheetWidgets: [
        SizedBox(
          height: AppConstant.naanBottomSheetChildHeight + 60.7.arP,
          child: DefaultTabController(
            length: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Padding(
                    padding:
                        EdgeInsets.only(left: 16.aR, right: 16.aR, top: 14.aR),
                    child: Row(
                      children: [
                        BouncingWidget(
                          onPressed: () {
                            CommonFunctions.bottomSheet(
                              const AccountSelectorSheet(),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              0.01.hspace,
                              CustomImageWidget(
                                imageType:
                                    controller.selectedAccount.value.imageType!,
                                imagePath: controller
                                    .selectedAccount.value.profileImage!,
                                imageRadius: 18.aR,
                              ),
                              0.03.hspace,
                              RichText(
                                text: TextSpan(
                                    text:
                                        controller.selectedAccount.value.name!,
                                    style: labelMedium,
                                    children: [
                                      WidgetSpan(
                                          child: SizedBox(
                                        width: 2.arP,
                                      )),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.bottom,
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 20.aR,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "\n${(controller.selectedAccount.value.publicKeyHash!).tz1Short()}",
                                        style: bodySmall.copyWith(
                                            height: 0,
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BouncingWidget(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: controller
                                        .selectedAccount.value.publicKeyHash));
                                Get.rawSnackbar(
                                  maxWidth: 0.45.width,
                                  backgroundColor: Colors.transparent,
                                  snackPosition: SnackPosition.BOTTOM,
                                  snackStyle: SnackStyle.FLOATING,
                                  padding: const EdgeInsets.only(bottom: 60),
                                  messageText: Container(
                                    height: 36,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: ColorConst.Neutral.shade10,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_circle_outline_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Copied ${tz1Shortner(controller.selectedAccount.value.publicKeyHash!)}",
                                          style: labelSmall,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: SvgPicture.asset(
                                '${PathConst.SVG}copy.svg',
                                color: Colors.white,
                                fit: BoxFit.contain,
                                height: 24.aR,
                              ),
                            ),
                            if (!controller.selectedAccount.value.isWatchOnly)
                              0.04.hspace,
                            if (!controller.selectedAccount.value.isWatchOnly)
                              BouncingWidget(
                                onPressed: () {
                                  Get.find<HomePageController>().openScanner();
                                },
                                child: SvgPicture.asset(
                                  '${PathConst.SVG}scanVector.svg',
                                  fit: BoxFit.contain,
                                  height: 24.aR,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                0.036.vspace,
                Obx(() => Center(
                      child: Text(
                        ((ServiceConfig.currentNetwork == NetworkType.mainnet
                                    ? controller.selectedAccount.value
                                            .accountDataModel?.totalBalance ??
                                        0
                                    : controller.selectedAccount.value
                                            .accountDataModel!.xtzBalance ??
                                        0) *
                                controller.xtzPrice.value)
                            .roundUpDollar(controller.xtzPrice.value),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30.aR,
                          color: Colors.white,
                        ),
                      ),
                    )),
                0.03.vspace,
                Obx(() {
                  return Padding(
                    padding: EdgeInsets.only(left: 17.arP, right: 16.arP),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _actionButton(
                            onTap: () {
                              String url =
                                  "https://wert.naan.app?address=${controller.selectedAccount.value.publicKeyHash}";

                              print(url);
                              CommonFunctions.bottomSheet(
                                  const DappBrowserView(),
                                  settings: RouteSettings(
                                    arguments: url,
                                  ));
                            },
                            imagePath: '${PathConst.SVG}plus.svg',
                            label: 'Buy'),
                        0.04.hspace,
                        _actionButton(
                            onTap: () {
                              NaanAnalytics.logEvent(
                                  NaanAnalyticsEvents.DELEGATE_FROM_WALLET);
                              Get.put(DelegateWidgetController())
                                  .openBakerList();
                            },
                            imagePath: '${PathConst.SVG}dollar_sign.svg',
                            label: 'Earn'),
                        0.04.hspace,
                        _actionButton(
                          imagePath: '${PathConst.SVG}arrow_up.svg',
                          label: 'Send',
                          onTap: (() => CommonFunctions.bottomSheet(
                                const SendPage(),
                                settings: RouteSettings(
                                    arguments:
                                        controller.selectedAccount.value),
                              )),
                        ),
                        0.04.hspace,
                        _actionButton(
                          imagePath: '${PathConst.SVG}arrow_down.svg',
                          label: 'Receive',
                          onTap: (() => CommonFunctions.bottomSheet(
                                const ReceivePageView(),
                                settings: RouteSettings(
                                    arguments:
                                        controller.selectedAccount.value),
                              )),
                        ),
                      ],
                    ),
                  );
                }),
                0.02.vspace,
                Divider(
                  height: 0.arP,
                  color: ColorConst.NeutralVariant.shade20,
                  endIndent: 16.aR,
                  indent: 16.aR,
                ),
                0.02.vspace,
                SizedBox(
                  height: 50.aR,
                  width: 1.width,
                  child: TabBar(
                      onTap: (value) async {
                        value == 2 ? controller.loadUserTransaction() : null;
                      },
                      isScrollable: true,
                      labelColor: ColorConst.Primary.shade95,
                      indicatorColor: ColorConst.Primary,
                      indicatorSize: TabBarIndicatorSize.tab,
                      padding: EdgeInsets.symmetric(horizontal: 15.aR),
                      labelPadding: EdgeInsets.symmetric(
                        horizontal: 6.aR,
                      ),
                      indicatorWeight: 4.aR,
                      enableFeedback: true,
                      indicator: MaterialIndicator(
                        color: ColorConst.Primary,
                        height: 4.aR,
                        topLeftRadius: 4.aR,
                        topRightRadius: 4.aR,
                        strokeWidth: 4.aR,
                      ),
                      labelStyle: labelLarge.copyWith(
                          fontSize: 14.aR, letterSpacing: 0.1.aR),
                      unselectedLabelColor: ColorConst.NeutralVariant.shade60,
                      tabs: [
                        SizedBox(
                          width: 70.arP,
                          child: Tab(
                            height: 30.arP,
                            text: "Crypto",
                            iconMargin: EdgeInsets.zero,
                          ),
                        ),
                        SizedBox(
                          width: 70.arP,
                          child: Tab(
                            height: 30.arP,
                            text: "NFTs",
                            iconMargin: EdgeInsets.zero,
                          ),
                        ),
                        SizedBox(
                          width: 70.arP,
                          child: Tab(
                            height: 30.arP,
                            text: "History",
                            iconMargin: EdgeInsets.zero,
                          ),
                        ),
                      ]),
                ),
                const Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CryptoTabPage(),
                      NFTabPage(),
                      HistoryPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
    // return BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //   child: DraggableScrollableSheet(
    //     maxChildSize: 0.9,
    //     initialChildSize: 0.9,
    //     minChildSize: 0.9,
    //     builder: ((context, scrollController) => Container(
    //           height: 0.9.height,
    //           width: 1.width,
    //           decoration: BoxDecoration(
    //               borderRadius:
    //                   BorderRadius.vertical(top: Radius.circular(10.aR)),
    //               color: Colors.black),
    //           child: DefaultTabController(
    //             length: 3,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 0.01.vspace,
    //                 Center(
    //                   child: Container(
    //                     height: 5.aR,
    //                     width: 36.aR,
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(8.aR),
    //                       color: ColorConst.NeutralVariant.shade60
    //                           .withOpacity(0.3),
    //                     ),
    //                   ),
    //                 ),
    //                 Obx(
    //                   () => Padding(
    //                     padding: EdgeInsets.only(
    //                         left: 16.aR, right: 16.aR, top: 14.aR),
    //                     child: Row(
    //                       children: [
    //                         GestureDetector(
    //                           onTap: () {
    //                             Get.bottomSheet(const AccountSelectorSheet(),
    //                                 enterBottomSheetDuration:
    //                                     const Duration(milliseconds: 180),
    //                                 exitBottomSheetDuration:
    //                                     const Duration(milliseconds: 150),
    //                                 isScrollControlled: true);
    //                           },
    //                           child: Row(
    //                             crossAxisAlignment: CrossAxisAlignment.center,
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             children: [
    //                               0.01.hspace,
    //                               CustomImageWidget(
    //                                 imageType: controller
    //                                     .selectedAccount.value.imageType!,
    //                                 imagePath: controller
    //                                     .selectedAccount.value.profileImage!,
    //                                 imageRadius: 18.aR,
    //                               ),
    //                               0.03.hspace,
    //                               RichText(
    //                                 text: TextSpan(
    //                                     text: controller
    //                                         .selectedAccount.value.name!,
    //                                     style: labelMedium.copyWith(
    //                                         fontSize: 12.aR,
    //                                         fontWeight: FontWeight.w600),
    //                                     children: [
    //                                       WidgetSpan(
    //                                           child: SizedBox(
    //                                         width: 2.arP,
    //                                       )),
    //                                       WidgetSpan(
    //                                         alignment:
    //                                             PlaceholderAlignment.bottom,
    //                                         child: Icon(
    //                                           Icons.keyboard_arrow_down_rounded,
    //                                           size: 20.aR,
    //                                           color: Colors.white,
    //                                         ),
    //                                       ),
    //                                       TextSpan(
    //                                         text:
    //                                             "\n${(controller.selectedAccount.value.publicKeyHash!).tz1Short()}",
    //                                         style: labelMedium.copyWith(
    //                                             fontSize: 12.aR,
    //                                             height: 0,
    //                                             fontWeight: FontWeight.w400,
    //                                             color: ColorConst
    //                                                 .NeutralVariant.shade60),
    //                                       )
    //                                     ]),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                         const Spacer(),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             InkWell(
    //                               onTap: () {
    //                                 Clipboard.setData(ClipboardData(
    //                                     text: controller.selectedAccount.value
    //                                         .publicKeyHash));
    //                                 Get.rawSnackbar(
    //                                   maxWidth: 0.45.width,
    //                                   backgroundColor: Colors.transparent,
    //                                   snackPosition: SnackPosition.BOTTOM,
    //                                   snackStyle: SnackStyle.FLOATING,
    //                                   padding:
    //                                       const EdgeInsets.only(bottom: 60),
    //                                   messageText: Container(
    //                                     height: 36,
    //                                     padding: const EdgeInsets.symmetric(
    //                                         horizontal: 10),
    //                                     decoration: BoxDecoration(
    //                                         color: ColorConst.Neutral.shade10,
    //                                         borderRadius:
    //                                             BorderRadius.circular(8)),
    //                                     child: Row(
    //                                       mainAxisSize: MainAxisSize.min,
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.center,
    //                                       children: [
    //                                         const Icon(
    //                                           Icons
    //                                               .check_circle_outline_rounded,
    //                                           size: 14,
    //                                           color: Colors.white,
    //                                         ),
    //                                         const SizedBox(
    //                                           width: 5,
    //                                         ),
    //                                         Text(
    //                                           "Copied ${tz1Shortner(controller.selectedAccount.value.publicKeyHash!)}",
    //                                           style: labelSmall,
    //                                         )
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 );
    //                               },
    //                               child: SvgPicture.asset(
    //                                 '${PathConst.SVG}copy.svg',
    //                                 color: Colors.white,
    //                                 fit: BoxFit.contain,
    //                                 height: 24.aR,
    //                               ),
    //                             ),
    //                             if (!controller
    //                                 .selectedAccount.value.isWatchOnly)
    //                               0.04.hspace,
    //                             if (!controller
    //                                 .selectedAccount.value.isWatchOnly)
    //                               InkWell(
    //                                 onTap: () {
    //                                   Get.find<HomePageController>()
    //                                       .openScanner();
    //                                 },
    //                                 child: SvgPicture.asset(
    //                                   '${PathConst.SVG}scanVector.svg',
    //                                   fit: BoxFit.contain,
    //                                   height: 24.aR,
    //                                   color: Colors.white,
    //                                 ),
    //                               ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 0.036.vspace,
    //                 Obx(() => Center(
    //                       child: Text(
    //                         (controller.selectedAccount.value.accountDataModel!
    //                                     .totalBalance! *
    //                                 controller.xtzPrice.value)
    //                             .roundUpDollar(),
    //                         style: TextStyle(
    //                           fontWeight: FontWeight.w700,
    //                           fontSize: 30.aR,
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     )),
    //                 0.03.vspace,
    //                 Obx(() {
    //                   return Padding(
    //                     padding: EdgeInsets.only(left: 17.arP, right: 16.arP),
    //                     child: Row(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                       children: [
    //                         _actionButton(
    //                             onTap: () {
    //                               String url =
    //                                   "https://wert.naan.app?address=${controller.selectedAccount.value.publicKeyHash}";

    //                               print(url);
    //                               Get.bottomSheet(
    //                                 const DappBrowserView(),
    //                                 barrierColor:
    //                                     Colors.white.withOpacity(0.09),
    //                                 settings: RouteSettings(
    //                                   arguments: url,
    //                                 ),
    //                                 isScrollControlled: true,
    //                               );
    //                             },
    //                             imagePath: '${PathConst.SVG}plus.svg',
    //                             label: 'Buy'),
    //                         0.04.hspace,
    //                         _actionButton(
    //                             onTap: () {
    //                               NaanAnalytics.logEvent(
    //                                   NaanAnalyticsEvents.DELEGATE_FROM_WALLET);
    //                               Get.put(DelegateWidgetController())
    //                                   .openBakerList();
    //                             },
    //                             imagePath: '${PathConst.SVG}dollar_sign.svg',
    //                             label: 'Earn'),
    //                         0.04.hspace,
    //                         _actionButton(
    //                           imagePath: '${PathConst.SVG}arrow_up.svg',
    //                           label: 'Send',
    //                           onTap: (() => Get.bottomSheet(const SendPage(),
    //                               enterBottomSheetDuration:
    //                                   const Duration(milliseconds: 180),
    //                               exitBottomSheetDuration:
    //                                   const Duration(milliseconds: 150),
    //                               settings: RouteSettings(
    //                                   arguments:
    //                                       controller.selectedAccount.value),
    //                               isScrollControlled: true,
    //                               barrierColor:
    //                                   Colors.white.withOpacity(0.09))),
    //                         ),
    //                         0.04.hspace,
    //                         _actionButton(
    //                           imagePath: '${PathConst.SVG}arrow_down.svg',
    //                           label: 'Receive',
    //                           onTap: (() => Get.bottomSheet(
    //                               const ReceivePageView(),
    //                               enterBottomSheetDuration:
    //                                   const Duration(milliseconds: 180),
    //                               exitBottomSheetDuration:
    //                                   const Duration(milliseconds: 150),
    //                               settings: RouteSettings(
    //                                   arguments:
    //                                       controller.selectedAccount.value),
    //                               isScrollControlled: true,
    //                               barrierColor:
    //                                   Colors.white.withOpacity(0.09))),
    //                         ),
    //                       ],
    //                     ),
    //                   );
    //                 }),
    //                 0.02.vspace,
    //                 Divider(
    //                   height: 0.arP,
    //                   color: ColorConst.NeutralVariant.shade20,
    //                   endIndent: 16.aR,
    //                   indent: 16.aR,
    //                 ),
    //                 0.02.vspace,
    //                 SizedBox(
    //                   height: 50.aR,
    //                   width: 1.width,
    //                   child: TabBar(
    //                       onTap: (value) async {
    //                         value == 2
    //                             ? controller.loadUserTransaction()
    //                             : null;
    //                       },
    //                       isScrollable: true,
    //                       labelColor: ColorConst.Primary.shade95,
    //                       indicatorColor: ColorConst.Primary,
    //                       indicatorSize: TabBarIndicatorSize.tab,
    //                       padding: EdgeInsets.symmetric(horizontal: 15.aR),
    //                       labelPadding: EdgeInsets.symmetric(
    //                         horizontal: 6.aR,
    //                       ),
    //                       indicatorWeight: 4.aR,
    //                       enableFeedback: true,
    //                       indicator: MaterialIndicator(
    //                         color: ColorConst.Primary,
    //                         height: 4.aR,
    //                         topLeftRadius: 4.aR,
    //                         topRightRadius: 4.aR,
    //                         strokeWidth: 4.aR,
    //                       ),
    //                       labelStyle: labelLarge.copyWith(
    //                           fontSize: 14.aR, letterSpacing: 0.1.aR),
    //                       unselectedLabelColor:
    //                           ColorConst.NeutralVariant.shade60,
    //                       tabs: [
    //                         SizedBox(
    //                           width: 70.arP,
    //                           child: Tab(
    //                             height: 30.arP,
    //                             text: "Crypto",
    //                             iconMargin: EdgeInsets.zero,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           width: 70.arP,
    //                           child: Tab(
    //                             height: 30.arP,
    //                             text: "NFTs",
    //                             iconMargin: EdgeInsets.zero,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           width: 70.arP,
    //                           child: Tab(
    //                             height: 30.arP,
    //                             text: "History",
    //                             iconMargin: EdgeInsets.zero,
    //                           ),
    //                         ),
    //                       ]),
    //                 ),
    //                 const Expanded(
    //                   child: TabBarView(
    //                     physics: NeverScrollableScrollPhysics(),
    //                     children: [
    //                       CryptoTabPage(),
    //                       NFTabPage(),
    //                       HistoryPage(),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         )),
    //   ),
    // );
  }

  // Obx _buildAppBar() {
  //   return Obx(
  //     () => Padding(
  //       padding: EdgeInsets.only(left: 16.aR, right: 16.aR, top: 14.aR),
  //       child: Row(
  //         children: [
  //           GestureDetector(
  //             onTap: () {
  //               Get.bottomSheet(AccountSelectorSheet(),
  //                   isScrollControlled: true);
  //             },
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 0.01.hspace,
  //                 CustomImageWidget(
  //                   imageType: controller.selectedAccount.value.imageType!,
  //                   imagePath: controller.selectedAccount.value.profileImage!,
  //                   imageRadius: 18.aR,
  //                 ),
  //                 0.03.hspace,
  //                 RichText(
  //                   text: TextSpan(
  //                       text: controller.selectedAccount.value.name!,
  //                       style: labelMedium.copyWith(
  //                           fontSize: 12.aR, fontWeight: FontWeight.w600),
  //                       children: [
  //                         WidgetSpan(
  //                             child: SizedBox(
  //                           width: 2.arP,
  //                         )),
  //                         WidgetSpan(
  //                           alignment: PlaceholderAlignment.bottom,
  //                           child: Icon(
  //                             Icons.keyboard_arrow_down_rounded,
  //                             size: 20.aR,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                         TextSpan(
  //                           text:
  //                               "\n${(controller.selectedAccount.value.publicKeyHash!).tz1Short()}",
  //                           style: labelMedium.copyWith(
  //                               fontSize: 12.aR,
  //                               height: 0,
  //                               fontWeight: FontWeight.w400,
  //                               color: ColorConst.NeutralVariant.shade60),
  //                         )
  //                       ]),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const Spacer(),
  //           Obx(() {
  //             return Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 InkWell(
  //                   onTap: () {
  //                     Clipboard.setData(ClipboardData(
  //                         text:
  //                             controller.selectedAccount.value.publicKeyHash));
  //                     Get.rawSnackbar(
  //                       message: "Copied to clipboard",
  //                       shouldIconPulse: true,
  //                       snackPosition: SnackPosition.BOTTOM,
  //                       maxWidth: 0.9.width,
  //                       margin: EdgeInsets.only(
  //                         bottom: 20.aR,
  //                       ),
  //                       duration: const Duration(milliseconds: 2000),
  //                     );
  //                   },
  //                   child: SvgPicture.asset(
  //                     '${PathConst.SVG}copy.svg',
  //                     color: Colors.white,
  //                     fit: BoxFit.contain,
  //                     height: 24.aR,
  //                   ),
  //                 ),
  //                 if (!(controller.selectedAccount.value.isWatchOnly))
  //                   0.04.hspace,
  //                 if (!(controller.selectedAccount.value.isWatchOnly))
  //                   InkWell(
  //                     child: SvgPicture.asset(
  //                       '${PathConst.SVG}scanVector.svg',
  //                       fit: BoxFit.contain,
  //                       height: 24.aR,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //               ],
  //             );
  //           }),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _actionButton(
      {required String imagePath, required String label, Function()? onTap}) {
    bool isEnabled = !(controller.selectedAccount.value.isWatchOnly);
    return BouncingWidget(
      onPressed: isEnabled ? onTap : null,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.arP),
                  child: CircleAvatar(
                    backgroundColor:
                        isEnabled ? ColorConst.Primary : ColorConst.darkGrey,
                    radius: 20.aR,
                    child: SvgPicture.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      height: 20.aR,
                      color: isEnabled ? Colors.white : ColorConst.textGrey1,
                    ),
                  ),
                )),
            TextSpan(
                text: '\n$label',
                style: labelMedium.copyWith(
                    fontSize: 12.aR, letterSpacing: 0.1.aR, height: 20 / 12)),
          ],
        ),
      ),
    );
  }
}
