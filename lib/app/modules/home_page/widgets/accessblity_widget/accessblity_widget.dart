// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:naan_wallet/app/modules/dapps_page/views/dapps_page_view.dart';
// import 'package:naan_wallet/utils/colors/colors.dart';
// import 'package:naan_wallet/utils/constants/path_const.dart';
// import 'package:naan_wallet/utils/extensions/size_extension.dart';
// import 'package:naan_wallet/utils/styles/styles.dart';

// class Accessiblity extends StatelessWidget {
//   const Accessiblity({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24.arP),
//       child: Container(
//         height: 0.45.width,
//         width: 1.width,
//         padding: EdgeInsets.all(0.04.width),
//         decoration: BoxDecoration(
//           color: const Color(0xff958E99).withOpacity(0.2),
//           borderRadius: BorderRadius.circular(22.arP),
//           border: Border.all(
//             color: const Color(0xff332f37),
//             width: 1.arP,
//           ),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: acessbilityChild(
//                         text: "DApps",
//                         onTap: () {
//                           Get.bottomSheet(
//                             const DappsPageView(),
//                             enterBottomSheetDuration:
//                                 const Duration(milliseconds: 180),
//                             exitBottomSheetDuration:
//                                 const Duration(milliseconds: 150),
//                             barrierColor: Colors.white.withOpacity(0.09),
//                             isScrollControlled: true,
//                           );
//                         },
//                         color: ColorConst.Orange,
//                         image: "${PathConst.HOME_PAGE}dapps.png",
//                         circleColor: ColorConst.Orange.shade80),
//                   ),
//                   0.04.hspace,
//                   Expanded(
//                     child: acessbilityChild(
//                         text: "Earn",
//                         color: ColorConst.Tertiary,
//                         image: "${PathConst.HOME_PAGE}earn.png",
//                         circleColor: ColorConst.Tertiary.shade90),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 0.04.width,
//             ),
//             Expanded(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: acessbilityChild(
//                         text: "Events",
//                         color: ColorConst.Secondary,
//                         image: "${PathConst.HOME_PAGE}events.png",
//                         circleColor: ColorConst.Secondary.shade80),
//                   ),
//                   0.04.hspace,
//                   Expanded(
//                     child: acessbilityChild(
//                         text: "Collections",
//                         color: ColorConst.Primary,
//                         image: "${PathConst.HOME_PAGE}collections.png",
//                         circleColor: ColorConst.Primary.shade80),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   acessbilityChild(
//       {String? text,
//       String? image,
//       Color? color,
//       Color? circleColor,
//       Function? onTap}) {
//     return GestureDetector(
//       onTap: () {
//         if (onTap != null) {
//           onTap();
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: color!,
//           borderRadius: BorderRadius.circular(16.arP),
//         ),
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               0.04.hspace,
//               CircleAvatar(
//                 radius: 16.arP,
//                 backgroundColor: circleColor,
//                 child: Image.asset(
//                   image!,
//                   height: 0.04.width,
//                 ),
//               ),
//               0.02.hspace,
//               Text(text!,
//                   style: bodyMedium.copyWith(fontWeight: FontWeight.w500))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
