import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../../utils/styles/styles.dart';
import 'account_selector.dart';

class ConfirmTransactionSheet extends StatelessWidget {
  ConfirmTransactionSheet({super.key});

  final controller = Get.find<HomePageController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: false ? 0.5.height : 0.6.height,
      width: 1.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        gradient: GradConst.GradientBackground,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.04.width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            0.01.vspace,
            Center(
              child: Container(
                height: 5,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                ),
              ),
            ),
            0.04.vspace,
            Center(
              child: Image.asset(
                'assets/temp/objkt.png',
                fit: BoxFit.contain,
                scale: 1,
              ),
            ),
            0.02.vspace,
            Center(
              child: Text(
                'OBJKT',
                style: titleLarge,
              ),
            ),
            0.006.vspace,
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: false
                      ? 'wants to connect to\n your wallet\n'
                      : 'Payload Signing Request\n',
                  style: titleMedium.copyWith(
                    color: ColorConst.NeutralVariant.shade60,
                  ),
                  children: false
                      ? [
                          WidgetSpan(child: 0.04.vspace),
                          TextSpan(
                            text: 'objkt.com',
                            style:
                                labelLarge.copyWith(color: ColorConst.Primary),
                          ),
                          WidgetSpan(child: 0.04.vspace),
                        ]
                      : null,
                ),
              ),
            ),
            if (true) ...[
              Text(
                'Message',
                style: labelSmall.copyWith(
                    color: ColorConst.NeutralVariant.shade60),
              ),
              0.01.vspace,
              Container(
                height: 0.1.height,
                width: 1.width,
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  border: Border.all(
                    color: ColorConst.NeutralVariant.shade60,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Tezos Signed Message: Confirming my identity as tz1Wc8ZYVcmJK3Zkmi7AErsHjFiCdA5zP1WK on objkt.com, sig:erZD81oBe2sfsMdxvt418BB0GuXS_T5',
                    textAlign: TextAlign.start,
                    style: bodySmall,
                  ),
                ),
              ),
            ],
            0.02.vspace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SolidButton(
                  height: 0.05.height,
                  width: 0.45.width,
                  borderColor: ColorConst.Neutral.shade80,
                  primaryColor: Colors.transparent,
                  borderWidth: 1,
                  title: 'Cancel',
                  onPressed: () {},
                ),
                SolidButton(
                  height: 0.05.height,
                  width: 0.45.width,
                  title: false ? 'Connect' : 'Confirm',
                  onPressed: () {},
                )
              ],
            ),
            0.01.vspace,
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Wallet\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade60),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: SizedBox(
                            child: Padding(
                              padding: EdgeInsets.only(top: 0.01.height),
                              child: GestureDetector(
                                onTap: () => Get.bottomSheet(
                                  AccountSelectorSheet(
                                      selectedAccount:
                                          controller.userAccounts[0],
                                      accounts: controller.userAccounts),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      ServiceConfig.allAssetsProfileImages[0],
                                      fit: BoxFit.contain,
                                      height: 25,
                                      width: 25,
                                    ),
                                    0.02.hspace,
                                    Text(
                                      'My Main Account',
                                      style: labelMedium,
                                    ),
                                    const SizedBox(width: 2),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  false
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: RichText(
                            text: TextSpan(
                              text: 'Balance\n',
                              style: labelSmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade60),
                              children: [
                                WidgetSpan(
                                    child: SizedBox(
                                  height: 0.02.height,
                                )),
                                TextSpan(text: '2370 tez', style: labelMedium)
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
