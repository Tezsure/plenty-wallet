import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/social_login_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/app/modules/create_wallet_page/controllers/create_wallet_page_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/accounts_widget/views/widget/add_new_account_sheet.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:web3auth_flutter/enums.dart';

class NoAccountsFoundBottomSheet extends StatelessWidget {
  NoAccountsFoundBottomSheet({Key? key}) : super(key: key);
  final controller = Get.put(CreateWalletPageController());

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "",
      // bottomSheetHorizontalPadding: 0
      height: AppConstant.naanBottomSheetChildHeight,
      bottomSheetWidgets: [
        SizedBox(
          height: AppConstant.naanBottomSheetChildHeight - .08.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Spacer(),
              Expanded(
                flex: 5,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "${PathConst.EMPTY_STATES}no_accounts.svg",
                        height: 175.arP,
                        width: 175.arP,
                      ),
                      0.05.vspace,
                      Text(
                        "No wallets found".tr,
                        textAlign: TextAlign.center,
                        style: titleLarge,
                      ),
                      0.016.vspace,
                      Text(
                        "Create or import new wallet to proceed".tr,
                        textAlign: TextAlign.center,
                        style: bodySmall.copyWith(
                          color: const Color(0xFF958E99),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              SolidButton(
                width: 1.width - 64.arP,
                title: "Create a new wallet",
                titleStyle: titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () {
                  Get.back();
                  CommonFunctions.bottomSheet(AddNewAccountBottomSheet(),
                          fullscreen: true)
                      .whenComplete(() {
                    Get.find<AccountsWidgetController>().resetCreateNewWallet();
                  });
                },
              ),
              0.016.vspace,
              SolidButton(
                width: 1.width - 64.arP,
                borderWidth: 1.5,
                borderColor: ColorConst.Neutral.shade80,
                textColor: ColorConst.Neutral.shade80,
                primaryColor: Colors.transparent,
                onPressed: () {
                  Get.back();

                  Get.toNamed(Routes.IMPORT_WALLET_PAGE);
                },
                title: "I already have a wallet",
              ),
              0.035.vspace,
              _buildDivider(),
              0.035.vspace,
              _builsSocialLogins(),
              BottomButtonPadding()
            ],
          ),
        ),
      ],
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
              "Or create wallet with".tr,
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

  Padding _builsSocialLogins() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.arP,
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
}
