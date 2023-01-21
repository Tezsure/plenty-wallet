import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';

class VeNFT extends StatelessWidget {
  final String url;

  const VeNFT({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return ScalableImageWidget.fromSISource(
      si: ScalableImageSource.fromSvgHttpUrl(
        Uri.parse(url),
      ),
      scale: 0.2,
    );
  }
}
