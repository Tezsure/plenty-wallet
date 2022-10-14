import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/receive_page/views/receive_page_view.dart';
import 'package:naan_wallet/app/modules/send_page/views/send_page.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

// ignore: must_be_immutable
class AccountValueWidget extends StatelessWidget {
  AccountValueWidget({super.key});

  HomePageController homePageController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.width,
      color: ColorConst.Primary,
      child: Column(
        children: [
          0.06.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Account Value",
                style: labelSmall.apply(
                  color: ColorConst.NeutralVariant.shade70,
                ),
              ),
              0.01.hspace,
              GestureDetector(
                child: SizedBox(
                  height: 12,
                  width: 12,
                  child: SvgPicture.asset(
                      "${PathConst.HOME_PAGE.SVG}eye_hide.svg"),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("${PathConst.HOME_PAGE.SVG}xtz.svg"),
              0.02.hspace,
              Obx(
                () => Text(
                  homePageController.userAccounts
                      .fold<double>(
                          0.0,
                          (previousValue, element) =>
                              previousValue +
                              element.accountDataModel!.totalBalance!)
                      .toStringAsFixed(6),
                  style: headlineLarge,
                ),
              )
            ],
          ),
          0.035.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              actionMethod("Send", "${PathConst.HOME_PAGE.SVG}send.svg",
                  onTap: () => Get.bottomSheet(const SendPage(),
                      isScrollControlled: true,
                      settings: RouteSettings(
                          arguments: homePageController.userAccounts[0]),
                      barrierColor: Colors.white.withOpacity(0.09))),
              0.09.hspace,
              actionMethod("Receive", "${PathConst.HOME_PAGE.SVG}receive.svg",
                  onTap: () => Get.bottomSheet(const ReceivePageView(),
                      isScrollControlled: true,
                      settings: RouteSettings(
                          arguments: homePageController.userAccounts[0]),
                      barrierColor: Colors.white.withOpacity(0.09))),
              0.09.hspace,
              actionMethod("Add", "${PathConst.HOME_PAGE.SVG}plus.svg"),
            ],
          ),
          0.06.vspace,
        ],
      ),
    );
  }

  Column actionMethod(
    String title,
    String svgPath, {
    GestureTapCallback? onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 0.07.width,
            backgroundColor: ColorConst.Primary.shade60,
            child: SvgPicture.asset(svgPath),
          ),
        ),
        0.01.vspace,
        Text(
          title,
          style: bodySmall,
        ),
      ],
    );
  }
}
