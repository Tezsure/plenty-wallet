import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/nft_page/views/nft_page_view.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class ActionButtonGroupWidget extends StatelessWidget {
  /// A widget that displays action buttons for send receive tokens, nft gallery and Dapps
  const ActionButtonGroupWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(
          minHeight: 148,
        ),
        height: 0.2.height,
        width: 1.width,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black.withOpacity(0.37),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: actionButtonWidget("assets/home_page/transfer.png",
                          "Send", () {}, appleBlue)),
                  8.hspace,
                  Expanded(
                      child: actionButtonWidget("assets/home_page/receive.png",
                          "Receive", () {}, appleOrange))
                ],
              ),
            ),
            8.vspace,
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: actionButtonWidget(
                        "assets/home_page/nft.png", "NFT Gallery", () {
                      Get.to(() => NftPageView());
                    }, applePurple),
                  ),
                  8.hspace,
                  Expanded(
                    child: actionButtonWidget("assets/home_page/activity.png",
                        "Dapp", () {}, appleGreen),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget actionButtonWidget(
          String asset, String text, Function onTap, Gradient gradient) =>
      GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: gradient,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                asset,
                height: 24,
              ),
              8.vspace,
              Text(
                text,
                style: body12,
              ),
            ],
          ),
        ),
      );
}
