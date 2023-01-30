import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../utils/colors/colors.dart';
import '../../data/services/enums/enums.dart';

class CustomImageWidget extends StatelessWidget {
  final AccountProfileImageType imageType;
  final String imagePath;
  final double? imageRadius;
  const CustomImageWidget(
      {super.key,
      required this.imageType,
      required this.imagePath,
      this.imageRadius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (imageRadius ?? 30.arP) * 2,
      width: (imageRadius ?? 30.arP) * 2,
      child: ClipOval(
        child: Image(
          image: imageType == AccountProfileImageType.assets
              ? AssetImage(imagePath)
              : FileImage(
                  File(imagePath),
                ) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
