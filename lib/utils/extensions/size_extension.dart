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
/*     print("Get.size.height.toString():${Get.size.height.toString()}");
    log(Get.size.aspectRatio.toString()); */
    double ratio = 1;
    if (Get.size.height < 690) {
      ratio = 1.2;
    } else if (Get.size.height < 740 && Get.size.height > 690) {
      ratio = Platform.isIOS ? 1.35 : 1.35;
    } else if (Get.size.height > 780 && Get.size.height < 800) {
      ratio = 1.6;
    } else if (Get.size.height > 1100) {
      ratio = 1.6;
    } else {
      ratio = 2;
    }
    double aspectRatio = Get.size.aspectRatio;

    return this * (aspectRatio * ratio);
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
