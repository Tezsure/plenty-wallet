import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_models/nft_token_model.dart';

import 'package:plenty_wallet/app/modules/common_widgets/back_button.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/naan_expansion_tile.dart';
import 'package:plenty_wallet/app/modules/custom_packages/readmore/readmore.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/account_switch_widget/account_switch_widget.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/objkt_nft_widget/widgets/choose_payment_method.dart';
import 'package:plenty_wallet/app/modules/import_wallet_page/widgets/custom_tab_indicator.dart';

import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/constants/path_const.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/app/modules/common_widgets/nft_image.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/app/modules/custom_packages/timeago/timeago.dart'
    as timeago;
import 'package:plenty_wallet/utils/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_gql/simple_gql.dart';

import '../../common_widgets/solid_button.dart';
import '../../dapp_browser/views/dapp_browser_view.dart';

class CustomNFTDetailBottomSheet extends StatefulWidget {
  final GestureTapCallback? onBackTap;
  final int? pk;

  final String? prevPage;
  final String? nftUrl;
  final bool saveAddress;
  const CustomNFTDetailBottomSheet(
      {super.key,
      this.onBackTap,
      this.prevPage,
      this.pk,
      this.nftUrl,
      this.saveAddress = false});

  @override
  State<CustomNFTDetailBottomSheet> createState() =>
      _CustomNFTDetailBottomSheetState();
}

