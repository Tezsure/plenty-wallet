// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/beacon_service/beacon_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/account_data_handler/account_data_handler.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/helpers/on_going_tx_helper.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/token_and_xtz_price_handler/token_and_xtz_price_handler.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/dapp_models.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';

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

  /// update value every 15 sec
  Timer? updateTimer;

  /// isDataFetching
  bool _isDataFetching = false;

  nftPatch(Function onDone) async {
    try {
      if (!(await UserStorageService().nftPatchRead())) {
        await NftAndTxHistoryHandler(renderService).executeProcess(
          postProcess: renderService.accountNft.updateProcess,
          onDone: () async {
            await UserStorageService().nftPatch();
            onDone();
          },
        );
      } else {
        onDone();
      }
    } catch (e) {
      print(e);
      onDone();
    }
  }

  /// init all data services which runs in isolate and store user specific data in to local storage
  Future<void> initDataServices() async {
    // first time if data exists in storage readand render
    //await ServiceConfig.localStorage.delete(key: ServiceConfig.nftPatch);
    await renderService.updateUi();

    setUpTimer();

    // update the values&store using isolates
    await updateAllTheValues();
    // init timer

    // update one time data in cache
    _updateOneTimeData();
  }

  setUpTimer() => {
        if (updateTimer == null || !updateTimer!.isActive)
          updateTimer = Timer.periodic(const Duration(seconds: 15), (_) {
            _isDataFetching = false;
            print("is data fetching: $_isDataFetching");
            updateAllTheValues();
          })
      };

  /// forced update when added new account
  Future<void> forcedUpdateData() async {
    _isDataFetching = true;
    await AccountDataHandler(renderService).executeProcess(
      postProcess: renderService.accountUpdater.updateProcess,
      onDone: () async =>
          await NftAndTxHistoryHandler(renderService).executeProcess(
              postProcess: () {},
              onDone: () => {
                    _isDataFetching = false,
                  }),
    );
  }

  /// Init all isolate for fetching data
  /// postProcess trigger ui for update new data
  Future<void> updateAllTheValues() async {
    if (updateTimer == null || _isDataFetching) {
      // print("data fetching in progress.............");
      // print("updateTimer: ${updateTimer == null}");
      // print("_isDataFetching: $_isDataFetching");
      return;
    }
    updateTimer!.cancel();
    // print("updating all the values.............");
    TokenAndXtzPriceHandler(renderService).executeProcess(
      postProcess: renderService.xtzPriceUpdater.updateProcess,
      onDone: () async =>
          await AccountDataHandler(renderService).executeProcess(
        postProcess: renderService.accountUpdater.updateProcess,
        onDone: () async =>
            await NftAndTxHistoryHandler(renderService).executeProcess(
          postProcess: renderService.accountNft.updateProcess,
          onDone: () {
            setUpTimer();
          },
        ),
      ),
    );
    if (onGoingTxStatusHelpers.isNotEmpty) {
      await updateOnGoingTxStatus();
    }
  }

  Future<void> updateTokens() async {
    await AccountDataHandler(renderService).executeProcess(
        postProcess: renderService.accountUpdater.updateProcess, onDone: () {});
  }

  Future<void> updateOnGoingTxStatus() async {
    for (var i = 0; i < onGoingTxStatusHelpers.length; i++) {
      var result = await onGoingTxStatusHelpers[i].getStatus();
      if (result == 1) {
        onGoingTxStatusHelpers.removeAt(i);
      }
    }
  }

  /// update one time data in cache
  Future<void> _updateOneTimeData() async {
    await getDappsAndStore();
  }

  Future<void> getDappsAndStore(
      {RxList<DappBannerModel>? dappBanners,
      RxMap<String, DappModel>? dapps}) async {
    if (dappBanners != null) {
      dapps!.value = jsonDecode(await ServiceConfig.localStorage
                  .read(key: ServiceConfig.dappsStorage) ??
              "{}")
          .map<String, DappModel>((key, json) =>
              MapEntry(key.toString(), DappModel.fromJson(json)));
      dappBanners.value = jsonDecode(await ServiceConfig.localStorage
                  .read(key: ServiceConfig.dappsBannerStorage) ??
              "[]")
          .map<DappBannerModel>((json) => DappBannerModel.fromJson(json))
          .toList();
    }

    // call apis
    List<DappBannerModel> banners = jsonDecode(
            await HttpService.performGetRequest(ServiceConfig.naanApis,
                endpoint: "explorer-banner"))
        .map<DappBannerModel>((json) => DappBannerModel.fromJson(json))
        .toList();

    String dappString = await HttpService.performGetRequest(
        ServiceConfig.naanApis,
        endpoint: "dapps");
    Map<String, DappModel> dappsMap = jsonDecode(dappString)
        .map<String, DappModel>(
            (key, json) => MapEntry(key.toString(), DappModel.fromJson(json)));

    if (dappBanners != null &&
        dappBanners.toString().hashCode != banners.toString().hashCode) {
      dapps!.value = dappsMap;
      dappBanners.value = banners;
    } else {}

    // store in local storage
    await ServiceConfig.localStorage
        .write(key: ServiceConfig.dappsStorage, value: dappString);
    await ServiceConfig.localStorage.write(
        key: ServiceConfig.dappsBannerStorage, value: jsonEncode(banners));
  }
}
