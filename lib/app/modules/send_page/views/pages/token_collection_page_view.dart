import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/collectible_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class TokenAndNftPageView extends GetView<SendPageController> {
  const TokenAndNftPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.8.height.arP,
      // decoration: const BoxDecoration(color: Colors.black),
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                      0.008.vspace,
                      Text(
                        'Tokens',
                        style: labelSmall.apply(
                            color: ColorConst.NeutralVariant.shade60),
                      ),
                      0.008.vspace
                    ] +
                    List.generate(
                      controller.userTokens.length < 3
                          ? controller.userTokens.length
                          : (controller.isTokensExpanded.value
                              ? controller.userTokens.length
                              : 3),
                      (index) => tokenWidget(controller.userTokens[index], () {
                        controller
                          ..onTokenClick(controller.userTokens[index])
                          ..setSelectedPageIndex(
                              index: 2, isKeyboardRequested: true);
                      }),
                    ) +
                    [
                      const SizedBox(
                        height: 16,
                      ),
                      if (controller.userTokens.length > 3)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: tokenExpandButton(),
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      controller.userNfts.isNotEmpty
                          ? Text(
                              'Collectibles',
                              style: labelSmall.apply(
                                  color: ColorConst.NeutralVariant.shade60),
                            )
                          : Container(),
                      0.008.vspace
                    ] +
                    List.generate(
                      controller.userNfts.length < 3
                          ? controller.userNfts.length
                          : (controller.isCollectibleExpanded.value
                              ? controller.userNfts.length
                              : 3),
                      (index) => CollectibleWidget(
                        widgetIndex: index,
                        collectionNfts: controller.userNfts[
                            controller.userNfts.keys.toList()[index]]!,
                      ),
                    ) +
                    [
                      const SizedBox(
                        height: 8,
                      ),
                      if (controller.userNfts.length > 3)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: collectibleExpandButton(),
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
              ),
            ),
          )
        ],
      ),
    );
  }

  GestureDetector tokenExpandButton() {
    return GestureDetector(
      onTap: () {
        controller.isTokensExpanded.value = !controller.isTokensExpanded.value;
      },
      child: Container(
        height: 24,
        width: controller.isTokensExpanded.value ? 55 : 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1E1C1F),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              controller.isTokensExpanded.value ? 'Less' : 'All',
              style: labelSmall.copyWith(color: const Color(0xFF958E99)),
            ),
            Icon(
              controller.isTokensExpanded.value
                  ? Icons.keyboard_arrow_up
                  : Icons.arrow_forward_ios,
              color: const Color(0xFF958E99),
              size: 10,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector collectibleExpandButton() {
    return GestureDetector(
      onTap: () {
        controller.isCollectibleExpanded.value =
            !controller.isCollectibleExpanded.value;
      },
      child: Container(
        height: 24,
        width: controller.isCollectibleExpanded.value ? 55 : 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1E1C1F),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              controller.isCollectibleExpanded.value ? 'Less' : 'All',
              style: labelSmall.copyWith(color: const Color(0xFF958E99)),
            ),
            AnimatedRotation(
              turns: controller.isCollectibleExpanded.value ? -0 / 25 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF958E99),
                size: 10,
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding tokenWidget(
    AccountTokenModel tokenModel,
    GestureTapCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 0.06.height,
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                child: tokenModel.iconUrl!.startsWith("assets")
                    ? Image.asset(
                        tokenModel.iconUrl!,
                        fit: BoxFit.cover,
                      )
                    : tokenModel.iconUrl!.endsWith(".svg")
                        ? SvgPicture.network(
                            tokenModel.iconUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(tokenModel
                                          .iconUrl!
                                          .startsWith("ipfs")
                                      ? "https://ipfs.io/ipfs/${tokenModel.iconUrl!.replaceAll("ipfs://", '')}"
                                      : tokenModel.iconUrl!)),
                            ),
                            // child: Image.network(
                            //   ,
                            //   fit: BoxFit.contain,
                            // ),
                          ),
              ),
              0.03.hspace,
              RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                      text: '${tokenModel.symbol}\n',
                      style: labelSmall,
                      children: [
                        TextSpan(
                          text: tokenModel.balance.toStringAsFixed(6),
                          style: labelSmall.apply(
                              color: ColorConst.NeutralVariant.shade60),
                        )
                      ])),
              const Spacer(),
              Container(
                height: 0.03.height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                child: Text(
                  r"$" +
                      (tokenModel.name == "Tezos"
                              ? controller.xtzPrice.value
                              : (tokenModel.currentPrice! *
                                  controller.xtzPrice.value))
                          .toStringAsFixed(6)
                          .removeTrailing0,
                  style: labelSmall.apply(
                      color: ColorConst.NeutralVariant.shade60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
