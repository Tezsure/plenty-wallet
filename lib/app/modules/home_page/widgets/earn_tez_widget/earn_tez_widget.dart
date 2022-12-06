import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/controllers/delegate_widget_controller.dart';

import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class EarnTezWidget extends StatelessWidget {
  const EarnTezWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.put(DelegateWidgetController()).checkBaker();
      },
      child: Container(
        height: 0.405.width,
        width: 0.405.width,
        margin: EdgeInsets.only(right: 24.sp),
        decoration: BoxDecoration(
          gradient: blueGradient,
          borderRadius: BorderRadius.circular(22.sp),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset("${PathConst.HOME_PAGE.SVG}earn.svg"),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Earn 5%",
                        style: headlineSmall.copyWith(fontSize: 20.sp)),
                    Text(
                      "on your tez",
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
