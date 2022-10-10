import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';

import '../../../../../../utils/colors/colors.dart';
import '../../../../send_page/views/widgets/collectible_widget.dart';
import 'nft_summary_sheet.dart';

class NftCollectibles extends StatefulWidget {
  final List<NftTokenModel> nftList;
  const NftCollectibles({required this.nftList, super.key});

  @override
  State<NftCollectibles> createState() => _NftCollectiblesState();
}

class _NftCollectiblesState extends State<NftCollectibles> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor:
                  ColorConst.NeutralVariant.shade60.withOpacity(0.2),
              foregroundImage: NetworkImage(
                widget.nftList.first.fa!.logo!.startsWith("ipfs://")
                    ? "https://ipfs.io/ipfs/${widget.nftList.first.fa!.logo!.replaceAll("ipfs://", "")}"
                    : widget.nftList.first.fa!.logo!,
              ),
            ),
            onExpansionChanged: (isExpand) =>
                setState(() => isExpanded = isExpand),
            trailing: SizedBox(
              height: 0.03.height,
              width: 0.14.width,
              child: expandButton(isExpanded: isExpanded),
            ),
            title: Text(
              widget.nftList.first.fa!.name!,
              style: labelLarge,
            ),
            children: [
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                  height: 0.31.height * (widget.nftList.length / 2).ceil(),
                  width: 1.width,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.nftList.length,
                    shrinkWrap: false,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 0.5.width,
                        mainAxisExtent: 0.3.height,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemBuilder: ((context, index) => NFTwidget(
                          nfTmodel: widget.nftList[index],
                          onTap: (model) {
                            Get.bottomSheet(
                              NFTSummaryBottomSheet(
                                nftModel: widget.nftList[index],
                              ),
                              isScrollControlled: true,
                            );
                          },
                          // onTap: (NftTokenModel nftTokenModel) => controller
                          //   ..onNFTClick(nftTokenModel)
                          //   ..setSelectedPageIndex(
                          //       index: 2, isKeyboardRequested: false),
                        )),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget expandButton({required bool isExpanded}) {
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
            "${widget.nftList.length}",
            style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
          ),
          const SizedBox(
            width: 2,
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
            color: ColorConst.NeutralVariant.shade60,
            size: 10,
          )
        ],
      ),
    );
  }
}

// class NftCollectibles extends GetView<AccountSummaryController> {
//   final int nftIndex;
//   const NftCollectibles({required this.nftIndex, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Column(
//         children: [
//           ExpansionTile(
//             tilePadding: EdgeInsets.zero,
//             leading: CircleAvatar(
//               radius: 20,
//               backgroundColor:
//                   ColorConst.NeutralVariant.shade60.withOpacity(0.2),
//               foregroundImage: NetworkImage(
//                 controller.userNfts[nftIndex]![nftIndex].fa!.logo!
//                         .startsWith("ipfs://")
//                     ? "https://ipfs.io/ipfs/${controller.userNfts[nftIndex]![nftIndex].fa!.logo!.replaceAll("ipfs://", "")}"
//                     : controller.userNfts[nftIndex]![nftIndex].fa!.logo!,
//               ),
//             ),
//             // onExpansionChanged: (isExpand) =>
//             //     setState(() => isExpanded = isExpand),
//             trailing: SizedBox(
//               height: 0.03.height,
//               width: 0.14.width,
//               // child: expandButton(isExpanded: true),
//             ),
//             title: Text(
//               controller.userNfts[nftIndex]![nftIndex].fa!.name!,
//               style: labelLarge,
//             ),
//             children: [
//               const SizedBox(
//                 height: 16,
//               ),
//               SizedBox(
//                   height: 0.31.height *
//                       (controller.userNfts[nftIndex]!.length / 2).ceil(),
//                   width: 1.width,
//                   child: GridView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: controller.userNfts[nftIndex]!.length,
//                     shrinkWrap: false,
//                     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                         maxCrossAxisExtent: 0.5.width,
//                         mainAxisExtent: 0.3.height,
//                         childAspectRatio: 1,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10),
//                     itemBuilder: ((context, index) => NFTwidget(
//                           nfTmodel: controller.userNfts[nftIndex]![index],
//                           onTap: (model) {},
//                           // onTap: (NftTokenModel nftTokenModel) => controller
//                           //   ..onNFTClick(nftTokenModel)
//                           //   ..setSelectedPageIndex(
//                           //       index: 2, isKeyboardRequested: false),
//                         )),
//                   )),
//               // Wrap(
//               //   spacing: 0.03.width,
//               //   runSpacing: 0.03.width,
//               //   children: controller.userNfts[nftIndex][nftIndex].nfts
//               //       .map(
//               //         (nfTmodel) => NFTwidget(
//               //           nfTmodel: nfTmodel,
//               //           onTap: (nftModel) => Get.bottomSheet(
//               //               const NFTSummaryBottomSheet(),
//               //               isScrollControlled: true,
//               //               settings: RouteSettings(arguments: nfTmodel)),
//               //         ),
//               //       )
//               //       .toList(),
//               // )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget expandButton({required bool isExpanded}) {
//     return Container(
//       height: 24,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
//       ),
//       alignment: Alignment.center,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             " ${controller.userNfts[nftIndex]!.length}",
//             style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
//           ),
//           const SizedBox(
//             width: 2,
//           ),
//           Icon(
//             isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
//             color: ColorConst.NeutralVariant.shade60,
//             size: 10,
//           )
//         ],
//       ),
//     );
//   }
// }

// class NftCollectibles extends StatefulWidget {
//   const NftCollectibles({super.key});

//   @override
//   State<NftCollectibles> createState() => _NftCollectiblesState();
// }

// class _NftCollectiblesState extends State<NftCollectibles> {
//   bool isExpanded = false;
//   final controller = Get.find<AccountSummaryController>();
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Column(
//         children: [
//           ExpansionTile(
//             tilePadding: EdgeInsets.zero,
//             leading: CircleAvatar(
//               radius: 20,
//               backgroundColor:
//                   ColorConst.NeutralVariant.shade60.withOpacity(0.2),
//               child: Image.asset(
//                 widget.collectibleModel.collectibleProfilePath,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             onExpansionChanged: (isExpand) =>
//                 setState(() => isExpanded = isExpand),
//             trailing: SizedBox(
//               height: 0.03.height,
//               width: 0.14.width,
//               child: expandButton(isExpanded: isExpanded),
//             ),
//             title: Text(
//               widget.collectibleModel.name,
//               style: labelLarge,
//             ),
//             children: [
//               const SizedBox(
//                 height: 16,
//               ),
//               Wrap(
//                 spacing: 0.03.width,
//                 runSpacing: 0.03.width,
//                 children: widget.collectibleModel.nfts
//                     .map(
//                       (nfTmodel) => NFTwidget(
//                         nfTmodel: nfTmodel,
//                         onTap: () => Get.bottomSheet(
//                           const NFTSummaryBottomSheet(),
//                           isScrollControlled: true,
//                         ),
//                       ),
//                     )
//                     .toList(),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget expandButton({required bool isExpanded}) {
//     return Container(
//       height: 24,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
//       ),
//       alignment: Alignment.center,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             widget.collectibleModel.nfts.length.toString(),
//             style: labelSmall.apply(color: ColorConst.NeutralVariant.shade60),
//           ),
//           const SizedBox(
//             width: 2,
//           ),
//           Icon(
//             isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward_ios,
//             color: ColorConst.NeutralVariant.shade60,
//             size: 10,
//           )
//         ],
//       ),
//     );
//   }
// }
