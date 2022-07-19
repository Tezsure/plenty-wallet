import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_balance/account_balance_widget.dart';
import 'action_button_group/action_button_group_widget.dart';
import 'dapp_search_widget/dapp_search_widget.dart';
import 'how_to_import_wallet/how_to_import_wallet_widget.dart';
import 'nft/nft_widget.dart';
import 'tez_balance_widget/tez_balance_widget.dart';
import 'tezos_headline/tezos_headline_widget.dart';
import 'token_balance/token_balance_widget.dart';

/// Check examples from lib/app/modules/widgets/ before adding your custom widget
final List<Widget> registeredWidgets = [
  const ActionButtonGroupWidget(),
  const HowToImportWalletWidget(),
  AccountBalanceWidget(),
  TokenBalanceWidget(),
  NftWidget(),
  TezBalanceWidget(),
  const DappSearchWidget(),
  TezosHeadlineWidget(),
];
