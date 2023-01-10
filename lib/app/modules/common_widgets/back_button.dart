import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

Widget backButton() {
  return GestureDetector(
    onTap: Get.back,
    child: CircleAvatar(
      // radius: 0.04.width,
      backgroundColor: Colors.transparent,
      child: SvgPicture.asset(
        "${PathConst.SVG}arrow_back.svg",
        fit: BoxFit.cover,
        height: 22.arP,
        color: Colors.white,
        alignment: Alignment.centerLeft,
      ),
    ),
  );
}
