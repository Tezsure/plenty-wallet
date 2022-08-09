import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/material_Tap.dart';

import '../../../utils/colors/colors.dart';

Widget backButton() {
  return GestureDetector(
    onTap: () => Get.back(),
    child: CircleAvatar(
      radius: 0.045.width,
      backgroundColor: ColorConst.Primary,
      child: SvgPicture.asset(
        "${PathConst.SVG}arrow_back.svg",
        fit: BoxFit.scaleDown,
      ),
    ),
  );
}
