import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_balance/account_balance_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_value_widget/account_value_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_app_bar_widget/home_app_bar_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/my_nfts_widget/my_nfts_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/tez_balance_widget/tez_balance_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/tezos_price/tezos_price_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/material_Tap.dart';
import '../../../../utils/styles/styles.dart';
import '../../../routes/app_pages.dart';
import '../../common_widgets/bottom_sheet.dart';
import '../../common_widgets/solid_button.dart';
import '../controllers/home_page_controller.dart';
import '../widgets/liquidity_baking_widget/liquidity_baking_widget.dart';
import '../widgets/public_nft_gallery/public_nft_gallery_widget.dart';
import '../widgets/register_widgets.dart';

class HomePageView extends GetView<HomePageController>
    with WidgetsBindingObserver {
  const HomePageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Get.arguments != null) {
        var showBottomSheet = Get.arguments[0] ?? false;
        showBottomSheet
            ? Get.bottomSheet(
                NaanBottomSheet(
                  gradientStartingOpacity: 1,
                  blurRadius: 5,
                  title: 'Backup Your Wallet',
                  bottomSheetWidgets: [
                    Text(
                      'With no backup. losing your device will result\nin the loss of access forever. The only way to\nguard against losses is to backup your wallet.',
                      textAlign: TextAlign.start,
                      style: bodySmall.copyWith(
                          color: ColorConst.NeutralVariant.shade60),
                    ),
                    30.vspace,
                    SolidButton(
                        textColor: ColorConst.Neutral.shade95,
                        title: "Backup Wallet ( ~1 min )",
                        onPressed: () => Get.toNamed(Routes.BACKUP_WALLET)),
                    12.vspace,
                    materialTap(
                      inkwellRadius: 8,
                      onPressed: () => Get.back(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: ColorConst.Neutral.shade80,
                            width: 1.50,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text("I will risk it",
                            style: titleSmall.apply(
                                color: ColorConst.Primary.shade80)),
                      ),
                    ),
                  ],
                ),
                enableDrag: true,
                isDismissible: true,
              )
            : Container();
      }
    });
    return Scaffold(
        body: Container(
            width: 1.width,
            color: ColorConst.Primary,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: const [
                      HomepageAppBar(),
                      AccountValueWidget(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 93),
                    child: SizedBox(
                      height: 1.height,
                      width: 1.width,
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.6,
                        maxChildSize: 1,
                        minChildSize: 0.6,
                        snap: true,
                        builder: (_, scrollController) => Container(
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8))),
                          child: Column(
                            children: [
                              0.005.vspace,
                              Container(
                                height: 5,
                                width: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ColorConst.NeutralVariant.shade60
                                      .withOpacity(0.3),
                                ),
                              ),
                              0.025.vspace,
                              Expanded(
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.04.width),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TezosPriceWidget(),
                                            MyNFTwidget()
                                          ],
                                        ),
                                      ),
                                      0.02.vspace,
                                      PublicNFTgalleryWidget(),
                                      0.02.vspace,
                                      LiquidityBakingWidget(),
                                    ],
                                  ),

                                  // child: Wrap(
                                  //   alignment: WrapAlignment.center,
                                  //   crossAxisAlignment:
                                  //       WrapCrossAlignment.center,
                                  //   runAlignment: WrapAlignment.center,
                                  //   runSpacing: 28,
                                  //   spacing: 20,
                                  //   children: registeredWidgets,
                                  // ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
