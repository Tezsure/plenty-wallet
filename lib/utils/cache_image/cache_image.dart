import 'dart:io';

import 'package:flutter/material.dart';

import 'image_cache_handler.dart';

class CacheImageBuilder extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final bool showLoading;
  const CacheImageBuilder({
    required this.imageUrl,
    this.fit = BoxFit.fill,
    this.showLoading = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CacheImageBuilderState createState() => _CacheImageBuilderState();
}

class _CacheImageBuilderState extends State<CacheImageBuilder> {
  var isLocalAvailable = false;
  ImageCacheHandler cacheImageBuilder = ImageCacheHandler();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: cacheImageBuilder.getAndCacheImage(widget.imageUrl),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        return snapshot.hasData
            ? Image.file(
                snapshot.data!,
                fit: widget.fit,
              )
            : widget.showLoading
                ? const CircularProgressIndicator()
                : Container();
      },
    );
  }
}
