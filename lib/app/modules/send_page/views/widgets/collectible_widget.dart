// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:plenty_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/naan_expansion_tile.dart';
import 'package:plenty_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../data/services/service_config/service_config.dart';

class CollectibleWidget extends GetView<SendPageController> {
  CollectibleWidget({
    super.key,
    required this.collectionNfts,
    required this.widgetIndex,
  }) {
    var firstValue = collectionNfts.first;
    logo = firstValue.fa!.logo?.isEmpty ?? true
        ? firstValue.creators?.isNotEmpty ?? false
            ? "https://services.tzkt.io/v1/avatars/${firstValue.creators?.first.creatorAddress}"
            : ""
        : firstValue.fa!.logo!.startsWith("ipfs://")
            ? "${ServiceConfig.ipfsUrl}/${firstValue.fa!.logo!.replaceAll("ipfs://", "")}"
            : firstValue.fa!.logo!;
    name = firstValue.fa!.name ?? "N/A";
  }

  final int widgetIndex;

  late String logo;
  late String name;
  late List<NftTokenModel> collectionNfts;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 2.arP),
        child: Obx(
          () => NaanExpansionTile(
            maintainState: true,
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
                  imageUrl: logo,
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
                controller.setExpandNFTCollectible(widgetIndex),
            trailing: SizedBox(
              height: 0.03.height,
              width: 0.14.width,
              child: _expandButton(
                isExpanded: controller.expandNFTCollectible.value &&
                    widgetIndex == controller.expandedIndex.value,
              ),
            ),
            title: Text(
              name,
              style: labelLarge,
            ),
            children: [
              SizedBox(
                  height: 0.31.height * (collectionNfts.length / 2).ceil(),
                  width: 1.width,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: collectionNfts.length,
                    shrinkWrap: false,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 0.5.width,
                        mainAxisExtent: 0.31.height,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10.arP,
                        mainAxisSpacing: 10.arP),
                    itemBuilder: ((context, index) => NFTwidget(
                          nfTmodel: collectionNfts[index],
                          onTap: (NftTokenModel nftTokenModel) => controller
                            ..onNFTClick(nftTokenModel)
                            ..setSelectedPageIndex(
                                index: 2, isKeyboardRequested: false),
                        )),
                  )),
              SizedBox(
                height: 16.arP,
              ),
            ],
          ),
        ));
  }

  Widget _expandButton({required bool isExpanded}) {
    return Container(
      height: 24.arP,
      padding: EdgeInsets.symmetric(horizontal: 12.arP),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.arP),
        // color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            collectionNfts.length.toString(),
            style: labelSmall.copyWith(
              color: Colors.white,
              fontSize: 12.txtArp,
            ),
          ),
          SizedBox(
            width: 6.arP,
          ),
          AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: isExpanded ? 1 / 4 : 0,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 12.arP,
            ),
          )
        ],
      ),
    );
  }
}

class NFTwidget extends StatelessWidget {
  final NftTokenModel nfTmodel;
  final Function(NftTokenModel) onTap;
  // String? nftArtifactUrl;
  NFTwidget({super.key, required this.nfTmodel, required this.onTap}) {
    // nftArtifactUrl =
    //     "https://assets.objkt.media/file/assets-003/${nfTmodel.faContract}/${nfTmodel.tokenId.toString()}/thumb400";
  }

  @override
  Widget build(BuildContext context) {
    return BouncingWidget(
      onPressed: () => onTap(nfTmodel),
      child: Container(
        width: 0.44.width,
        height: 0.32.height,
        padding: EdgeInsets.all(10.aR),
        decoration: BoxDecoration(
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.aR)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                height: 180.aR,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.aR),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.aR),
                    child: NFTImage(
                      nftTokenModel: nfTmodel,
                      memCacheHeight: 250,
                      memCacheWidth: 250,
                    )
                    // CachedNetworkImage(
                    //   imageUrl: nftArtifactUrl!,
                    //   fit: BoxFit.cover,
                    //   memCacheWidth: 341,
                    //   memCacheHeight: 332,
                    // ),
                    ),
              ),
            ),
            SizedBox(
              height: 10.aR,
            ),
            Text(
              nfTmodel.name ?? "N/A",
              style: labelMedium.copyWith(fontSize: 12.aR),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(
              height: 4.aR,
            ),
            Text(
              nfTmodel.creators?.isEmpty ?? true
                  ? "N/A"
                  : nfTmodel.creators?.first.holder?.alias ??
                      nfTmodel.creators!.first.holder!.address!.tz1Short(),
              maxLines: 1,
              style: labelMedium.copyWith(
                  fontSize: 12.aR,
                  color: ColorConst.NeutralVariant.shade60,
                  fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
