import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

Widget backButton({Function()? ontap, String? lastPageName}) {
  return BouncingWidget(
    onPressed: ontap ?? Get.back,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "${PathConst.SVG}arrow_back.svg",
          fit: BoxFit.cover,
          height: 18.arP,
          color: Colors.white,
          alignment: Alignment.centerLeft,
        ),
        if (lastPageName != null)
          SizedBox(
            width: 8.arP,
          ),
        lastPageName == null
            ? Container()
            : Container(
                constraints: BoxConstraints(maxWidth: .25.width),
                child: Text(
                  lastPageName.tr,
                  overflow: TextOverflow.ellipsis,
                  style: bodyMedium,
                ),
              )
      ],
    ),
  );
}

Widget closeButton({Function()? ontap}) {
  return BouncingWidget(
    onPressed: ontap ?? Get.back,
    child: Container(
      decoration:
          BoxDecoration(color: ColorConst.darkGrey, shape: BoxShape.circle),
      height: 30.arP,
      width: 30.arP,
      alignment: Alignment.center,
      child: SvgPicture.asset(
        "${PathConst.SVG}xmark.svg",
        fit: BoxFit.cover,
        height: 11.arP,
        color: Colors.white,
      ),
    ),
  );
}
