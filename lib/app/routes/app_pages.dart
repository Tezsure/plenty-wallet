import 'package:get/get.dart';

import '../modules/account_summary/bindings/account_summary_binding.dart';
import '../modules/account_summary/views/account_summary_view.dart';
import '../modules/backup_wallet_page/bindings/backup_wallet_binding.dart';
import '../modules/backup_wallet_page/views/backup_wallet_view.dart';
import '../modules/beacon_bottom_sheet/biometric/bindings/biometric_binding.dart';
import '../modules/beacon_bottom_sheet/biometric/views/biometric_view.dart';
import '../modules/beacon_bottom_sheet/opreation_request/bindings/opreation_request_binding.dart';
import '../modules/beacon_bottom_sheet/opreation_request/views/opreation_request_view.dart';
import '../modules/beacon_bottom_sheet/pair_request/bindings/pair_request_binding.dart';
import '../modules/beacon_bottom_sheet/pair_request/views/pair_request_view.dart';
import '../modules/beacon_bottom_sheet/payload_request/bindings/payload_request_binding.dart';
import '../modules/beacon_bottom_sheet/payload_request/views/payload_request_view.dart';
import '../modules/biometric_page/bindings/biometric_page_binding.dart';
import '../modules/biometric_page/views/biometric_page_view.dart';
import '../modules/create_profile_page/bindings/create_profile_page_binding.dart';
import '../modules/create_profile_page/views/create_profile_page_view.dart';
import '../modules/create_wallet_page/bindings/create_wallet_page_binding.dart';
import '../modules/create_wallet_page/views/create_wallet_page_view.dart';
import '../modules/dapp_browser/bindings/dapp_browser_binding.dart';
import '../modules/dapp_browser/views/dapp_browser_view.dart';
import '../modules/home_page/widgets/discover_apps_widget/bindings/dapps_page_binding.dart';
import '../modules/home_page/widgets/discover_apps_widget/widgets/discover_apps_page_view.dart';
import '../modules/events/bindings/events_binding.dart';
import '../modules/events/views/events_view.dart';
import '../modules/home_page/bindings/home_page_binding.dart';
import '../modules/home_page/views/home_page_view.dart';
import '../modules/home_page/widgets/accounts_widget/bindings/accounts_widget_binding.dart';
import '../modules/home_page/widgets/accounts_widget/views/accounts_widget_view.dart';
import '../modules/import_wallet_page/bindings/import_wallet_page_binding.dart';
import '../modules/import_wallet_page/views/import_wallet_page_view.dart';
import '../modules/loading_page/bindings/loading_page_binding.dart';
import '../modules/loading_page/views/loading_page_view.dart';
import '../modules/onboarding_page/bindings/onboarding_page_binding.dart';
import '../modules/onboarding_page/views/onboarding_page_view.dart';
import '../modules/passcode_page/bindings/passcode_page_binding.dart';
import '../modules/passcode_page/views/passcode_page_view.dart';
import '../modules/receive_page/bindings/receive_page_binding.dart';
import '../modules/receive_page/views/receive_page_view.dart';
import '../modules/send_page/bindings/send_token_page_binding.dart';
import '../modules/send_page/views/send_page.dart';
import '../modules/settings_page/bindings/settings_page_binding.dart';
import '../modules/settings_page/views/settings_page_view.dart';
import '../modules/splash_page/bindings/splash_page_binding.dart';
import '../modules/splash_page/views/splash_page_view.dart';
import '../modules/verify_phrase_page/bindings/verify_phrase_page_binding.dart';
import '../modules/verify_phrase_page/views/verify_phrase_page_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME_PAGE,
      page: () => HomePageView(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_WALLET_PAGE,
      page: () => const CreateWalletPageView(),
      binding: CreateWalletPageBinding(),
    ),
    GetPage(
      name: _Paths.PASSCODE_PAGE,
      page: () => const PasscodePageView(),
      binding: PasscodePageBinding(),
    ),
    GetPage(
      name: _Paths.BIOMETRIC_PAGE,
      page: () => const BiometricPageView(),
      binding: BiometricPageBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_PROFILE_PAGE,
      page: () => const CreateProfilePageView(),
      binding: CreateProfilePageBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING_PAGE,
      page: () => const OnboardingPageView(),
      binding: OnboardingPageBinding(),
    ),
    // GetPage(
    //   name: _Paths.BACKUP_WALLET,
    //   page: () => const BackupWalletView(),
    //   binding: BackupWalletBinding(),
    // ),
    // GetPage(
    //   name: _Paths.VERIFY_PHRASE_PAGE,
    //   page: () => const VerifyPhrasePageView(),
    //   binding: VerifyPhrasePageBinding(),
    // ),
    GetPage(
      name: _Paths.IMPORT_WALLET_PAGE,
      page: () => ImportWalletPageView(),
      binding: ImportWalletPageBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNTS_WIDGET,
      page: () => AccountsWidget(),
      binding: AccountsWidgetBinding(),
    ),
    // GetPage(
    //   name: _Paths.SETTINGS_PAGE,
    //   page: () => const SettingsPageView(),
    //   binding: SettingsPageBinding(),
    // ),
    GetPage(
      name: _Paths.SEND_PAGE,
      page: () => const SendPage(),
      binding: SendTokenPageBinding(),
    ),
    GetPage(
      name: _Paths.RECEIVE_PAGE,
      page: () => const ReceivePageView(),
      binding: ReceivePageBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_PAGE,
      page: () => const SplashPageView(),
      binding: SplashPageBinding(),
    ),
    GetPage(
      name: _Paths.LOADING_PAGE,
      page: () => const LoadingPageView(),
      binding: LoadingPageBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_SUMMARY,
      page: () => AccountSummaryView(),
      binding: AccountSummaryBinding(),
    ),
    GetPage(
      name: _Paths.DAPP_BROWSER,
      page: () => const DappBrowserView(),
      binding: DappBrowserBinding(),
    ),
    // GetPage(
    //   name: _Paths.PAIR_REQUEST,
    //   page: () => const PairRequestView(),
    //   binding: PairRequestBinding(),
    // ),
    GetPage(
      name: _Paths.PAYLOAD_REQUEST,
      page: () => const PayloadRequestView(),
      binding: PayloadRequestBinding(),
    ),
    GetPage(
      name: _Paths.OPREATION_REQUEST,
      page: () => const OpreationRequestView(),
      binding: OpreationRequestBinding(),
    ),
    GetPage(
      name: _Paths.BIOMETRIC,
      page: () => const BiometricView(),
      binding: BiometricBinding(),
    ),
    GetPage(
      name: _Paths.DAPPS_PAGE,
      page: () =>  DappsPageView(),
      binding: DappsPageBinding(),
    ),
    GetPage(
      name: _Paths.EVENTS,
      page: () => const EventsView(),
      binding: EventsBinding(),
    ),
  ];
}
