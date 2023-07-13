// import 'package:flutter/material.dart';
// import 'package:plenty_wallet/utils/extensions/size_extension.dart';
// import 'package:plenty_wallet/utils/styles/styles.dart';

// import '../../../../../../utils/colors/colors.dart';
// import '../../../../../../utils/constants/path_const.dart';

// class NFTActivityTab extends StatelessWidget {
//   const NFTActivityTab({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         0.02.vspace,
//         Material(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
//           child: ListTile(
//             dense: true,
//             leading: CircleAvatar(
//               radius: 20.arP,
//               backgroundColor: ColorConst.Neutral.shade30,
//               child: Icon(
//                 Icons.wallet,
//                 color: ColorConst.Primary.shade80,
//               ),
//             ),
//             title: Text(
//               'Transferred to tz2RB..MoQ',
//               style: labelMedium,
//             ),
//             subtitle: Text(
//               'August 12, 2022 at 10:30 am',
//               style:
//                   labelSmall.copyWith(color: ColorConst.NeutralVariant.shade70),
//             ),
//           ),
//         ),
//         0.005.vspace,
//         Material(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
//           child: ListTile(
//             dense: true,
//             leading: CircleAvatar(
//                 radius: 20.arP,
//                 backgroundColor: ColorConst.Tertiary,
//                 child: Image.asset('${PathConst.SEND_PAGE}nft_art1.png')),
//             title: Text(
//               'Offered made by tz2RB...MoQ',
//               style: labelMedium,
//             ),
//             subtitle: Text(
//               'August 1, 2022 at 10:30 am ',
//               style:
//                   labelSmall.copyWith(color: ColorConst.NeutralVariant.shade70),
//             ),
//             trailing: Text(
//               '20 tez',
//               style: labelLarge,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
