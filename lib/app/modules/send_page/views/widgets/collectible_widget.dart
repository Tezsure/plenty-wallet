// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';

class CollectibleWidget extends GetView<SendPageController> {
  CollectibleWidget({
    super.key,
    required this.collectionNfts,
    required this.widgetIndex,
  }) {
    var firstValue = collectionNfts.first;
    logo = firstValue.fa!.logo!;
    if (logo.startsWith("ipfs://")) {
      logo = "https://ipfs.io/ipfs/${logo.replaceAll("ipfs://", "")}";
    }
    name = firstValue.fa!.name!;
  }

  final int widgetIndex;

  late String logo;
  late String name;
  late List<NftTokenModel> collectionNfts;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Obx(
          () => Column(
            children: [
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                  foregroundImage: NetworkImage(
                    logo,
                    // fit: BoxFit.contain,
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
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemBuilder: ((context, index) => NFTwidget(
                              nfTmodel: collectionNfts[index],
                              onTap: (NftTokenModel nftTokenModel) => controller
                                ..onNFTClick(nftTokenModel)
                                ..setSelectedPageIndex(
                                    index: 2, isKeyboardRequested: false),
                            )),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _expandButton({required bool isExpanded}) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            collectionNfts.length.toString(),
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
          const SizedBox(
            width: 2,
          ),
          AnimatedRotation(
            duration: const Duration(milliseconds: 300),
            turns: isExpanded ? 1 / 4 : 0,
            child: Icon(
              Icons.arrow_forward_ios,
              color: ColorConst.NeutralVariant.shade60,
              size: 10,
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
  String? nftArtifactUrl;
  NFTwidget({super.key, required this.nfTmodel, required this.onTap}) {
    nftArtifactUrl =
        "https://assets.objkt.media/file/assets-003/${nfTmodel.faContract}/${nfTmodel.tokenId.toString()}/thumb400";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(nfTmodel),
      child: Container(
        width: 0.44.width,
        height: 0.32.height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 164.sp,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    nftArtifactUrl!,
                  ),
                ),
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Text(
              nfTmodel.name!,
              style: labelMedium,
            ),
            const SizedBox(
              height: 4,
            ),
            FutureBuilder(
                initialData: 'Artist',
                future: ObjktNftApiService()
                    .getNftCreator(nfTmodel.creators!.first.creatorAddress!),
                builder: ((context, AsyncSnapshot<String> snapshot) {
                  return Text(
                    snapshot.data!.isEmpty
                        ? nfTmodel.description
                        : snapshot.data!,
                    maxLines: 1,
                    style: labelMedium.copyWith(
                        color: ColorConst.NeutralVariant.shade60,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  );
                })),
          ],
        ),
      ),
    );
  }
}
