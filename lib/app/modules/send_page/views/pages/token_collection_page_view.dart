import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/token_model.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/collectible_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class TokenAndNftPageView extends GetView<SendPageController> {
  const TokenAndNftPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.8.height,
      width: 1.width,
      decoration: const BoxDecoration(gradient: GradConst.GradientBackground),
      padding: EdgeInsets.symmetric(horizontal: 0.035.width),
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView(
                children: <Widget>[
                      Text(
                        'Tokens',
                        style: labelSmall.apply(
                            color: ColorConst.NeutralVariant.shade60),
                      ),
                      0.008.vspace
                    ] +
                    List.generate(
                      controller.tokens.length < 3
                          ? controller.tokens.length
                          : (controller.isTokensExpanded.value
                              ? controller.tokens.length
                              : 3),
                      (index) => tokenWidget(controller.tokens[index], () {
                        controller
                          ..onTokenClick()
                          ..setSelectedPageIndex(
                              index: 2, isKeyboardRequested: true);
                      }),
                    ) +
                    [
                      const SizedBox(
                        height: 16,
                      ),
                      if (controller.tokens.length > 3)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: tokenExpandButton(),
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Collectibles',
                        style: labelSmall.apply(
                            color: ColorConst.NeutralVariant.shade60),
                      ),
                      0.008.vspace
                    ] +
                    List.generate(
                      controller.collectibles.length < 3
                          ? controller.collectibles.length
                          : (controller.isCollectibleExpanded.value
                              ? controller.collectibles.length
                              : 3),
                      (index) => CollectibleWidget(
                        widgetIndex: index,
                        collectibleModel: controller.collectibles[index],
                      ),
                    ) +
                    [
                      const SizedBox(
                        height: 8,
                      ),
                      if (controller.collectibles.length > 3)
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
          color: ColorConst.NeutralVariant.shade30,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              controller.isTokensExpanded.value ? 'Less' : 'All',
              style: labelSmall,
            ),
            Icon(
              controller.isTokensExpanded.value
                  ? Icons.keyboard_arrow_up
                  : Icons.arrow_forward_ios,
              color: Colors.white,
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
          color: ColorConst.NeutralVariant.shade30,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              controller.isCollectibleExpanded.value ? 'Less' : 'All',
              style: labelSmall,
            ),
            Icon(
              controller.isCollectibleExpanded.value
                  ? Icons.keyboard_arrow_up
                  : Icons.arrow_forward_ios,
              color: Colors.white,
              size: 10,
            )
          ],
        ),
      ),
    );
  }

  Padding tokenWidget(
    TokenModel tokenModel,
    GestureTapCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        height: 0.06.height,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          trailing: Container(
            height: 0.03.height,
            width: 0.14.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            child: Text(
              "\$${tokenModel.balance}",
              style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
            ),
          ),
          leading: CircleAvatar(
            radius: 22,
            backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            child: SvgPicture.asset(
              tokenModel.imagePath,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(
            tokenModel.tokenName,
            style: labelSmall,
          ),
          subtitle: Text(
            "${tokenModel.price}",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
