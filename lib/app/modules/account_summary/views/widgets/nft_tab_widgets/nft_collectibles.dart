import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_expansion_tile.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../send_page/views/widgets/collectible_widget.dart';
import '../../../../nft_gallery/view/nft_detail_sheet.dart';

class NftCollectibles extends StatefulWidget {
  final List<NftTokenModel> nftList;
  final String account;
  const NftCollectibles(
      {required this.nftList, required this.account, super.key});

  @override
  State<NftCollectibles> createState() => _NftCollectiblesState();
}

class _NftCollectiblesState extends State<NftCollectibles> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.aR),
      child: Column(
        children: [
          NaanExpansionTile(
            maintainState: true,
            initiallyExpanded: isExpanded,
            tilePadding: EdgeInsets.zero,
            leading: Container(
              height: 40.aR,
              width: 40.aR,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1.5.aR,
                  color: ColorConst.NeutralVariant.shade60,
                ),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.nftList.first.fa!.logo?.isEmpty ?? true
                      ? widget.nftList.first.creators?.isNotEmpty ?? false
                          ? "https://services.tzkt.io/v1/avatars/${widget.nftList.first.creators?.first.creatorAddress}"
                          : ""
                      : widget.nftList.first.fa!.logo!.startsWith("ipfs://")
                          ? "https://ipfs.io/ipfs/${widget.nftList.first.fa!.logo!.replaceAll("ipfs://", "")}"
                          : widget.nftList.first.fa!.logo!,
                  memCacheHeight: 73,
                  memCacheWidth: 73,
                  placeholder: (context, url) => SizedBox(
                    child: Shimmer.fromColors(
                      baseColor: const Color(0xff474548),
                      highlightColor: const Color(0xFF958E99).withOpacity(0.2),
                      child: Container(
                          decoration: const BoxDecoration(
                        color: Color(0xff474548),
                      )),
                    ),
                  ),
                ),
              ),
            ),
            onExpansionChanged: (isExpand) =>
                setState(() => isExpanded = isExpand),
            trailing: expandButton(isExpanded: isExpanded),
            title: Text(
              widget.nftList.first.fa!.name == null
                  ? widget.nftList.first.name!
                  : widget.nftList.first.fa!.name!,
              style:
                  labelLarge.copyWith(fontSize: 14.aR, letterSpacing: 0.1.aR),
            ),
            children: [
              SizedBox(
                height: 16.aR,
              ),
              SizedBox(
                  height: 260.aR * (widget.nftList.length / 2).ceil(),
                  width: 1.width,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.nftList.length,
                    shrinkWrap: false,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300.arP,
                        mainAxisExtent: 250.aR,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10.aR,
                        mainAxisSpacing: 10.aR),
                    itemBuilder: ((context, index) => NFTwidget(
                          nfTmodel: widget.nftList[index],
                          onTap: (model) {
                            Get.bottomSheet(
                              NFTDetailBottomSheet(
                                onBackTap: Get.back,
                                pk: widget.nftList[index].pk,
                                publicKeyHashs: [widget.account],
                              ),
                              enterBottomSheetDuration:
                                  const Duration(milliseconds: 180),
                              exitBottomSheetDuration:
                                  const Duration(milliseconds: 150),
                              isScrollControlled: true,
                            ); //todo: uncomment this when NFTDetailBottomSheet is ready
                          },
                        )),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget expandButton({required bool isExpanded}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${widget.nftList.length}",
          style: labelMedium.copyWith(
              fontSize: 12.aR,
              color: Colors.white,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          width: 2.aR,
        ),
        AnimatedRotation(
          turns: isExpanded ? 1 / 4 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Colors.white,
            size: 20.aR,
          ),
        ),
      ],
    );
  }
}
