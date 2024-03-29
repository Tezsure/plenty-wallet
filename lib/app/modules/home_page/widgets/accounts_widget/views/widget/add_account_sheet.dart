import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/app/modules/create_wallet_page/controllers/create_wallet_page_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/accounts_widget/controllers/accounts_widget_controller.dart';
import 'package:plenty_wallet/app/routes/app_pages.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:web3auth_flutter/enums.dart';

import '../../../../../create_wallet_page/views/create_wallet_page_view.dart';
import 'add_new_account_sheet.dart';

class AddAccountSheet extends StatefulWidget {
  final String? warning;
  const AddAccountSheet({super.key, required this.warning});

  @override
  State<AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends State<AddAccountSheet> {
  final controller = Get.put(CreateWalletPageController());
  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      // bottomSheetHorizontalPadding: 0,
      height: 0.44.height,

      title: widget.warning ?? 'Add wallet',
      bottomSheetWidgets: [
        SizedBox(
          height: 12.arP,
        ),
        Center(
          child: Text(
            'Create or import a wallet'.tr,
            style: bodySmall.copyWith(
              color: const Color(0xFF958E99),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Spacer(),
        SizedBox(
          height: 24.arP,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.arP,
              ),
              SolidButton(
                width: 1.width - 64.arP,
                title: "Create a new wallet",
                titleStyle: titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () async {
                  Get.back();
                  bool passcode = await AuthService().getIsPassCodeSet();

                  if (!passcode) {
                    await Get.toNamed(Routes.PASSCODE_PAGE,
                        arguments: [false, Routes.ADD_NEW_WALLET]);
                  } else {
                    CommonFunctions.bottomSheet(AddNewAccountBottomSheet(),
                            fullscreen: true)
                        .whenComplete(() {
                      Get.find<AccountsWidgetController>()
                          .resetCreateNewWallet();
                    });
                  }
                },
              ),
              0.016.vspace,
              SolidButton(
                width: 1.width - 64.arP,
                borderWidth: 1.5,
                borderColor: ColorConst.Secondary,
                textColor: ColorConst.Secondary,
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
}
