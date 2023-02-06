import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_expansion_tile.dart';
import 'package:naan_wallet/app/modules/custom_packages/readmore/readmore.dart';
import 'package:naan_wallet/app/modules/import_wallet_page/widgets/custom_tab_indicator.dart';
import 'package:naan_wallet/app/modules/nft_gallery/view/cast_devices.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/app/modules/custom_packages/timeago/timeago.dart'
    as timeago;
import 'package:share_plus/share_plus.dart';

import '../../../../utils/constants/path_const.dart';
import '../../../../utils/utils.dart';
import '../../common_widgets/solid_button.dart';
import '../../dapp_browser/views/dapp_browser_view.dart';

class NFTDetailBottomSheet extends StatefulWidget {
  final GestureTapCallback? onBackTap;
  final NftTokenModel? nftModel;
  const NFTDetailBottomSheet({
    super.key,
    this.onBackTap,
    this.nftModel,
  });

  @override
  State<NFTDetailBottomSheet> createState() => _NFTDetailBottomSheetState();
}

class _NFTDetailBottomSheetState extends State<NFTDetailBottomSheet> {
  bool isExpanded = false;
  // late String imageUrl;
  final _controller = Get.put(AccountSummaryController());
  String ipfsHost = "https://ipfs.gcp.marigold.dev/ipfs";
  bool showButton = true;
  bool showFloating = true;
  bool isScrolling = false;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showButton = false;
        });
      }
    });
