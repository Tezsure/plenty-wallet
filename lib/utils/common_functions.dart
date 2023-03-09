import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/router_report.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'bottom_sheet_manager.dart';

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
  }) async {
    // return await Get.bottomSheet(
    //   child,
    //   settings: settings,
    //   isScrollControlled: true,
    //   barrierColor: Colors.black.withOpacity(0.5),
    //   backgroundColor: Colors.transparent,
    //   enterBottomSheetDuration: const Duration(milliseconds: 180),
    //   exitBottomSheetDuration: const Duration(milliseconds: 150),
    // ).then((value) {
    //   return value;
    // });
    return await showCupertinoModalBottomSheet(
            context: Get.context!,
            navigatorState: Get.global(null).currentState!,
            onCreate: (route) {
              RouterReportManager.reportCurrentRoute(route);
            },
            onDispose: (route) {
              RouterReportManager.reportRouteDispose(route);
            },
            builder: (context) => Material(
                  child: child,
                ),
            settings: settings,
            bounce: false,
            // : true,
            // barrierColor: Colors.black.withOpacity(0.6),
            // elevation: 5,
            // topRadius: Radius.circular(24.arP),
            // backgroundColor: ColorConst.darkGrey,
            overlayStyle: SystemUiOverlayStyle.light,
            // transitionBackgroundColor: ColorConst.darkGrey,
            // backgroundColor: Colors.black54,
            // barrierColor: ColorConst.darkGrey.withOpacity(.8),
            backgroundColor: Colors.transparent
            // shadow: BoxShadow(
            //   color: Colors.black.withOpacity(0.2),
            //   spreadRadius: 50,
            //   blurRadius: 50,
            //   // offset: const Offset(0, 0), // changes position of shadow
            // ),
            // transitionBackgroundColor: Colors.white.withOpacity(.2),
            // useRootNavigator: true
            // enterBottomSheetDuration: const Duration(milliseconds: 180),
            // exitBottomSheetDuration: const Duration(milliseconds: 150),
            )
        .then((value) {
      return value;
    });
  }
}
