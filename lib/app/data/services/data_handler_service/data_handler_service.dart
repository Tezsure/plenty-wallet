// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/account_data_handler/account_data_handler.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/helpers/on_going_tx_helper.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/token_and_xtz_price_handler/token_and_xtz_price_handler.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:plenty_wallet/app/data/services/service_config/service_config.dart';
import 'package:plenty_wallet/app/data/services/service_models/dapp_models.dart';
import 'package:plenty_wallet/app/data/services/service_models/event_models.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/home_page/widgets/teztown/controllers/teztown_model.dart';

import 'data_handler_render_service.dart';

class DataHandlerService {
  static DataHandlerService? singleton = DataHandlerService._internal();

  factory DataHandlerService() {
    return singleton ??= DataHandlerService._internal();
  }

  DataHandlerService._internal();

  /// data handler render service updater
  DataHandlerRenderService renderService = DataHandlerRenderService();

  /// list of ongoing txs
  RxList<OnGoingTxStatusHelper> onGoingTxStatusHelpers =
      <OnGoingTxStatusHelper>[].obs;

  /// update value every 15 sec
  Timer? updateTimer;

  /// isDataFetching
  bool _isDataFetching = false;

  bool isRunning = false;

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
      debugPrint(e.toString());
      onDone();
    }
  }

  /// init all data services which runs in isolate and store user specific data in to local storage
  Future<void> initDataServices() async {
    if (isRunning) {
      debugPrint("already running canceling init data services");
      return;
    } else {
      debugPrint("init data services.............");
    }

    isRunning = true;
    // first time if data exists in storage readand render

    onGoingTxStatusHelpers.listen((p0) async {
      if (p0.isNotEmpty) {
        //for loop for 6 times call until onGoingTxStatusHelpers is empty
        for (int i = 0; i < 6; i++) {
          if (onGoingTxStatusHelpers.isNotEmpty) {
            await updateOnGoingTxStatus();
            if (onGoingTxStatusHelpers.isNotEmpty) {
              await Future.delayed(const Duration(seconds: 5));
            }
          } else {
            break;
          }
        }
      }
    });

    await renderService.updateUi();

    setUpTimer();

    currencyPrices();

    // update the values&store using isolates
    await updateAllTheValues();
    // init timer

    // update one time data in cache
    _updateOneTimeData();
  }

  currencyPrices() {
    HttpService.performGetRequest(
            "https://api.currencybeacon.com/v1/latest?base=USD&symbols=INR,EUR,AUD&api_key=P0uX2YC1vt5k0K5LlrX9ivFH7i72iAET")
        .then((result) async {
      dynamic response = jsonDecode(result);
      var inr = response['rates']['INR'];
      var eur = response['rates']['EUR'];
      var aud = response['rates']['AUD'];
      debugPrint("inr: $inr eur: $eur aud: $aud");

      ServiceConfig.inr = inr;
      ServiceConfig.eur = eur;
      ServiceConfig.aud = aud;

      await ServiceConfig.hiveStorage
          .write(key: ServiceConfig.inrPriceStorage, value: inr.toString());
      await ServiceConfig.hiveStorage
          .write(key: ServiceConfig.eurPriceStorage, value: eur.toString());
      await ServiceConfig.hiveStorage
          .write(key: ServiceConfig.audPriceStorage, value: aud.toString());
    });
  }

  setUpTimer() => {
        if (updateTimer == null || !updateTimer!.isActive)
          updateTimer = Timer.periodic(const Duration(seconds: 15), (_) {
            _isDataFetching = false;
            debugPrint("is data fetching: $_isDataFetching");
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

  Future<void> forcedUpdateDataPriceAndToken() async {
    _isDataFetching = true;
    TokenAndXtzPriceHandler(renderService).executeProcess(
      postProcess: renderService.xtzPriceUpdater.updateProcess,
      onDone: () async =>
          await AccountDataHandler(renderService).executeProcess(
              postProcess: renderService.accountUpdater.updateProcess,
              onDone: () {
                _isDataFetching = false;
              }),
    );
  }

  /// Init all isolate for fetching data
  /// postProcess trigger ui for update new data
  Future<void> updateAllTheValues() async {
    if (updateTimer == null || _isDataFetching) {
      // debugPrint("data fetching in progress.............");
      // debugPrint("updateTimer: ${updateTimer == null}");
      // debugPrint("_isDataFetching: $_isDataFetching");
      return;
    }
    updateTimer!.cancel();
    // debugPrint("updating all the values.............");
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
/*     if (onGoingTxStatusHelpers.isNotEmpty) {
      await updateOnGoingTxStatus();
    } */
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
      {RxList<DappBannerDatum>? dappBanners,
      RxMap<String, DappModel>? dapps}) async {
    if (dappBanners != null) {
      dapps!.value = jsonDecode(await ServiceConfig.hiveStorage
                  .read(key: ServiceConfig.dappsStorage) ??
              "{}")
          .map<String, DappModel>((key, json) =>
              MapEntry(key.toString(), DappModel.fromJson(json)));
      dappBanners.value = jsonDecode(await ServiceConfig.hiveStorage
                  .read(key: ServiceConfig.dappsBannerStorage) ??
              "[]")
          .map<DappBannerDatum>((json) => DappBannerDatum.fromJson(json))
          .toList();
    }

    // call apis
    List<DappBannerDatum> banners = jsonDecode(
            await HttpService.performGetRequest(ServiceConfig.naanApis,
                endpoint: "discover-apps"))["data"]
        .map<DappBannerDatum>((json) => DappBannerDatum.fromJson(json))
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
    await ServiceConfig.hiveStorage
        .write(key: ServiceConfig.dappsStorage, value: dappString);
    await ServiceConfig.hiveStorage.write(
        key: ServiceConfig.dappsBannerStorage, value: jsonEncode(banners));
  }

  Future<TeztownModel> getTeztownData(Rx<TeztownModel> data) async {
    final apiResult = jsonDecode(await HttpService.performGetRequest(
        ServiceConfig.naanApis,
        endpoint: "spring_fever"));
    if (data.toJson().toString().hashCode != apiResult.toString().hashCode) {
      data.value = TeztownModel.fromJson(apiResult);
    }
    return data.value;
  }

  Future<Map<String, List<EventModel>>> getVCAEventsDetail({
    required RxList tags,
    required RxMap<String, List<EventModel>> events,
    required RxList<StallsModel> stalls,
    required RxString banner,
    required RxString mapImage,
  }) async {
    var eventsStorage = jsonDecode(await ServiceConfig.hiveStorage
            .read(key: ServiceConfig.vcaEventsStorage) ??
        "{}");
    if (eventsStorage.isNotEmpty) {
      tags.value = eventsStorage['tags'];
      banner.value = eventsStorage['stalls']['banner'];

      mapImage.value = eventsStorage['stalls']['mapImage'];
      stalls.value = eventsStorage['stalls']['stallsList']
          .map<StallsModel>((json) => StallsModel.fromJson(json))
          .toList();

      final Map<String, List<EventModel>> eventsByTime = {
        "Today": [],
        "Tomorrow": [],
        "This Week": [],
        "Next Week": [],
        "This Month": [],
        "Next Month": [],
        "This Year": [],
      };
      // sort eventsStorage by timestamp in ascending order
      eventsStorage['events'].sort((a, b) {
        return int.parse(a['timestamp']) > int.parse(b['timestamp']) ? 1 : -1;
      });
// Iterate through each event and categorize them based on their timestamp
      eventsStorage['events'].forEach((json) {
        final EventModel event = EventModel.fromJson(json);
        final DateTime? eventTime = event.timestamp;
        final DateTime? endTime = event.endTimestamp;
        if (endTime!.isAfter(DateTime.now())) {
          if (_isToday(eventTime!, endTime)) {
            eventsByTime['Today']!.add(event);
          } else if (_isTomorrow(eventTime)) {
            eventsByTime['Tomorrow']!.add(event);
          } else if (_isThisWeek(eventTime)) {
            eventsByTime['This Week']!.add(event);
          } else if (_isNextWeek(eventTime)) {
            eventsByTime['Next Week']!.add(event);
          } else if (_isThisMonth(eventTime)) {
            eventsByTime['This Month']!.add(event);
          } else if (_isNextMonth(eventTime)) {
            eventsByTime['Next Month']!.add(event);
          } else if (_isThisYear(eventTime)) {
            eventsByTime['This Year']!.add(event);
          }
        }
      });
      events.value = eventsByTime;
    }

    final apiResult = jsonDecode(await HttpService.performGetRequest(
        ServiceConfig.naanApis,
        endpoint: "vca_events"));

    if (eventsStorage.toString().hashCode != apiResult.toString().hashCode) {
      tags.value = apiResult['tags'];
      banner.value = apiResult['stalls']['banner'];
      mapImage.value = apiResult['stalls']['mapImage'];
      stalls.value = apiResult['stalls']['stallsList']
          .map<StallsModel>((json) => StallsModel.fromJson(json))
          .toList();

      final Map<String, List<EventModel>> eventsByTime = {
        "Today": [],
        "Tomorrow": [],
        "This Week": [],
        "Next Week": [],
        "This Month": [],
        "Next Month": [],
        "This Year": [],
      };
      apiResult['events'].sort((a, b) {
        return int.parse(a['timestamp']) > int.parse(b['timestamp']) ? 1 : -1;
      });
// Iterate through each event and categorize them based on their timestamp
      apiResult['events'].forEach((json) {
        final EventModel event = EventModel.fromJson(json);
        final DateTime? eventTime = event.timestamp;
        final DateTime? endTime = event.endTimestamp;
        if (endTime!.isAfter(DateTime.now())) {
          if (_isToday(eventTime!, endTime)) {
            eventsByTime['Today']!.add(event);
          } else if (_isTomorrow(eventTime)) {
            eventsByTime['Tomorrow']!.add(event);
          } else if (_isThisWeek(eventTime)) {
            eventsByTime['This Week']!.add(event);
          } else if (_isNextWeek(eventTime)) {
            eventsByTime['Next Week']!.add(event);
          } else if (_isThisMonth(eventTime)) {
            eventsByTime['This Month']!.add(event);
          } else if (_isNextMonth(eventTime)) {
            eventsByTime['Next Month']!.add(event);
          } else if (_isThisYear(eventTime)) {
            eventsByTime['This Year']!.add(event);
          }
        }
      });
      events.value = eventsByTime;
    } else {}

    // store in local storage

    await ServiceConfig.hiveStorage.write(
        key: ServiceConfig.vcaEventsStorage, value: jsonEncode(apiResult));

    return events.value;
  }

  Future<Map<String, List<EventModel>>> getEventsDetail(
      {required RxList tags,
      required RxString bottomText,
      required RxString contactUsLink,
      required RxMap<String, List<EventModel>> events}) async {
    var eventsStorage = jsonDecode(await ServiceConfig.hiveStorage
            .read(key: ServiceConfig.eventsStorage) ??
        "{}");
    if (eventsStorage.isNotEmpty) {
      tags.value = eventsStorage['tags'];
      bottomText.value = eventsStorage['bottomText'];
      contactUsLink.value = eventsStorage['contactUsLink'];
      final Map<String, List<EventModel>> eventsByTime = {
        "Today": [],
        "Tomorrow": [],
        "This Week": [],
        "Next Week": [],
        "This Month": [],
        "Next Month": [],
        "This Year": [],
      };
      eventsStorage['events'].sort((a, b) {
        return int.parse(a['timestamp']) > int.parse(b['timestamp']) ? 1 : -1;
      });
// Iterate through each event and categorize them based on their timestamp
      eventsStorage['events'].forEach((json) {
        final EventModel event = EventModel.fromJson(json);
        final DateTime? eventTime = event.timestamp;
        final DateTime? endTime = event.endTimestamp;
        if (endTime!.isAfter(DateTime.now())) {
          if (_isToday(eventTime!, endTime)) {
            eventsByTime['Today']!.add(event);
          } else if (_isTomorrow(eventTime)) {
            eventsByTime['Tomorrow']!.add(event);
          } else if (_isThisWeek(eventTime)) {
            eventsByTime['This Week']!.add(event);
          } else if (_isNextWeek(eventTime)) {
            eventsByTime['Next Week']!.add(event);
          } else if (_isThisMonth(eventTime)) {
            eventsByTime['This Month']!.add(event);
          } else if (_isNextMonth(eventTime)) {
            eventsByTime['Next Month']!.add(event);
          } else if (_isThisYear(eventTime)) {
            eventsByTime['This Year']!.add(event);
          }
        }
      });
      events.value = eventsByTime;
    }

    final apiResult = jsonDecode(await HttpService.performGetRequest(
        ServiceConfig.naanApis,
        endpoint: "events"));

    if (eventsStorage.toString().hashCode != apiResult.toString().hashCode) {
      tags.value = apiResult['tags'];
      bottomText.value = apiResult['bottomText'];
      contactUsLink.value = apiResult['contactUsLink'];
      final Map<String, List<EventModel>> eventsByTime = {
        "Today": [],
        "Tomorrow": [],
        "This Week": [],
        "Next Week": [],
        "This Month": [],
        "Next Month": [],
        "This Year": [],
      };

      apiResult['events'].sort((a, b) {
        return int.parse(a['timestamp']) > int.parse(b['timestamp']) ? 1 : -1;
      });

// Iterate through each event and categorize them based on their timestamp
      apiResult['events'].forEach((json) {
        final EventModel event = EventModel.fromJson(json);
        final DateTime? eventTime = event.timestamp;
        final DateTime? endTime = event.endTimestamp;
        if (endTime!.isAfter(DateTime.now())) {
          if (_isToday(eventTime!, endTime)) {
            eventsByTime['Today']!.add(event);
          } else if (_isTomorrow(eventTime)) {
            eventsByTime['Tomorrow']!.add(event);
          } else if (_isThisWeek(eventTime)) {
            eventsByTime['This Week']!.add(event);
          } else if (_isNextWeek(eventTime)) {
            eventsByTime['Next Week']!.add(event);
          } else if (_isThisMonth(eventTime)) {
            eventsByTime['This Month']!.add(event);
          } else if (_isNextMonth(eventTime)) {
            eventsByTime['Next Month']!.add(event);
          } else if (_isThisYear(eventTime)) {
            eventsByTime['This Year']!.add(event);
          }
        }
      });
      events.value = eventsByTime;
    } else {}

    // store in local storage

    await ServiceConfig.hiveStorage
        .write(key: ServiceConfig.eventsStorage, value: jsonEncode(apiResult));

    return events.value;
  }

  // Helper functions to determine if a date falls into a specific time range
  bool _isToday(DateTime startTime, DateTime endTime) {
    final now = DateTime.now();
    return (startTime.day == now.day &&
            startTime.month == now.month &&
            startTime.year == now.year) ||
        now.isAfter(startTime) && now.isBefore(endTime);
  }

  bool _isTomorrow(DateTime dateTime) {
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));
    return dateTime.day == tomorrow.day &&
        dateTime.month == tomorrow.month &&
        dateTime.year == tomorrow.year;
  }

  bool _isThisWeek(DateTime dateTime) {
    final now = DateTime.now();
    final endOfWeek =
        now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    return dateTime.isAfter(now) && dateTime.isBefore(endOfWeek);
  }

  bool _isNextWeek(DateTime dateTime) {
    final now = DateTime.now();
    final endOfWeek =
        now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
    final nextEndOfWeek = endOfWeek.add(Duration(days: DateTime.daysPerWeek));
    return dateTime.isAfter(endOfWeek) && dateTime.isBefore(nextEndOfWeek);
  }

  bool _isThisMonth(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.month == now.month && dateTime.year == now.year;
  }

  bool _isNextMonth(DateTime dateTime) {
    final now = DateTime.now();
    final endOfMonth =
        DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
    final nextEndOfMonth =
        DateTime(now.year, now.month + 2, 1).subtract(const Duration(days: 1));
    return dateTime.isAfter(endOfMonth) && dateTime.isBefore(nextEndOfMonth);
  }

  bool _isThisYear(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year;
  }
}
