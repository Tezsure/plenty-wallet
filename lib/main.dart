import 'dart:async';
import 'dart:io';
import 'dart:ui';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:get/get.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/env.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 20;
  PaintingBinding.instance.imageCache.clear();
  Get.put(LifeCycleController(), permanent: true);
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(
        details.exception, details.stack ?? StackTrace.current);
  };
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(oneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared
      .promptUserForPushNotificationPermission(fallbackToSettings: true)
      .then((accepted) {
    print("Accepted permission: $accepted");
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler(
      (OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
  });

  runZonedGuarded(() async {
    //  debugPaintSizeEnabled = true;
    //  debugInvertOversizedImages = true;
    await Firebase.initializeApp();
/*     await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(kReleaseMode); */

    NaanAnalytics().setupAnalytics();
/*     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError; */
/*     PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance
          .recordError(error, stack, fatal: true, reason: "Platform error");
      return true;
    }; */

    //FirebaseCrashlytics.instance.crash();
    await Instabug.start(
        '74da8bcfe330c611f60eaee532e451db', [InvocationEvent.shake]);

    //Remove this method to stop OneSignal Debugging

    runApp(
      Phoenix(
        child: GetMaterialApp(
            title: "naan",
            locale: Get.deviceLocale,
            theme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: "Poppins",
            ),
            navigatorObservers: [
              //InstabugNavigatorObserver(),
              FirebaseAnalyticsObserver(
                  analytics: NaanAnalytics().getAnalytics()),
            ],
            supportedLocales: const [
              Locale("en", "US"),
              Locale("en", "IN"),
            ],
            debugShowCheckedModeBanner: false,
            initialRoute: AppPages.INITIAL,

            // getPages: AppPages.routes,
            onGenerateRoute: (settings) {
              final page = AppPages.routes.firstWhere(
                  (e) => e.name.toLowerCase() == settings.name!.toLowerCase());
              page.binding?.dependencies();

              return MaterialWithModalsPageRoute(
                  settings: settings,
                  builder: (context) => CupertinoScaffold(
                      topRadius: Radius.circular(24.arP), body: page.page()));
            }),
      ),
    );
  }, (error, stackTrace) {
    CrashReporting.reportCrash(error, stackTrace);
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
    PaintingBinding.instance.imageCache.clear();
    if (DataHandlerService().updateTimer != null) {
      //Get.delete<BeaconService>(force: true);
      DataHandlerService().updateTimer!.cancel();
      DataHandlerService().updateTimer = null;
    }
  }

  bool isFirstTime = true;
  @override
  void onResumed() {
    //Get.put(BeaconService(), permanent: true);
    if (isFirstTime) {
      isFirstTime = false;

      return;
    }
    DataHandlerService().currencyPrices();
    DataHandlerService().setUpTimer();
    print("onResumed");
  }
}
