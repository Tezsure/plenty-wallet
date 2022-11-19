import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/transaction_controller.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

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
  const AccountSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put((AccountSummaryController()));
    Get.put(TransactionController());
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20.sp, sigmaY: 20.sp),
      child: DraggableScrollableSheet(
        maxChildSize: 0.95,
        initialChildSize: 0.95,
        minChildSize: 0.9,
        builder: ((context, scrollController) => Container(
              height: 1.height,
              width: 1.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                color: Colors.black,
              ),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    0.01.vspace,
                    Center(
                      child: Container(
                        height: 5.aR,
                        width: 36.aR,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.aR),
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.only(
                            left: 16.aR, right: 16.aR, top: 14.aR),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                    AccountSelectorSheet(
                                      selectedAccount:
                                          controller.userAccount.value,
                                    ),
                                    enterBottomSheetDuration:
                                        const Duration(milliseconds: 180),
                                    exitBottomSheetDuration:
                                        const Duration(milliseconds: 150),
                                    isScrollControlled: true);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  0.01.hspace,
                                  CustomImageWidget(
                                    imageType:
                                        controller.userAccount.value.imageType!,
                                    imagePath: controller
                                        .userAccount.value.profileImage!,
                                    imageRadius: 18.aR,
                                  ),
                                  0.03.hspace,
                                  RichText(
                                    text: TextSpan(
                                        text:
                                            controller.userAccount.value.name!,
                                        style: labelMedium.copyWith(
                                            fontSize: 12.aR,
                                            fontWeight: FontWeight.w600),
                                        children: [
                                          WidgetSpan(
                                              child: SizedBox(
                                            width: 2.sp,
                                          )),
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.bottom,
                                            child: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 20.aR,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "\n${(controller.userAccount.value.publicKeyHash!).tz1Short()}",
                                            style: labelMedium.copyWith(
                                                fontSize: 12.aR,
                                                height: 0,
                                                fontWeight: FontWeight.w400,
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
                                InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                        text: controller
                                            .userAccount.value.publicKeyHash));
                                    Get.rawSnackbar(
                                      message: "Copied to clipboard",
                                      shouldIconPulse: true,
                                      snackPosition: SnackPosition.BOTTOM,
                                      maxWidth: 0.9.width,
                                      margin: EdgeInsets.only(
                                        bottom: 20.aR,
                                      ),
                                      duration:
                                          const Duration(milliseconds: 700),
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    '${PathConst.SVG}copy.svg',
                                    color: Colors.white,
                                    fit: BoxFit.contain,
                                    height: 24.aR,
                                  ),
                                ),
                                0.04.hspace,
                                InkWell(
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
                            "\$ ${(controller.userAccount.value.accountDataModel!.totalBalance! * controller.xtzPrice.value).toStringAsFixed(6)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30.aR,
                              color: Colors.white,
                            ),
                          ),
                        )),
                    0.03.vspace,
                    Padding(
                      padding: EdgeInsets.only(left: 17.sp, right: 16.sp),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _actionButton(
                              imagePath: '${PathConst.SVG}plus.svg',
                              label: 'Buy'),
                          0.04.hspace,
                          _actionButton(
                              imagePath: '${PathConst.SVG}dollar_sign.svg',
                              label: 'Earn'),
                          0.04.hspace,
                          _actionButton(
                            imagePath: '${PathConst.SVG}arrow_up.svg',
                            label: 'Send',
                            onTap: (() => Get.bottomSheet(const SendPage(),
                                enterBottomSheetDuration:
                                    const Duration(milliseconds: 180),
                                exitBottomSheetDuration:
                                    const Duration(milliseconds: 150),
                                settings: RouteSettings(
                                    arguments: controller.userAccount.value),
                                isScrollControlled: true,
                                barrierColor: Colors.white.withOpacity(0.09))),
                          ),
                          0.04.hspace,
                          _actionButton(
                            imagePath: '${PathConst.SVG}arrow_down.svg',
                            label: 'Receive',
                            onTap: (() => Get.bottomSheet(
                                const ReceivePageView(),
                                enterBottomSheetDuration:
                                    const Duration(milliseconds: 180),
                                exitBottomSheetDuration:
                                    const Duration(milliseconds: 150),
                                settings: RouteSettings(
                                    arguments: controller.userAccount.value),
                                isScrollControlled: true,
                                barrierColor: Colors.white.withOpacity(0.09))),
                          ),
                        ],
                      ),
                    ),
                    0.02.vspace,
                    Divider(
                      height: 0.sp,
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
                            value == 2
                                ? controller.loadUserTransaction()
                                : null;
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
                          unselectedLabelColor:
                              ColorConst.NeutralVariant.shade60,
                          tabs: [
                            SizedBox(
                              width: 70.sp,
                              child: Tab(
                                height: 30.sp,
                                text: "Crypto",
                                iconMargin: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(
                              width: 70.sp,
                              child: Tab(
                                height: 30.sp,
                                text: "NFTs",
                                iconMargin: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(
                              width: 70.sp,
                              child: Tab(
                                height: 30.sp,
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
            )),
      ),
    );
  }

  Widget _actionButton(
      {required String imagePath, required String label, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: CircleAvatar(
                    backgroundColor: ColorConst.Primary,
                    radius: 20.aR,
                    child: SvgPicture.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      height: 20.aR,
                      color: Colors.white,
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
