import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/modules/common_widgets/naan_app_bar.dart';
import 'package:naan_wallet/app/modules/nft_page/controllers/nft_page_controller.dart';
import 'package:naan_wallet/models/nft_token_model.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

class NftDetailed extends StatefulWidget {
  const NftDetailed(this.nft);
  final NFTToken nft;

  @override
  State<NftDetailed> createState() => _NftDetailedState();
}

class _NftDetailedState extends State<NftDetailed> {
  final NftPageController _controller = Get.put(NftPageController());

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Container(
            height: 1.height,
            width: 1.width,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                NaanAppBar(
                  onBack: () => Get.back(),
                  pageName: "NFT Gallery",
                  backButtonName: "Back",
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          34.vspace,
                          nftImage(),
                          24.vspace,
                          animtaedTab(),
                          18.vspace,
                          nftDetails(),
                          24.vspace,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget nftImage() => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.nft.displayUri!,
          fit: BoxFit.cover,
          height: 1.height / 2.2,
          width: 1.width,
        ),
      );

  Widget animtaedTab() => Obx(
        () => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _controller.currentSelectedTab.value = 0;
                      _controller.listOfWidth.value = [
                        0,
                        (1.width / 2) - 24,
                        (1.width / 2) - 24
                      ];
                    },
                    child: Container(
                      height: 40,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          "Details",
                          style: _controller.currentSelectedTab.value != 0
                              ? bold16.copyWith(color: ColorConst.textGrey1)
                              : bold16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.currentSelectedTab.value = 1;
                        _controller.listOfWidth.value = [
                          (1.width / 2) - 24,
                          (1.width / 2) - 24,
                          0
                        ];
                      });
                    },
                    child: Container(
                      height: 40,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          "Activity",
                          style: _controller.currentSelectedTab.value != 1
                              ? bold16.copyWith(color: ColorConst.textGrey1)
                              : bold16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            8.vspace,
            Row(
              children: [
                AnimatedContainer(
                  duration: _controller.duration,
                  height: 2,
                  width: _controller.listOfWidth[0],
                  color: ColorConst.textGrey1,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    width: _controller.listOfWidth[1],
                    color: Colors.white,
                  ),
                ),
                AnimatedContainer(
                  duration: _controller.duration,
                  height: 2,
                  width: _controller.listOfWidth[2],
                  color: ColorConst.textGrey1,
                ),
              ],
            ),
          ],
        ),
      );

  Widget nftDetails() => Obx(() => _controller.currentSelectedTab == 0
      ? Container(
          child: Column(
            children: [
              //name and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.nft.name!,
                    style: bold16,
                  ),
                  Column(
                    children: [
                      Text(
                        "Current Price",
                        style: body10Medium600,
                      ),
                      Row(
                        children: [
                          Text(
                            "${(widget.nft.lowestAsk / 1e6).toStringAsFixed(1)}xtz",
                            style: bold14,
                          ),
                          2.hspace,
                          Text(
                            "(\$${(widget.nft.lowestAsk / 1e6) * 1.9})",
                            style: bold14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              18.vspace,
              //description
              Text(
                widget.nft.description,
                style: bold14,
              ),
              24.vspace,
              //owners, owned, editions
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.nft.holders!.length.toString(),
                        style: bold14,
                      ),
                      Text(
                        "Owned",
                        style: body10Medium500,
                      ),
                    ],
                  ),
                  24.hspace,
                  Column(
                    children: [
                      Text(
                        widget.nft.supply.toString(),
                        style: bold14,
                      ),
                      Text(
                        "Owners",
                        style: body10Medium500,
                      ),
                    ],
                  ),
                  24.hspace,
                  Column(
                    children: [
                      Text(
                        widget.nft.supply.toString(),
                        style: bold14,
                      ),
                      Text(
                        "Editions",
                        style: body10Medium500,
                      ),
                    ],
                  ),
                ],
              ),
              32.vspace,
              //creator details
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: appleBlack,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://services.tzkt.io/v1/avatars/${widget.nft.creators!.last.creatorAddress}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    12.hspace,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Created by",
                          style: body10Medium400,
                        ),
                        Text(
                          tz1Shortner(
                              widget.nft.creators!.last.creatorAddress!),
                          style: body12Bold700,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Text(
                          widget.nft.fa!.name!,
                          style: body12Bold400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      : Container(
          child: Column(
            children: [
              24.vspace,
              activityItem("Transfer", "HEN marketplace",
                  "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5", DateTime.now(), 5, 1),
              33.vspace,
              activityItem("Transfer", "HEN marketplace",
                  "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5", DateTime.now(), 5, 1),
              33.vspace,
              activityItem("Transfer", "HEN marketplace",
                  "tz1TCAF7vUmYV5AinJrNhdEhzHds3hhEsxg5", DateTime.now(), 5, 1),
            ],
          ),
        ));

  Widget activityItem(String type, String marketPlace, String tz1,
          DateTime dateTime, double tez, int quanity) =>
      Column(
        children: [
          Row(
            children: [
              Text(
                "$type  ",
                style: body12,
              ),
              const Icon(
                Icons.circle,
                size: 4,
                color: Colors.white,
              ),
              Text(
                "  $marketPlace -> ",
                style: body12,
              ),
              Text(
                tz1Shortner(tz1),
                style: body12,
              ),
              const Spacer(),
              Text(
                "$tez xtz",
                style: body12,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "${dateTime.day} hourse ago  ",
                style: bodyMedium10,
              ),
              const Icon(
                Icons.circle,
                size: 4,
                color: ColorConst.grey,
              ),
              Text(
                "  ${quanity}x",
                style: bodyMedium10,
              ),
            ],
          ),
        ],
      );
}
