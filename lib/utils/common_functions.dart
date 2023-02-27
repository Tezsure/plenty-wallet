import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommonFunctions {
  static void launchURL(String url, {LaunchMode? mode}) async =>
      await canLaunchUrl(Uri.parse(url))
          ? await launchUrlString(url,
              mode: mode ??
                  (Platform.isAndroid
                      ? LaunchMode.externalNonBrowserApplication
                      : LaunchMode.inAppWebView))
          : url.contains("mailto:naan-support@tezsure.com")
              ? launchUrlString(url)
              : throw 'Could not launch $url';
  static Future bottomSheet(
    Widget child, {
    RouteSettings? settings,
  }) {
    return showCupertinoModalBottomSheet(
        context: Get.context!,
        builder: (context) => Material(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: child),
            ),
        settings: settings,
        bounce: true,
        // : true,
        // barrierColor: Colors.black.withOpacity(0.6),
        elevation: 5,
        topRadius: Radius.circular(24.arP),
        backgroundColor: ColorConst.darkGrey,
        overlayStyle: SystemUiOverlayStyle.light,
        shadow: BoxShadow(
          color: Colors.black.withOpacity(0.5),
          spreadRadius: 0,
          blurRadius: 10,
          offset: const Offset(0, 0), // changes position of shadow
        ),
        transitionBackgroundColor: Color(0xff2D2447),
        useRootNavigator: true
        // enterBottomSheetDuration: const Duration(milliseconds: 180),
        // exitBottomSheetDuration: const Duration(milliseconds: 150),
        );
  }
}
