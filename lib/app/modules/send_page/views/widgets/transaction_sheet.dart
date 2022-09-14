import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import 'transaction_status.dart';

class TransactionBottomSheet extends StatelessWidget {
  const TransactionBottomSheet({
    super.key,
    required this.showNFTPage,
  });

  final bool showNFTPage;

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: showNFTPage ? 50 : 5,
      width: 1.width,
      height: 355.sp,
      title: 'Sending',
      titleAlignment: Alignment.center,
      titleStyle: titleMedium,
      bottomSheetHorizontalPadding: 10,
      bottomSheetWidgets: [
        ListTile(
          title: Text(
            showNFTPage ? 'Unstable #5' : '\$3.42',
            style: headlineSmall,
          ),
          subtitle: Text(
            showNFTPage ? 'Unstable dreams' : '1.23 XTZ',
            style: bodyMedium.copyWith(color: ColorConst.Primary.shade70),
          ),
          trailing: showNFTPage
              ? Image.asset(
                  'assets/temp/nft_send.png',
                  fit: BoxFit.cover,
                )
              : SvgPicture.asset('assets/svg/tez.svg'),
        ),
        ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            leading: Container(
              height: 24,
              width: 36,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
              child: Center(
                child: Text(
                  'to',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ),
              ),
            ),
            trailing: SvgPicture.asset('assets/svg/chevron_down.svg')),
        ListTile(
            title: Text(
              'Bernd.tez',
              style: headlineSmall,
            ),
            subtitle: SizedBox(
              width: 0.3.width,
              child: Row(
                children: [
                  Text(
                    'tz1K...pkDZ',
                    style:
                        bodyMedium.copyWith(color: ColorConst.Primary.shade70),
                  ),
                  0.02.hspace,
                  Icon(
                    Icons.copy,
                    color: ColorConst.Primary.shade60,
                    size: 10,
                  ),
                ],
              ),
            ),
            trailing: SvgPicture.asset('assets/svg/send.svg')),
        0.02.vspace,
        Align(
          alignment: Alignment.center,
          child: SolidButton(
            title: 'Hold to Send',
            width: 0.85.width,
            onPressed: () {
              Get.back();
              Get.bottomSheet(NaanBottomSheet(
                height: 380.sp,
                bottomSheetWidgets: [
                  0.04.vspace,
                  Align(
                    alignment: Alignment.center,
                    child: LottieBuilder.asset(
                      '${PathConst.SEND_PAGE}lottie/send_success.json',
                      height: 68,
                      width: 68,
                    ),
                  ),
                  0.02.vspace,
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Transaction is submitted',
                      style: titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  0.02.vspace,
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Your transaction should be confirmed in\nnext 30 seconds',
                      textAlign: TextAlign.center,
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade70),
                    ),
                  ),
                  0.02.vspace,
                  SolidButton(
                      elevation: 0,
                      borderWidth: 1,
                      primaryColor: Colors.transparent,
                      borderColor: ColorConst.Neutral.shade80,
                      textColor: ColorConst.Primary.shade80,
                      title: 'Got it',
                      onPressed: () {
                        Get
                          ..back()
                          ..back();
                        transactionStatusSnackbar(
                            status: TransactionStatus.success,
                            tezAddress: 'tz1KpKTX1........DZ',
                            transactionAmount: '1.0');
                      }),
                  0.02.vspace,
                  SolidButton(
                    title: 'Share Naan',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ));
            },
          ),
        )
      ],
    );
  }
}
