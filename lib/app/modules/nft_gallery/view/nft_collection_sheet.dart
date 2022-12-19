import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/nft_gallery/view/nft_detail_sheet.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/utils.dart';

class NFTCollectionSheet extends StatelessWidget {
  final List<NftTokenModel> nfts;
  const NFTCollectionSheet({super.key, this.nfts = const []});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      bottomSheetHorizontalPadding: 0,
      height: .9.height,
      bottomSheetWidgets: [
        _getNftListViewWidget(),
      ],
    );
  }

  Widget _getNftListViewWidget([
    double crossAxisCount = 2.1,
  ]) =>
      Container(
          height: .8724.height,
          margin: EdgeInsets.symmetric(
            horizontal: 16.arP,
          ),
          child: Column(
            children: [
              _getCollectionDetailsRow(
                nfts.first,
                nfts.toList().length,
              ),
              SizedBox(
                height: 15.arP,
              ),
              Expanded(
                child: MasonryGridView.count(
                    crossAxisCount: (Get.width > 768
                            ? crossAxisCount == 1.1
                                ? 2
                                : 3
                            : crossAxisCount == 2.1 && nfts.toList().length == 1
                                ? 1
                                : crossAxisCount == 1.1
                                    ? 1
                                    : 2)
                        .toInt(),
                    mainAxisSpacing: 12.arP,
                    crossAxisSpacing: 12.arP,
                    itemCount: nfts.toList().length,
                    itemBuilder: ((context, i) {
                      var nftTokenModel = nfts[i];
                      return GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            NFTDetailBottomSheet(
                              onBackTap: Get.back,
                              nftModel: nftTokenModel,
                            ),
                            enterBottomSheetDuration:
                                const Duration(milliseconds: 180),
                            exitBottomSheetDuration:
                                const Duration(milliseconds: 150),
                            isScrollControlled: true,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          // constraints: const BoxConstraints(minHeight: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFF958E99).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              12.arP,
                            ),
                          ),
                          padding: EdgeInsets.all(
                            12.arP,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    8.arP,
                                  ),
                                  child: Image.network(
                                    "https://assets.objkt.media/file/assets-003/${nftTokenModel.faContract}/${nftTokenModel.tokenId.toString()}/thumb${crossAxisCount == 1.1 ? 400 : 288}",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12.arP,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  nftTokenModel.name ??
                                      nftTokenModel.fa?.name ??
                                      "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.arP,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5.arP,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4.arP,
                              ),
                              // created by text
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  nftTokenModel.creators!.isEmpty
                                      ? "N/A"
                                      : nftTokenModel
                                              .creators![0].holder!.alias ??
                                          nftTokenModel
                                              .creators![0].holder!.address!
                                              .tz1Short(),
                                  style: TextStyle(
                                    color: const Color(0xFF958E99),
                                    fontSize: 10.arP,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5.arP,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
              ),
            ],
          ));

  Widget _getCollectionDetailsRow(NftTokenModel nftTokenModel, length) {
    var logo = nftTokenModel.fa!.logo!;
    if (logo.startsWith("ipfs://")) {
      logo = "https://ipfs.io/ipfs/${logo.replaceAll("ipfs://", "")}";
    }
    return Row(
      children: [
        Expanded(
            child: Align(alignment: Alignment.centerLeft, child: backButton())),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 32.arP,
                height: 32.arP,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(logo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 12.arP,
              ),
              Text(
                nftTokenModel.fa!.name!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.arP,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1.arP,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "$length items",
              style: TextStyle(
                color: const Color(0xFF958E99),
                fontSize: 12.arP,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1.arP,
              ),
            ),
          ),
        ),
      ],
    );
  }
}