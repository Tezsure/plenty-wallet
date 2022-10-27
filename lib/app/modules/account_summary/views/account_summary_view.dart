import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../common_widgets/custom_image_widget.dart';
import '../../receive_page/views/receive_page_view.dart';
import '../../send_page/views/send_page.dart';
import '../controllers/account_summary_controller.dart';
import 'bottomsheets/account_selector.dart';
import 'bottomsheets/search_sheet.dart';
import 'pages/crypto_tab.dart';
import 'pages/history_tab.dart';
import 'pages/nft_tab.dart';

class AccountSummaryView extends GetView<AccountSummaryController> {
  const AccountSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountSummaryController());
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
                        height: 5.sp,
                        width: 36.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.sp),
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                    Obx(
                      () => Padding(
                        padding: EdgeInsets.only(
                            left: 16.sp, right: 16.sp, top: 14.sp),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                    AccountSelectorSheet(
                                      selectedAccount:
                                          controller.userAccount.value,
                                    ),
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
                                    imageRadius: 18.sp,
                                  ),
                                  0.03.hspace,
                                  RichText(
                                    text: TextSpan(
                                        text:
                                            controller.userAccount.value.name!,
                                        style: labelMedium.copyWith(
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
                                              size: 20.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "\n${(controller.userAccount.value.publicKeyHash!).tz1Short()}",
                                            style: labelMedium.copyWith(
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
                                        bottom: 20.sp,
                                      ),
                                      duration:
                                          const Duration(milliseconds: 700),
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    '${PathConst.SVG}copy.svg',
                                    color: Colors.white,
                                    fit: BoxFit.contain,
                                    height: 24.sp,
                                  ),
                                ),
                                0.04.hspace,
                                InkWell(
                                  child: SvgPicture.asset(
                                    '${PathConst.SVG}scanVector.svg',
                                    fit: BoxFit.contain,
                                    height: 24.sp,
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
                              fontSize: 30.sp,
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
                      endIndent: 16.sp,
                      indent: 16.sp,
                    ),
                    0.02.vspace,
                    SizedBox(
                      height: 50.sp,
                      width: 1.width,
                      child: TabBar(
                          onTap: (value) async {
                            value == 2
                                ? controller.userTransactionLoader()
                                : null;
                          },
                          isScrollable: true,
                          labelColor: ColorConst.Primary.shade95,
                          indicatorColor: ColorConst.Primary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: 8.sp,
                          ),
                          indicatorWeight: 4.sp,
                          enableFeedback: true,
                          indicator: UnderlineTabIndicator(
                            insets: EdgeInsets.only(left: 4.sp, right: 4.sp),
                            borderSide: BorderSide(
                                color: ColorConst.Primary, width: 4.sp),
                          ),
                          labelStyle: labelLarge,
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
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          const CryptoTabPage(),
                          const NFTabPage(),
                          HistoryPage(
                            onTap: (() => Get.bottomSheet(
                                  const SearchBottomSheet(),
                                  isScrollControlled: true,
                                )),
                          ),
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
                    radius: 20.sp,
                    child: SvgPicture.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      height: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                )),
            TextSpan(
                text: '\n$label',
                style: labelMedium.copyWith(
                    letterSpacing: 0.1.sp, height: 20 / 12)),
          ],
        ),
      ),
    );
  }
}
