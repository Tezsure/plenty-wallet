import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/models/token_tx_model.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

class AppConstant {
  static const String defaultUrl = 'https://dapps-naan.netlify.app/';
  static const String naanWebsite = 'https://naan.app/';
  static double homeWidgetDimension = ((0.5 * Get.width) - 33.arP);
  // static double naanBottomSheetHeight = 0.89.height;
  static double naanBottomSheetChildHeight = 0.87.height;
  static const ScrollPhysics scrollPhysics =
      BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  static Function() hapticFeedback = () {
    HapticFeedback.selectionClick();
  };
}

class Dapp {
  String name;
  String url;
  String description;
  String image;

  Dapp(
      {required this.name,
      required this.url,
      required this.description,
      required this.image});
}
