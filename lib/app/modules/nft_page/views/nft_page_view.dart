import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_app_bar.dart';
import 'package:naan_wallet/app/modules/nft_page/controllers/nft_page_controller.dart';
import 'package:naan_wallet/app/modules/nft_page/views/nft_detailed_page_view.dart';
import 'package:naan_wallet/mock/mock_data.dart';
import 'package:naan_wallet/models/nft_token_model.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

class NftPageView extends GetView<NftPageController> {
  /// list of nfts
  final List<NFTToken> listOfNFTTokens = MockData().listOfNFTTokens;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            height: 1.height,
            width: 1.width,
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NaanAppBar(
                    onBack: () => Get.back(),
                    pageName: "NFT Gallery",
                    backButtonName: "Home"),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 12,
                      // childAspectRatio: 0.72,
                      mainAxisExtent: 228,
                    ),
                    padding: EdgeInsets.only(top: 36),
                    itemCount: listOfNFTTokens.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => NftDetailed(listOfNFTTokens[index]));
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  listOfNFTTokens[index].displayUri!,
                                  fit: BoxFit.cover,
                                  height: (1.width / 2) - 24,
                                  width: (1.width / 2) - 24,
                                ),
                              ),
                              12.vspace,
                              Text(
                                listOfNFTTokens[index].name!,
                                style: body12,
                              ),
                              6.vspace,
                              Container(
                                height: 20,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    listOfNFTTokens[index].fa!.name!,
                                    style: body12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
