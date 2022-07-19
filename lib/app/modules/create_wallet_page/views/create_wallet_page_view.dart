import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/routes/app_pages.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naan_wallet/utils/material_Tap.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import '../controllers/create_wallet_page_controller.dart';

class CreateWalletPageView extends GetView<CreateWalletPageController> {
  const CreateWalletPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: GradConst.GradientBackground),
      width: 1.width,
      height: 1.height,
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                  Color(0xffD9D9D9).withOpacity(0),
                  Color(0xffD9D9D9),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ).createShader(bounds);
            },
            child: SvgPicture.asset(
                PathConst.SVG + "create_wallet_background.svg"),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to Naan Wallet",
                        style: titleLarge,
                      ),
                      12.h.vspace,
                      Text(
                        "Naan is a fun, simple, and secure way to create a Tezos wallet, collect NFTs, and explore the new world of Web3 on Tezos.",
                        style: bodySmall.apply(
                          color: Color(0XFF958E99),
                        ),
                      ),
                      ((28 / 844) * 1.height).h.vspace,
                      SolidButton(
                          title: "Create new wallet",
                          onPressed: () {
                            Get.toNamed(Routes.BIOMETRIC_PAGE);
                          }),
                      12.h.vspace,
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.PASSCODE_PAGE);
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorConst.Neutral.shade80,
                              width: 1.50,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text("I already have a wallet",
                              style: titleSmall.apply(
                                  color: ColorConst.Neutral.shade80)),
                        ),
                      ),
                      20.h.vspace,
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
                        color: Color(0xff958E99).withOpacity(0.4),
                      )),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Or Login with",
                          style: bodySmall.apply(
                            color: Color(0xff958E99),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1,
                        color: Color(0xff958E99).withOpacity(0.4),
                      )),
                    ],
                  ),
                ),
                28.h.vspace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(PathConst.SVG + "apple.svg"),
                      SvgPicture.asset(PathConst.SVG + "google.svg"),
                      SvgPicture.asset(PathConst.SVG + "facebook.svg"),
                      SvgPicture.asset(PathConst.SVG + "twitter.svg"),
                    ],
                  ),
                ),
                12.h.vspace,
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.IMPORT_WALLET_PAGE);
                  },
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "Not now",
                      style: titleSmall.apply(
                          color: ColorConst.NeutralVariant.shade60),
                    ),
                  ),
                ),
                15.vspace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
