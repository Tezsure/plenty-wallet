import 'package:get/get.dart';

import '../modules/biometric_page/bindings/biometric_page_binding.dart';
import '../modules/biometric_page/views/biometric_page_view.dart';
import '../modules/create_profile_page/bindings/create_profile_page_binding.dart';
import '../modules/create_profile_page/views/create_profile_page_view.dart';
import '../modules/create_wallet_page/bindings/create_wallet_page_binding.dart';
import '../modules/create_wallet_page/views/create_wallet_page_view.dart';
import '../modules/home_page/bindings/home_page_binding.dart';
import '../modules/home_page/views/home_page_view.dart';
import '../modules/import_wallet_page/bindings/import_wallet_page_binding.dart';
import '../modules/import_wallet_page/views/import_wallet_page_view.dart';
import '../modules/nft_page/bindings/nft_page_binding.dart';
import '../modules/nft_page/views/nft_page_view.dart';
import '../modules/passcode_page/bindings/passcode_page_binding.dart';
import '../modules/passcode_page/views/passcode_page_view.dart';
import '../modules/onboarding_page/bindings/onboarding_page_binding.dart';
import '../modules/onboarding_page/views/onboarding_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME_PAGE,
      page: () => HomePageView(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: _Paths.NFT_PAGE,
      page: () => NftPageView(),
      binding: NftPageBinding(),
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
    GetPage(
      name: _Paths.IMPORT_WALLET_PAGE,
      page: () => const ImportWalletPageView(),
      binding: ImportWalletPageBinding(),
    ),
  ];
}
