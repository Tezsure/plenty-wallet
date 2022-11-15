import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/dapps_page/views/dapps_page_view.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class HomepageAppBar extends StatelessWidget {
  const HomepageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24, top: 26, bottom: 24, left: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.SETTINGS_PAGE),
            child: Image.asset(
              "${PathConst.HOME_PAGE}menu.png",
              width: 24,
              height: 24,
            ),
          ),
          GestureDetector(
            onTap: () => {},
            child: Image.asset(
              "${PathConst.HOME_PAGE}scan.png",
              width: 42,
              height: 42,
            ),
          ),
        ],
      ),
    );
  }
}
