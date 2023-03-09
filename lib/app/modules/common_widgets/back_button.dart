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
          height: 16.arP,
          color: Colors.white,
          alignment: Alignment.centerLeft,
        ),
        if (lastPageName != null)
          SizedBox(
            width: 8.arP,
          ),
        lastPageName == null
            ? Container()
            : Text(
                lastPageName.tr,
                style: bodySmall,
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
      height: 24.arP,
      width: 24.arP,
      alignment: Alignment.center,
      child: Icon(
        Icons.close,
        color: Color.fromRGBO(235, 235, 245, .6),
        size: 14.arP,
      ),
    ),
  );
}
