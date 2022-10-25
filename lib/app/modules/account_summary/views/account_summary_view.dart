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
                      () => ListTile(
                        onTap: (() => Get.bottomSheet(
                            AccountSelectorSheet(
                              selectedAccount: controller.userAccount.value,
                            ),
                            isScrollControlled: true)),
                        enableFeedback: true,
                        horizontalTitleGap: 8.sp,
                        visualDensity: VisualDensity.standard,
                        dense: false,
                        leading: CustomImageWidget(
                          imageType: controller.userAccount.value.imageType!,
                          imagePath: controller.userAccount.value.profileImage!,
                          imageRadius: 20.sp,
                        ),
                        title: SizedBox(
                          height: 0.035.height,
                          width: 0.4.width,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                controller.userAccount.value.name!,
                                style: labelLarge.copyWith(
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(width: 2.sp),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        subtitle: Text(
                          tz1Shortner(
                              controller.userAccount.value.publicKeyHash!),
                          style: labelSmall.copyWith(
                              color: ColorConst.NeutralVariant.shade60),
                        ),
                        trailing: SizedBox(
                          height: 20.sp,
                          width: 60.sp,
                          child: Row(
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
                                    duration: const Duration(milliseconds: 700),
                                  );
                                },
                                child: SvgPicture.asset(
                                  '${PathConst.SVG}copy.svg',
                                  color: Colors.white,
                                  fit: BoxFit.contain,
                                  height: 16.sp,
                                ),
                              ),
                              0.04.hspace,
                              InkWell(
                                child: SvgPicture.asset(
                                  '${PathConst.SVG}scanVector.svg',
                                  fit: BoxFit.contain,
                                  height: 16.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    0.02.vspace,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.sp),
                                    child: CircleAvatar(
                                      backgroundColor: ColorConst.Primary,
                                      radius: 20.sp,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(
                                    text: '\nBuy',
                                    style: labelSmall.copyWith(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.sp),
                                      child: CircleAvatar(
                                        backgroundColor: ColorConst.Primary,
                                        radius: 20.sp,
                                        child: SvgPicture.asset(
                                          '${PathConst.SVG}dollar_sign.svg',
                                          fit: BoxFit.cover,
                                          width: 0.025.width,
                                          height: 0.025.height,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                TextSpan(
                                    text: '\nEarn',
                                    style: labelSmall.copyWith(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.bottomSheet(const SendPage(),
                              isScrollControlled: true,
                              settings: RouteSettings(
                                  arguments: controller.userAccount.value),
                              barrierColor: Colors.white.withOpacity(0.09)),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.sp),
                                    child: CircleAvatar(
                                      backgroundColor: ColorConst.Primary,
                                      radius: 20.sp,
                                      child: Icon(
                                        Icons.arrow_upward,
                                        color: ColorConst.Primary.shade90,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(
                                    text: '\nSend',
                                    style: labelSmall.copyWith(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.bottomSheet(const ReceivePageView(),
                              settings: RouteSettings(
                                  arguments: controller.userAccount.value),
                              isScrollControlled: true,
                              barrierColor: Colors.white.withOpacity(0.09)),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.sp),
                                      child: CircleAvatar(
                                        backgroundColor: ColorConst.Primary,
                                        radius: 20.sp,
                                        child: Icon(
                                          Icons.arrow_downward,
                                          color: ColorConst.Primary.shade90,
                                          size: 20.sp,
                                        ),
                                      ),
                                    )),
                                TextSpan(
                                    text: '\nReceive',
                                    style: labelSmall.copyWith(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    0.03.vspace,
                    Divider(
                      height: 20.sp,
                      color: ColorConst.NeutralVariant.shade20,
                      endIndent: 20.sp,
                      indent: 20.sp,
                    ),
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
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: 20.sp,
                          ),
                          enableFeedback: true,
                          labelStyle: labelLarge,
                          unselectedLabelColor:
                              ColorConst.NeutralVariant.shade60,
                          tabs: [
                            Tab(
                              height: 30.sp,
                              text: "Crypto",
                              iconMargin: EdgeInsets.zero,
                            ),
                            Tab(
                              height: 30.sp,
                              text: "NFTs",
                              iconMargin: EdgeInsets.zero,
                            ),
                            Tab(
                              height: 30.sp,
                              text: "History",
                              iconMargin: EdgeInsets.zero,
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
}

enum HistoryStatus {
  receive,
  sent,
  inProgress,
}
