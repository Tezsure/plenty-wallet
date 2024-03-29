import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:plenty_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:plenty_wallet/env.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/nested_route_observer.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../common_widgets/custom_image_widget.dart';
import '../../import_wallet_page/widgets/custom_tab_indicator.dart';
import '../../receive_page/views/receive_page_view.dart';
import '../../send_page/views/send_page.dart';
import '../controllers/account_summary_controller.dart';
import 'bottomsheets/account_selector.dart';
import 'pages/crypto_tab.dart';
import 'pages/history_tab.dart';
import 'pages/nft_tab.dart';

class AccountSummaryView extends GetView<AccountSummaryController> {
  AccountSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<AccountSummaryController>()) {
      controller.fetchAllTokens();
      controller.fetchAllNfts();
      if (Get.isRegistered<TransactionController>()) {
        // controller.loadUserTransaction();
      }
      controller.selectedTokenIndexSet.clear();
    }
    Get.put((AccountSummaryController()));
    Get.put(TransactionController());

    return NaanBottomSheet(
        height: AppConstant.naanBottomSheetHeight,
        bottomSheetHorizontalPadding: 0,
        bottomSheetWidgets: [
          SizedBox(
              height: AppConstant.naanBottomSheetHeight - 16.arP,
              child: Navigator(
                  observers: [NestedRouteObserver()],
                  onGenerateRoute: (_) {
                    return MaterialPageRoute(builder: (context) {
                      return Builder(builder: (context) {
                        return DefaultTabController(
                            length: 3,
                            child: SizedBox(
                                height: AppConstant.naanBottomSheetHeight,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.arP),
                                        child: const BottomSheetHeading(
                                          title: "Accounts",
                                        ),
                                      ),
                                      0.01.vspace,
                                      Obx(
                                        () => Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.aR,
                                              right: 16.aR,
                                              top: 14.aR),
                                          child: Row(
                                            children: [
                                              BouncingWidget(
                                                onPressed: () {
                                                  CommonFunctions.bottomSheet(
                                                    const AccountSelectorSheet(),
                                                  );
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    0.01.hspace,
                                                    CustomImageWidget(
                                                      imageType: controller
                                                          .selectedAccount
                                                          .value
                                                          .imageType!,
                                                      imagePath: controller
                                                          .selectedAccount
                                                          .value
                                                          .profileImage!,
                                                      imageRadius: 18.aR,
                                                    ),
                                                    0.03.hspace,
                                                    RichText(
                                                      text: TextSpan(
                                                          text: controller
                                                              .selectedAccount
                                                              .value
                                                              .name!,
                                                          style: labelMedium,
                                                          children: [
                                                            WidgetSpan(
                                                                child: SizedBox(
                                                              width: 2.arP,
                                                            )),
                                                            WidgetSpan(
                                                              alignment:
                                                                  PlaceholderAlignment
                                                                      .bottom,
                                                              child: Icon(
                                                                Icons
                                                                    .keyboard_arrow_down_rounded,
                                                                size: 20.aR,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  "\n${(controller.selectedAccount.value.publicKeyHash!).tz1Short()}",
                                                              style: bodySmall.copyWith(
                                                                  height: 0,
                                                                  color: ColorConst
                                                                      .NeutralVariant
                                                                      .shade60),
                                                            )
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  BouncingWidget(
                                                    onPressed: () {
                                                      Clipboard.setData(ClipboardData(
                                                          text: controller
                                                              .selectedAccount
                                                              .value
                                                              .publicKeyHash!));
                                                      Get.rawSnackbar(
                                                        maxWidth: 0.45.width,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        snackStyle:
                                                            SnackStyle.FLOATING,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 60),
                                                        messageText: Container(
                                                          height: 36,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          decoration: BoxDecoration(
                                                              color: ColorConst
                                                                  .Neutral
                                                                  .shade10,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .check_circle_outline_rounded,
                                                                size: 14,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "${"Copied".tr} ${tz1Shortner(controller.selectedAccount.value.publicKeyHash!)}",
                                                                style:
                                                                    labelSmall,
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
                                                  if (!controller
                                                      .selectedAccount
                                                      .value
                                                      .isWatchOnly)
                                                    0.04.hspace,
                                                  if (!controller
                                                      .selectedAccount
                                                      .value
                                                      .isWatchOnly)
                                                    BouncingWidget(
                                                      onPressed: () {
                                                        Get.find<
                                                                HomePageController>()
                                                            .openScanner();
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
                                              ((controller
                                                              .selectedAccount
                                                              .value
                                                              .accountDataModel!
                                                              .totalBalance ??
                                                          0) *
                                                      controller.xtzPrice.value)
                                                  .roundUpDollar(controller
                                                      .xtzPrice.value),
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
                                          padding: EdgeInsets.only(
                                              left: 17.arP, right: 16.arP),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              _actionButton(
                                                  onTap: () {
                                                    bool isIndia =
                                                        DateTime.now()
                                                                .timeZoneName ==
                                                            "IST";

                                                    String url = isIndia
                                                        ? 'https://onramp.money/app/?appId=$onrampId&coinCode=xtz&network=xtz&walletAddress=${controller.selectedAccount.value.publicKeyHash}'
                                                        : "https://wert.naan.app?address=${controller.selectedAccount.value.publicKeyHash}";

                                                    debugPrint(url);
                                                    // final dappController = Get.put(
                                                    //   DappBrowserController(),
                                                    // );
                                                    // dappController.initUrl = url;
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             DappBrowserView()));
                                                    CommonFunctions.bottomSheet(
                                                        const DappBrowserView(),
                                                        fullscreen: true,
                                                        settings: RouteSettings(
                                                          arguments: url,
                                                        ));
                                                  },
                                                  imagePath:
                                                      '${PathConst.SVG}plus.svg',
                                                  label: 'Buy'),
                                              0.04.hspace,
                                              _actionButton(
                                                  onTap: () {
                                                    NaanAnalytics.logEvent(
                                                        NaanAnalyticsEvents
                                                            .DELEGATE_FROM_WALLET);
                                                    Get.put(DelegateWidgetController())
                                                        .openBakerList(context,
                                                            "Accounts");
                                                  },
                                                  imagePath:
                                                      '${PathConst.SVG}dollar_sign.svg',
                                                  label: 'Earn'),
                                              0.04.hspace,
                                              _actionButton(
                                                imagePath:
                                                    '${PathConst.SVG}arrow_up.svg',
                                                label: 'Send',
                                                onTap: () {
                                                  return Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          settings: RouteSettings(
                                                              arguments: controller
                                                                  .selectedAccount
                                                                  .value),
                                                          builder: (context) =>
                                                              const SendPage(
                                                                lastPageName:
                                                                    "Accounts",
                                                              )));
                                                  // return CommonFunctions
                                                  //     .bottomSheet(
                                                  //   const SendPage(),
                                                  //   settings: RouteSettings(
                                                  //       arguments: controller
                                                  //           .selectedAccount.value),
                                                  // );
                                                },
                                              ),
                                              0.04.hspace,
                                              _actionButton(
                                                imagePath:
                                                    '${PathConst.SVG}arrow_down.svg',
                                                label: 'Receive',
                                                onTap: (() {
                                                  return Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          settings: RouteSettings(
                                                              arguments: controller
                                                                  .selectedAccount
                                                                  .value),
                                                          builder: (context) =>
                                                              const ReceivePageView(
                                                                lastPageName:
                                                                    "Accounts",
                                                              )));
                                                  // return CommonFunctions
                                                  //     .bottomSheet(
                                                  //   const ReceivePageView(),
                                                  //   settings: RouteSettings(
                                                  //       arguments: controller
                                                  //           .selectedAccount.value),
                                                  // );
                                                }),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      0.02.vspace,
                                      Divider(
                                        height: 0.arP,
                                        color:
                                            ColorConst.NeutralVariant.shade20,
                                        endIndent: 16.aR,
                                        indent: 16.aR,
                                      ),
                                      0.02.vspace,
                                      SizedBox(
                                        height: 48.aR,
                                        width: 1.width,
                                        child: TabBar(
                                            onTap: (value) async {
                                              refreshNft() async {
                                                controller.contractOffset = 0;
                                                controller.contracts.clear();
                                                controller.userNfts.clear();
                                                await controller.fetchAllNfts();
                                              }

                                              AppConstant.hapticFeedback();
                                              value == 2
                                                  ? controller
                                                      .loadUserTransaction()
                                                  : value == 1
                                                      ? refreshNft()
                                                      : null;
                                            },
                                            // isScrollable: true,
                                            labelColor:
                                                ColorConst.Primary.shade95,
                                            indicatorColor: ColorConst.Primary,
                                            indicatorSize:
                                                TabBarIndicatorSize.tab,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.aR,
                                            ),
                                            labelPadding: EdgeInsets.only(
                                              bottom: 12.aR,
                                            ),
                                            // EdgeInsets.symmetric(
                                            //   horizontal: 6.aR,
                                            // ),
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
                                              fontSize: 14.aR,
                                              letterSpacing: 0.1.aR,
                                            ),
                                            tabAlignment: TabAlignment.fill,
                                            unselectedLabelColor: ColorConst
                                                .NeutralVariant.shade60,
                                            tabs: [
                                              SizedBox(
                                                width: 70.arP,
                                                child: Tab(
                                                  height: 30.arP,
                                                  text: "Crypto".tr,
                                                  iconMargin: EdgeInsets.zero,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 70.arP,
                                                child: Tab(
                                                  height: 30.arP,
                                                  text: "NFTs".tr,
                                                  iconMargin: EdgeInsets.zero,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 70.arP,
                                                child: Tab(
                                                  height: 30.arP,
                                                  text: "History".tr,
                                                  iconMargin: EdgeInsets.zero,
                                                ),
                                              ),
                                            ]),
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          children: [
                                            CryptoTabPage(),
                                            NFTabPage(),
                                            const HistoryPage(),
                                          ],
                                        ),
                                      ),
                                      // 0.036.vspace,
                                      // Obx(() => Center(
                                      //       child: Text(
                                      //         ((ServiceConfig.currentNetwork ==
                                      //                         NetworkType.mainnet
                                      //                     ? controller
                                      //                             .selectedAccount
                                      //                             .value
                                      //                             .accountDataModel
                                      //                             ?.totalBalance ??
                                      //                         0
                                      //                     : controller
                                      //                             .selectedAccount
                                      //                             .value
                                      //                             .accountDataModel!
                                      //                             .xtzBalance ??
                                      //                         0) *
                                      //                 controller.xtzPrice.value)
                                      //             .roundUpDollar(
                                      //                 controller.xtzPrice.value),
                                      //         style: TextStyle(
                                      //           fontWeight: FontWeight.w700,
                                      //           fontSize: 30.aR,
                                      //           color: Colors.white,
                                      //         ),
                                      //       ),
                                      //     ))
                                    ])));
                      });
                    });
                  }))
        ]);
  }

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
                text: '\n${label.tr}',
                style: labelMedium.copyWith(
                    fontSize: 12.aR, letterSpacing: 0.1.aR, height: 20 / 12)),
          ],
        ),
      ),
    );
  }
}
