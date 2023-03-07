import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SizeExtension on num {
  double get width => Get.width * this;
  double get height => Get.height * this;

  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
  // double get sp => this * (Get.width / 4) / 100;

  double get spH => this * (Get.height / 6) / 100;

  double get arP {
    // log(Get.size.height.toString());
    // log(Get.pixelRatio.toString());
    double ratio = 1;
    if (Get.size.height < 600) {
      ratio = 1;
    } else if (Get.size.height > 1100) {
      ratio = 1.35;
    } else {
      ratio = 2;
    }
    return this * (Get.size.aspectRatio * ratio);
  }

  double get txtArp => arP;
  double get aR => arP;

  SizedBox get vspace => SizedBox(
        height: height.arP.toDouble(),
      );

  SizedBox get hspace => SizedBox(
        width: width.arP.toDouble(),
      );
}