class _CustomNFTDetailBottomSheetState
    extends State<CustomNFTDetailBottomSheet> {
  bool isExpanded = false;
  // late String imageUrl;
  final _controller = Get.find<HomePageController>();
  String ipfsHost = ServiceConfig.ipfsUrl;
  String fxHash = "";
  bool showButton = false;
  bool isScrolling = false;
  bool showFloating = true;

  NftTokenModel? nftModel;

  getNFT() async {
    late final GQLResponse response;
    if (widget.pk != null) {
      response = await GQLClient(
        'https://data.objkt.com/v3/graphql',
      ).query(
        query: ServiceConfig.getNFTfromPkwithoutHolder,
        variables: {
          'pk': widget.pk,
        },
      );
    } else {
      List<String> mainUrl = widget.nftUrl
          .toString()
          .replaceFirst("https://objkt.com/asset/", '')
          .split("/");
      if (mainUrl[0].startsWith('KT1') || mainUrl[0].startsWith('kt1')) {
        response = await GQLClient(
          'https://data.objkt.com/v3/graphql',
        ).query(
          query: ServiceConfig.getNFTFromContractWithoutHolder,
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      } else {
        response = await GQLClient(
          'https://data.objkt.com/v3/graphql',
        ).query(
          query: ServiceConfig.getNFTFromCollectionWithoutHolder,
          variables: {'address': mainUrl[0], 'tokenId': mainUrl[1]},
        );
      }
    }

    NftTokenModel localNft = NftTokenModel.fromJson(response.data['token'][0]);

    var response1 = await GQLClient(
      'https://data.objkt.com/v3/graphql',
    ).query(
      query: r'''
                              query NftDetails($address: String!, $tokenId: String!) {
                                token(where: {token_id: {_eq: $tokenId}, fa_contract: {_eq: $address}}) {
                                  listings(limit: 1, order_by: {price: asc}, where: {status: {_eq: "active"}}) {
                                    bigmap_key
                                    price
                                    marketplace_contract
                                  }
                                }
                              }
                          ''',
      variables: {
        'address': localNft.fa!.contract,
        'tokenId': localNft.tokenId
      },
    );
    if (response1.data["token"][0]["listings"].length == 1 &&
        response1.data["token"][0]["listings"][0]["marketplace_contract"] ==
            "KT1WvzYHCNBvDSdwafTHv7nJ1dWmZ8GCYuuC") {
      showButton = true;
    } else {
      showButton = false;
    }

    setState(() {
      nftModel = localNft;
    });
  }

  @override
  void initState() {
    getNFT();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      prevPageName: widget.prevPage,
      bottomSheetHorizontalPadding: 0,
      height: AppConstant.naanBottomSheetHeight,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.arP),
        child: widget.prevPage == null
            ? null
            : backButton(
                ontap: () {
                  Navigator.pop(context);
                },
                lastPageName: widget.prevPage),
      ),
      title: "",
      action: Padding(
        padding: EdgeInsets.only(right: 16.arP),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BouncingWidget(
                onPressed: () {
                  Share.share(
                      'https://objkt.com/asset/${nftModel!.fa!.contract}/${nftModel!.tokenId}');
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 16.arP),
                  child: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 20.aR,
                  ),
                )),
            closeButton()
          ],
        ),
      ),
      bottomSheetWidgets: [
        0.02.vspace,
        SizedBox(
          height: AppConstant.naanBottomSheetChildHeight,
          child: _buildBody(widget.saveAddress),
        )
      ],
    );
  }

  Scaffold _buildBody(bool saveAddress) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: nftModel != null
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
                width: showButton ? 220.arP : 125.arP,
                primaryColor: ColorConst.Primary,
                disabledButtonColor: ColorConst.Primary,
                onPressed: null,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: BouncingWidget(
                          onPressed: () async {
                            if (isScrolling == false) {
                              setState(() {
                                isScrolling = true;
                              });
                              String? hash = nftModel?.artifactUri
                                  ?.replaceAll("ipfs://", "");
                              if (nftModel!.faContract ==
                                      "KT1U6EHmNxJTkvaWJ4ThczG4FSDaHC21ssvi" ||
                                  nftModel!.faContract ==
                                      "KT1KEa8z6vWXDJrVqtMrAeDVzsvxat3kHaCE") {
                                ipfsHost = ServiceConfig.ipfsUrl;
                                if (hash!.contains("fxhash")) {
                                  var x = hash.split("?");

                                  hash = "${x[0]}/?${x[1]}";
                                }
                              }

                              final String img = '$ipfsHost/$hash';
                              //CommonFunctions.launchURL(img);
                              await CommonFunctions.bottomSheet(
                                const DappBrowserView(),
                                fullscreen: true,
                                settings: RouteSettings(
                                  arguments: img,
                                ),
                              );
                              debugPrint("closed");
                              setState(() {
                                isScrolling = false;
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              showButton
                                  ? SizedBox(
                                      width: 4.arP,
                                    )
                                  : SizedBox(),
                              Image.asset(
                                "${PathConst.NFT_PAGE}svg/external-link.png",
                                height: 20.arP,
                                width: 20.arP,
                              ),
                              0.02.hspace,
                              Text(
                                "Open".tr,
                                style: labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      showButton
                          ? Expanded(
                              child: BouncingWidget(
                                onPressed: () {
                                  CommonFunctions.bottomSheet(
                                    AccountSwitch(
                                      title: "Buy NFT",
                                      isAddressSave: saveAddress,
                                      subtitle:
                                          'This module will be powered by wert.io and you will be using wert’s interface.',
                                      onNext: ({String senderAddress = ""}) {
                                        CommonFunctions.bottomSheet(
                                          ChoosePaymentMethod(
                                            senderAddress: saveAddress
                                                ? senderAddress
                                                : "",
                                          ),
                                          settings: RouteSettings(
                                            arguments:
                                                "https://objkt.com/asset/${nftModel!.fa!.contract}/${nftModel!.tokenId}",
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
/*                                     SizedBox(
                                      width: 16.arP,
                                    ), */
                                    SvgPicture.asset(
                                      "${PathConst.HOME_PAGE}svg/plus.svg",
                                      height: 20.arP,
                                      width: 20.arP,
                                    ),
                                    0.02.hspace,
                                    Text(
                                      "Buy".tr,
                                      style: labelLarge,
                                    ),
                                    SizedBox(
                                      width: 4.arP,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
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
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10.arP)),
                color: Colors.black),
            child: SingleChildScrollView(
              // controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nftModel == null
                      ? Padding(
                          padding: EdgeInsets.only(
                              top:
                                  AppConstant.naanBottomSheetChildHeight / 2.5),
                          child: Center(
                            child: CupertinoActivityIndicator(
                                radius: 15.arP, color: ColorConst.Primary),
                          ))
                      : Column(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.symmetric(vertical: 0.02.height),
                              height: 0.5.height,
                              width: 1.width,
                              child: GestureDetector(
                                onTap: () {
                                  AppConstant.hapticFeedback();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FullScreenView(
                                                  child: NFTImage(
                                                nftTokenModel: nftModel!,
                                                boxFit: BoxFit.contain,
                                              ))));
                                  // Get.to(FullScreenView(
                                  //     child: NFTImage(
                                  //   nftTokenModel: nftModel!,
                                  //   boxFit: BoxFit.contain,
                                  // )));
                                },
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: SizedBox(
                                        height: 0.5.height,
                                        width: 1.width,
                                        child:
                                            NFTImage(nftTokenModel: nftModel!),
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
                              padding:
                                  EdgeInsets.only(left: 16.aR, right: 13.aR),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${nftModel!.fa!.name ?? "N/A"}\n',
                                          style: TextStyle(
                                            fontSize: 12.arP,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF958E99),
                                            letterSpacing: 0.5.arP,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${nftModel!.name}\n',
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
                                            nftModel!.description == null
                                                ? ""
                                                : '${nftModel!.description}',
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
                                            colorClickableText:
                                                ColorConst.Primary,
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
                                                  '${nftModel!.holders!.fold<int>(
                                                0,
                                                (previousValue, element) =>
                                                    element.quantity! +
                                                    previousValue,
                                              )}\n',
                                              style: labelLarge,
                                              children: [
                                                TextSpan(
                                                    text: 'Owned'.tr,
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
                                                  '${nftModel!.holders!.length}\n',
                                              style: labelLarge,
                                              children: [
                                                TextSpan(
                                                    text: 'Owners'.tr,
                                                    style: labelSmall.copyWith(
                                                        fontSize: 11.aR,
                                                        color: ColorConst
                                                            .NeutralVariant
                                                            .shade70))
                                              ])),
                                      RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              text: '${nftModel!.supply}\n',
                                              style: labelLarge.copyWith(
                                                  fontSize: 14.aR),
                                              children: [
                                                TextSpan(
                                                    text: 'Editions'.tr,
                                                    style: labelSmall.copyWith(
                                                        color: ColorConst
                                                            .NeutralVariant
                                                            .shade70))
                                              ])),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.arP,
                                  ),
/*                                   Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: SolidButton(
                                        primaryColor: Colors.black,
                                        // borderColor: ColorConst.Primary.shade60,
                                        borderColor: const Color(0xFFE8A2B9),
                                        borderWidth: 1.5,

                                        onPressed: () async {
                                          String? hash = nftModel?.artifactUri
                                              ?.replaceAll("ipfs://", "");
                                          if (nftModel!.faContract ==
                                                  "KT1U6EHmNxJTkvaWJ4ThczG4FSDaHC21ssvi" ||
                                              nftModel!.faContract ==
                                                  "KT1KEa8z6vWXDJrVqtMrAeDVzsvxat3kHaCE") {
                                            ipfsHost = ServiceConfig.ipfsUrl;
                                            if (hash!.contains("fxhash")) {
                                              var x = hash.split("?");

                                              hash = "${x[0]}/?${x[1]}";
                                            }
                                          }

                                          final String img = '$ipfsHost/$hash';
                                          //CommonFunctions.launchURL(img);
                                          await CommonFunctions.bottomSheet(
                                            const DappBrowserView(),
                                            fullscreen: true,
                                            settings: RouteSettings(
                                              arguments: img,
                                            ),
                                          );
                                        },

                                        title: "Open".tr,
                                        titleStyle: const TextStyle(
                                            color: Color(0xFFE8A2B9)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.arP,
                                  ), */
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 0.02.height),
                                      width: 1.width,
                                      padding: EdgeInsets.all(8.aR),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: ColorConst
                                                .NeutralVariant.shade60
                                                .withOpacity(0.2)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.aR),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                    text:
                                                        '${'Current Price'.tr}\n',
                                                    style: labelSmall.copyWith(
                                                        color: ColorConst
                                                            .NeutralVariant
                                                            .shade60),
                                                    children: [
                                                      TextSpan(
                                                          text: nftModel!
                                                                      .lowestAsk ==
                                                                  null
                                                              ? "0 "
                                                              : "${(nftModel!.lowestAsk / 1e6)} ",
                                                          style: headlineSmall
                                                              .copyWith(
                                                                  fontSize:
                                                                      24.aR)),
                                                      WidgetSpan(
                                                          child:
                                                              SvgPicture.asset(
                                                        '${PathConst.HOME_PAGE}svg/xtz.svg',
                                                        height: 20.aR,
                                                      )),
                                                      TextSpan(
                                                          text: nftModel?.lowestAsk ==
                                                                      0 ||
                                                                  nftModel?.lowestAsk ==
                                                                      null
                                                              ? '\n0'
                                                              : '\n${double.parse(((nftModel?.lowestAsk / 1e6) * _controller.xtzPrice.value).toString()).roundUpDollar(_controller.xtzPrice.value)}',
                                                          style: labelSmall.copyWith(
                                                              fontSize: 11.aR,
                                                              color: ColorConst
                                                                  .NeutralVariant
                                                                  .shade60)),
                                                    ])),
                                            !showButton
                                                ? SizedBox(
                                                    height: 12.arP,
                                                  )
                                                : SizedBox(),
                                            !showButton
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "NFT is not listed. You can offer to buy this NFT for a specific price on objkt.com",
                                                        style: bodySmall.copyWith(
                                                            color: const Color(
                                                                0xff958E99)),
                                                      ),
                                                      SizedBox(
                                                        height: 12.arP,
                                                      ),
                                                      SolidButton(
                                                        onPressed: () {
                                                          CommonFunctions
                                                              .bottomSheet(
                                                            const DappBrowserView(),
                                                            fullscreen: true,
                                                            settings:
                                                                RouteSettings(
                                                              arguments:
                                                                  "https://objkt.com/asset/${nftModel!.fa!.contract}/${nftModel!.tokenId}",
                                                            ),
                                                          );
                                                        },
                                                        title:
                                                            "View on objkt.com"
                                                                .tr,
                                                      )
                                                    ],
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: nftModel?.creators?.length ?? 0,
                                shrinkWrap: true,
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                // controller: scrollController,
                                itemBuilder: ((context, index) {
                                  var creator =
                                      "https://services.tzkt.io/v1/avatars/${nftModel!.creators![index].creatorAddress}";
                                  return BouncingWidget(
                                    onPressed: () {
                                      CommonFunctions.bottomSheet(
                                          DappBrowserView(),
                                          fullscreen: true,
                                          settings: RouteSettings(
                                              arguments:
                                                  "https://objkt.com/profile/${nftModel!.creators![index].creatorAddress}"));
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: creator,
                                          ),
                                        ),
                                      ),
                                      title: Row(
                                        children: [
                                          RichText(
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                  text: 'Created By '.tr,
                                                  style: labelSmall.copyWith(
                                                      fontSize: 11.aR,
                                                      color: ColorConst
                                                          .NeutralVariant
                                                          .shade60),
                                                  children: [
                                                    TextSpan(
                                                        text: tz1Shortner(
                                                            "${nftModel!.creators![index].creatorAddress}"),
                                                        style: labelMedium
                                                            .copyWith(
                                                                fontSize:
                                                                    12.aR))
                                                  ])),
                                          SizedBox(
                                            width: 8.arP,
                                          ),
                                          Image.asset(
                                            "${PathConst.NFT_PAGE}svg/external-link.png",
                                            height: 16.arP,
                                            width: 16.arP,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.arP),
                              child: const Divider(
                                color: ColorConst.darkGrey,
                                thickness: 1,
                              ),
                            ),
                            if (nftModel!.holders?.isNotEmpty ?? false)
                              BouncingWidget(
                                onPressed: () {
                                  CommonFunctions.bottomSheet(
                                      const DappBrowserView(),
                                      fullscreen: true,
                                      settings: RouteSettings(
                                          arguments:
                                              "https://objkt.com/profile/${nftModel!.holders!.first.holderAddress}/owned"));
                                },
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    foregroundImage: NetworkImage(
                                        "https://services.tzkt.io/v1/avatars/${nftModel!.holders!.first.holderAddress}"),
                                  ),
                                  title: Row(
                                    children: [
                                      RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                              text: 'Owned By '.tr,
                                              style: labelSmall.copyWith(
                                                  fontSize: 11.aR,
                                                  color: ColorConst
                                                      .NeutralVariant.shade60),
                                              children: [
                                                TextSpan(
                                                    text: tz1Shortner(
                                                        "${nftModel!.holders!.first.holderAddress}"),
                                                    style: labelMedium.copyWith(
                                                        fontSize: 12.aR))
                                              ])),
                                      SizedBox(
                                        width: 8.arP,
                                      ),
                                      Image.asset(
                                        "${PathConst.NFT_PAGE}svg/external-link.png",
                                        height: 16.arP,
                                        width: 16.arP,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            _buildTabs(),
                            SizedBox(
                              height: 0.4.height,
                              child: TabBarView(children: [
                                _buildDetailsTab(),
                                // Sliver List Builder
                                _buildActivityTab(),
                              ]),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
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
          tabs: [
            Tab(
              child: Text(
                'Details'.tr,
              ),
            ),
            Tab(
              child: Text(
                'Item Activity'.tr,
              ),
            ),
          ]),
    );
  }

  CustomScrollView _buildActivityTab() {
    return CustomScrollView(
      // controller: scrollController,
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
                    child: SvgPicture.asset(icon(nftModel!.events![index]),
                        fit: BoxFit.contain),
                  ),
                  title: Text(
                    nftModel!.events![index].marketplaceEventType
                            ?.split("_")
                            .join(" ")
                            .capitalizeFirst ??
                        nftModel!.events![index].eventType?.capitalizeFirst ??
                        "Sale",
                    style: labelMedium.copyWith(fontSize: 12.aR),
                  ),
                  subtitle: nftModel!.events![index].recipientAddress == null
                      ? null
                      : Text(
                          'to ${tz1Shortner('${nftModel!.events![index].recipientAddress}')}',
                          style: bodySmall.copyWith(
                              fontSize: 12.aR,
                              color: ColorConst.NeutralVariant.shade60),
                        ),
                  //           ),
                  trailing: nftModel!.events![index].price == null
                      ? Text(
                          timeago.format(DateTime.parse(
                              nftModel!.events![index].timestamp!)),
                          style: labelSmall.copyWith(
                              color: ColorConst.NeutralVariant.shade60),
                        )
                      : RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                            text: '${(nftModel!.events![index].price / 1e6)} ',
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
                                    '\n${timeago.format(DateTime.parse(nftModel!.events![index].timestamp!))}',
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
            childCount: nftModel!.events!.length,
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

  Widget _buildDetailsTab() {
    final royality = nftModel?.royalties?.isEmpty ?? true
        ? 0
        : ((nftModel?.royalties?.last.decimals ?? 0) /
                (nftModel?.royalties?.last.amount ?? 1)) *
            100;
    var logo = nftModel!.fa!.logo!;
    if (logo.startsWith("ipfs://")) {
      logo = "https://ipfs.io/ipfs/${logo.replaceAll("ipfs://", "")}";
    }
    if (logo.isEmpty && (nftModel!.creators?.isNotEmpty ?? false)) {
      logo =
          "https://services.tzkt.io/v1/avatars/${nftModel!.creators!.first.creatorAddress}";
    }
    return SingleChildScrollView(
      // controller: scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NaanExpansionTile(
              onExpansionChanged: (val) => setState(() {
                    isExpanded = val;
                  }),
              title: Text(
                'About Collection'.tr,
                style: labelSmall.copyWith(fontSize: 11.aR),
              ),
              iconColor: Colors.white,
              collapsedIconColor: Colors.white,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.arP, right: 13.arP),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            nftModel!.fa!.name ?? "N/A",
                            style: labelSmall.copyWith(fontSize: 11.aR),
                          ),
                        ],
                      ),
                      0.01.vspace,
                      Text(
                        nftModel?.description ?? "N/A",
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
                'Details'.tr,
                style: labelSmall.copyWith(fontSize: 11.aR),
              ),
              childrenPadding: EdgeInsets.only(left: 16.arP, right: 13.arP),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Token ID".tr, style: bodySmall),
                    Text(
                      nftModel?.tokenId ?? "",
                      style: bodySmall.copyWith(color: ColorConst.textGrey1),
                    )
                  ],
                ),
                .008.vspace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Royality".tr, style: bodySmall),
                    Text(
                      "${royality.toStringAsFixed(1)}%",
                      style: bodySmall.copyWith(color: ColorConst.textGrey1),
                    )
                  ],
                ),
                .008.vspace,
                nftModel!.timestamp != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Minted".tr, style: bodySmall),
                          Text(
                            DateFormat("MMM dd,yyyy")
                                .format(DateTime.parse(nftModel!.timestamp!)),
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
                    Text("Artifact".tr, style: bodySmall),
                    const Spacer(),
                    BouncingWidget(
                        onPressed: () {
                          final String? hash =
                              nftModel?.artifactUri?.replaceAll("ipfs://", "");
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
                    BouncingWidget(
                        onPressed: () {
                          final String? hash =
                              nftModel?.artifactUri?.replaceAll("ipfs://", "");
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
                    Text("MetaData".tr, style: bodySmall),
                    const Spacer(),
                    BouncingWidget(
                        onPressed: () {
                          final String? hash =
                              nftModel?.metadata?.replaceAll("ipfs://", "");
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
                    Text("Contract address".tr, style: bodySmall),
                    const Spacer(),
                    InkWell(
                        onTap: () {
                          final String? hash =
                              nftModel?.faContract?.replaceAll("ipfs://", "");
                          final String url = 'https://tzkt.io/$hash';
                          CommonFunctions.launchURL(url);
                        },
                        child: Row(
                          children: [
                            Text(
                              nftModel?.faContract?.tz1Short() ?? "",
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
    return NaanBottomSheet(
        title: "",
        prevPageName: "Back",
        bottomSheetHorizontalPadding: 0,
        height: AppConstant.naanBottomSheetHeight,
        action: Padding(
          padding: EdgeInsets.only(right: 16.arP),
          child: closeButton(),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 16.arP),
          child: backButton(
              ontap: () => Navigator.pop(context), lastPageName: "Back"),
        ),
        bottomSheetWidgets: [
          SizedBox(
            height: AppConstant.naanBottomSheetChildHeight,
            child: Column(
              // alignment: Alignment.topLeft,
              children: [
                Expanded(
                  child: Stack(
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
                ),
              ],
            ),
          ),
        ]);
  }
}
