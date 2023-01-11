import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SizeExtension on num {
  double get width => Get.width * this;
  double get height => Get.height * this;

  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
  // double get sp => this * (Get.width / 4) / 100;

  double get spH => this * (Get.height / 6) / 100;

  double get arP => this * (Get.size.aspectRatio * 2);

  double get aR => Get.width > 1100
      ? this * Get.size.aspectRatio
      : this * (Get.size.aspectRatio * 2);

  SizedBox get vspace => SizedBox(
        height: height.arP.toDouble(),
      );

  SizedBox get hspace => SizedBox(
        width: width.arP.toDouble(),
      );
}
