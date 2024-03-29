import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/settings_page/views/settings_page_view.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

class HomepageAppBar extends StatelessWidget {
  const HomepageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: 22.arP, top: 26.arP, bottom: 24.arP, left: 22.arP),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          BouncingWidget(
            onPressed: () {
              // Get.bottomSheet(
              //   TestNetworkBottomSheet(),
              // );
              CommonFunctions.bottomSheet(const SettingsPageView(),
                  fullscreen: true);
            },
            child: Image.asset(
              "${PathConst.HOME_PAGE}menu.png",
              width: 24.arP,
              height: 24.arP,
            ),
          ),
          Obx(() {
            if (Get.find<HomePageController>().userAccounts.isEmpty) {
              return Container();
            }
            if (Get.find<HomePageController>()
                .userAccounts[
                    Get.find<HomePageController>().selectedIndex.value]
                .isWatchOnly) {
              return SizedBox(
                width: 42.arP,
                height: 42.arP,
              );
            }
            return BouncingWidget(
              onPressed: () {
                Get.find<HomePageController>().openScanner();
              },
              child: Image.asset(
                "${PathConst.HOME_PAGE}scan.png",
                width: 42.arP,
                height: 42.arP,
              ),
            );
          }),
        ],
      ),
    );
  }
}
