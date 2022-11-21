import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker_tile.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class ReviewDelegateSelectBaker extends GetView<DelegateWidgetController> {
  const ReviewDelegateSelectBaker({super.key});
  static final _homePageController = Get.find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DelegateWidgetController());
    return NaanBottomSheet(
        title: "Review",
        mainAxisAlignment: MainAxisAlignment.end,
        bottomSheetHorizontalPadding: 16.sp,
        height: 0.5.height,
        blurRadius: 5,
        width: double.infinity,
        bottomSheetWidgets: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _accountOption(),
                0.015.vspace,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: const Divider(
                    thickness: .2,
                    color: ColorConst.grey,
                  ),
                ),
                Text(
                  "Delegate to",
                  style: labelMedium.copyWith(color: ColorConst.textGrey1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.sp),
                  child: const DelegateBakerTile(),
                ),
                0.02.vspace,
                SolidButton(
                  active: true,
                  onPressed: () {
                    controller.confirmBioMetric();
                  },
                  title: "Hold to Delegate",
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Platform.isAndroid
                          ? SvgPicture.asset(
                              "${PathConst.SVG}fingerprint.svg",
                              color: ColorConst.Neutral.shade100,
                              width: 15.sp,
                            )
                          : SvgPicture.asset(
                              "${PathConst.SVG}faceid.svg",
                              color: ColorConst.Neutral.shade100,
                              width: 20.sp,
                            ),
                      0.02.hspace,
                      Text(
                        "Hold to Delegate",
                        style: titleSmall.copyWith(
                            fontSize: 14.aR,
                            color: ColorConst.Neutral.shade100),
                      )
                    ],
                  ),
                ),
                0.018.vspace
              ],
            ),
          ),
        ]);
  }

  Widget _accountOption() {
    return Row(
      children: [
        SizedBox(
          width: 0.165.width,
          child: Align(
              alignment: Alignment.centerLeft,
              child: CustomImageWidget(
                imageType: _homePageController.userAccounts[0].imageType!,
                imagePath: _homePageController.userAccounts[0].profileImage!,
                imageRadius: 23,
              )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 14,
              child: Text(
                "Account",
                style: labelSmall.apply(
                  color: ColorConst.NeutralVariant.shade60,
                ),
              ),
            ),
            SizedBox(
              height: 27,
              child: Row(
                children: [
                  Text(
                    _homePageController.userAccounts[0].name ?? 'Account Name',
                    style: labelMedium,
                  ),
                  0.02.hspace,
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                          text: _homePageController
                              .userAccounts[0].publicKeyHash));
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
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
