import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/new_headlines_widget/new_headlines_widget.dart';

import 'package:naan_wallet/app/data/mock/mock_data.dart';
import 'accounts_widget/views/accounts_widget_view.dart';
import 'community_widget/community_widget.dart';
import 'delegate_widget/views/delegate_widget_view.dart';
import 'info_stories/models/story_page/views/story_page_view.dart';
import 'liquidity_baking_widget/liquidity_baking_widget.dart';
import 'my_nfts_widget/my_nfts_widget.dart';
import 'public_nft_gallery/views/public_nft_gallery_widget.dart';
import 'tezos_price/tezos_price_widget.dart';

/// Check examples from lib/app/modules/widgets/ before adding your custom widget
final List<Widget> registeredWidgets = [
  StoryPageView(
    profileImagePath: MockData.naanInfoStory.values.toList(),
    storyTitle: MockData.naanInfoStory.keys.toList(),
  ),
  const AccountsWidget(),
  const TezosPriceWidget(),
  const MyNFTwidget(),
  const PublicNFTgalleryWidget(),
  const CommunityProductsWidget(),
  LiquidityBakingWidget(),
  const DelegateWidget(),
  const NewsHeadlineWidget()
];
