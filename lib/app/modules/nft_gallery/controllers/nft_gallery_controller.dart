import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';

class NftGalleryController extends GetxController {
  RxInt currentSelectedCategoryIndex = 0.obs;
  RxInt currentPageIndex = 0.obs;
  RxBool searchNft = false.obs;

  List<String> nftChips = const [
    'Art',
    'Collectibles',
    'Domain Names',
    'Music',
    'Sports',
  ];

  RxBool isExpanded = false.obs;
  RxString selectedCollectionsKey = "".obs;
  RxInt selectedNftIndex = 0.obs;

  void selectCollectible(String key) {
    selectedCollectionsKey.value = key;
  }

  void changeCurrentSelectedCategoryIndex(int index) {
    currentSelectedCategoryIndex.value = index;
  }

  void searchNftToggle() {
    searchNft.value = !searchNft.value;
  }

  void toggleExpanded(bool val) {
    isExpanded.value = val;
  }

  RxMap<String, List<NftTokenModel>> usersNfts =
      <String, List<NftTokenModel>>{}.obs; // List of tokens

  RxList<AccountModel> userAccounts = <AccountModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    userAccounts.value = Get.find<HomePageController>().userAccounts;
    fetchAllNfts();

    Get.find<HomePageController>().userAccounts.listen((accounts) {
      userAccounts.value = accounts;
      fetchAllNfts();
    });
  }

  Future<void> fetchAllNfts() async {
    usersNfts = <String, List<NftTokenModel>>{}.obs;
    for (var account in userAccounts) {
      UserStorageService()
          .getUserNfts(
        userAddress: account.publicKeyHash!,
      )
          .then(
        (nftList) {
          for (var i = 0; i < nftList.length; i++) {
            usersNfts[nftList[i].fa!.contract!] =
                (usersNfts[nftList[i].fa!.contract!] ?? [])..add(nftList[i]);
          }
        },
      );
    }
  }
}

// TODO Remove this models after merging with the send flow branch