import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/text_scale_factor.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:web3auth_flutter/enums.dart';
import '../controllers/create_wallet_page_controller.dart';

class CreateWalletPageView extends GetView<CreateWalletPageController> {
  const CreateWalletPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OverrideTextScaleFactor(
      child: CupertinoPageScaffold(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AnnotatedRegion(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.black,
            ),
            child: Container(
              color: Colors.transparent,
              width: 1.width,
              height: 1.height,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [
                            const Color(0xffD9D9D9).withOpacity(0),
                            const Color(0xffD9D9D9).withOpacity(0.08),
                            const Color(0xffD9D9D9).withOpacity(0.4),
                            const Color(0xffD9D9D9).withOpacity(0.9),
                          ],
                          begin: Alignment.bottomCenter,
                          end: const Alignment(0, 0.2),
                        ).createShader(bounds);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.arP),
                        child: Container(
                          margin: EdgeInsets.only(top: 25.arP),
                          child: SvgPicture.asset(
                            "${PathConst.SVG}create_wallet_background.svg",
                            height: 0.4.height,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.08.width),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   "Welcome to Naan Wallet",
                          //   style: titleLarge,
                          // ),
                          // 0.01.vspace,
                          // Text(
                          //   "Naan is a fun, simple, and secure way to create a Tezos wallet, collect NFTs, and explore the new world of Web3 on Tezos.",
                          //   style: bodySmall.apply(
                          //     color: ColorConst.NeutralVariant.shade60,
                          //   ),
                          // ),
                          0.046.vspace,
                          _buildCreateAccountButton(),

                          0.0125.vspace,
                          _buildImportAccountButton(),
                          0.025.vspace,
                        ],
                      ),
                    ),
                    _buildDivider(),
                    0.035.vspace,
                    _builsSocialLogins(),
                    0.018.vspace,
                    BouncingWidget(
                      onPressed: () {
                        NaanAnalytics.logEvent(
                          NaanAnalyticsEvents.SKIP_LOGIN,
                        );
                        Get.offAndToNamed(Routes.HOME_PAGE);
                      },
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          "Not now".tr,
                          style: titleSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConst.NeutralVariant.shade60),
                        ),
                      ),
                    ),
                    0.023.vspace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildDivider() {
    return SizedBox(
      width: 1.width,
      child: Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 1,
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.4),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Or login with".tr,
              style: bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorConst.NeutralVariant.shade60,
              ),
            ),
          ),
          Expanded(
              child: Divider(
            thickness: 1,
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.4),
          )),
        ],
      ),
    );
  }

  SolidButton _buildCreateAccountButton() {
    return SolidButton(
      width: 1.width - 64.arP,
      title: "Create a new wallet",
      titleStyle: titleSmall.copyWith(
        fontWeight: FontWeight.w600,
      ),
      onPressed: () {
        // arguments true is define for setting a new passcode for wallet
        Get.toNamed(
          Routes.PASSCODE_PAGE,
          arguments: [
            false,
            Routes.BIOMETRIC_PAGE,
          ],
        );
      },
    );
  }

  Padding _builsSocialLogins() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.arP,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (Platform.isIOS)
            SocialLoginButton(
              onTap: controller.login(socialAppName: Provider.apple),
              socialIconPath: "apple.svg",
            ),
          SocialLoginButton(
            onTap: controller.login(socialAppName: Provider.google),
            socialIconPath: "google.svg",
          ),
          SocialLoginButton(
            onTap: controller.login(socialAppName: Provider.facebook),
            socialIconPath: "facebook.svg",
          ),
          SocialLoginButton(
            onTap: controller.login(socialAppName: Provider.twitter),
            socialIconPath: "twitter.svg",
          ),
        ],
      ),
    );
  }

  Widget _buildImportAccountButton() {
    return SolidButton(
      primaryColor: Colors.transparent,
      onPressed: () {
        Get.toNamed(Routes.IMPORT_WALLET_PAGE);
      },
      title: "I already have a wallet",
      borderColor: ColorConst.Secondary.shade70,
      textColor: ColorConst.Secondary.shade70,
    );
  }
}

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
        radius: 1.width / 18,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset("${PathConst.SVG}$socialIconPath"),
      ),
    );
  }
}
