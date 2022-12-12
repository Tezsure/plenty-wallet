import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/custom_packages/readmore/readmore.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/app/modules/custom_packages/timeago/timeago.dart'
    as timeago;
import 'package:share_plus/share_plus.dart';

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
  final _controller = Get.put(AccountSummaryController());
  String ipfsHost = "https://ipfs.io/ipfs";
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
                        height: 5.aR,
                        width: 36.aR,
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
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 16.aR,
                            )),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Share.share(
                                  'https://objkt.com/asset/${widget.nftModel!.fa!.contract}/${widget.nftModel!.tokenId}');
                            },
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 16.aR,
                            )),
                        IconButton(
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.cast_rounded,
                              color: Colors.white,
                              size: 16.aR,
                            )),
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
                                    right: 10.aR, bottom: 22.aR),
                                height: 36.aR,
                                width: 36.aR,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Transform.rotate(
                                  angle: pi / 180 * 135,
                                  child: Icon(
                                    Icons.code_outlined,
                                    size: 20.aR,
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
                      padding: EdgeInsets.only(left: 16.aR, right: 13.aR),
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
                                        fontSize: 11.aR,
                                        color:
                                            ColorConst.NeutralVariant.shade60)),
                                TextSpan(
                                    text: '${widget.nftModel!.name}\n',
                                    style: bodyLarge.copyWith(fontSize: 16.aR)),
                                WidgetSpan(
                                  child: ReadMoreText(
                                    widget.nftModel!.description == null
                                        ? ""
                                        : '${widget.nftModel!.description}',
                                    trimLines: 2,
                                    lessStyle: bodySmall.copyWith(
                                        fontSize: 12.aR,
                                        color: ColorConst.Primary),
                                    style: bodySmall.copyWith(
                                        color:
                                            ColorConst.NeutralVariant.shade60),
                                    colorClickableText: ColorConst.Primary,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: ' Show more',
                                    trimExpandedText: ' Show less',
                                    moreStyle: bodySmall.copyWith(
                                        fontSize: 12.aR,
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
                                                fontSize: 11.aR,
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
                                                fontSize: 11.aR,
                                                color: ColorConst
                                                    .NeutralVariant.shade70))
                                      ])),
                              RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: '${widget.nftModel!.supply}\n',
                                      style:
                                          labelLarge.copyWith(fontSize: 14.aR),
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
                              height: 100.aR,
                              width: 1.width,
                              padding: EdgeInsets.all(8.aR),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: ColorConst.NeutralVariant.shade60
                                        .withOpacity(0.2)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.aR),
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
                                                  : "${(widget.nftModel!.lowestAsk / 1e6)} ",
                                              style: headlineSmall.copyWith(
                                                  fontSize: 24.aR)),
                                          WidgetSpan(
                                              child: SvgPicture.asset(
                                            '${PathConst.HOME_PAGE}svg/xtz.svg',
                                            height: 20.aR,
                                          )),
                                          TextSpan(
                                              text: widget.nftModel
                                                              ?.lowestAsk ==
                                                          0 ||
                                                      widget.nftModel
                                                              ?.lowestAsk ==
                                                          null
                                                  ? '\n0'
                                                  : '\n\$${((widget.nftModel?.lowestAsk / 1e6) * _controller.xtzPrice.value).toStringAsFixed(2)}',
                                              style: labelSmall.copyWith(
                                                  fontSize: 11.aR,
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
                        padding: EdgeInsets.zero,
                        itemCount: widget.nftModel?.creators?.length ?? 0,
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: scrollController,
                        itemBuilder: ((context, index) {
                          var creator =
                              "https://services.tzkt.io/v1/avatars/${widget.nftModel!.creators![index].creatorAddress}";
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              foregroundImage: NetworkImage(creator),
                            ),
                            title: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: 'Created By ',
                                    style: labelSmall.copyWith(
                                        fontSize: 11.aR,
                                        color:
                                            ColorConst.NeutralVariant.shade60),
                                    children: [
                                      TextSpan(
                                          text: tz1Shortner(
                                              "${widget.nftModel!.creators![index].creatorAddress}"),
                                          style: labelMedium.copyWith(
                                              fontSize: 12.aR))
                                    ])),
                          );
                        })),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        foregroundImage: NetworkImage(
                            "https://services.tzkt.io/v1/avatars/${widget.nftModel!.holders!.first.holderAddress}"),
                      ),
                      title: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: 'Owned By ',
                              style: labelSmall.copyWith(
                                  fontSize: 11.aR,
                                  color: ColorConst.NeutralVariant.shade60),
                              children: [
                                TextSpan(
                                    text: tz1Shortner(
                                        "${widget.nftModel!.holders!.first.holderAddress}"),
                                    style:
                                        labelMedium.copyWith(fontSize: 12.aR))
                              ])),
                    ),
                    _buildTabs(),
                    SizedBox(
                      height: isExpanded ? 0.4.height : 0.25.height,
                      child: TabBarView(children: [
                        _buildDetailsTab(scrollController),
                        // Sliver List Builder
                        _buildActivityTab(scrollController),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  SizedBox _buildTabs() {
    return SizedBox(
      width: 1.width,
      height: 0.1.height,
      child: TabBar(
          padding: EdgeInsets.all(8.aR),
          enableFeedback: true,
          isScrollable: true,
          indicatorColor: ColorConst.Primary,
          unselectedLabelColor: ColorConst.NeutralVariant.shade60,
          unselectedLabelStyle: labelLarge.copyWith(fontSize: 14.aR),
          labelColor: ColorConst.Primary.shade95,
          labelStyle: labelLarge.copyWith(fontSize: 14.aR),
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
    );
  }

  CustomScrollView _buildActivityTab(ScrollController scrollController) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 8.sp),
              child: Material(
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: SvgPicture.asset(
                      widget.nftModel!.events![index].eventType
                              .toString()
                              .contains("transfer")
                          ? '${PathConst.SVG}bi_arrow.svg'
                          : '${PathConst.SVG}cart.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(
                    widget.nftModel!.events![index].eventType
                            .toString()
                            .contains("transfer")
                        ? "Transfer"
                        : "Sale",
                    style: labelMedium.copyWith(fontSize: 12.aR),
                  ),
                  subtitle: Text(
                    'to ${tz1Shortner('${widget.nftModel!.events![index].recipientAddress}')}',
                    style: bodySmall.copyWith(
                        fontSize: 12.aR,
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                  //           ),
                  trailing: widget.nftModel!.events![index].price == null
                      ? Text(
                          timeago.format(DateTime.parse(
                              widget.nftModel!.events![index].timestamp!)),
                          style: labelSmall.copyWith(
                              color: ColorConst.NeutralVariant.shade60),
                        )
                      : RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                            text:
                                '${(widget.nftModel!.events![index].price / 1e6)} ',
                            style: labelSmall.copyWith(fontSize: 11.aR),
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: SvgPicture.asset(
                                  '${PathConst.HOME_PAGE}svg/xtz.svg',
                                  height: 12.aR,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '\n${timeago.format(DateTime.parse(widget.nftModel!.events![index].timestamp!))}',
                                style: labelSmall.copyWith(
                                    fontSize: 11.aR,
                                    color: ColorConst.NeutralVariant.shade60),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            childCount: widget.nftModel!.events!.length,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsTab(ScrollController scrollController) {
    final royality = ((widget.nftModel?.royalties?.last.decimals ?? 0) /
            (widget.nftModel?.royalties?.last.amount ?? 1)) *
        100;
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
              onExpansionChanged: (val) => setState(() {
                    isExpanded = val;
                  }),
              title: Text(
                'About Collection',
                style: labelSmall.copyWith(fontSize: 11.aR),
              ),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.sp, right: 13.sp),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 10.aR,
                              backgroundColor: Colors.white,
                              foregroundImage:
                                  NetworkImage("${widget.nftModel!.fa!.logo}")),
                          0.04.hspace,
                          Text(
                            "${widget.nftModel!.fa!.name}",
                            style: labelSmall.copyWith(fontSize: 11.aR),
                          ),
                        ],
                      ),
                      0.01.vspace,
                      Text(
                        widget.nftModel?.description ?? "",
                        style: bodySmall.copyWith(
                            fontSize: 12.aR,
                            color: ColorConst.NeutralVariant.shade60),
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
              onExpansionChanged: (val) => setState(() {
                    isExpanded = val;
                  }),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: Text(
                'Details',
                style: labelSmall.copyWith(fontSize: 11.aR),
              ),
              childrenPadding: EdgeInsets.only(left: 16.sp, right: 13.sp),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Token ID", style: bodySmall),
                    Text(
                      widget.nftModel?.tokenId ?? "",
                      style: bodySmall.copyWith(color: ColorConst.textGrey1),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Royality", style: bodySmall),

                    /// DUMMY
                    Text(
                      "${royality.toStringAsFixed(1)}%",
                      style: bodySmall.copyWith(color: ColorConst.textGrey1),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Minted", style: bodySmall),

                    /// DUMMY
                    Text(
                      DateFormat("MMM dd,yyyy")
                          .format(DateTime.parse(widget.nftModel!.timestamp!)),
                      style: bodySmall.copyWith(color: ColorConst.textGrey1),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Artifact", style: bodySmall),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          final String? hash = widget.nftModel?.artifactUri
                              ?.replaceAll("ipfs://", "");
                          final String img =
                              'https://assets.objkt.media/file/assets-003/$hash/artifact';
                          CommonFunctions.launchURL(img);
                        },
                        child: Row(
                          children: [
                            Text(
                              "CDN ",
                              style: labelMedium.copyWith(
                                  color: ColorConst.Primary),
                            ),
                            SvgPicture.asset(
                              '${PathConst.SETTINGS_PAGE}svg/external-link.svg',
                              color: ColorConst.Primary,
                              fit: BoxFit.fill,
                              height: 16.aR,
                            )
                          ],
                        )),
                    0.05.hspace,
                    GestureDetector(
                        onTap: () {
                          final String? hash = widget.nftModel?.artifactUri
                              ?.replaceAll("ipfs://", "");
                          final String img = '$ipfsHost/$hash';
                          CommonFunctions.launchURL(img);
                        },
                        child: Row(
                          children: [
                            Text(
                              "IPFS ",
                              style: labelMedium.copyWith(
                                  color: ColorConst.Primary),
                            ),
                            SvgPicture.asset(
                              '${PathConst.SETTINGS_PAGE}svg/external-link.svg',
                              color: ColorConst.Primary,
                              fit: BoxFit.fill,
                              height: 16.aR,
                            )
                          ],
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("MetaData", style: bodySmall),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          final String? hash = widget.nftModel?.metadata
                              ?.replaceAll("ipfs://", "");
                          final String img = '$ipfsHost/$hash';
                          CommonFunctions.launchURL(img);
                        },
                        child: Row(
                          children: [
                            Text(
                              "IPFS ",
                              style: labelMedium.copyWith(
                                  color: ColorConst.Primary),
                            ),
                            SvgPicture.asset(
                              '${PathConst.SETTINGS_PAGE}svg/external-link.svg',
                              color: ColorConst.Primary,
                              fit: BoxFit.fill,
                              height: 16.aR,
                            )
                          ],
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Contract address", style: bodySmall),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          final String? hash = widget.nftModel?.metadata
                              ?.replaceAll("ipfs://", "");
                          final String url = 'https://tzkt.io/$hash';
                          CommonFunctions.launchURL(url);
                        },
                        child: Row(
                          children: [
                            Text(
                              widget.nftModel?.faContract?.tz1Short() ?? "",
                              style: labelMedium.copyWith(
                                  color: ColorConst.Primary),
                            ),
                            SvgPicture.asset(
                              '${PathConst.SETTINGS_PAGE}svg/external-link.svg',
                              color: ColorConst.Primary,
                              fit: BoxFit.fill,
                              height: 16.aR,
                            )
                          ],
                        ))
                  ],
                ),
              ]),
        ],
      ),
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
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 25.aR,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
