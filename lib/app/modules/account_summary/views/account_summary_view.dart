import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../utils/colors/colors.dart';
import '../../../../utils/constants/path_const.dart';
import '../../common_widgets/bottom_sheet.dart';
import '../controllers/account_summary_controller.dart';
import 'pages/crypto_tab.dart';
import 'pages/nft_tab.dart';

class AccountSummaryView extends GetView<AccountSummaryController> {
  AccountSummaryView({super.key});
  @override
  final controller = Get.put(AccountSummaryController());
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 0.95.height,
        width: 1.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          gradient: GradConst.GradientBackground,
        ),
        child: DefaultTabController(
          length: 3,
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
              ListTile(
                leading: Image.asset(
                  'assets/temp/account_profile.png',
                  fit: BoxFit.contain,
                  height: 40,
                  width: 40,
                ),
                title: SizedBox(
                  height: 20,
                  width: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'My Main Account',
                        style: labelMedium,
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                subtitle: Text(
                  'tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'.addressShortner(),
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ),
                trailing: SizedBox(
                  height: 20,
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        Icons.content_copy_outlined,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.qr_code_scanner_sharp,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              0.02.vspace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('254.00', style: headlineSmall),
                  const SizedBox(width: 5),
                  SvgPicture.asset(
                    "${PathConst.HOME_PAGE.SVG}xtz.svg",
                    height: 20,
                    width: 15,
                  )
                ],
              ),
              0.03.vspace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: CircleAvatar(
                                backgroundColor:
                                    ColorConst.NeutralVariant.shade20,
                                radius: 15,
                                child: Text('\$',
                                    style: TextStyle(
                                        color: ColorConst.Primary.shade90)))),
                        const WidgetSpan(
                          child: SizedBox(
                            width: 8,
                          ),
                        ),
                        TextSpan(
                            text: 'Buy',
                            style: labelSmall.copyWith(
                                color: ColorConst.Primary.shade90)),
                      ],
                    ),
                  ),
                  0.10.hspace,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: CircleAvatar(
                            backgroundColor: ColorConst.NeutralVariant.shade20,
                            radius: 15,
                            child: Icon(
                              Icons.arrow_upward,
                              color: ColorConst.Primary.shade90,
                              size: 20,
                            ),
                          ),
                        ),
                        const WidgetSpan(
                          child: SizedBox(
                            width: 8,
                          ),
                        ),
                        TextSpan(
                            text: 'Send',
                            style: labelSmall.copyWith(
                                color: ColorConst.Primary.shade90)),
                      ],
                    ),
                  ),
                  0.10.hspace,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: CircleAvatar(
                              backgroundColor:
                                  ColorConst.NeutralVariant.shade20,
                              radius: 15,
                              child: Icon(
                                Icons.arrow_downward,
                                color: ColorConst.Primary.shade90,
                                size: 20,
                              ),
                            )),
                        const WidgetSpan(
                          child: SizedBox(
                            width: 8,
                          ),
                        ),
                        TextSpan(
                            text: 'Receive',
                            style: labelSmall.copyWith(
                                color: ColorConst.Primary.shade90)),
                      ],
                    ),
                  ),
                ],
              ),
              0.03.vspace,
              Divider(
                height: 20,
                color: ColorConst.NeutralVariant.shade20,
                endIndent: 20,
                indent: 20,
              ),
              SizedBox(
                height: 50,
                child: TabBar(
                    isScrollable: true,
                    labelColor: ColorConst.Primary.shade95,
                    indicatorColor: ColorConst.Primary,
                    indicatorSize: TabBarIndicatorSize.tab,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    enableFeedback: true,
                    unselectedLabelColor: ColorConst.NeutralVariant.shade60,
                    tabs: const [
                      Tab(text: "Crypto"),
                      Tab(text: "NFTs"),
                      Tab(text: "History"),
                    ]),
              ),
              Expanded(
                child: TabBarView(children: [
                  const CryptoTabPage(),
                  NFTabPage(collectibles: controller.collectibles),
                  HistoryPage(
                    onTap: (() => Get.bottomSheet(const SearchBottomSheet(),
                        isScrollControlled: true)),
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

enum HistoryStatus {
  receive,
  send,
}

class HistoryPage extends StatelessWidget {
  final bool isNftTransaction;
  final GestureTapCallback? onTap;
  const HistoryPage({super.key, this.isNftTransaction = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.02.width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                0.02.vspace,
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 0.06.height,
                        width: 0.8.width,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorConst.NeutralVariant.shade60
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: ColorConst.NeutralVariant.shade60,
                              size: 22,
                            ),
                            0.02.hspace,
                            Text(
                              'Search',
                              style: bodySmall.copyWith(
                                  color: ColorConst.NeutralVariant.shade70),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.filter,
                            color: ColorConst.Primary,
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 16.sp, left: 16.sp, bottom: 16.sp),
            child: Text(
              'August 15, 2022',
              style: labelMedium,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return index.isEven
                  ? HistoryTile(
                      onTap: () => Get.bottomSheet(
                          const TransactionDetailsBottomSheet()),
                      status: HistoryStatus.receive,
                    )
                  : const NftHistoryTile(
                      status: HistoryStatus.send,
                    );
            },
            childCount: 10,
          ),
        ),
      ],
    );
  }
}

