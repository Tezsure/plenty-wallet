import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  Get.put(LifeCycleController(), permanent: true);
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runZonedGuarded(() async {
    // debugInvertOversizedImages = true;
    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kReleaseMode);
    // FirebaseCrashlytics.instance.crash();
    NaanAnalytics().setupAnalytics();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(
      GetMaterialApp(
        title: "Naan",
        theme: ThemeData(
          fontFamily: "Poppins",
        ),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: NaanAnalytics().getAnalytics()),
        ],
        supportedLocales: const [
          Locale("en", "US"),
        ],
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class LifeCycleController extends SuperController {
  @override
  void onDetached() {
    if (DataHandlerService().updateTimer != null) {
      DataHandlerService().updateTimer!.cancel();
    }
    print("onDetached");
  }

  @override
  void onInactive() {}

  @override
  void onPaused() {
    closeBackground();
    print("onPaused");
  }

  closeBackground() {
    if (DataHandlerService().updateTimer != null) {
      //Get.delete<BeaconService>(force: true);
      DataHandlerService().updateTimer!.cancel();
      DataHandlerService().updateTimer = null;
    }
  }

  @override
  void onResumed() {
    //Get.put(BeaconService(), permanent: true);

    DataHandlerService().setUpTimer();
    print("onResumed");
  }
}
