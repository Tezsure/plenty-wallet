import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ForcedUpdate extends StatelessWidget {
  const ForcedUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    String updateText = Get.arguments[0];
    return Material(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset(
            "${PathConst.SVG}forced_update.svg",
            width: 280.arP,
          ),
          SizedBox(
            height: 32.arP,
          ),
          Text(
            "Update Time",
            style: headlineSmall,
          ),
          SizedBox(
            height: 24.arP,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 64.0.arP),
            child: Text(
              updateText,
              style: bodySmall.copyWith(
                fontWeight: FontWeight.w300,
                color: const Color(0xff958E99),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.all(32.arP),
            child: SolidButton(
              title: "Update",
              onPressed: () {
                launchUrl(
                    Platform.isAndroid
                        ? Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.naan")
                        : Uri.parse(
                            "https://apps.apple.com/in/app/naan-your-portal-to-web3/id1573210354"),
                    mode: LaunchMode.externalApplication);
              },
            ),
          )
        ],
      ),
    );
  }
}