class NftHistoryTile extends StatelessWidget {
  final HistoryStatus status;
  const NftHistoryTile({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 0.03.width, vertical: 0.003.height),
      decoration: BoxDecoration(
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            minVerticalPadding: 0,
            visualDensity: VisualDensity.compact,
            dense: true,
            leading: Container(
              height: 40.sp,
              width: 40.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/temp/nft_preview.png',
                  ),
                ),
              ),
            ),
            title: Text(
              'Receive',
              style: labelMedium,
            ),
            subtitle: Text(
              tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
              style:
                  labelSmall.copyWith(color: ColorConst.NeutralVariant.shade60),
            ),
            trailing: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                  text: '+1 Unstable\n',
                  style:
                      labelMedium.copyWith(color: ColorConst.naanCustomColor),
                  children: [
                    WidgetSpan(child: 0.02.vspace),
                    TextSpan(
                        text: 'N/A',
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60))
                  ]),
            ),
          ),
          Container(
            height: 0.33.height,
            width: 0.76.width,
            margin: EdgeInsets.only(
                right: 0.04.width, bottom: 0.02.height, top: 0.01.height),
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                alignment: Alignment.center,
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/temp/nft_preview.png',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryTile extends StatelessWidget {
  final VoidCallback? onTap;
  final HistoryStatus status;
  const HistoryTile({super.key, required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.03.width, vertical: 0.003.height),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
                radius: 20.sp,
                backgroundColor: ColorConst.Tertiary,
                child: SvgPicture.asset('${PathConst.SVG}tez.svg')),
            title: Text(
              status == HistoryStatus.receive ? 'Receive' : '- - Sending',
              style: labelMedium.copyWith(
                color: status == HistoryStatus.receive
                    ? Colors.white
                    : ColorConst.Primary.shade60,
              ),
            ),
            subtitle: Text(
              tz1Shortner('tz1KqTpEZ7Yob7QbPE4Hy4Wo8fHG8LhKxZSx'),
              style:
                  labelSmall.copyWith(color: ColorConst.NeutralVariant.shade60),
            ),
            trailing: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                  text: status == HistoryStatus.receive
                      ? '+18.267\n'
                      : '-18.267\n',
                  style: labelMedium.copyWith(
                    color: status == HistoryStatus.receive
                        ? ColorConst.naanCustomColor
                        : Colors.white,
                  ),
                  children: [
                    WidgetSpan(child: 0.02.vspace),
                    TextSpan(
                        text: '\$23.21',
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionDetailsBottomSheet extends StatelessWidget {
  const TransactionDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: 50,
      width: 1.width,
      height: 0.42.height,
      titleAlignment: Alignment.center,
      titleStyle: titleMedium,
      bottomSheetHorizontalPadding: 1,
      bottomSheetWidgets: [
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Transaction Details\n',
                style: titleMedium,
                children: [
                  WidgetSpan(child: 0.03.vspace),
                  TextSpan(
                      text: '15/08/2022 19:50\n',
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade60)),
                  WidgetSpan(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 0.015.height),
                        width: 0.32.width,
                        height: 0.03.height,
                        decoration: BoxDecoration(
                            color: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('view on tzkt.io',
                                style: labelSmall.copyWith(
                                    color: ColorConst.NeutralVariant.shade60)),
                            Icon(
                              Icons.open_in_new_rounded,
                              size: 12.sp,
                              color: ColorConst.NeutralVariant.shade60,
                            )
                          ],
                        )),
                  ),
                ]),
          ),
        ),
        ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(
            '+18.267',
            style: headlineSmall.copyWith(color: ColorConst.naanCustomColor),
          ),
          subtitle: Text(
            '\$23.21',
            style: bodyMedium.copyWith(color: ColorConst.Primary.shade70),
          ),
          trailing: SvgPicture.asset(
            'assets/svg/tez.svg',
            height: 45.sp,
          ),
        ),
        ListTile(
            leading: Container(
              height: 0.03.height,
              width: 0.1.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
              child: Center(
                child: Text(
                  'from',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ),
              ),
            ),
            trailing: SvgPicture.asset('assets/svg/chevron_down.svg')),
        ListTile(
            title: Row(
              children: [
                Text(
                  'tz1K...pkDZ',
                  style: bodyMedium.copyWith(color: ColorConst.Primary.shade70),
                ),
                0.02.hspace,
                Icon(
                  Icons.copy,
                  color: ColorConst.Primary.shade60,
                  size: 16.sp,
                ),
              ],
            ),
            trailing: SvgPicture.asset('assets/svg/send.svg')),
        0.02.vspace,
      ],
    );
  }
}

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 0.95.height,
        width: 1.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          gradient: GradConst.GradientBackground,
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
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
                        color:
                            ColorConst.NeutralVariant.shade60.withOpacity(0.3),
                      ),
                    ),
                  ),
                  0.03.vspace,
                  Center(
                    child: SizedBox(
                      height: 0.06.height,
                      width: 0.9.width,
                      child: Center(
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.top,
                          textAlign: TextAlign.start,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorConst.NeutralVariant.shade60
                                .withOpacity(0.2),
                            prefixIcon: Icon(
                              Icons.search,
                              color: ColorConst.NeutralVariant.shade60,
                              size: 22,
                            ),
                            counterStyle:
                                const TextStyle(backgroundColor: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none),
                            hintText: 'Search',
                            hintStyle: bodySmall.copyWith(
                                color: ColorConst.NeutralVariant.shade70),
                            labelStyle: labelSmall,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            focusNode.hasFocus
                ? SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return (index % 3 == 0)
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: 16.sp, left: 16.sp, bottom: 16.sp),
                              child: Text(
                                'August 15, 2022',
                                style: labelMedium,
                              ),
                            )
                          : HistoryTile(
                              status: index.isEven
                                  ? HistoryStatus.receive
                                  : HistoryStatus.send,
                            );
                    }, childCount: 20),
                  )
                : SliverToBoxAdapter(
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.03.height),
                      child:
                          Text('Try searching for token,\nprotocols, and tags',
                              textAlign: TextAlign.center,
                              style: bodyMedium.copyWith(
                                color: ColorConst.NeutralVariant.shade70,
                              )),
                    )),
                  ),
          ],
        ));
  }
}
