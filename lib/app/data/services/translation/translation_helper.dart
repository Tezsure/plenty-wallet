import 'package:get/get.dart';

class AppTranslations extends Translations {
  final Map<String, String> en;
  final Map<String, String> nld;
  final Map<String, String> fr;

  AppTranslations({required this.en, required this.nld,
  required this.fr,});

  static AppTranslations fromJson(dynamic json) {
    return AppTranslations(
    en: Map<String, String>.from(json["en"]),
    nld: Map<String, String>.from(json["nld"]),
    fr: Map<String, String>.from(json["fr"]),
   );
  }

 @override
 Map<String, Map<String, String>> get keys => {
    "en": en,
    "nld": nld,
    "fr": fr,
  };
}
class TranslationHelper extends GetConnect {
  Future<AppTranslations?> getTranslations() async {
  const url = 'https://raw.githubusercontent.com/Tezsure/naan-app/feat/language/assets/language/eur.json';

  final response = await get(url, decoder: AppTranslations.fromJson);

   if (response.hasError) {
     return Future.error(response.statusText!);
    }

   return response.body;
  }
}