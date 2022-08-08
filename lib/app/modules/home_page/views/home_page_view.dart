import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_value_widget/account_value_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_app_bar_widget/home_app_bar_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/liquidity_baking_widget/liquidity_baking_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/my_nfts_widget/my_nfts_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/public_nft_gallery/public_nft_gallery_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/register_widgets.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/tezos_price/tezos_price_widget.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../controllers/home_page_controller.dart';

class HomePageView extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.width,
        color: ColorConst.Primary,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
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
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(8))),
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
        ),
        // child: SingleChildScrollView(
        //   physics: const AlwaysScrollableScrollPhysics(),
        //   child: Stack(
        //     children: [
        //       //background gradient color
        //       Positioned(
        //         top: 0,
        //         bottom: 0,
        //         left: 0,
        //         right: 0,
        //         child: Container(
        //           decoration: BoxDecoration(
        //             gradient: background,
        //           ),
        //         ),
        //       ),
        //       Column(
        //         children: [
        //           (MediaQuery.of(context).padding.top + 20)
        //               .vspace, //notification bar padding + 20

        //           appBar(),

        //           32.vspace, //header spacing

        //           Padding(
        //             padding: const EdgeInsets.only(left: 24.0, right: 24),
        //             child: Wrap(
        //               runSpacing: 28,
        //               spacing: 20,
        //               children: registeredWidgets,
        //             ),
        //           ),
        //           28.vspace,
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  /// App Bar for Home Page
  Widget appBar() => Container(
        height: 34,
        padding: const EdgeInsets.symmetric(
            horizontal:
                35), // 24 + 11 = 35.24 is Foundation padding and 11 is internal widget padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/home_page/scanner.png",
              height: 25,
            ),
            Container(
              height: 34,
              width: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
}
