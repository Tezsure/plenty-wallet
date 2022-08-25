import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../controllers/send_token_page_controller.dart';
import 'widgets/token_textfield.dart';
import 'widgets/transaction_status.dart';

class SendTokenPageView extends GetView<SendTokenPageController> {
  const SendTokenPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
      child: SafeArea(
        child: SendTokenPage(
          controller: controller,
          totalTez: '3.23',
          showNFTPage: true,
          receiverName: 'Bernd.tez',
          nftImageUrl: 'assets/temp/nft_thumbnail.png',
        ),
      ),
    ));
  }
}

// SendTokenPage(
//           controller: controller,
//           totalTez: '3.23',
//           showNFTPage: true,
//           receiverName: 'Bernd.tez',
//           nftImageUrl: 'assets/temp/nft_thumbnail.png',
//         ),

/// To show the send token page or send nft page depending on the condition.
///
/// [showNFTPage] - Whether to show the NFT page or the send token page, default value is false
///
/// [totalTez] - The total amount of tez user have, by default it's 0.0
///
/// [showNFTPage] - if true, [nftImageUrl] must be provided, by default it's null
///
/// [receiverName] is a required paramenter & can't be null
class SendTokenPage extends StatelessWidget {
  final SendTokenPageController controller;
  final String totalTez;
  final bool showNFTPage;
  final String? receiverName;
  final Function()? onTapSave;
  final String? nftImageUrl;
  const SendTokenPage({
    Key? key,
    required this.controller,
    this.totalTez = '0.0',
    this.showNFTPage = false,
    required this.receiverName,
    this.onTapSave,
    this.nftImageUrl,
  })  : assert(receiverName != null),
        assert(showNFTPage == true ? nftImageUrl != null : true),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          leading: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'To  ',
              style: bodyMedium.copyWith(
                  fontSize: 12.sp, color: ColorConst.NeutralVariant.shade60),
              children: <TextSpan>[
                TextSpan(
                  text: receiverName,
                  style: bodyMedium.copyWith(
                      fontSize: 12.sp, color: ColorConst.Primary.shade60),
                ),
              ],
            ),
          ),
          trailing: GestureDetector(
            onTap: onTapSave,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.person_add_alt_outlined,
                      color: ColorConst.Primary.shade60,
                      size: 16,
                    ),
                  ),
                  TextSpan(
                    text: ' Save',
                    style: bodyMedium.copyWith(
                        fontSize: 12.sp, color: ColorConst.Primary.shade60),
                  )
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              dense: true,
              leading: showNFTPage
                  ? Image.asset(
                      nftImageUrl ?? 'assets/temp/nft_thumbnail.png',
                    )
                  : SvgPicture.asset('assets/svg/tez.svg'),
              title: Text(
                showNFTPage ? 'Unstable #5' : 'Tezos',
                style: bodySmall.copyWith(color: ColorConst.Primary.shade60),
              ),
              subtitle: Text(
                  showNFTPage ? 'Unstable dreams' : '$totalTez available',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60)),
              trailing: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorConst.Neutral.shade80.withOpacity(0.2)),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorConst.Primary.shade60,
                  size: 12,
                ),
              ),
            ),
          ),
        ),
        0.05.vspace,
        if (!showNFTPage) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Material(
              borderRadius: BorderRadius.circular(8),
              color: ColorConst.Neutral.shade10.withOpacity(0.6),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: ColorConst.Neutral.shade70),
                    borderRadius: BorderRadius.circular(8)),
                dense: true,
                leading: SizedBox(
                  width: 0.3.width,
                  child: TokenSendTextfield(
                    focusNode: controller.recipientFocusNode,
                    hintText: '0.00',
                    controller: controller.recipientController,
                    onChanged: (val) => controller.amount.value = val,
                  ),
                ),
                trailing: SizedBox(
                  width: 0.4.width,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 24,
                            width: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: ColorConst.Neutral.shade80
                                    .withOpacity(0.2)),
                            child: Center(
                              child: Text('Max',
                                  style: labelSmall.copyWith(
                                      color: ColorConst.Primary.shade60)),
                            ),
                          ),
                        ),
                        0.02.hspace,
                        Text(
                          'XTZ',
                          style: labelLarge.copyWith(
                              color: ColorConst.Neutral.shade70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          0.008.vspace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Material(
              borderRadius: BorderRadius.circular(8),
              color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  dense: true,
                  leading: SizedBox(
                    width: 0.3.width,
                    child: Obx(
                      () => TokenSendTextfield(
                        onChanged: (val) => controller.amount.value = val,
                        hintText: controller.amount.value.isNumericOnly &&
                                controller.amount.value.isNotEmpty
                            ? '3.42'
                            : '0.00',
                        hintStyle: headlineMedium.copyWith(
                            color: controller.amount.value.isNumericOnly &&
                                    controller.amount.value.isNotEmpty
                                ? ColorConst.NeutralVariant.shade60
                                : ColorConst.NeutralVariant.shade30),
                      ),
                    ),
                  ),
                  trailing: Text(
                    'USD',
                    style: labelLarge.copyWith(
                        color: ColorConst.NeutralVariant.shade60),
                  )),
            ),
          ),
        ] else ...[
          0.1.vspace,
          Center(
            child: Image.asset(
              'assets/temp/nft_preview.png',
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
          0.06.vspace,
        ],
        0.06.vspace,
        Align(
          alignment: Alignment.center,
          child: Obx(() => SolidButton(
                height: 0.05.height,
                width: 0.8.width,
                onPressed: () => controller.amount.value.isNumericOnly &&
                            controller.amount.value.isNotEmpty ||
                        showNFTPage
                    ? Get.bottomSheet(
                        NaanBottomSheet(
                          blurRadius: showNFTPage ? 50 : 5,
                          width: 1.width,
                          height: 0.5.height,
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
                                style: bodyMedium.copyWith(
                                    color: ColorConst.Primary.shade70),
                              ),
                              trailing: showNFTPage
                                  ? Image.asset(
                                      'assets/temp/nft_send.png',
                                      fit: BoxFit.cover,
                                    )
                                  : SvgPicture.asset('assets/svg/tez.svg'),
                            ),
                            ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                leading: Container(
                                  height: 24,
                                  width: 36,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: ColorConst.NeutralVariant.shade60
                                          .withOpacity(0.2)),
                                  child: Center(
                                    child: Text(
                                      'to',
                                      style: labelSmall.copyWith(
                                          color: ColorConst
                                              .NeutralVariant.shade60),
                                    ),
                                  ),
                                ),
                                trailing: SvgPicture.asset(
                                    'assets/svg/chevron_down.svg')),
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
                                        style: bodyMedium.copyWith(
                                            color: ColorConst.Primary.shade70),
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
                                trailing:
                                    SvgPicture.asset('assets/svg/send.svg')),
                            0.02.vspace,
                            Align(
                              alignment: Alignment.center,
                              child: SolidButton(
                                title: 'Hold to Send',
                                width: 0.75.width,
                                onPressed: () {
                                  Get.back();
                                  Get.bottomSheet(NaanBottomSheet(
                                    height: 0.35.height,
                                    bottomSheetWidgets: [
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
                                              color: ColorConst
                                                  .NeutralVariant.shade70),
                                        ),
                                      ),
                                      0.02.vspace,
                                      SolidButton(
                                          title: 'Got it',
                                          onPressed: () {
                                            Get
                                              ..back()
                                              ..back();
                                            transactionStatusSnackbar(
                                                status:
                                                    TransactionStatus.success,
                                                tezAddress:
                                                    'tz1KpKTX1........DZ',
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
                        ),
                      )
                    : null,
                primaryColor: controller.amount.value.isEmpty && !showNFTPage
                    ? ColorConst.NeutralVariant.shade60.withOpacity(0.2)
                    : ColorConst.Primary,
                textColor: controller.amount.value.isEmpty && !showNFTPage
                    ? ColorConst.NeutralVariant.shade60
                    : Colors.white,
                title: controller.amount.value.isEmpty && !showNFTPage
                    ? 'Enter an amount'
                    : 'Review',
              )),
        ),
        0.032.vspace,
        Padding(
          padding: EdgeInsets.all(12.sp),
          child: RichText(
              text: TextSpan(
                  text: 'Estimated Fees\n',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                  children: [
                TextSpan(text: '\$0.00181', style: labelMedium),
              ])),
        ),
      ],
    );
  }
}
