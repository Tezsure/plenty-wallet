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
}
