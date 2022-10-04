import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

import '../../../../utils/constants/path_const.dart';
import '../../../../utils/styles/styles.dart';
import '../../../../utils/utils.dart';
import '../controllers/nft_gallery_controller.dart';
import 'widgets/full_screen_view.dart';

class NFTDetailView extends GetView<NftGalleryController> {
  final GestureTapCallback? onBackTap;
  const NFTDetailView({
    super.key,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      maxChildSize: 0.96,
      minChildSize: 0.6,
      builder: ((context, scrollController) => DefaultTabController(
            length: 2,
            child: Container(
              width: 1.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                gradient: GradConst.GradientBackground,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    0.01.vspace,
                    Center(
                      child: Container(
                        height: 5,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.3),
                        ),
                      ),
                    ),
                    0.001.vspace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: onBackTap,
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white)),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.share, color: Colors.white)),
                        IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.cast_rounded,
                                color: Colors.white)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0.02.height),
                      height: 0.5.height,
                      width: 1.width,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          Positioned.fill(
                              child: Image.asset(
                            controller
                                .collectibles[
                                    controller.selectedCollectibleIndex.value]
                                .nfts[controller.selectedNftIndex.value]
                                .nftPath,
                            fit: BoxFit.cover,
                          )),
                          GestureDetector(
                            onTap: () => Get.to(FullScreenNFTImage(
                              child: Image.asset(
                                controller
                                    .collectibles[controller
                                        .selectedCollectibleIndex.value]
                                    .nfts[controller.selectedNftIndex.value]
                                    .nftPath,
                                fit: BoxFit.contain,
                              ),
                            )),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: 10.sp, bottom: 22.sp),
                                height: 36.sp,
                                width: 36.sp,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Transform.rotate(
                                  angle: pi / 180 * 135,
                                  child: const Icon(
                                    Icons.code_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.sp, right: 13.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'unstable dreams\n',
                                    style: labelSmall.copyWith(
                                        color:
                                            ColorConst.NeutralVariant.shade60)),
                                TextSpan(
                                    text: 'Unstable #5\n', style: bodyLarge),
                                TextSpan(
                                  text:
                                      'Donec lectus nibh, consectetur vitae dolor ac, finibus\nsuscipit quam. Nunc at nunc turpis. Donec gravida',
                                  style: bodySmall.copyWith(
                                    color: ColorConst.NeutralVariant.shade60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          MaterialButton(
                            padding: EdgeInsets.zero,
                            minWidth: 1,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {},
                            child: Text(
                              'See more',
                              textAlign: TextAlign.start,
                              style: labelMedium.copyWith(
                                  color: ColorConst.Primary),
                            ),
                          ),
                          0.01.vspace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: '2\n',
                                      style: labelLarge,
                                      children: [
                                        TextSpan(
                                            text: 'Owned',
                                            style: labelSmall.copyWith(
                                                color: ColorConst
                                                    .NeutralVariant.shade70))
                                      ])),
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: '40\n',
                                      style: labelLarge,
                                      children: [
                                        TextSpan(
                                            text: 'Owners',
                                            style: labelSmall.copyWith(
                                                color: ColorConst
                                                    .NeutralVariant.shade70))
                                      ])),
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: '69\n',
                                      style: labelLarge,
                                      children: [
                                        TextSpan(
                                            text: 'Editions',
                                            style: labelSmall.copyWith(
                                                color: ColorConst
                                                    .NeutralVariant.shade70))
                                      ])),
                            ],
                          ),
                          Center(
                            child: Container(
                              margin:
                                  EdgeInsets.symmetric(vertical: 0.02.height),
                              height: 0.12.height,
                              width: 1.width,
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: ColorConst.NeutralVariant.shade60
                                        .withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.sp),
                                child: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: 'Current Price\n',
                                        style: labelSmall.copyWith(
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                        children: [
                                          TextSpan(
                                              text: '420.69 ',
                                              style: headlineSmall),
                                          WidgetSpan(
                                              child: SvgPicture.asset(
                                            '${PathConst.HOME_PAGE}svg/xtz.svg',
                                            height: 20,
                                          )),
                                          TextSpan(
                                              text: '\n\$596.21',
                                              style: labelSmall.copyWith(
                                                  color: ColorConst
                                                      .NeutralVariant.shade60)),
                                        ])),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset('${PathConst.TEMP}nft_summary1.png'),
                      ),
                      title: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: 'Created By ',
                              style: labelSmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade60),
                              children: [
                                TextSpan(
                                    text: tz1Shortner(
                                        'tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
                                    style: labelMedium)
                              ])),
                    ),
                    Divider(
                      color: ColorConst.NeutralVariant.shade20,
                      endIndent: 14.sp,
                      indent: 14.sp,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset('${PathConst.TEMP}nft_summary2.png'),
                      ),
                      title: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: 'Created By ',
                              style: labelSmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade60),
                              children: [
                                TextSpan(
                                    text: tz1Shortner(
                                        'tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
                                    style: labelMedium)
                              ])),
                    ),
                    SizedBox(
                      width: 1.width,
                      height: 0.1.height,
                      child: TabBar(
                          padding: EdgeInsets.all(8.sp),
                          enableFeedback: true,
                          isScrollable: true,
                          indicatorColor: ColorConst.Primary,
                          unselectedLabelColor:
                              ColorConst.NeutralVariant.shade60,
                          unselectedLabelStyle: labelLarge,
                          labelColor: ColorConst.Primary.shade95,
                          labelStyle: labelLarge,
                          tabs: const [
                            Tab(
                              child: Text(
                                'Details',
                              ),
                            ),
                            Tab(
                              child: Text(
                                'Item Activity',
                              ),
                            ),
                          ]),
                    ),
                    Obx(() => SizedBox(
                          height: controller.isExpanded.value
                              ? 0.4.height
                              : 0.25.height,
                          child: TabBarView(children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  ExpansionTile(
                                      onExpansionChanged:
                                          controller.toggleExpanded,
                                      title: Text(
                                        'About Collection',
                                        style: labelSmall,
                                      ),
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 16.sp, right: 13.sp),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Image.asset(
                                                        '${PathConst.TEMP}nft_details.png'),
                                                  ),
                                                  0.04.hspace,
                                                  Text(
                                                    'stay a vision',
                                                    style: labelSmall,
                                                  ),
                                                ],
                                              ),
                                              0.01.vspace,
                                              Text(
                                                'Donec lectus nibh, consectetur vitae dolor ac, finibus suscipit quam. Nunc at nunc turpis. Donec gradvida',
                                                style: bodySmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade60),
                                              )
                                            ],
                                          ),
                                        )
                                      ]),
                                  Divider(
                                    color: ColorConst.NeutralVariant.shade20,
                                    endIndent: 14.sp,
                                    indent: 14.sp,
                                  ),
                                  ExpansionTile(
                                      onExpansionChanged:
                                          controller.toggleExpanded,
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      title: Text(
                                        'Details',
                                        style: labelSmall,
                                      ),
                                      children: [
                                        Row(
                                          children: [
                                            0.04.hspace,
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                    text: 'Contract Address\n',
                                                    style: labelSmall,
                                                    children: [
                                                      TextSpan(
                                                          text: 'Token ID',
                                                          style: labelSmall)
                                                    ])),
                                            const Spacer(),
                                            RichText(
                                                textAlign: TextAlign.end,
                                                text: TextSpan(
                                                    text: 'Ox495f...7b5e',
                                                    style: bodySmall.copyWith(
                                                        color:
                                                            ColorConst.Primary),
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Icon(
                                                          Icons.open_in_new,
                                                          size: 14,
                                                          color: ColorConst
                                                              .Primary,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text: '\n13951734451',
                                                          style: bodySmall.copyWith(
                                                              color: ColorConst
                                                                  .NeutralVariant
                                                                  .shade60))
                                                    ])),
                                            0.04.hspace,
                                          ],
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.sp),
                              child: Column(
                                children: [
                                  0.01.vspace,
                                  Material(
                                    color: ColorConst.NeutralVariant.shade60
                                        .withOpacity(0.2),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: ListTile(
                                      dense: true,
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: SvgPicture.asset(
                                          '${PathConst.SVG}bi_arrow.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      title: Text(
                                        'Transfer',
                                        style: labelMedium,
                                      ),
                                      subtitle: Text(
                                        'to ${tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx')}',
                                        style: bodySmall.copyWith(
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                      ),
                                      trailing: Text(
                                        '1.5 hours ago',
                                        style: labelSmall.copyWith(
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                      ),
                                    ),
                                  ),
                                  0.01.vspace,
                                  Material(
                                    color: ColorConst.NeutralVariant.shade60
                                        .withOpacity(0.2),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: ListTile(
                                      dense: true,
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: SvgPicture.asset(
                                          '${PathConst.SVG}cart.svg',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      title: Text(
                                        'Sale',
                                        style: labelMedium,
                                      ),
                                      subtitle: Text(
                                        'to ${tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx')}',
                                        style: bodySmall.copyWith(
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                      ),
                                      trailing: RichText(
                                        textAlign: TextAlign.end,
                                        text: TextSpan(
                                          text: '123 ',
                                          style: labelSmall,
                                          children: [
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              child: SvgPicture.asset(
                                                '${PathConst.HOME_PAGE}svg/xtz.svg',
                                                height: 12.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '\n2 days ago',
                                              style: labelSmall.copyWith(
                                                  color: ColorConst
                                                      .NeutralVariant.shade60),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        )),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
