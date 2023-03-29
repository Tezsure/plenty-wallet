// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';

// abstract class AnimateBottomsheetController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   late AnimationController animate;
//   late RxDouble scale;
//   AnimateBottomsheetController() {
//     animate = AnimationController(
//         vsync: this,
//         duration:
//             Duration(milliseconds: 350), //This is an inital controller duration
//         lowerBound: 0,
//         upperBound: 0.15)
//       ..addListener(() {
//         scale.value = 1 - animate.value;
//       });
//     scale = (1 - animate.value).obs;
//   }
//   void animateForward();
//   void animateReverse();
// }

// class BottomSheetManager {
//   static List<AnimateBottomsheetController> sheets = [];
//   static void addSheet(AnimateBottomsheetController child) {
//     // if (sheets.isNotEmpty) {
//     //   (sheets.last).animateForward();
//     // }
//     sheets.add(child);
//   }

//   static void deleteSheet(AnimateBottomsheetController child) {
   
//     sheets.remove(child);

//     // if (sheets.isNotEmpty) {
//     //   (sheets.last).animateReverse();
//     // }
//   }
// }
