import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/custom_packages/readmore/readmore.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/app/modules/custom_packages/timeago/timeago.dart'
    as timeago;

import '../../../../../../utils/constants/path_const.dart';
import '../../../../../../utils/utils.dart';

class NFTSummaryBottomSheet extends StatefulWidget {
  final GestureTapCallback? onBackTap;
  final NftTokenModel? nftModel;
  const NFTSummaryBottomSheet({
    super.key,
    this.onBackTap,
    this.nftModel,
  });

  @override
  State<NFTSummaryBottomSheet> createState() => _NFTSummaryBottomSheetState();
}

class _NFTSummaryBottomSheetState extends State<NFTSummaryBottomSheet> {
  bool isExpanded = false;
  late String imageUrl;
  final _controller = Get.find<AccountSummaryController>();

  @override
  void initState() {
    imageUrl =
        "https://assets.objkt.media/file/assets-003/${widget.nftModel!.faContract}/${widget.nftModel!.tokenId.toString()}/thumb400";
    super.initState();
  }

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
                  // gradient: GradConst.GradientBackground,
                  color: Colors.black),
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
                            onPressed: widget.onBackTap,
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
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(FullScreenView(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ));
                            },
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
                                    text: '${widget.nftModel!.fa!.name}\n',
                                    style: labelSmall.copyWith(
                                        color:
                                            ColorConst.NeutralVariant.shade60)),
                                TextSpan(
                                    text: '${widget.nftModel!.name}\n',
                                    style: bodyLarge),
                                WidgetSpan(
                                  child: ReadMoreText(
                                    widget.nftModel!.description == null
                                        ? ""
                                        : '${widget.nftModel!.description}',
                                    trimLines: 2,
                                    lessStyle: bodySmall.copyWith(
                                        color: ColorConst.Primary),
                                    style: bodySmall.copyWith(
                                        color:
                                            ColorConst.NeutralVariant.shade60),
                                    colorClickableText: ColorConst.Primary,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: ' Show more',
                                    trimExpandedText: ' Show less',
                                    moreStyle: bodySmall.copyWith(
                                        color: ColorConst.Primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          0.02.vspace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text:
                                          '${widget.nftModel!.holders!.fold<int>(
                                        0,
                                        (previousValue, element) =>
                                            element.quantity! + previousValue,
                                      )}\n',
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
                                      text:
                                          '${widget.nftModel!.holders!.length}\n',
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
                                      text: '${widget.nftModel!.supply}\n',
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
                                              text: widget.nftModel!
                                                          .lowestAsk ==
                                                      null
                                                  ? "0 "
                                                  : "${widget.nftModel!.lowestAsk} ",
                                              style: headlineSmall),
                                          WidgetSpan(
                                              child: SvgPicture.asset(
                                            '${PathConst.HOME_PAGE}svg/xtz.svg',
                                            height: 20,
                                          )),
                                          TextSpan(
                                              text: widget.nftModel
                                                              ?.lowestAsk ==
                                                          0 ||
                                                      widget.nftModel
                                                              ?.lowestAsk ==
                                                          null
                                                  ? '\n0'
                                                  : '\n\$${(widget.nftModel?.lowestAsk * _controller.xtzPrice.value).toStringAsFixed(2)}',
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
                    ListView.builder(
                        itemCount: widget.nftModel?.creators?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                    '${PathConst.TEMP}nft_summary${Random().nextInt(2) + 1}.png'),
                              ),
                              title: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      text: 'Created By ',
                                      style: labelSmall.copyWith(
                                          color: ColorConst
                                              .NeutralVariant.shade60),
                                      children: [
                                        TextSpan(
                                            text: tz1Shortner(
                                                "${widget.nftModel!.creators![index].creatorAddress}"),
                                            style: labelMedium)
                                      ])),
                            ))),
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
                    SizedBox(
                      height: isExpanded ? 0.4.height : 0.25.height,
                      child: TabBarView(children: [
                        Column(
                          children: [
                            ExpansionTile(
                                onExpansionChanged: (val) => isExpanded = val,
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
                                                backgroundColor: Colors.white,
                                                foregroundImage: NetworkImage(
                                                    "${widget.nftModel!.fa!.logo}")),
                                            0.04.hspace,
                                            Text(
                                              "${widget.nftModel!.fa!.name}",
                                              style: labelSmall,
                                            ),
                                          ],
                                        ),
                                        0.01.vspace,
                                        Text(
                                          ' Donec lectus nibh, consectetur vitae dolor ac, finibus suscipit quam. Nunc at nunc turpis. Donec gradvida',
                                          style: bodySmall.copyWith(
                                              color: ColorConst
                                                  .NeutralVariant.shade60),
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
                                onExpansionChanged: (val) => isExpanded = val,
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
                                                  color: ColorConst.Primary),
                                              children: [
                                                const WidgetSpan(
                                                  child: Icon(
                                                    Icons.open_in_new,
                                                    size: 14,
                                                    color: ColorConst.Primary,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        '\n${widget.nftModel!.tokenId}',
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
                        // Sliver List Builder
                        CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.sp,
                                            right: 10.sp,
                                            bottom: 8.sp),
                                        child: Material(
                                          color: ColorConst
                                              .NeutralVariant.shade60
                                              .withOpacity(0.2),
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: ListTile(
                                            dense: true,
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: SvgPicture.asset(
                                                widget.nftModel!.events![index]
                                                        .eventType!
                                                        .contains("transfer")
                                                    ? '${PathConst.SVG}bi_arrow.svg'
                                                    : '${PathConst.SVG}cart.svg',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            title: Text(
                                              widget.nftModel!.events![index]
                                                      .eventType!
                                                      .contains("transfer")
                                                  ? "Transfer"
                                                  : "Sale",
                                              style: labelMedium,
                                            ),
                                            subtitle: Text(
                                              'to ${tz1Shortner('${widget.nftModel!.events![index].recipientAddress}')}',
                                              style: bodySmall.copyWith(
                                                  color: ColorConst
                                                      .NeutralVariant.shade60),
                                            ),
                                            //           ),
                                            trailing: widget.nftModel!
                                                        .events![index].price ==
                                                    null
                                                ? Text(
                                                    timeago.format(
                                                        DateTime.parse(widget
                                                            .nftModel!
                                                            .events![index]
                                                            .timestamp!)),
                                                    style: labelSmall.copyWith(
                                                        color: ColorConst
                                                            .NeutralVariant
                                                            .shade60),
                                                  )
                                                : RichText(
                                                    textAlign: TextAlign.end,
                                                    text: TextSpan(
                                                      text:
                                                          '${widget.nftModel!.events![index].price} ',
                                                      style: labelSmall,
                                                      children: [
                                                        WidgetSpan(
                                                          alignment:
                                                              PlaceholderAlignment
                                                                  .middle,
                                                          child:
                                                              SvgPicture.asset(
                                                            '${PathConst.HOME_PAGE}svg/xtz.svg',
                                                            height: 12.sp,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '\n${timeago.format(DateTime.parse(widget.nftModel!.events![index].timestamp!))}',
                                                          style: labelSmall.copyWith(
                                                              color: ColorConst
                                                                  .NeutralVariant
                                                                  .shade60),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                  childCount: widget.nftModel!.events!.length),
                            ),
                          ],
                        ),

                        // ListView.builder(
                        //   controller: scrollController,
                        //   primary: false,
                        //   padding: EdgeInsets.all(10.sp),
                        //   itemCount: widget.nftModel!.events!.length,
                        //   itemBuilder: ((context, index) => Padding(
                        //         padding: EdgeInsets.only(bottom: 6.sp),
                        //         child: Material(
                        //           color: ColorConst.NeutralVariant.shade60
                        //               .withOpacity(0.2),
                        //           shape: const RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.all(
                        //                   Radius.circular(10))),
                        //           child: ListTile(
                        //             dense: true,
                        //             leading: CircleAvatar(
                        //               backgroundColor: Colors.transparent,
                        //               child: SvgPicture.asset(
                        //                 '${PathConst.SVG}bi_arrow.svg',
                        //                 fit: BoxFit.contain,
                        //               ),
                        //             ),
                        //             title: Text(
                        //               // "${widget.nftModel!.events!}",
                        //               'Transfer',
                        //               style: labelMedium,
                        //             ),
                        //             subtitle: Text(
                        //               'to ${tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx')}',
                        //               style: bodySmall.copyWith(
                        //                   color: ColorConst
                        //                       .NeutralVariant.shade60),
                        //             ),
                        //             trailing: Text(
                        //               '1.5 hours ago',
                        //               style: labelSmall.copyWith(
                        //                   color: ColorConst
                        //                       .NeutralVariant.shade60),
                        //             ),
                        //           ),
                        //         ),
                        //       )),
                        // ),

                        // Padding(
                        //   padding: EdgeInsets.all(10.sp),
                        //   child: Column(
                        //     children: [
                        //       0.01.vspace,
                        //       Material(
                        //         color: ColorConst.NeutralVariant.shade60
                        //             .withOpacity(0.2),
                        //         shape: const RoundedRectangleBorder(
                        //             borderRadius:
                        //                 BorderRadius.all(Radius.circular(10))),
                        //         child: ListTile(
                        //           dense: true,
                        //           leading: CircleAvatar(
                        //             backgroundColor: Colors.transparent,
                        //             child: SvgPicture.asset(
                        //               '${PathConst.SVG}bi_arrow.svg',
                        //               fit: BoxFit.contain,
                        //             ),
                        //           ),
                        //           title: Text(
                        //             // "${widget.nftModel!.events!}",
                        //             'Transfer',
                        //             style: labelMedium,
                        //           ),
                        //           subtitle: Text(
                        //             'to ${tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx')}',
                        //             style: bodySmall.copyWith(
                        //                 color:
                        //                     ColorConst.NeutralVariant.shade60),
                        //           ),
                        //           trailing: Text(
                        //             '1.5 hours ago',
                        //             style: labelSmall.copyWith(
                        //                 color:
                        //                     ColorConst.NeutralVariant.shade60),
                        //           ),
                        //         ),
                        //       ),
                        //       0.01.vspace,
                        //       Material(
                        //         color: ColorConst.NeutralVariant.shade60
                        //             .withOpacity(0.2),
                        //         shape: const RoundedRectangleBorder(
                        //             borderRadius:
                        //                 BorderRadius.all(Radius.circular(10))),
                        //         child: ListTile(
                        //           dense: true,
                        //           leading: CircleAvatar(
                        //             backgroundColor: Colors.transparent,
                        //             child: SvgPicture.asset(
                        //               '${PathConst.SVG}cart.svg',
                        //               fit: BoxFit.contain,
                        //             ),
                        //           ),
                        //           title: Text(
                        //             'Sale',
                        //             style: labelMedium,
                        //           ),
                        //           subtitle: Text(
                        //             'to ${tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx')}',
                        //             style: bodySmall.copyWith(
                        //                 color:
                        //                     ColorConst.NeutralVariant.shade60),
                        //           ),
                        //           trailing: RichText(
                        //             textAlign: TextAlign.end,
                        //             text: TextSpan(
                        //               text: '123 ',
                        //               style: labelSmall,
                        //               children: [
                        //                 WidgetSpan(
                        //                   alignment:
                        //                       PlaceholderAlignment.middle,
                        //                   child: SvgPicture.asset(
                        //                     '${PathConst.HOME_PAGE}svg/xtz.svg',
                        //                     height: 12.sp,
                        //                     color: Colors.white,
                        //                   ),
                        //                 ),
                        //                 TextSpan(
                        //                   text: '\n2 days ago',
                        //                   style: labelSmall.copyWith(
                        //                       color: ColorConst
                        //                           .NeutralVariant.shade60),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class FullScreenView extends StatelessWidget {
  final Image child;
  const FullScreenView({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 333),
                curve: Curves.fastOutSlowIn,
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4,
                  child: child,
                ),
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: MaterialButton(
                padding: const EdgeInsets.all(15),
                elevation: 0,
                color: Colors.black12,
                highlightElevation: 0,
                minWidth: double.minPositive,
                height: double.minPositive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: Get.back,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
