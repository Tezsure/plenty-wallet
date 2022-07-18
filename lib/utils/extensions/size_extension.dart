import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SizeExtension on num {
  double get width => Get.width * this;
  double get height => Get.height * this;

  SizedBox get vspace => SizedBox(
        height: this.toDouble(),
      );

  SizedBox get hspace => SizedBox(
        width: this.toDouble(),
      );

  double get sp => this * (Get.width / 4) / 100;

  double get h => (this / 844) * Get.height;
  double get w => (this / 844) * Get.width;
}
