import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:naan_wallet/app/modules/veNFT.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

class NFTImage extends StatelessWidget {
  final NftTokenModel nftTokenModel;
  int? maxWidthDiskCache;
  int? maxHeightDiskCache;
  int? memCacheHeight;
  int? memCacheWidth;
  BoxFit boxFit;
  NFTImage(
      {super.key,
      required this.nftTokenModel,
      this.maxWidthDiskCache,
      this.maxHeightDiskCache,
      this.memCacheHeight,
      this.memCacheWidth,
      this.boxFit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    final String nftImageUrl = nftTokenModel.displayUri
                ?.contains("data:image/svg+xml") ??
            false
        ? nftTokenModel.displayUri!
        : (nftTokenModel.displayUri?.contains("ipfs://") ?? false
            ? "https://ipfs.io/ipfs/${nftTokenModel.displayUri?.replaceAll("ipfs://", '')}"
            : "https://assets.objkt.media/file/assets-003/${nftTokenModel.faContract}/${nftTokenModel.tokenId.toString()}/thumb400");
    return Container(
      child: nftTokenModel.faContract == "KT18kkvmUoefkdok5mrjU6fxsm7xmumy1NEw"
          ? VeNFT(url: nftImageUrl)
          : Image.network(
              "https://assets.objkt.media/file/assets-003/${nftTokenModel.faContract}/${nftTokenModel.tokenId.toString()}/thumb400",
              fit: boxFit,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorConst.Primary,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
/*               imageUrl: nftImageUrl,
              fit: boxFit,
              placeholderFadeInDuration: const Duration(milliseconds: 1),
              placeholder: (context, url) => CachedNetworkImage(
                  imageUrl:
                      "https://assets.objkt.media/file/assets-003/${nftTokenModel.faContract}/${nftTokenModel.tokenId.toString()}/thumb400"),
              cacheKey:
                  "https://assets.objkt.media/file/assets-003/${nftTokenModel.faContract}/${nftTokenModel.tokenId?.toString()}/thumb288", */

              // maxWidthDiskCache: maxWidthDiskCache,
              // maxHeightDiskCache: maxHeightDiskCache,
              // memCacheHeight: memCacheHeight,
              // memCacheWidth: memCacheWidth,
            ),
    );
  }
}
