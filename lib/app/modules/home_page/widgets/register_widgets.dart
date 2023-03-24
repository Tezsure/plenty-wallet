import 'package:flutter/material.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/accessblity_widget/accessblity_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/art_foundation_widget/naan_art_foundation_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/art_foundation_widget/tf_art_foundation_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/beta_tag_widget/beta_tag_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/buy_tez_widget/buy_tez_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/buy_tezos_domain/buy_tez_domain.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/coming_soon_widget/coming_soon_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/discover_apps_widget/discover_apps_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/discover_events_widget/dicover_events_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/earn_tez_widget/earn_tez_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/home_widget_frame.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/iaf/iaf_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/nft_gallery_widget/view/nft_gallery_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/objkt_nft_widget/objkt_nft_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/tez_quake_aid_widget/tez_quake_aid_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/vca/vca_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/vca_gallery_widget/view/vca_galllery_widget_view.dart';
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
  if (ServiceConfig.isTezQuakeWidgetVisible)
    Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.arP),
        child: const TezQuake()),
  if (ServiceConfig.isTezQuakeWidgetVisible) homeWidgetsGap,
  Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.arP), child: VCAWidget()),

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
  homeWidgetsGap,

  Container(
    padding: EdgeInsets.symmetric(horizontal: 22.arP),
    height: AppConstant.homeWidgetDimension,
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        NaanArtFoundationWidget(),
        Spacer(),
        TFArtFoundationWidget(),
      ],
    ),
  ),

  homeWidgetsGap,
  const VcaGalleryWidget(),
  homeWidgetsGap,
  Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.arP),
      child: const DiscoverEvents()),
  homeWidgetsGap,
  Container(
    padding: EdgeInsets.symmetric(horizontal: 22.arP),
    height: AppConstant.homeWidgetDimension,
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TezosDomainWidget(),
        Spacer(),
        BetaTagWidget(),
      ],
    ),
  ),
  homeWidgetsGap,

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
