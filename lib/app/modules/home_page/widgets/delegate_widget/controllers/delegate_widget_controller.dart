import 'dart:developer';
import 'dart:math';

import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/delegate/delegate_handler.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_baker_list_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_cycle_model.dart';
import 'package:naan_wallet/app/data/services/service_models/delegate_reward_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/beacon_bottom_sheet/biometric/views/biometric_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_info_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/delegate_success_sheet.dart';
import 'package:naan_wallet/app/modules/home_page/widgets/delegate_widget/widgets/redelegate_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';

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

    accountModel = Get.find<HomePageController>().userAccounts[0].obs;
    if (accountModel == null) {
      Get.back();
      Get.snackbar('Error', 'Connect wallet not found',
          backgroundColor: ColorConst.Error, colorText: Colors.white);
    }
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

  selectFilter(BakerListBy type) {
    bakerListBy.value = type;

    updateBakerList();
    Get.back();
  }

  void updateBakerList() {
    searchedDelegateBakerList.value = delegateBakerList.where((p0) {
      return p0.name!
          .toLowerCase()
          .contains(textEditingController.text.toLowerCase());
    }).toList();

    searchedDelegateBakerList.sort((p0, p1) {
      switch (bakerListBy.value) {
        case BakerListBy.Fees:
          return (((p0.fee) - (p1.fee)) * 10000000).toInt();

        case BakerListBy.Rank:
          return (p0.rank ?? 0) - (p1.rank ?? 0);
      }
    });
  }

  Future<void> confirmBioMetric(DelegateBakerModel baker) async {
    try {
      AuthService authService = AuthService();
      bool isBioEnabled = await authService.getBiometricAuth();

      if (isBioEnabled) {
        final bioResult = await Get.bottomSheet(const BiometricView(),
            barrierColor: Colors.white.withOpacity(0.09),
            isScrollControlled: true,
            settings: RouteSettings(arguments: isBioEnabled));
        if (bioResult == null) {
          return;
        }
        if (!bioResult) {
          return;
        }
      } else {
        var isValid = await Get.toNamed('/passcode-page', arguments: [
          true,
        ]);
        if (isValid == null) {
          return;
        }
        if (!isValid) {
          return;
        }
      }
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
      toggleLoaderOverlay(
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
      final signer = await Dartez.createSigner(Dartez.writeKeyWithHint(
          keyStore.secretKey,
          keyStore.publicKeyHash.startsWith("tz2") ? 'spsk' : 'edsk'));
      final result = await Dartez.sendDelegationOperation(
          ServiceConfig.currentSelectedNode,
          signer,
          keyStore,
          baker.address!,
          1000);
      print(result);
      Future.delayed(
        const Duration(milliseconds: 500),
      ).then((value) {
        Get.bottomSheet(const DelegateBakerSuccessSheet())
            .whenComplete(() => Get.back());
      });
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: ColorConst.Error, colorText: Colors.white);
    }
  }

  Future<void> getBakerList() async {
    bakerListBy.value = BakerListBy.Rank;
    searchedDelegateBakerList = <DelegateBakerModel>[].obs;
    try {
      await _delegateHandler.getBakerList().then((value) {
        searchedDelegateBakerList.value = value;
        return delegateBakerList.value = value;
      });
    } catch (e) {
      Get.closeAllSnackbars();

      Get.rawSnackbar(
        onTap: (_) {
          getBakerList();
        },
        message: "Failed to load, tap to try gain",
        shouldIconPulse: true,
        backgroundColor: ColorConst.NaanRed,
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: 0.9.width,
        margin: EdgeInsets.only(
          bottom: 20.aR,
        ),
        duration: const Duration(milliseconds: 700),
      );
      delegateBakerList.value = <DelegateBakerModel>[];
    }
  }

  Future<void> getDelegateRewardList(String bakerAddress) async {
    delegateRewardList.value = [];
    totalRewards.value = 0;
    try {
      await _delegateHandler
          .getDelegateReward(accountModel!.value.publicKeyHash!, bakerAddress)
          .then((value) {
        return delegateRewardList.value = value;
      });
    } catch (e) {
      Get.closeAllSnackbars();

      Get.rawSnackbar(
        onTap: (_) {
          getBakerList();
        },
        message: "Failed to load, tap to try gain",
        shouldIconPulse: true,
        backgroundColor: ColorConst.NaanRed,
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: 0.9.width,
        margin: EdgeInsets.only(
          bottom: 20.aR,
        ),
        duration: const Duration(milliseconds: 700),
      );
      delegateRewardList.value = <DelegateRewardModel>[];
    }
    getTotalRewards();
    getCycleStatus();
  }

  Future<void> getCycleStatus() async {
    try {
      for (var i = 0; i < delegateRewardList.length; i++) {
        final status = (await _delegateHandler
            .getCycleStatus(delegateRewardList[i].cycle ?? 0));
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
    delegateRewardList.forEach((element) {
      totalRewards.value = totalRewards.value +
          ((element.balance / element.activeStake) *
              (element.blockRewards + element.endorsementRewards));
    });
    totalRewards.value = (totalRewards / pow(10, 6)) *
        Get.find<HomePageController>().xtzPrice.value;
  }

  Future<void> checkBaker() async {
    String? bakerAddress;
    await toggleLoaderOverlay(() async {
      bakerAddress =
          await _delegateHandler.checkBaker(accountModel!.value.publicKeyHash!);
    });

    if (bakerAddress == null) {
      Get.bottomSheet(const DelegateInfoSheet(),
          enableDrag: true, isScrollControlled: true);
    } else {
      DelegateBakerModel delegatedBaker;
      if (delegateBakerList.isEmpty) {
        await toggleLoaderOverlay(getBakerList);
      }
      if (delegateBakerList.any((element) => element.address == bakerAddress)) {
        delegatedBaker = delegateBakerList.firstWhere(
          (element) => element.address == bakerAddress,
        );
        Get.bottomSheet(
            ReDelegateBottomSheet(
              baker: delegatedBaker,
            ),
            enableDrag: true,
            isScrollControlled: true);
      }
    }
  }

  Future<void> toggleLoaderOverlay(Function() asyncFunction) async {
    await Get.showOverlay(
        asyncFunction: () async => await asyncFunction(),
        loadingWidget: const SizedBox(
          height: 50,
          width: 50,
          child: Center(
              child: CircularProgressIndicator(
            color: ColorConst.Primary,
          )),
        ));
    // if (Get.isOverlaysOpen) {
    //   Get.back();
    // }
  }
}

enum BakerListBy { Rank, Fees }
