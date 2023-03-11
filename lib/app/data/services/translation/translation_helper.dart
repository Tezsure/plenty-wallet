import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/utils/translation.dart';

import '../rpc_service/http_service.dart';

class AppTranslations extends Translations {
  final Map<String, String> en;
  final Map<String, String> nl;
  final Map<String, String> fr;

  AppTranslations({
    required this.en,
    required this.nl,
    required this.fr,
  });

  static AppTranslations fromJson(dynamic json) {
    return AppTranslations(
      en: Map<String, String>.from(json["en"]),
      nl: Map<String, String>.from(json["nl"]),
      fr: Map<String, String>.from(json["fr"]),
    );
  }

  @override
  Map<String, Map<String, String>> get keys => {
        "en": en,
        "nl": nl,
        "fr": fr,
      };
}

class TranslationHelper extends GetConnect {
  Future<Translations?> getTranslations() async {
    const url =
        'https://raw.githubusercontent.com/Tezsure/naan-app/feat/language/assets/language/eur.json';

    final response = await HttpService.performGetRequest(
      url,
    );

    if (response.isNotEmpty && jsonDecode(response).length != 0) {
      return AppTranslations.fromJson(jsonDecode(response));
    }
    return null;
  }
}