/*     Timer.periodic(const Duration(milliseconds: 1000), (c) {
      if (isScrolling == true) {
        setState(() {
          isScrolling = false;
        });
      }
    }); */
    // imageUrl = widget.nftModel!.artifactUri?.contains("data:image/svg+xml") ??
    //         false
    //     ? (widget.nftModel!.artifactUri ?? "")
    //     : "https://assets.objkt.media/file/assets-003/${widget.nftModel!.faContract}/${widget.nftModel!.tokenId.toString()}/thumb400";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      maxChildSize: 0.96,
      minChildSize: 0.6,
      builder: ((context, scrollController) => Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: showFloating
                ? AnimatedContainer(
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 350),
                    transform: Matrix4.identity()
                      ..translate(
                        0.0,
                        isScrolling ? 220.0.arP : 0,
                      ),
                    child: SolidButton(
                      height: 45.arP,
                      borderRadius: 40.arP,
                      width: 125.arP,
                      primaryColor: ColorConst.Primary,
                      onPressed: () {
                        final String? hash = widget.nftModel?.artifactUri
                            ?.replaceAll("ipfs://", "");
                        final String img = '$ipfsHost/$hash';
                        //CommonFunctions.launchURL(img);
                        Get.bottomSheet(
                          const DappBrowserView(),
                          barrierColor: Colors.white.withOpacity(0.09),
                          settings: RouteSettings(
                            arguments: img,
                          ),
                          isScrollControlled: true,
                        );
                      },
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "${PathConst.NFT_PAGE}svg/external-link.png",
                              height: 20.arP,
                              width: 20.arP,
                            ),
                            0.02.hspace,
                            Text(
                              "Open",
                              style: labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : null,
            body: NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                final ScrollDirection direction = notification.direction;
                if (direction == ScrollDirection.forward) {
                  isScrolling = false;
                } else if (direction == ScrollDirection.reverse) {
                  isScrolling = true;
                }
                setState(() {});
                return true;
              },
              child: DefaultTabController(
                length: 2,
                child: Container(
                  width: 1.width,
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      color: Colors.black),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        0.02.vspace,
                        Align(
                          alignment: Alignment.topCenter,
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
                            // IconButton(
                            //     onPressed: () {
                            //       Get.bottomSheet(const CastDevicesSheet());
                            //     },
                            //     padding: EdgeInsets.zero,
                            //     visualDensity: VisualDensity.compact,
                            //     icon: Icon(
                            //       Icons.cast_rounded,
                            //       color: Colors.white,
                            //       size: 16.aR,
                            //     )),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 0.02.height),
                          height: 0.5.height,
                          width: 1.width,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(FullScreenView(
                                  child: NFTImage(
                                nftTokenModel: widget.nftModel!,
                                boxFit: BoxFit.contain,
                              )));
                            },
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: SizedBox(
                                    height: 0.5.height,
                                    width: 1.width,
                                    child: NFTImage(
                                        nftTokenModel: widget.nftModel!),
                                  ),
                                ),
                                Visibility(
                                  visible: showButton,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: 10.aR, bottom: 22.aR),
                                      height: 36.aR,
                                      width: 36.aR,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8)),
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
                                ),
                              ],
                            ),
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
                                      text:
                                          '${widget.nftModel!.fa!.name ?? "N/A"}\n',
                                      style: TextStyle(
                                        fontSize: 12.arP,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF958E99),
                                        letterSpacing: 0.5.arP,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${widget.nftModel!.name}\n',
                                      style: TextStyle(
                                          fontSize: 16.arP,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFFFFFFF),
                                          letterSpacing: 0.5.arP,
                                          height: 1.5),
                                    ),
                                    /*         TextSpan(
                                        text: "  ",
                                        style: TextStyle(
                                          fontSize: 5.arP,
                                        )), */
                                    WidgetSpan(child: 0.03.vspace),
                                    WidgetSpan(
                                      child: ReadMoreText(
                                        widget.nftModel!.description == null
                                            ? ""
                                            : '${widget.nftModel!.description}',
                                        trimLines: 2,
                                        lessStyle: bodySmall.copyWith(
                                            fontSize: 12.aR,
                                            color: ColorConst.Primary),
                                        style: TextStyle(
                                            fontSize: 12.arP,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF958E99),
                                            letterSpacing: 0.5.arP,
                                            height: 1.6),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text:
                                              '${widget.nftModel!.holders!.fold<int>(
                                            0,
                                            (previousValue, element) =>
                                                element.quantity! +
                                                previousValue,
                                          )}\n',
                                          style: labelLarge,
                                          children: [
                                            TextSpan(
                                                text: 'Owned',
                                                style: labelSmall.copyWith(
                                                    fontSize: 11.aR,
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade70))
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
                                                        .NeutralVariant
                                                        .shade70))
                                          ])),
                                  RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: '${widget.nftModel!.supply}\n',
                                          style: labelLarge.copyWith(
                                              fontSize: 14.aR),
                                          children: [
                                            TextSpan(
                                                text: 'Editions',
                                                style: labelSmall.copyWith(
                                                    color: ColorConst
                                                        .NeutralVariant
                                                        .shade70))
                                          ])),
                                ],
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0.02.height),
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
                                                          .NeutralVariant
                                                          .shade60)),
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
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: creator,
                                    ),
                                  ),
                                ),
                                title: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: 'Created By ',
                                        style: labelSmall.copyWith(
                                            fontSize: 11.aR,
                                            color: ColorConst
                                                .NeutralVariant.shade60),
                                        children: [
                                          TextSpan(
                                              text: tz1Shortner(
                                                  "${widget.nftModel!.creators![index].creatorAddress}"),
                                              style: labelMedium.copyWith(
                                                  fontSize: 12.aR))
                                        ])),
                              );
                            })),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.arP),
                          child: const Divider(
                            color: ColorConst.darkGrey,
                            thickness: 1,
                          ),
                        ),
                        if (widget.nftModel!.holders?.isNotEmpty ?? false)
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
                                        color:
                                            ColorConst.NeutralVariant.shade60),
                                    children: [
                                      TextSpan(
                                          text: tz1Shortner(
                                              "${widget.nftModel!.holders!.first.holderAddress}"),
                                          style: labelMedium.copyWith(
                                              fontSize: 12.aR))
                                    ])),
                          ),
                        _buildTabs(),
                        SizedBox(
                          height: 0.4.height,
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
              ),
            ),
          )),
    );
  }

  SizedBox _buildTabs() {
    return SizedBox(
      width: 1.width,
      height: 0.06.height,
      child: TabBar(
          padding: EdgeInsets.symmetric(horizontal: 8.aR, vertical: 4.aR),
          indicatorWeight: 4.aR,
          indicatorSize: TabBarIndicatorSize.tab,
          enableFeedback: true,
          isScrollable: true,
          indicator: MaterialIndicator(
            color: ColorConst.Primary,
            height: 4.aR,
            topLeftRadius: 4.aR,
            topRightRadius: 4.aR,
            strokeWidth: 4.aR,
          ),
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
              padding:
                  EdgeInsets.only(left: 10.arP, right: 10.arP, bottom: 8.arP),
              child: Material(
                color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  // dense: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: SvgPicture.asset(
                        icon(widget.nftModel!.events![index]),
                        fit: BoxFit.contain),
                  ),
                  title: Text(
                    widget.nftModel!.events![index].marketplaceEventType
                            ?.split("_")
                            .join(" ")
                            .capitalizeFirst ??
                        widget.nftModel!.events![index].eventType
                            ?.capitalizeFirst ??
                        "Sale",
                    style: labelMedium.copyWith(fontSize: 12.aR),
                  ),
                  subtitle:
                      widget.nftModel!.events![index].recipientAddress == null
                          ? null
                          : Text(
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

  String icon(Events event) {
    switch (event.eventType) {
      case "transfer":
        return '${PathConst.SVG}bi_arrow.svg';
      case "mint":
        return "assets/nft_page/svg/mint.svg";
      case "burn":
        return "assets/nft_page/svg/burn.svg";
      case "sale":
        return "assets/nft_page/svg/sale.svg";
      case "list_buy":
        return "assets/nft_page/svg/sale.svg";
      case "list_cancel":
        return "assets/nft_page/svg/cancel.svg";
      case "list_create":
        return "assets/nft_page/svg/create.svg";
      default:
        return '${PathConst.SVG}bi_arrow.svg';
    }
  }

  Widget _buildDetailsTab(ScrollController scrollController) {
    final royality = widget.nftModel?.royalties?.isEmpty ?? true
        ? 0
        : ((widget.nftModel?.royalties?.last.decimals ?? 0) /
                (widget.nftModel?.royalties?.last.amount ?? 1)) *
            100;
    var logo = widget.nftModel!.fa!.logo!;
    if (logo.startsWith("ipfs://")) {
      logo = "https://ipfs.io/ipfs/${logo.replaceAll("ipfs://", "")}";
    }
    if (logo.isEmpty && (widget.nftModel!.creators?.isNotEmpty ?? false)) {
      logo =
          "https://services.tzkt.io/v1/avatars/${widget.nftModel!.creators!.first.creatorAddress}";
    }
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NaanExpansionTile(
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
                  padding: EdgeInsets.only(left: 16.arP, right: 13.arP),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              height: 20,
                              width: 20,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: logo,
                                  memCacheHeight: 36,
                                  memCacheWidth: 36,
                                ),
                              )),
                          0.04.hspace,
                          Text(
                            widget.nftModel!.fa!.name ?? "N/A",
                            style: labelSmall.copyWith(fontSize: 11.aR),
                          ),
                        ],
                      ),
                      0.01.vspace,
                      Text(
                        widget.nftModel?.description ?? "N/A",
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
            endIndent: 14.arP,
            indent: 14.arP,
          ),
          NaanExpansionTile(
              onExpansionChanged: (val) => setState(() {
                    isExpanded = val;
                  }),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              title: Text(
                'Details',
                style: labelSmall.copyWith(fontSize: 11.aR),
              ),
              childrenPadding: EdgeInsets.only(left: 16.arP, right: 13.arP),
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
                .008.vspace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Royality", style: bodySmall),
                    Text(
                      "${royality.toStringAsFixed(1)}%",
                      style: bodySmall.copyWith(color: ColorConst.textGrey1),
                    )
                  ],
                ),
                .008.vspace,
                widget.nftModel!.timestamp != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Minted", style: bodySmall),
                          Text(
                            DateFormat("MMM dd,yyyy").format(
                                DateTime.parse(widget.nftModel!.timestamp!)),
                            style:
                                bodySmall.copyWith(color: ColorConst.textGrey1),
                          )
                        ],
                      )
                    : const SizedBox(),
                .008.vspace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Artifact", style: bodySmall),
                    const Spacer(),
                    InkWell(
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
                    InkWell(
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
                .008.vspace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("MetaData", style: bodySmall),
                    const Spacer(),
                    InkWell(
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
                .008.vspace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Contract address", style: bodySmall),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          final String? hash = widget.nftModel?.faContract
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
  final Widget child;
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
