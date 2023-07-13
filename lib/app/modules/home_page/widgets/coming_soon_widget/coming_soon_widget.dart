import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';

class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.width,
      child: SvgPicture.asset(
        "${PathConst.HOME_PAGE.SVG}coming_soon.svg",
        width: 1.width,
      ),
    );
  }
}
