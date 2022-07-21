import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SizeExtension on num {
  double get width => Get.width * this;
  double get height => Get.height * this;

  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
  double get sp => this * (Get.width / 4) / 100;

  SizedBox get vspace => SizedBox(
        height: height.toDouble(),
      );

  SizedBox get hspace => SizedBox(
        width: width.toDouble(),
      );
}
