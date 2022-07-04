import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naan_wallet/app/modules/widgets/account_balance/account_balance_widget.dart';
import 'package:naan_wallet/app/modules/widgets/dapp_search_widget/dapp_search_widget.dart';
import 'package:naan_wallet/app/modules/widgets/how_to_import_wallet/how_to_import_wallet_widget.dart';
import 'package:naan_wallet/app/modules/widgets/tez_balance_widget/tez_balance_widget.dart';
import 'package:naan_wallet/app/modules/widgets/action_button_group/action_button_group_widget.dart';
import 'package:naan_wallet/app/modules/widgets/nft/nft_widget.dart';
import 'package:naan_wallet/app/modules/widgets/tezos_headline/tezos_headline_widget.dart';
import 'package:naan_wallet/app/modules/widgets/token_balance/token_balance_widget.dart';

/// Check examples from lib/app/modules/widgets/ before adding your custom widget
final List<Widget> registeredWidgets = [
  ActionButtonGroupWidget(),
  HowToImportWalletWidget(),
  AccountBalanceWidget(),
  TokenBalanceWidget(),
  NftWidget(),
  TezBalanceWidget(),
  DappSearchWidget(),
  TezosHeadlineWidget(),
];
