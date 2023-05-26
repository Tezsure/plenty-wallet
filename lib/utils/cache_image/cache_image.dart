import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:naan_wallet/utils/colors/colors.dart';

import 'image_cache_handler.dart';

class CacheImageBuilder extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final bool showLoading;
  CacheImageBuilder({
    required this.imageUrl,
    this.fit = BoxFit.fill,
    this.showLoading = false,
  });

  var isLocalAvailable = false;

  ImageCacheHandler cacheImageBuilder = ImageCacheHandler();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: cacheImageBuilder.getAndCacheImage(imageUrl),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        return snapshot.hasData
            ? Image.file(
                snapshot.data!,
                fit: fit,
              )
            : showLoading
                ? const CupertinoActivityIndicator(
                            color: ColorConst.Primary,
                          )
                : Container();
      },
    );
  }
}
