import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accessblity_widget/accessblity_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/buy_tez_widget/buy_tez_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/coming_soon_widget/coming_soon_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/discover_apps_widget/discover_apps_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/earn_tez_widget/earn_tez_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/view/nft_gallery_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/objkt_nft_widget.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

// import 'package:naan_wallet/app/data/mock/mock_data.dart';
import 'accounts_widget/views/accounts_widget_view.dart';
// import 'info_stories/models/story_page/views/story_page_view.dart';
import 'tezos_price/tezos_price_widget.dart';

/// Check examples from lib/app/modules/widgets/ before adding your custom widget
final List<Widget> registeredWidgets = [
  // StoryPageView(
  //   profileImagePath: MockData.naanInfoStory.values.toList(),
  //   storyTitle: MockData.naanInfoStory.keys.toList(),
  // ),
  const AccountsWidget(),
  // const Accessiblity(),
  0.024.vspace,
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      BuyTezWidget(),
      EarnTezWidget(),
    ],
  ),
  0.024.vspace,

  //const TezosPriceWidget(),
  //const MyNFTwidget(),

  const NftGalleryWidget(),
  0.024.vspace,

  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const ObjktNftWidget(),
      TezosPriceWidget(),
    ],
  ),
  0.024.vspace,

  const DiscoverAppsWidget(),
  const ComingSoonWidget()

  // const PublicNFTgalleryWidget(),
  //const CommunityProductsWidget(),
  // LiquidityBakingWidget(),
  // const DelegateWidget(),
  //const NewsHeadlineWidget()
];
