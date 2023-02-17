import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import 'bouncing_widget.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final String socialIconPath;
  const SocialLoginButton({
    Key? key,
    required this.onTap,
    required this.socialIconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: onTap,
      // onTap: onTap,
      child: CircleAvatar(
        radius: 0.07.width,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset("${PathConst.SVG}$socialIconPath"),
      ),
    );
  }
}