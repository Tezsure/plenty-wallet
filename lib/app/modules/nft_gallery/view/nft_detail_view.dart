import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/back_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import 'nft_image_viewer.dart';

class NFtDetailView extends StatefulWidget {
  final NftTokenModel nft;
  NFtDetailView({super.key, required this.nft});

  @override
  State<NFtDetailView> createState() => _NFtDetailViewState();
}

class _NFtDetailViewState extends State<NFtDetailView> {
  String ipfsHost = "https://ipfs.io/ipfs";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: NaanBottomSheet(
        // isScrollControlled: true,
        height: 0.95.height,
        bottomSheetHorizontalPadding: 0.arP,
        bottomSheetWidgets: [
          SizedBox(
            height: 0.92.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [backButton()],
                ),
                _buildImage(),
                0.02.vspace,
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.arP),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.nft.creators!.isEmpty
                                ? "N/A"
                                : widget.nft.creators![0].holder!.alias ??
                                    widget.nft.creators![0].holder!.address!
                                        .tz1Short(),
                            style:
                                bodySmall.copyWith(color: ColorConst.textGrey1),
                          ),
                          Text(
                            widget.nft.name ?? "",
                            style: titleMedium,
                          ),
                          0.012.vspace,
                          Text(
                            widget.nft.description ?? "",
                            style:
                                bodySmall.copyWith(color: ColorConst.textGrey1),
                          ),
                          _buildCount(),
                          _buildPrice(),
                          _buildAvatar(
                              address: widget.nft.creators?[0].creatorAddress
                                  ?.tz1Short(),
                              title: "Created by ",
                              avatar: ServiceConfig.allAssetsProfileImages[0]),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.arP),
                            child: const Divider(
                              color: ColorConst.darkGrey,
                              height: 1,
                            ),
                          ),
                          _buildAvatar(
                              address: widget.nft.holders?[0].holderAddress
                                  ?.tz1Short(),
                              title: "Owned by ",
                              avatar: ServiceConfig.allAssetsProfileImages[1]),
                          0.03.vspace,
                          _buildTabs(),
                          _buildTabView(),
                          0.2.vspace
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  int selectedTab = 0;

  List<String> tabs = ["Details", "Item activity"];

  Widget _buildTabView() {
    switch (selectedTab) {
      case 0:
        return _buildDetailsTab();
      case 1:
        return _buildActivityTab();
      default:
        return _buildDetailsTab();
    }
  }

  Widget _buildDetailsTab() {
    final royality = ((widget.nft.royalties?.last.decimals ?? 0) /
            (widget.nft.royalties?.last.amount ?? 1)) *
        100;
    return Column(
      children: [
        /// DUMMY
        ExpansionTile(
          iconColor: ColorConst.textGrey1,
          collapsedIconColor: ColorConst.textGrey1,
          tilePadding: EdgeInsets.zero,
          title: Text(
            "About Collection",
            style: labelSmall,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: ColorConst.darkGrey,
                  radius: 10,
                ),
                0.02.hspace,
                Text(
                  "stay a vision",
                  style: labelSmall,
                ),
              ],
            ),
            0.01.vspace,
            Text(
              "Donec lectus nibh, consectetur vitae dolor ac, finibus suscipit quam. Nunc at nunc turpis. Donec gravida ",
              style: bodySmall.copyWith(color: ColorConst.textGrey1),
            )
          ],
        ),
        ExpansionTile(
          iconColor: ColorConst.textGrey1,
          collapsedIconColor: ColorConst.textGrey1,
          tilePadding: EdgeInsets.zero,
          title: Text(
            "Details",
            style: labelSmall,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Token ID", style: bodySmall),
                Text(
                  widget.nft.tokenId ?? "",
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
                      .format(DateTime.parse(widget.nft.timestamp!)),
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
                      final String? hash =
                          widget.nft.artifactUri?.replaceAll("ipfs://", "");
                      final String img =
                          'https://assets.objkt.media/file/assets-003/$hash/artifact';
                      CommonFunctions.launchURL(img);
                    },
                    child: Row(
                      children: [
                        Text(
                          "CDN ",
                          style:
                              labelMedium.copyWith(color: ColorConst.Primary),
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
                      final String? hash =
                          widget.nft.artifactUri?.replaceAll("ipfs://", "");
                      final String img = '$ipfsHost/$hash';
                      CommonFunctions.launchURL(img);
                    },
                    child: Row(
                      children: [
                        Text(
                          "IPFS ",
                          style:
                              labelMedium.copyWith(color: ColorConst.Primary),
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
                      final String? hash =
                          widget.nft.metadata?.replaceAll("ipfs://", "");
                      final String img = '$ipfsHost/$hash';
                      CommonFunctions.launchURL(img);
                    },
                    child: Row(
                      children: [
                        Text(
                          "IPFS ",
                          style:
                              labelMedium.copyWith(color: ColorConst.Primary),
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
                      final String? hash =
                          widget.nft.metadata?.replaceAll("ipfs://", "");
                      final String url = 'https://tzkt.io/$hash';
                      CommonFunctions.launchURL(url);
                    },
                    child: Row(
                      children: [
                        Text(
                          widget.nft.faContract?.tz1Short() ?? "",
                          style:
                              labelMedium.copyWith(color: ColorConst.Primary),
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
          ],
        )
      ],
    );
  }

  Widget _buildActivityTab() {
    return Column(
      children: [
        0.02.vspace,
        ...widget.nft.events
                ?.map((e) {
                  String icon = e.eventType?.contains("transfer") ?? true
                      ? '${PathConst.SVG}bi_arrow.svg'
                      : '${PathConst.SVG}cart.svg';
                  return Container(
                    margin: EdgeInsets.only(bottom: 16.arP),
                    decoration: BoxDecoration(
                        color: ColorConst.darkGrey,
                        borderRadius: BorderRadius.circular(12.arP)),
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(icon),
                        ],
                      ),
                      tileColor: ColorConst.darkGrey,
                      title: Text(
                        e.eventType?.capitalizeFirst ?? "",
                        style: labelMedium,
                      ),
                      subtitle: e.recipientAddress == null
                          ? null
                          : Text(
                              "to ${e.recipientAddress?.tz1Short()}",
                              style: bodySmall.copyWith(
                                  color: ColorConst.textGrey1),
                            ),
                      trailing: Text(
                        relativeDate(DateTime.parse(e.timestamp!)),
                        style: bodySmall.copyWith(color: ColorConst.textGrey1),
                      ),
                    ),
                  );
                })
                .toList()
                .reversed
                .toList() ??
            []
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        ...List.generate(
          tabs.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16.arP),
              child: Column(
                children: [
                  Text(
                    tabs[index],
                    style: labelLarge.copyWith(
                        color: selectedTab == index
                            ? Colors.white
                            : ColorConst.textGrey1),
                  ),
                  Container(
                    height: 5,
                    width: 0.3.width,
                    margin: EdgeInsets.only(top: 8.arP),
                    decoration: selectedTab != index
                        ? null
                        : BoxDecoration(
                            color: ColorConst.Primary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.arP),
                              topRight: Radius.circular(12.arP),
                            )),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  ListTile _buildAvatar({
    String? address,
    String? title,
    String? avatar,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage(avatar ?? ""),
      ),
      title: RichText(
          text: TextSpan(
        text: title,
        style: bodySmall.copyWith(color: ColorConst.textGrey1),
        children: [TextSpan(text: address, style: bodySmall)],
      )),
    );
  }

  Widget _buildImage() {
    final String? hash = widget.nft.artifactUri?.replaceAll("ipfs://", "");
    final String img = '$ipfsHost/$hash';

    return GestureDetector(
      onTap: () {
        Get.dialog(NFTImageViewer(image: img));
      },
      child: Hero(
        tag: img,
        child: CachedNetworkImage(
          imageUrl: img,
        ),
      ),
    );
  }

  Widget _buildCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCountTile(widget.nft.creators?.length ?? 0, "Owned"),
        _buildCountTile(widget.nft.holders?.length ?? 0, "Owner"),
        _buildCountTile(widget.nft.supply ?? 0, "Editions"),
      ],
    );
  }

  Column _buildCountTile(int count, String title) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: titleSmall,
        ),
        Text(
          title,
          style: titleSmall.copyWith(color: ColorConst.textGrey1, fontSize: 12),
        )
      ],
    );
  }

  final _homeController = Get.find<HomePageController>();

  Widget _buildPrice() {
    double price =
        (widget.nft.events?.last.price ?? 0) * _homeController.xtzPrice.value;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.arP),
      padding: EdgeInsets.symmetric(
        vertical: 16.arP,
        horizontal: 16.arP,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: ColorConst.darkGrey),
          borderRadius: BorderRadius.circular(12.arP)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Price",
            style: labelSmall.copyWith(color: ColorConst.textGrey1),
          ),
          Row(
            children: [
              Text(widget.nft.events?.last.price?.toString() ?? "0.00 ",
                  style: headlineSmall.copyWith(fontWeight: FontWeight.w600)),
              SvgPicture.asset(
                'assets/svg/path.svg',
                color: Colors.white,
                height: 20,
                width: 15,
              )
            ],
          ),
          Text(
            "\$ ${price.toStringAsFixed(2)}",
            style: labelSmall.copyWith(color: ColorConst.textGrey1),
          ),
        ],
      ),
    );
  }
}
