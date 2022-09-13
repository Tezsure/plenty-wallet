import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../controllers/nft_gallery_controller.dart';

class NftGalleryView extends GetView<NftGalleryController> {
  const NftGalleryView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        height: 0.95.height,
        width: 1.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          gradient: GradConst.GradientBackground,
        ),
        child: SingleChildScrollView(
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
                    color: ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                  ),
                ),
              ),
              0.01.vspace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {},
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
                      icon:
                          const Icon(Icons.cast_rounded, color: Colors.white)),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.02.height),
                height: 0.4.height,
                width: 1.width,
                color: Colors.white,
              ),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(text: '\n'),
                    TextSpan(text: '\n'),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See more',
                  style: bodySmall.copyWith(color: ColorConst.Primary),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(text: '2\n', style: labelLarge, children: [
                        TextSpan(
                            text: 'Owned',
                            style: labelSmall.copyWith(
                                color: ColorConst.NeutralVariant.shade70))
                      ])),
                  RichText(
                      textAlign: TextAlign.center,
                      text:
                          TextSpan(text: '40\n', style: labelLarge, children: [
                        TextSpan(
                            text: 'Owners',
                            style: labelSmall.copyWith(
                                color: ColorConst.NeutralVariant.shade70))
                      ])),
                  RichText(
                      textAlign: TextAlign.center,
                      text:
                          TextSpan(text: '69\n', style: labelLarge, children: [
                        TextSpan(
                            text: 'Editions',
                            style: labelSmall.copyWith(
                                color: ColorConst.NeutralVariant.shade70))
                      ])),
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 0.02.height),
                  height: 0.1.height,
                  width: 0.95.width,
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border:
                        Border.all(color: ColorConst.NeutralVariant.shade60),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          text: 'Current Price\n',
                          style: labelLarge,
                          children: [
                            TextSpan(text: '420.69 ', style: labelLarge),
                            WidgetSpan(
                                child: SvgPicture.asset(
                              '${PathConst.HOME_PAGE}svg/xtz.svg',
                              height: 20,
                            )),
                            TextSpan(text: '\n\$596.21', style: labelLarge),
                          ])),
                ),
              ),
              ListTile(
                leading: const CircleAvatar(),
                title: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: 'Created By ',
                        style: labelLarge,
                        children: [
                          TextSpan(
                              text: tz1Shortner(
                                  'tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
                              style: labelSmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade70))
                        ])),
              ),
              ListTile(
                leading: const CircleAvatar(),
                title: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: 'Created By ',
                        style: labelLarge,
                        children: [
                          TextSpan(
                              text: tz1Shortner(
                                  'tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
                              style: labelSmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade70))
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
                    tabs: const [
                      Tab(
                        child: Text('Details'),
                      ),
                      Tab(
                        child: Text('Item Activity'),
                      ),
                    ]),
              ),
              SizedBox(
                height: 0.4.height,
                child: TabBarView(children: [
                  Column(
                    children: [
                      ExpansionTile(
                          title: Text(
                            'About Collection',
                            style: labelMedium,
                          ),
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.sp),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 10,
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
                                    style: bodySmall,
                                  )
                                ],
                              ),
                            )
                          ]),
                      const Divider(
                        color: Colors.white,
                        indent: 15,
                        endIndent: 15,
                      ),
                      ExpansionTile(
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white,
                          title: Text(
                            'Details',
                            style: labelMedium,
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
                                              style: bodySmall)
                                        ])),
                                const Spacer(),
                                RichText(
                                    textAlign: TextAlign.end,
                                    text: TextSpan(
                                        text: 'Ox495f...7b5e',
                                        style: labelSmall,
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.open_in_new,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                              text: '\n13951734451',
                                              style: bodySmall)
                                        ])),
                                0.04.hspace,
                              ],
                            ),
                          ]),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Column(
                      children: [
                        0.01.vspace,
                        Material(
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.2),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ListTile(
                            dense: true,
                            leading: const CircleAvatar(),
                            title: Text(
                              'Transfer',
                              style: labelMedium,
                            ),
                            subtitle: Text(
                              'to ${tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx')}',
                              style: labelMedium,
                            ),
                            trailing: Text(
                              '1.5 hours ago',
                              style: labelMedium,
                            ),
                          ),
                        ),
                        0.01.vspace,
                        Material(
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.2),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: ListTile(
                            dense: true,
                            leading: const CircleAvatar(),
                            title: Text(
                              'Sale',
                              style: labelMedium,
                            ),
                            subtitle: Text(
                              'to ${tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx')}',
                              style: labelMedium,
                            ),
                            trailing: RichText(
                              textAlign: TextAlign.end,
                              text: TextSpan(
                                text: '123 ',
                                style: labelMedium,
                                children: [
                                  WidgetSpan(
                                    child: SvgPicture.asset(
                                      '${PathConst.HOME_PAGE}svg/xtz.svg',
                                      height: 20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '\n2 days ago',
                                    style: labelMedium.copyWith(
                                        color:
                                            ColorConst.NeutralVariant.shade60),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
