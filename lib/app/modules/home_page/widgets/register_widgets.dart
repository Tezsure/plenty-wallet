import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/info_stories/models/story_page/views/story_page_view.dart';
import 'package:naan_wallet/mock/mock_data.dart';

import 'accounts_widget/views/accounts_widget_view.dart';
import 'community_widget/community_widget.dart';
import 'dapp_search_widget/dapp_search_widget.dart';
import 'delegate_widget/views/delegate_widget_view.dart';
import 'nft/nft_widget.dart';
import 'tez_balance_widget/tez_balance_widget.dart';
import 'tezos_headline/tezos_headline_widget.dart';

/// Check examples from lib/app/modules/widgets/ before adding your custom widget
final List<Widget> registeredWidgets = [
  StoryPageView(
    profileImagePath: MockData.naanInfoStory.values.toList(),
    storyTitle: MockData.naanInfoStory.keys.toList(),
  ),
  const AccountsWidget(),
  const CommunityProducts(),
  const DelegateWidget(),
  const NftWidget(),
  TezBalanceWidget(),
  const DappSearchWidget(),
  TezosHeadlineWidget(),
  // const ActionButtonGroupWidget(),
  // const HowToImportWalletWidget(),
  // AccountBalanceWidget(),
  // TokenBalanceWidget(),
];
