import 'dart:async';

import 'package:naan_wallet/app/data/services/data_handler_service/account_data_handler/account_data_handler.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/token_and_xtz_price_handler/token_and_xtz_price_handler.dart';

import 'data_handler_render_service.dart';

class DataHandlerService {
  static final DataHandlerService _singleton = DataHandlerService._internal();

  factory DataHandlerService() {
    return _singleton;
  }

  DataHandlerService._internal();

  /// data handler render service updater
  DataHandlerRenderService renderService = DataHandlerRenderService();

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
  }

  /// Init all isolate for fetching data
  /// postProcess trigger ui for update new data
  Future<void> updateAllTheValues() async {
    await TokenAndXtzPriceHandler(renderService).executeProcess(
      postProcess: () {},
    );
    await AccountDataHandler(renderService).executeProcess(
      postProcess: renderService.accountUpdater.updateProcess,
    );
  }
}
