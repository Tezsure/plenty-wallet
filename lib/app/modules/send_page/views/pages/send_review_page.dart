import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../widgets/token_selector.dart';
import '../widgets/token_view.dart';

class SendReviewPage extends StatelessWidget {
  final SendPageController controller;
  const SendReviewPage({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.8.height,
      width: 1.width,
      decoration: const BoxDecoration(color: Colors.black),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
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
                      onTap: () {
                        controller.selectedPageIndex.value = 1;
                        controller.amountFocusNode.value.unfocus();
                      },
                      controller: controller,
                    ),
                  ),
                ),
                controller.isNFTPage.value ? 0.02.vspace : 0.05.vspace,
                if (!controller.isNFTPage.value) ...[
                  const TokenView(),
                ] else ...[
                  0.07.vspace,
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://assets.objkt.media/file/assets-003/${controller.selectedNftModel!.faContract}/${controller.selectedNftModel!.tokenId.toString()}/thumb400",
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  0.03.vspace,
                ],
                0.04.vspace,
                Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () {
                      var isEnterAmountEnable =
                          controller.amountText.value.isNotEmpty &&
                              !controller.amountTileError.value &&
                              !controller.amountUsdTileError.value;
                      return SolidButton(
                        height: 0.05.height,
                        width: 0.8.width,
                        onPressed: () =>
                            controller.amountText.value.isNotEmpty ||
                                    controller.isNFTPage.value
                                ? Get.bottomSheet(
                                    TransactionBottomSheet(
                                      controller: controller,
                                    ),
                                  )
                                : null,
                        primaryColor: controller.isNFTPage.value
                            ? ColorConst.Primary
                            : isEnterAmountEnable
                                ? ColorConst.Primary
                                : ColorConst.NeutralVariant.shade60
                                    .withOpacity(0.2),
                        textColor: controller.isNFTPage.value
                            ? Colors.white
                            : isEnterAmountEnable
                                ? Colors.white
                                : ColorConst.NeutralVariant.shade60,
                        title:
                            !controller.isNFTPage.value && !isEnterAmountEnable
                                ? 'Enter an amount'
                                : 'Review',
                      );
                    },
                  ),
                ),
                0.02.vspace,
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
        ),
      ),
    );
  }
}
