import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

import '../../../nft_gallery/views/nft_gallery_view.dart';

class HomepageAppBar extends StatelessWidget {
  const HomepageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24, top: 26, bottom: 16, left: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.SETTINGS_PAGE),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          Container(
            width: 124,
            height: 40,
            decoration: BoxDecoration(
              color: ColorConst.Primary.shade60,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                actionItems(
                    onTap: () {
                      Get.bottomSheet(
                        NftGalleryView(),
                        isDismissible: true,
                        enableDrag: true,
                        isScrollControlled: true,
                      );
                    },
                    svgPath: "${PathConst.HOME_PAGE.SVG}gallery.svg"),
                const VerticalDivider(
                  width: 2,
                  thickness: 2,
                  color: ColorConst.Primary,
                ),
                actionItems(
                    onTap: () {},
                    svgPath: "${PathConst.HOME_PAGE.SVG}browser.svg"),
                const VerticalDivider(
                  width: 2,
                  thickness: 2,
                  color: ColorConst.Primary,
                ),
                actionItems(
                    onTap: () {},
                    svgPath: "${PathConst.HOME_PAGE.SVG}qrcode.svg"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector actionItems(
      {required GestureTapCallback onTap, required String svgPath}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        width: 40,
        child: SvgPicture.asset(
          svgPath,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
