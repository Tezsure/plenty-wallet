import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/dapps_page/views/dapps_page_view.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class DiscoverAppsWidget extends StatelessWidget {
  const DiscoverAppsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          const DappsPageView(),
          enterBottomSheetDuration: const Duration(milliseconds: 180),
          exitBottomSheetDuration: const Duration(milliseconds: 150),
          barrierColor: Colors.white.withOpacity(0.09),
          isScrollControlled: true,
        );
      },
      child: Container(
        height: 0.405.width,
        width: 1.width,
        margin: EdgeInsets.only(left: 32.arP, right: 32.arP),
        decoration: BoxDecoration(
          gradient: appleOrange,
          borderRadius: BorderRadius.circular(22.sp),
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22.arP),
              child: Image.asset(
                "${PathConst.HOME_PAGE}discover_apps.png",
                fit: BoxFit.cover,cacheHeight: 335,cacheWidth: 709,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Discover",
                        style: headlineSmall.copyWith(fontSize: 20.sp)),
                    Text(
                      "apps on Tezos",
                      style: bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
