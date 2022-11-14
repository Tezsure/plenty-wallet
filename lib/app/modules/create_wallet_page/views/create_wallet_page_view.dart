import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
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
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
      ),
      child: Container(
        color: Colors.black,
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
                      const Color(0xffD9D9D9),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ).createShader(bounds);
                },
                child: SvgPicture.asset(
                  "${PathConst.SVG}create_wallet_background.svg",
                  fit: BoxFit.contain,
                  height: 400.sp,
                  width: 340.sp,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.08.width),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    0.046.vspace,
                    SolidButton(
                      height: 50.sp,
                      width: 326.sp,
                      title: "Create a new account",
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
                    ),
                    0.0125.vspace,
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.IMPORT_WALLET_PAGE);
                      },
                      child: Container(
                        height: 48.sp,
                        width: 326.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.sp),
                          border: Border.all(
                            color: ColorConst.Neutral.shade80,
                            width: 1.50,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text("I already have an account",
                            style: titleSmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorConst.Neutral.shade80)),
                      ),
                    ),
                    0.025.vspace,
                  ],
                ),
              ),
              SizedBox(
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
                        "Or login with",
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
              ),
              0.03.vspace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SocialLoginButton(
                        onTap: controller.login(socialAppName: Provider.apple),
                        socialIconPath: "apple.svg"),
                    SocialLoginButton(
                        onTap: controller.login(socialAppName: Provider.google),
                        socialIconPath: "google.svg"),
                    SocialLoginButton(
                        onTap:
                            controller.login(socialAppName: Provider.facebook),
                        socialIconPath: "facebook.svg"),
                    SocialLoginButton(
                        onTap:
                            controller.login(socialAppName: Provider.twitter),
                        socialIconPath: "twitter.svg"),
                  ],
                ),
              ),
              0.02.vspace,
              GestureDetector(
                onTap: () => Get.offAndToNamed(Routes.HOME_PAGE),
                child: Container(
                  height: 48.sp,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    "Not now",
                    style: titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                ),
              ),
              0.025.vspace,
            ],
          ),
        ),
      ),
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
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 0.07.width,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(
          "${PathConst.SVG}$socialIconPath",
          fit: BoxFit.contain,
          height: 48.sp,
          width: 48.sp,
        ),
      ),
    );
  }
}
