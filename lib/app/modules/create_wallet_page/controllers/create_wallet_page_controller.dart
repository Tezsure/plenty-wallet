import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/web3auth_services/web3auth.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3auth_flutter/enums.dart';

class CreateWalletPageController extends GetxController {
  @override
  void onInit() {
    Web3Auth.initPlatformState();
    super.onInit();
  }

  login({required Provider socialAppName}) {
    CommonFunctions.bottomSheet(
      NaanBottomSheet(
        height: 380.arP,
        bottomSheetHorizontalPadding: 32.arP,
        bottomSheetWidgets: [
          0.04.vspace,
          Align(
            alignment: Alignment.center,
            child: LottieBuilder.asset(
              '${PathConst.SEND_PAGE}lottie/failed.json',
              height: 68,
              width: 68,
              repeat: false,
            ),
          ),
          0.02.vspace,
          Align(
            alignment: Alignment.center,
            child: Text(
              'Temporary Maintenance',
              style: titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          0.01.vspace,
          Align(
            alignment: Alignment.center,
            child: Text(
              'We apologize for the inconvenience, but the social login feature is currently undergoing maintenance and will not be functional for the next few days. \n\nIt will be available again in our upcoming update. If you have any questions or need assistance, please feel free to connect with the Naan team on Discord at',
              textAlign: TextAlign.center,
              style:
                  labelSmall.copyWith(color: ColorConst.NeutralVariant.shade70),
            ),
          ),
          0.01.vspace,
          BouncingWidget(
            onPressed: () {
              launchUrl(Uri.parse('https://discord.gg/wpcNRsBbxy'));
            },
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'https://discord.gg/wpcNRsBbxy',
                textAlign: TextAlign.center,
                style: labelSmall.copyWith(
                    color: ColorConst.Primary,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
          0.03.vspace,
          SolidButton(
            title: 'Done',
            textColor: Colors.white,
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
    //return Web3Auth.login(socialAppName: socialAppName);
  }
}
