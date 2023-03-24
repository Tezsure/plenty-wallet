// import 'package:flutter/material.dart';

// import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
// import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
// import 'package:naan_wallet/app/modules/home_page/widgets/vca_gallery_widget/view/vca_gallery_view.dart';
// import 'package:naan_wallet/app/modules/nft_gallery/view/nft_gallery_view.dart';
// import 'package:naan_wallet/utils/common_functions.dart';

// import 'package:naan_wallet/utils/extensions/size_extension.dart';
// import 'package:naan_wallet/app/modules/common_widgets/nft_image.dart';

// class VcaGalleryWidget extends StatefulWidget {
//   const VcaGalleryWidget({super.key});

//   @override
//   State<VcaGalleryWidget> createState() => _VcaGalleryWidgetState();
// }

// class _VcaGalleryWidgetState extends State<VcaGalleryWidget> {
//   Widget _getGalleryWidget() => ClipRRect(
//         borderRadius: BorderRadius.circular(22.arP),
//         child: SizedBox(
//             width: double.infinity,
//             height: double.infinity,
//             child: BouncingWidget(
//               onPressed: () {
//                 CommonFunctions.bottomSheet(
//                   VcaGalleryView(),
//                   fullscreen: true,
//                 );
//               },
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(22),
//                 child: Stack(
//                   children: [
//                     SizedBox(
//                       width: double.infinity,
//                       height: double.infinity,
//                       // decoration: BoxDecoration(
//                       //     gradient: applePurple,
//                       //     image: DecorationImage(
//                       //       image: CachedNetworkImageProvider(
//                       //         "https://assets.objkt.media/file/assets-003/${controller.nftGalleryList[index].nftTokenModel!.faContract}/${controller.nftGalleryList[index].nftTokenModel!.tokenId.toString()}/thumb400",
//                       //       ),
//                       //       fit: BoxFit.cover,
//                       //     )),
//                       child:
//                           NFTImage(nftTokenModel: ServiceConfig.randomVcaNft),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Container(
//                         height: 0.2.height,
//                         width: double.infinity,
//                         // ignore: prefer_const_constructors
//                         decoration: BoxDecoration(
//                             // ignore: prefer_const_constructors
//                             gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 // ignore: prefer_const_literals_to_create_immutables
//                                 colors: [
//                               Colors.transparent,
//                               Colors.grey[900]!.withOpacity(0.6),
//                               Colors.grey[900]!.withOpacity(0.99),
//                             ])),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Container(
//                         margin: EdgeInsets.all(
//                           22.arP,
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "VCA Gallery",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 22.arP,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 4.arP,
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(
//         left: 22.arP,
//         right: 10.arP,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: SizedBox(
//               // color: Colors.red,
//               width: double.infinity,

//               height: 0.87.width,
//               // decoration: BoxDecoration(
//               //   borderRadius: BorderRadius.circular(22.arP),
//               //   // color: Colors.white,
//               //   color: const Color(0xFF1E1C1F),
//               // ),
//               child: _getGalleryWidget(),
//             ),
//           ),
//           SizedBox(
//             width: 8.arP,
//           ),
//           SizedBox(
//             width: 4.arP,
//           ),
//         ],
//       ),
//     );
//   }
// }
