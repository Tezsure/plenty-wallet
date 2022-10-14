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
    return Material(
      elevation: 4,
      color: Colors.transparent,
      child: Container(
        height: 0.95.height,
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
                  height: 5,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
              ),
              Obx(
                () => ListTile(
                  leading: CustomImageWidget(
                    imageType: controller.userAccount.value.imageType!,
                    imagePath: controller.userAccount.value.profileImage!,
                    imageRadius: 20,
                  ),
                  title: GestureDetector(
                    onTap: (() => Get.bottomSheet(
                        AccountSelectorSheet(
                          selectedAccount: controller.userAccount.value,
                        ),
                        isScrollControlled: true)),
                    child: SizedBox(
                      height: 20,
                      width: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            controller.userAccount.value.name!,
                            style: labelMedium,
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  subtitle: Text(
                    tz1Shortner(controller.userAccount.value.publicKeyHash!),
                    style: labelSmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                  trailing: SizedBox(
                    height: 20,
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              margin: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              duration: const Duration(milliseconds: 1000),
                            );
                          },
                          child: SvgPicture.asset(
                            '${PathConst.SVG}copy.svg',
                            color: ColorConst.Primary.shade90,
                            fit: BoxFit.contain,
                          ),
                        ),
                        InkWell(
                          child: SvgPicture.asset(
                            '${PathConst.SVG}scanVector.svg',
                            fit: BoxFit.contain,
                            color: ColorConst.Primary.shade90,
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
                          const WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: CircleAvatar(
                                backgroundColor: ColorConst.Primary,
                                radius: 20,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(text: '\nBuy', style: labelSmall),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: CircleAvatar(
                                    backgroundColor: ColorConst.Primary,
                                    radius: 20,
                                    child: Text('\$',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20))),
                              )),
                          TextSpan(
                              text: '\nEarn',
                              style: labelSmall.copyWith(
                                  color: ColorConst.Primary.shade90)),
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
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: CircleAvatar(
                                backgroundColor: ColorConst.Primary,
                                radius: 20,
                                child: Icon(
                                  Icons.arrow_upward,
                                  color: ColorConst.Primary.shade90,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          TextSpan(
                              text: '\nSend',
                              style: labelSmall.copyWith(
                                  color: ColorConst.Primary.shade90)),
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
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: CircleAvatar(
                                  backgroundColor: ColorConst.Primary,
                                  radius: 20,
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: ColorConst.Primary.shade90,
                                    size: 20,
                                  ),
                                ),
                              )),
                          TextSpan(
                              text: '\nReceive',
                              style: labelSmall.copyWith(
                                  color: ColorConst.Primary.shade90)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              0.03.vspace,
              Divider(
                height: 20,
                color: ColorConst.NeutralVariant.shade20,
                endIndent: 20,
                indent: 20,
              ),
              SizedBox(
                height: 50,
                child: TabBar(
                    onTap: (value) {
                      value == 2 ? controller.userTransactionLoader() : null;
                    },
                    isScrollable: true,
                    labelColor: ColorConst.Primary.shade95,
                    indicatorColor: ColorConst.Primary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    enableFeedback: true,
                    unselectedLabelColor: ColorConst.NeutralVariant.shade60,
                    tabs: const [
                      Tab(text: "Crypto"),
                      Tab(text: "NFTs"),
                      Tab(text: "History"),
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
      ),
    );
  }
}

enum HistoryStatus {
  receive,
  sent,
  inProgress,
}
