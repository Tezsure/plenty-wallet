import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_token_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../widgets/token_selector.dart';
import '../widgets/token_view.dart';

/// To show the send token page or send nft page depending on the condition.
///
/// [showNFTPage] - Whether to show the NFT page or the send token page, default value is false
///
/// [totalTez] - The total amount of tez user have, by default it's 0.0
///
/// [showNFTPage] - if true, [nftImageUrl] must be provided, by default it's null
///
/// [receiverName] is a required paramenter & can't be null
class SendReviewPage extends StatelessWidget {
  final SendPageController controller;
  final String totalTez;
  final bool showNFTPage;
  final String? receiverName;
  final Function()? onTapSave;
  final String? nftImageUrl;
  const SendReviewPage({
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
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Material(
                borderRadius: BorderRadius.circular(8),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                child: TokenSelector(
                    showNFTPage: showNFTPage,
                    nftImageUrl: nftImageUrl,
                    totalTez: totalTez),
              ),
            ),
            0.05.vspace,
            if (!showNFTPage) ...[
              TokenView(
                sendPageController: controller,
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
              0.01.vspace,
            ],
            0.06.vspace,
            Align(
              alignment: Alignment.center,
              child: Obx(
                () => SolidButton(
                  height: 0.05.height,
                  width: 0.8.width,
                  onPressed: () => controller.amount.value.isNumericOnly &&
                              controller.amount.value.isNotEmpty ||
                          showNFTPage
                      ? Get.bottomSheet(
                          TransactionBottomSheet(showNFTPage: showNFTPage),
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
                ),
              ),
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
                    ]),
              ),
            ),
          ]),
    );
  }
}
