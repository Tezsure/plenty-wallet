import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class AccountValueWidget extends StatelessWidget {
  const AccountValueWidget({Key? key}) : super(key: key);

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
              GestureDetector(
                child: SizedBox(
                  height: 12,
                  width: 12,
                  child: SvgPicture.asset(
                      PathConst.HOME_PAGE.SVG + "eye_hide.svg"),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(PathConst.HOME_PAGE.SVG + "xtz.svg"),
              0.02.hspace,
              Text(
                "1020.00",
                style: headlineLarge,
              )
            ],
          ),
          0.035.vspace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              actionMethod("Send", PathConst.HOME_PAGE.SVG + "send.svg"),
              0.09.hspace,
              actionMethod("Receive", PathConst.HOME_PAGE.SVG + "receive.svg"),
              0.09.hspace,
              actionMethod("Add", PathConst.HOME_PAGE.SVG + "plus.svg"),
            ],
          ),
          0.06.vspace,
        ],
      ),
    );
  }

  Column actionMethod(String title, String svgPath) {
    return Column(
      children: [
        CircleAvatar(
          radius: 0.07.width,
          backgroundColor: ColorConst.Primary.shade60,
          child: SvgPicture.asset(svgPath),
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
