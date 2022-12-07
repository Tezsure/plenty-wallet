import 'package:firebase_analytics/firebase_analytics.dart';

class NaanAnalytics {
  static final NaanAnalytics _singleton = NaanAnalytics._internal();
  static late FirebaseAnalytics _analytics;

  factory NaanAnalytics() => _singleton;

  NaanAnalytics._internal() {
    _analytics = FirebaseAnalytics.instance;
  }

  void logEvent(String name,
      {bool addTz1 = false, Map<String, dynamic>? param}) async {
    await _analytics.logEvent(name: name, parameters: param);
  }

  FirebaseAnalytics getAnalytics() {
    return _analytics;
  }
}
