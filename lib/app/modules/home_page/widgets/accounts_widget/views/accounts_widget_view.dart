import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/modules/account_summary/views/account_summary_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/receive_page/views/receive_page_view.dart';
import 'package:naan_wallet/app/modules/send_page/views/send_page.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../../../utils/styles/styles.dart';
import '../controllers/accounts_widget_controller.dart';
import 'widget/add_account_widget.dart';

// ignore: must_be_immutable
class AccountsWidget extends GetView<AccountsWidgetController> {
  AccountsWidget({Key? key}) : super(key: key);

  final HomePageController homePageController = Get.find<HomePageController>();
  @override
  final AccountsWidgetController controller =
      Get.put(AccountsWidgetController());
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AccountsWidgetController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: 1.width,
        height: 0.45.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => homePageController.userAccounts.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                          right: homePageController.userAccounts.isEmpty
                              ? 0.04.width
                              : 0),
                      child: const AddAccountWidget(),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff958E99).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(22.sp),
                      ),
                      width: 1.width,
                      height: 0.45.width,
                      child: GetBuilder<AccountsWidgetController>(
                        builder: ((_) => PageView.builder(
                            padEnds: false,
                            itemCount: homePageController.userAccounts
                                    .where((e) => e.isAccountHidden == false)
                                    .toList()
                                    .length +
                                1,
                            controller: PageController(
                              viewportFraction: 1,
                              initialPage: 0,
                            ),
                            onPageChanged: controller.onPageChanged,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (_, index) {
                              var scale =
                                  controller.selectedAccountIndex.value == index
                                      ? 1.0
                                      : 0.8;
                              print(
                                  "index: $index, accountIndex: ${controller.selectedAccountIndex.value}");

                              return index ==
                                      homePageController.userAccounts
                                          .where(
                                              (e) => e.isAccountHidden == false)
                                          .toList()
                                          .length
                                  ? TweenAnimationBuilder(
                                      tween: Tween<double>(
                                          begin: scale, end: scale),
                                      curve: Curves.easeIn,
                                      builder: (context, value, child) =>
                                          Transform.scale(
                                            scale: value,
                                            child: child,
                                          ),
                                      duration:
                                          const Duration(milliseconds: 350),
                                      child: const AddAccountWidget())
                                  : homePageController
                                          .userAccounts[index].isAccountHidden!
                                      ? const SizedBox()
                                      : TweenAnimationBuilder(
                                          tween: Tween<double>(
                                              begin: scale, end: scale),
                                          curve: Curves.easeIn,
                                          builder: (context, value, child) =>
                                              Transform.scale(
                                                scale: value,
                                                child: child,
                                              ),
                                          duration:
                                              const Duration(milliseconds: 350),
                                          child: accountContainer(
                                            homePageController
                                                .userAccounts[index],
                                          ));
                            })),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accountContainer(AccountModel model) {
    return Stack(
      children: [
        Container(
          height: 0.26.height,
          width: 1.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              controller.imagePath[Random().nextInt(3)],
              fit: BoxFit.cover,
            ),
        child: Stack(
          children: [
            Container(
              width: 1.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22), gradient: accountBg),
            ),
            Padding(
              padding: EdgeInsets.all(0.04.width),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16.sp,
                        height: 16.sp,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(4.sp),
                          image: DecorationImage(
                            image: model.imageType ==
                                    AccountProfileImageType.assets
                                ? AssetImage(model.profileImage!)
                                : FileImage(
                                    File(model.profileImage!),
                                  ) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      0.020.hspace,
                      Text(
                        model.name!,
                        style: labelMedium,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              tz1Shortner(model.publicKeyHash!),
                              style: bodySmall.copyWith(
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                            0.02.hspace,
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: model.publicKeyHash));
                                Get.rawSnackbar(
                                  message: "Copied to clipboard",
                                  shouldIconPulse: true,
                                  snackPosition: SnackPosition.BOTTOM,
                                  maxWidth: 0.9.width,
                                  margin: const EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  duration: const Duration(milliseconds: 750),
                                );
                              },
                              child: Icon(
                                Icons.copy_outlined,
                                size: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  0.015.vspace,
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Text(
                            "\$ ${(model.accountDataModel!.totalBalance! * Get.find<HomePageController>().xtzPrice.value).toStringAsFixed(3)}",
                            style: headlineLarge,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.sp),
                            color: Colors.black.withOpacity(0.3),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0.sp, vertical: 6.sp),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RawMaterialButton(
                                  constraints: BoxConstraints(
                                      minWidth: 48.sp, minHeight: 48.sp),
                                  elevation: 1,
                                  padding: const EdgeInsets.all(8),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  enableFeedback: true,
                                  onPressed: () => Get.bottomSheet(
                                      const SendPage(),
                                      isScrollControlled: true,
                                      settings: RouteSettings(
                                        arguments: model,
                                      ),
                                      barrierColor:
                                          Colors.white.withOpacity(0.09)),
                                  fillColor: ColorConst.Primary.shade0,
                                  shape:
                                      const CircleBorder(side: BorderSide.none),
                                  child: Image.asset(
                                    "${PathConst.HOME_PAGE}send.png",
                                    width: 24.sp,
                                    height: 24.sp,
                                  ),
                                ),
                                0.036.hspace,
                                RawMaterialButton(
                                  enableFeedback: true,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.all(8),
                                  constraints: BoxConstraints(
                                      minWidth: 48.sp, minHeight: 48.sp),
                                  elevation: 1,
                                  onPressed: () => Get.bottomSheet(
                                      const ReceivePageView(),
                                      isScrollControlled: true,
                                      settings: RouteSettings(
                                        arguments: model,
                                      ),
                                      barrierColor:
                                          Colors.white.withOpacity(0.09)),
                                  fillColor: ColorConst.Primary.shade0,
                                  shape:
                                      const CircleBorder(side: BorderSide.none),
                                  child: Image.asset(
                                    "${PathConst.HOME_PAGE}qr.png",
                                    width: 24.sp,
                                    height: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
