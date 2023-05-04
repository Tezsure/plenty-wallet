import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/custom_image_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker_tile.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class ReviewDelegateSelectBaker extends GetView<DelegateWidgetController> {
  final DelegateBakerModel baker;
  const ReviewDelegateSelectBaker({super.key, required this.baker});
  static final _homePageController = Get.find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DelegateWidgetController());
    return NaanBottomSheet(
        title: "Review",
        mainAxisAlignment: MainAxisAlignment.end,
        bottomSheetHorizontalPadding: 16.arP,
        height: 0.52.height,
        blurRadius: 5,
        width: double.infinity,
        bottomSheetWidgets: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                0.023.vspace,
                _accountOption(),
                0.015.vspace,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.arP),
                  child: const Divider(
                    thickness: .2,
                    color: ColorConst.grey,
                  ),
                ),
                Text(
                  "Delegate to".tr,
                  style: labelMedium.copyWith(color: ColorConst.textGrey1),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.arP),
                  child: DelegateBakerTile(
                    baker: baker,
                  ),
                ),
                0.02.vspace,
                Align(
                  alignment: Alignment.center,
                  child: SolidButton(
                    width: 1.width - 64.arP,
                    active: true,
                    onLongPressed: () {
                      controller.confirmBioMetric(baker);
                    },
                    title: "Hold to Delegate",
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Platform.isAndroid
                            ? SvgPicture.asset(
                                "${PathConst.SVG}fingerprint.svg",
                                color: Colors.white,
                                width: 24.arP,
                              )
                            : SvgPicture.asset(
                                "${PathConst.SVG}faceid.svg",
                                color: Colors.white,
                                width: 24.arP,
                              ),
                        0.02.hspace,
                        Text(
                          "Hold to Delegate".tr,
                          style: titleSmall.copyWith(
                              fontSize: 14.aR, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                0.018.vspace
              ],
            ),
          ),
        ]);
  }

  Widget _accountOption() {
    final account = _homePageController
        .userAccounts[_homePageController.selectedIndex.value];
    return Row(
      children: [
        SizedBox(
          // width: 0.16.width,
          child: Align(
              alignment: Alignment.centerLeft,
              child: CustomImageWidget(
                imageType: account.imageType!,
                imagePath: account.profileImage!,
                imageRadius: 23.arP,
              )),
        ),
        0.016.hspace,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // height: 14.arP,
              child: Text(
                account.name ?? 'Wallet',
                style: labelSmall.apply(
                  color: ColorConst.NeutralVariant.shade60,
                ),
              ),
            ),
            SizedBox(
              height: 27.arP,
              child: Row(
                children: [
                  Text(
                    tz1Shortner(account.publicKeyHash ?? ""),
                    style: labelLarge,
                  ),
                  0.02.hspace,
                  BouncingWidget(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: account.publicKeyHash));
                      Get.rawSnackbar(
                        maxWidth: 0.45.width,
                        backgroundColor: Colors.transparent,
                        snackPosition: SnackPosition.BOTTOM,
                        snackStyle: SnackStyle.FLOATING,
                        padding: EdgeInsets.only(bottom: 60.arP),
                        messageText: Container(
                          height: 36.arP,
                          padding: EdgeInsets.symmetric(horizontal: 10.arP),
                          decoration: BoxDecoration(
                              color: ColorConst.Neutral.shade10,
                              borderRadius: BorderRadius.circular(8.arP)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 14.arP,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.arP,
                              ),
                              Text(
                                "copied to clipboard".tr,
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
                      height: 15.aR,
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
