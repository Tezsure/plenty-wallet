import 'package:flutter/material.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accessblity_widget/accessblity_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/buy_tez_widget/buy_tez_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/coming_soon_widget/coming_soon_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/discover_apps_widget/discover_apps_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/earn_tez_widget/earn_tez_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/iaf/iaf_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/view/nft_gallery_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/objkt_nft_widget.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
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
  homeWidgetsGap,
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 22.arP),
    child: Row(
      children: [
        BuyTezWidget(),
        const Spacer(),
        const EarnTezWidget(),
      ],
    ),
  ),
  homeWidgetsGap,
  if (ServiceConfig.isIAFWidgetVisible)
    Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.arP),
        child: const IAFWidget()),
  if (ServiceConfig.isIAFWidgetVisible) homeWidgetsGap,
  //const TezosPriceWidget(),
  //const MyNFTwidget(),

  const NftGalleryWidget(),
  homeWidgetsGap,

  Container(
    padding: EdgeInsets.symmetric(horizontal: 22.arP),
    height: AppConstant.homeWidgetDimension,
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ObjktNftWidget(),
        const Spacer(),
        TezosPriceWidget(),
      ],
    ),
  ),
  homeWidgetsGap,

  Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.arP),
      child: const DiscoverAppsWidget()),
  const ComingSoonWidget()

  // const PublicNFTgalleryWidget(),
  //const CommunityProductsWidget(),
  // LiquidityBakingWidget(),
  // const DelegateWidget(),
  //const NewsHeadlineWidget()
];

Widget homeWidgetsGap = SizedBox(
  height: 22.arP,
);
