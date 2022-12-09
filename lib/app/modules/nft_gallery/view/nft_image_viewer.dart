import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../common_widgets/back_button.dart';

class NFTImageViewer extends StatelessWidget {
  final String image;
  const NFTImageViewer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backButton(),
          Expanded(
            child: Hero(
              tag: image,
              child: InteractiveViewer(
                child: Center(child: CachedNetworkImage(imageUrl: image)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
