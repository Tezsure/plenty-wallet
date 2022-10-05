import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';

class NftFilterController extends GetxController {
  RxList<AccountModel> accounts = List.generate(
    10,
    (index) => AccountModel(
        isNaanAccount: true,
        name: "Account $index",
        publicKeyHash: "tezjfbejbfeuvkjvb",
        profileImage: "${PathConst.ASSETS}profile_images/${index + 1}.png"),
  ).obs;

  RxList<AccountModel> selectedAccounts = <AccountModel>[].obs;

  Rx<NFTviewType> nfTviewType = NFTviewType.collection.obs;
  Rx<NftSortBy> nftsortby = NftSortBy.recentlyAdded.obs;

  void clear() {
    selectedAccounts.clear();
    nfTviewType.value = NFTviewType.collection;
    nftsortby.value = NftSortBy.recentlyAdded;
  }
}

enum NFTviewType { collection, list, thumbnail }

enum NftSortBy { recentlyAdded, oldest }
