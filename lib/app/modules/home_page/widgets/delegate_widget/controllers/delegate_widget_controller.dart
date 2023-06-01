
import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/delegate_service/delegate_handler.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_reward_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/account_selector.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/account_switch_widget/account_switch_widget.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_baker.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_info_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_success_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/redelegate_sheet.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/transaction_status.dart';
import 'package:naan_wallet/utils/common_functions.dart';

import '../widgets/review_delegate_baker.dart';

class DelegateWidgetController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final RxString bakerAddress = ''.obs;

  final RxBool showFilter = true.obs;
  final RxDouble totalRewards = 0.0.obs;

  final ScrollController scrollController = ScrollController();
  Rx<AccountModel>? accountModel;
  Rx<BakerListBy> bakerListBy = BakerListBy.Rank.obs;
  late DelegateHandler _delegateHandler;

  RxList<DelegateRewardModel> delegateRewardList = <DelegateRewardModel>[].obs;
  RxList<DelegateBakerModel> delegateBakerList = <DelegateBakerModel>[].obs;
  RxList<DelegateBakerModel> searchedDelegateBakerList =
      <DelegateBakerModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      showFilter.value = scrollController.position.userScrollDirection ==
          ScrollDirection.forward;
    });
    _delegateHandler = DelegateHandler();
    getBakerList();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    textEditingController.dispose();
  }

  void onTextChanged(String value) {
    bakerAddress.value = value;
  }

  void selectFilter(BakerListBy type) {
    bakerListBy.value = type;

    updateBakerList();
    Get.back();
  }

  void updateBakerList() {
    searchedDelegateBakerList.value = delegateBakerList.where((p0) {
      return p0.name!
          .toLowerCase()
          .contains(textEditingController.text.toLowerCase().trim());
    }).toList();

    searchedDelegateBakerList.sort((p0, p1) {
      switch (bakerListBy.value) {
        case BakerListBy.Fees:
          return (((p0.fee) - (p1.fee)) * 10000000).toInt();

        case BakerListBy.Rank:
          return (p0.rank ?? 0) - (p1.rank ?? 0);
        case BakerListBy.Yield:
          return ((p0.delegateBakersListResponseYield ?? 0) -
                  (p1.delegateBakersListResponseYield ?? 0))
              .toInt();

        case BakerListBy.Space:
          return (p0.freespace ?? 0) - (p1.freespace ?? 0);

        case BakerListBy.Staking:
          return (p0.freespace ?? 0) - (p1.freespace ?? 0);
      }
    });
  }

  Future<void> addCustomBaker(String address) async {
    try {
      final result = await DelegateHandler().bakerDetail(address);

      if (result == null) {
        Get.showSnackbar(const GetSnackBar(
          message: "Not a valid baker",
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        ));
        return;
      } else {
        Get.back();
        CommonFunctions.bottomSheet(ReviewDelegateSelectBaker(
          baker: result,
        ));
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(const GetSnackBar(
        message: "Not a valid baker",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 2),
      ));
      return;
    }
  }

  Future<void> confirmBioMetric(DelegateBakerModel baker) async {
    try {
      final isVerified = await AuthService().verifyBiometricOrPassCode();
      if (!isVerified) return;
      CommonFunctions.toggleLoaderOverlay(
        () async {
          await confirmDelegate(baker);
        },
      );
    } catch (e) {}
  }

  Future<void> confirmDelegate(DelegateBakerModel baker) async {
    try {
      KeyStoreModel keyStore = KeyStoreModel(
        publicKey: (await UserStorageService()
                .readAccountSecrets(accountModel!.value.publicKeyHash!))!
            .publicKey,
        secretKey: (await UserStorageService()
                .readAccountSecrets(accountModel!.value.publicKeyHash!))!
            .secretKey,
        publicKeyHash: accountModel!.value.publicKeyHash!,
      );
      final signer = Dartez.createSigner(
        keyStore.secretKey!,
      );
      await Dartez.sendDelegationOperation(
          ServiceConfig.currentSelectedNode, signer, keyStore, baker.address!);
      Future.delayed(
        const Duration(milliseconds: 500),
      ).then((value) {
        NaanAnalytics.logEvent(
            NaanAnalyticsEvents.DELEGATE_TRANSACTION_SUBMITTED,
            param: {
              NaanAnalytics.address: keyStore.publicKeyHash,
              "baker_name": baker.name,
              "baker_address": baker.address,
            });
        CommonFunctions.bottomSheet(const DelegateBakerSuccessSheet())
            .whenComplete(() => Get.back());
      });
    } catch (e) {
      print(e.toString());
      transactionStatusSnackbar(
        status: TransactionStatus.error,
        duration: const Duration(seconds: 2),
        tezAddress: "Something went wrong",
        transactionAmount: "Error",
      );
      // Get.snackbar(
      //   'Error',
      //   "Something went wrong",
      //   margin: const EdgeInsets.all(20),
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: ColorConst.Error.withOpacity(0.75),
      //   colorText: Colors.white,
      // );
    }
  }

  Future<void> getBakerList() async {
    bakerListBy.value = BakerListBy.Rank;
    searchedDelegateBakerList = <DelegateBakerModel>[].obs;
    if (delegateBakerList.isNotEmpty) {
      searchedDelegateBakerList.value = delegateBakerList;
      return;
    }
    // try {
    await _delegateHandler.getBakerList().then((value) {
      searchedDelegateBakerList.value = value;
      return delegateBakerList.value = value;
    });
    // } catch (e) {
    //   print(e.toString());

    //   delegateBakerList.value = <DelegateBakerModel>[];
    // }
  }

  Future<void> getDelegateRewardList() async {
    delegateRewardList.value = [];
    totalRewards.value = 0;
    try {
      await _delegateHandler
          .getDelegateReward(
        accountModel!.value.publicKeyHash!,
      )
          .then((value) {
        return delegateRewardList.value = value;
      });
    } catch (e) {
      // Get.closeAllSnackbars();

      // Get.rawSnackbar(
      //   onTap: (_) {
      //     getDelegateRewardList();
      //   },
      //   message: "Failed to load, tap to try again",
      //   shouldIconPulse: true,
      //   backgroundColor: ColorConst.NaanRed,
      //   snackPosition: SnackPosition.BOTTOM,
      //   maxWidth: 0.9.width,
      //   margin: EdgeInsets.only(
      //     bottom: 20.aR,
      //   ),
      //   duration: const Duration(milliseconds: 700),
      // );
      delegateRewardList.value = <DelegateRewardModel>[];
    }
    getTotalRewards();
    getCycleStatus();
  }

  Future<void> getCycleStatus() async {
    try {
      int limit =
          (delegateRewardList.first.cycle! - delegateRewardList.last.cycle!) +
              1;
      final cycleStatusList = await _delegateHandler.getCycleStatus(limit);
      for (var i = 0; i < delegateRewardList.length; i++) {
        final baker = delegateBakerList.firstWhere(
            (element) =>
                element.address == delegateRewardList[i].baker?.address,
            orElse: () => DelegateBakerModel());
        delegateRewardList[i].bakerDetail = baker;
        delegateRewardList.value = List.from([...delegateRewardList]);
        final status = cycleStatusList.firstWhere(
            (element) => element.index == delegateRewardList[i].cycle);
        if (status == null) {
          continue;
        }
        if (DateTime.now().isAfter(status.endTime!)) {
          delegateRewardList[i].status = "Completed";
        } else if (DateTime.now().isAfter(status.startTime!)) {
          delegateRewardList[i].status = "In Progess";
        } else {
          delegateRewardList[i].status = "Pending";
        }
        //  delegateRewardList[i].status
        delegateRewardList.value = List.from([...delegateRewardList]);
      }
    } catch (e) {
      printError(info: e.toString());
    }
  }

  void getTotalRewards() {
    totalRewards.value = 0;
    for (var element in delegateRewardList) {
      totalRewards.value = totalRewards.value +
          ((element.balance /
                  (element.activeStake == 0.0 ? 1 : element.activeStake)) *
              (element.blockRewards + element.endorsementRewards));
    }
    totalRewards.value =
        (totalRewards / 1e6) * Get.find<HomePageController>().xtzPrice.value;
  }

  Future<String?> getCurrentBakerAddress(String pkh) async {
    return await _delegateHandler.checkBaker(pkh);
  }

  String? prevPage;
  Future<void> checkBaker(BuildContext context) async {
    String? bakerAddress;

    if (Get.find<HomePageController>().userAccounts.isEmpty) {
      return CommonFunctions.bottomSheet(
        const DelegateInfoSheet(),
      );
    }

    Get.put(AccountSummaryController());
    accountModel = Get.find<HomePageController>()
        .userAccounts[Get.find<HomePageController>().selectedIndex.value]
        .obs;

    if (accountModel == null) {
      return CommonFunctions.bottomSheet(const AccountSelectorSheet(),
          fullscreen: true);
    }
    // if (accountModel?.value.publicKeyHash == null) {}
    // await toggleLoaderOverlay(() async {
    bakerAddress = accountModel!.value.delegatedBakerAddress;
    // ;
    // });

    if (bakerAddress == null) {
      CommonFunctions.bottomSheet(
        const DelegateInfoSheet(),
      ).then((value) {
        if (value != null) {
          if (prevPage == null) {
            CommonFunctions.bottomSheet(
                DelegateSelectBaker(
                  isScrollable: true,
                ),
                fullscreen: true);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DelegateSelectBaker(
                    isScrollable: true,
                  ),
                ));
          }
        }
      });
    } else {
      DelegateBakerModel? delegatedBaker;
      if (delegateBakerList.isEmpty) {
        await CommonFunctions.toggleLoaderOverlay(getBakerList);
      }
      NaanAnalytics.logEvent(NaanAnalyticsEvents.REDELEGATE);
      if (delegateBakerList.any((element) => element.address == bakerAddress)) {
        delegatedBaker = delegateBakerList.firstWhere(
          (element) => element.address == bakerAddress,
        );
        if (prevPage != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReDelegateBottomSheet(
                  baker: delegatedBaker!,
                ),
              ));
        } else {
          CommonFunctions.bottomSheet(
              ReDelegateBottomSheet(
                baker: delegatedBaker,
              ),
              fullscreen: true);
        }
      } else {
        await CommonFunctions.toggleLoaderOverlay(() async {
          delegatedBaker = (await getBakerDetail(bakerAddress!)) ??
              DelegateBakerModel(address: bakerAddress);
          delegateBakerList.add(delegatedBaker!);
        });
        CommonFunctions.bottomSheet(
            ReDelegateBottomSheet(
              baker: delegatedBaker!,
            ),
            fullscreen: true);
      }
    }
  }

  Future<DelegateBakerModel?> getBakerDetail(String bakerAddress) async {
    // try {
    return await _delegateHandler.bakerDetail(bakerAddress);
    // } catch (e) {
    //   print(e.toString());
    //   return null;
    // }
  }

  Future<void> openBakerList(BuildContext context, String? prevPageName) async {
    //setting prevpage
    prevPage = prevPageName;
    if (prevPage == null) {
      Get.put(AccountSummaryController());
      CommonFunctions.bottomSheet(
        AccountSwitch(
          title: "Delegate",
          subtitle:
              "In Tezos, we delegate a wallet to a baker\nand earn interest on the available Tez in the wallet.",
          onNext: ({String senderAddress = ""}) {
            checkBaker(context);
          },
        ),
      );
    } else {
      checkBaker(context);
    }
  }
}

enum BakerListBy { Rank, Yield, Space, Staking, Fees }
