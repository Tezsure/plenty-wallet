// import 'package:flutter/material.dart';
// import 'package:plenty_wallet/utils/extensions/size_extension.dart';

// import '../../../../../../utils/colors/colors.dart';
// import '../../../../../../utils/styles/styles.dart';
// import '../../../../custom_packages/readmore/readmore.dart';

// class NFTInformationTab extends StatelessWidget {
//   const NFTInformationTab({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         0.02.vspace,
//         Text(
//           'Description',
//           style: labelSmall.copyWith(color: ColorConst.NeutralVariant.shade60),
//         ),
//         0.012.vspace,
//         Container(
//             width: 0.9.width,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//                 color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8)),
//             child: ReadMoreText(
//               'Donec lectus nibh, consectetur vitae dolor ac, finibus suscipit quam. Nunc at nunc turpis. Donec gravida tempus urna. Nam maximus pretium leo non feugiat. Integer semper, orci et dignissim bibendum, libero enim scelerisque libero, nec rutrum nisl',
//               trimLines: 4,
//               lessStyle: bodySmall,
//               style:
//                   bodySmall.copyWith(color: ColorConst.NeutralVariant.shade60),
//               colorClickableText: Colors.white,
//               trimMode: TrimMode.Line,
//               trimCollapsedText: 'Show more',
//               trimExpandedText: 'Show less',
//               moreStyle: bodySmall,
//             )),
//         0.02.vspace,
//         Container(
//             height: 0.08.height,
//             width: 0.9.width,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//                 color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                         text: 'Owner\n',
//                         style: labelSmall.copyWith(
//                             color: ColorConst.NeutralVariant.shade70),
//                         children: [TextSpan(text: '5', style: labelLarge)])),
//                 RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                         text: 'Owners\n',
//                         style: labelSmall.copyWith(
//                             color: ColorConst.NeutralVariant.shade70),
//                         children: [TextSpan(text: '10', style: labelLarge)])),
//                 RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                         text: 'Editions\n',
//                         style: labelSmall.copyWith(
//                             color: ColorConst.NeutralVariant.shade70),
//                         children: [TextSpan(text: '69', style: labelLarge)]))
//               ],
//             )),
//       ],
//     );
//   }
// }
