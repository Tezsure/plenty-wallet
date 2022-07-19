import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/material_Tap.dart';

import '../../../utils/colors/colors.dart';

Widget backButton() {
  return materialTap(
    inkwellRadius: 20.5,
    onPressed: () => Get.back(),
    child: CircleAvatar(
      radius: 20.5,
      backgroundColor: ColorConst.Primary,
      child: SvgPicture.asset(
        PathConst.SVG + "arrow_back.svg",
        fit: BoxFit.scaleDown,
      ),
    ),
  );
}
