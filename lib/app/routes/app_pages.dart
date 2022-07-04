import 'package:get/get.dart';

import 'package:naan_wallet/app/modules/home_page/bindings/home_page_binding.dart';
import 'package:naan_wallet/app/modules/home_page/views/home_page_view.dart';
import 'package:naan_wallet/app/modules/nft_page/bindings/nft_page_binding.dart';
import 'package:naan_wallet/app/modules/nft_page/views/nft_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME_PAGE;

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
  ];
}
