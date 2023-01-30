import 'dart:io';

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
}
