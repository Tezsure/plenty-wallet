import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommonFunctions {
  static void launchURL(String url) async => await canLaunchUrl(Uri.parse(url))
      ? await launchUrlString(url,
          mode: LaunchMode.externalNonBrowserApplication)
      : url.contains("mailto:naan-support@tezsure.com")
          ? launchUrlString(url)
          : throw 'Could not launch $url';
}
