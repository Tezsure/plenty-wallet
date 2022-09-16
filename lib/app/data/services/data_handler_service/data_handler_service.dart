// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:naan_wallet/app/data/services/data_handler_service/account_data_handler/account_data_handler.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/helpers/on_going_tx_helper.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/token_and_xtz_price_handler/token_and_xtz_price_handler.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';

import 'data_handler_render_service.dart';

class DataHandlerService {
  static final DataHandlerService _singleton = DataHandlerService._internal();

  factory DataHandlerService() {
    return _singleton;
  }

  DataHandlerService._internal();

  /// data handler render service updater
  DataHandlerRenderService renderService = DataHandlerRenderService();

  /// list of ongoing txs
  List<OnGoingTxStatusHelper> onGoingTxStatusHelpers = [];

  /// update value every 20 sec
  Timer? updateTimer;

  /// init all data services which runs in isolate and store user specific data in to local storage
  Future<void> initDataServices() async {
    // first time if data exists in storage readand render
    await renderService.updateUi();
    // update the values&store using isolates
    await updateAllTheValues();
    // init timer
    updateTimer = Timer.periodic(
        const Duration(seconds: 20), (_) => updateAllTheValues());
  }

  /// forced update when added new account
  Future<void> forcedUpdateData() async {
    await AccountDataHandler(renderService).executeProcess(
      postProcess: renderService.accountUpdater.updateProcess,
    );
    await NftAndTxHistoryHandler(renderService).executeProcess(
      postProcess: () {},
    );
  }

  /// Init all isolate for fetching data
  /// postProcess trigger ui for update new data
  Future<void> updateAllTheValues() async {
    await TokenAndXtzPriceHandler(renderService).executeProcess(
      postProcess: renderService.xtzPriceUpdater.updateProcess,
    );
    await AccountDataHandler(renderService).executeProcess(
      postProcess: renderService.accountUpdater.updateProcess,
    );
    await NftAndTxHistoryHandler(renderService).executeProcess(
      postProcess: () {},
    );

    if (onGoingTxStatusHelpers.isNotEmpty) {
      await updateOnGoingTxStatus();
    }
  }

  Future<void> updateOnGoingTxStatus() async {
    for (var i = 0; i < onGoingTxStatusHelpers.length; i++) {
      var result = await onGoingTxStatusHelpers[i].getStatus();
      if (result == 1) {
        onGoingTxStatusHelpers.removeAt(i);
      }
    }
  }
}
