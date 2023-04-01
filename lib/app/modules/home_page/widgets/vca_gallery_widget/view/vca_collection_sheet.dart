import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/custom_gallery/widgets/custom_nft_detail_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class NFTCollectionSheet extends StatelessWidget {
  final String? prevPage;
  final List<NftTokenModel> nfts;

  const NFTCollectionSheet({super.key, this.nfts = const [], this.prevPage});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      prevPageName: prevPage,
      // isScrollControlled: true,
      // bottomSheetHorizontalPadding: 0,
      height: AppConstant.naanBottomSheetHeight - 4.arP,
      bottomSheetWidgets: [
        _getNftListViewWidget(2.1, context),
      ],
    );
  }

  Widget _getNftListViewWidget(double crossAxisCount, BuildContext context) =>
      SizedBox(
          height: AppConstant.naanBottomSheetHeight - 18.arP,
          // margin: EdgeInsets.symmetric(
          //   horizontal: 16.arP,
          // ),
          child: Column(
            children: [
              0.02.vspace,
              _getCollectionDetailsRow(
                  nfts.first, nfts.toList().length, context),
              SizedBox(
                height: 15.arP,
              ),
              Expanded(
                child: MasonryGridView.count(
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
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
                      return BouncingWidget(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CustomNFTDetailBottomSheet(
                                    onBackTap: Get.back,
                                    prevPage: nftTokenModel.fa!.name ??
                                        nftTokenModel.fa!.contract
                                            ?.tz1Short() ??
                                        "",
                                    pk: nftTokenModel.pk,
                                  )));
                          // CommonFunctions.bottomSheet(
                          //   NFTDetailBottomSheet(
                          //     prevPage: prevPage,
                          //     onBackTap: Get.back,
                          //     pk: nftTokenModel.pk,
                          //     publicKeyHashs: publicKeyHashs,
                          //   ),
                          // );
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
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: crossAxisCount == 2.1
                                      ? 150.arP
                                      : crossAxisCount == 1.1
                                          ? 300.arP
                                          : 1,
                                ),
                                width: double.infinity,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      8.arP,
                                    ),
                                    child: NFTImage(
                                        memCacheHeight: 250,
                                        memCacheWidth: 250,
                                        nftTokenModel: nftTokenModel)),
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

  Widget _getCollectionDetailsRow(
      NftTokenModel nftTokenModel, length, BuildContext context) {
    var logo = nftTokenModel.fa!.logo!;
    if (logo.startsWith("ipfs://")) {
      logo = "https://ipfs.io/ipfs/${logo.replaceAll("ipfs://", "")}";
    }
    if (logo.isEmpty && (nftTokenModel.creators?.isNotEmpty ?? false)) {
      logo =
          "https://services.tzkt.io/v1/avatars/${nftTokenModel.creators!.first.creatorAddress}";
    }
    final String name =
        nftTokenModel.fa!.name ?? nftTokenModel.fa!.contract?.tz1Short() ?? "X";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        backButton(
            ontap: () {
              Navigator.pop(context);
            },
            lastPageName: prevPage),
        // backButton(),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 32.arP,
                  height: 32.arP,
                  child: ClipOval(
                      child: Image.network(
                    logo,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        padding: EdgeInsets.all(6.arP),
                        alignment: Alignment.center,
                        color:
                            ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                        child: Container(
                          width: 24.aR,
                          height: 24.aR,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              name.substring(0, 1),
                              style: bodySmall.copyWith(
                                color: ColorConst.NeutralVariant.shade60,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                ),
                SizedBox(
                  width: 12.arP,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: .3.width),
                  child: Text(
                    nftTokenModel.fa!.name ??
                        nftTokenModel.fa!.contract?.tz1Short() ??
                        "",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.arP,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1.arP,
                    ),
                  ),
                ),
                SizedBox(
                  width: 24.arP,
                ),
              ],
            ),
          ),
        ),
        closeButton()
      ],
    );
  }
}
