// import 'package:flutter/material.dart';
// import 'package:naan_wallet/utils/colors/colors.dart';
// import 'package:naan_wallet/utils/extensions/size_extension.dart';
// import 'package:naan_wallet/utils/styles/styles.dart';

// class NewsHeadlineWidget extends StatelessWidget {
//   const NewsHeadlineWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Text("Tezos Headlines",
//           textAlign: TextAlign.start,
//           style: titleSmall.apply(color: ColorConst.NeutralVariant.shade50)),
//       0.0165.vspace,
//       Container(
//         width: 0.9.width,
//         decoration: BoxDecoration(
//           color: ColorConst.NeutralVariant.shade10,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: ListView.separated(
//             scrollDirection: Axis.vertical,
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             padding: EdgeInsets.symmetric(horizontal: 0.045.width),
//             itemBuilder: (_, index) => NewsItem(),
//             separatorBuilder: (_, index) => Divider(
//                   height: 1,
//                   thickness: 1,
//                   color: ColorConst.NeutralVariant.shade30,
//                 ),
//             itemCount: 3),
//       ),
//     ]);
//   }

//   Widget NewsItem() {
//     return Padding(
//         padding: EdgeInsets.symmetric(vertical: 0.046.width),
//         child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//           Container(
//             width: 0.18.width,
//             height: 0.18.width,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                   fit: BoxFit.fill,
//                   image: AssetImage(
//                     'assets/temp/headlines.png',
//                   )),
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(8)),
//             ),
//           ),
//           SizedBox(
//             width: 0.03.width,
//           ),
//           SizedBox(
//             height: 0.18.width,
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "The Crunchy Aggregator - DEX\nTrade Routing For Optimal Text",
//                     style: labelLarge,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//                     Text(
//                       "July, 31, 2022",
//                       style: labelSmall.apply(
//                           color: ColorConst.NeutralVariant.shade60),
//                     ),
//                     SizedBox(
//                       width: 0.03.width,
//                     ),
//                     newsCategory(),
//                   ])
//                 ]),
//           )
//         ]));
//   }

//   Container newsCategory() {
//     return Container(
//       height: 20,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//           color: ColorConst.NeutralVariant.shade40,
//           borderRadius: BorderRadius.circular(10)),
//       alignment: Alignment.center,
//       child: Text(
//         "Defi",
//         style: labelSmall,
//       ),
//     );
//   }
// }
