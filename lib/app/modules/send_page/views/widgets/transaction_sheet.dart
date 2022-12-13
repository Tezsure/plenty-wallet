import 'dart:io';

import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/data/services/analytics/firebase_analytics.dart';
import 'package:naan_wallet/app/data/services/auth_service/auth_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/helpers/on_going_tx_helper.dart';
import 'package:naan_wallet/app/data/services/operation_service/operation_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_model.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/constants/path_const.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

import 'transaction_status.dart';

class TransactionBottomSheet extends StatelessWidget {
  final SendPageController controller;
  RxBool isLoading = false.obs;

  TransactionBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      blurRadius: controller.isNFTPage.value ? 50 : 5,
      height: 450.sp,
      title: 'Review',
      titleAlignment: Alignment.center,
      titleStyle: titleMedium,
      bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.arrow_upward_rounded,
                color: ColorConst.textGrey1,
                size: 15,
              ),
              Text(
                'Sending',
                style: bodySmall.copyWith(
                    color: ColorConst.textGrey1, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          subtitle: Text(
            controller.isNFTPage.value
                ? controller.selectedNftModel!.fa!.name!
                : '${controller.selectedTokenModel!.symbol}',
            style: bodyMedium,
          ),
          leading: controller.isNFTPage.value
              ? getNftImage(controller.selectedNftModel)
              : getTokenImage(controller.selectedTokenModel),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 16.arP,
            horizontal: 8.arP,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorConst.darkGrey),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.isNFTPage.value
                    ? controller.selectedNftModel!.name!
                    : '${controller.amountController.text} ${controller.selectedTokenModel!.symbol}',
                style: bodyLarge.copyWith(color: ColorConst.textGrey1),
              ),
              Text(
                controller.isNFTPage.value
                    ? '\$ 0.00'
                    : '\$${controller.amountUsdController.text}',
                style: bodyLarge,
              )
            ],
          ),
        ),
        ListTile(
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text: controller.selectedReceiver.value!.address,
                ),
              ).whenComplete(() {
                Get.showSnackbar(const GetSnackBar(
                  message: "Copied to clipboard",
                  duration: Duration(seconds: 2),
                ));
              });
            },
            contentPadding: EdgeInsets.zero,
            title: Text(
              "To",
              style: bodySmall.copyWith(color: ColorConst.textGrey1),
            ),
            subtitle: SizedBox(
              width: 0.3.width,
              child: Row(
                children: [
                  Text(
                    controller.selectedReceiver.value!.name,
                    style: bodyMedium,
                  ),
                  0.02.hspace,
                  SvgPicture.asset(
                    '${PathConst.SVG}copy.svg',
                    color: Colors.white,
                    fit: BoxFit.contain,
                    height: 17.arP,
                  )
                ],
              ),
            ),
            leading: Image.asset(
              controller.selectedReceiver.value!.imagePath,
              width: 44,
            )),

        const Divider(
          color: ColorConst.darkGrey,
        ),
        // ListTile(
        //     contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        //     leading: Container(
        //       height: 24,
        //       width: 36,
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(12),
        //           color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
        //       child: Center(
        //         child: Text(
        //           'to',
        //           style: labelSmall.copyWith(
        //               color: ColorConst.NeutralVariant.shade60),
        //         ),
        //       ),
        //     ),
        //     trailing: SvgPicture.asset('assets/svg/chevron_down.svg')),
        ListTile(
            onTap: () {
              Clipboard.setData(
                ClipboardData(
                  text: controller.senderAccountModel!.publicKeyHash,
                ),
              ).whenComplete(() {
                Get.showSnackbar(const GetSnackBar(
                  message: "Copied to clipboard",
                  duration: Duration(seconds: 2),
                ));
              });
            },
            contentPadding: EdgeInsets.zero,
            title: Text(
              "From",
              style: bodySmall.copyWith(color: ColorConst.textGrey1),
            ),
            subtitle: SizedBox(
              width: 0.3.width,
              child: Row(
                children: [
                  Text(
                    controller.senderAccountModel!.name!,
                    style: bodyMedium,
                  ),
                  0.02.hspace,
                  SvgPicture.asset(
                    '${PathConst.SVG}copy.svg',
                    color: Colors.white,
                    fit: BoxFit.contain,
                    height: 17.arP,
                  )
                ],
              ),
            ),
            leading: Image.asset(
              controller.senderAccountModel!.profileImage!,
              width: 44,
            )),
        0.02.vspace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SolidButton(
            title: 'Hold to Send',
            isLoading: isLoading,
            onLongPressed: () async {
              if (isLoading.value) {
                return;
              }
              var isPasscodeOrBioValid =
                  await AuthService().verifyBiometricOrPassCode();

              if (!isPasscodeOrBioValid) {
                isLoading.value = false;
                return;
              }

              isLoading.value = true;

              AccountSecretModel? accountSecretModel =
                  await UserStorageService().readAccountSecrets(
                      controller.senderAccountModel!.publicKeyHash!);

              // submit Tx
              KeyStoreModel keyStoreModel = KeyStoreModel(
                publicKeyHash: controller.senderAccountModel!.publicKeyHash!,
                secretKey: accountSecretModel!.secretKey,
                publicKey: accountSecretModel.publicKey,
              );
              OperationModel operationModel;

              String opHash;

              if (controller.isNFTPage.value) {
                operationModel = OperationModel<NftTokenModel>();
              } else {
                operationModel = OperationModel<AccountTokenModel>();
              }

              operationModel.amount = !controller.isNFTPage.value
                  ? double.parse(controller.amountController.text)
                  : 0.0;

              operationModel.keyStoreModel = keyStoreModel;

              operationModel.model = controller.isNFTPage.value
                  ? controller.selectedNftModel
                  : controller.selectedTokenModel;

              operationModel.receiverContractAddres =
                  !controller.isNFTPage.value &&
                          controller.selectedTokenModel!.name == "Tezos"
                      ? ""
                      : controller.isNFTPage.value
                          ? controller.selectedNftModel!.faContract
                          : controller.selectedTokenModel!.contractAddress;

              operationModel.receiveAddress =
                  controller.selectedReceiver.value!.address;

              if (!controller.isNFTPage.value &&
                  controller.selectedTokenModel!.name == "Tezos") {
                var opHashData = await OperationService().sendXtzTx(
                    operationModel, ServiceConfig.currentSelectedNode);
                opHash = opHashData['operationGroupID']
                    .toString()
                    .trim()
                    .replaceAll('"', "");
                // print(opHash);
              } else {
                operationModel.buildParams();
                // do preApply from start and inject here
                operationModel.preAppliedResult = await OperationService()
                    .preApplyOperation(
                        operationModel, ServiceConfig.currentSelectedNode);
                // var opHash =
                opHash = await OperationService().injectOperation(
                    operationModel.preAppliedResult!,
                    ServiceConfig.currentSelectedNode);
                // print(opHash);
              }

              Get.back();

              NaanAnalytics.logEvent(NaanAnalyticsEvents.SEND_TRANSACTION,
                  param: {
                    NaanAnalytics.address:
                        operationModel.keyStoreModel?.publicKeyHash,
                    "receiver_address": operationModel.receiveAddress ??
                        operationModel.receiverContractAddres,
                    "type": controller.isNFTPage.value
                        ? "NFT_TRANSFER"
                        : "TOKEN_TRANSFER",
                    "name": controller.selectedTokenModel?.name ??
                        controller.selectedNftModel?.name
                  });
              Get.bottomSheet(
                NaanBottomSheet(
                  height: 380.sp,
                  bottomSheetWidgets: [
                    0.04.vspace,
                    Align(
                      alignment: Alignment.center,
                      child: LottieBuilder.asset(
                        '${PathConst.SEND_PAGE}lottie/success_primary.json',
                        height: 68,
                        width: 68,
                        repeat: false,
                      ),
                    ),
                    0.02.vspace,
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Transaction is submitted',
                        style: titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    0.01.vspace,
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Your transaction should be confirmed in\nnext 30 seconds',
                        textAlign: TextAlign.center,
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade70),
                      ),
                    ),
                    0.02.vspace,
                    SolidButton(
                        elevation: 0,
                        borderWidth: 1,
                        primaryColor: Colors.transparent,
                        borderColor: ColorConst.Neutral.shade80,
                        textColor: ColorConst.Primary.shade80,
                        title: 'Done',
                        onPressed: () {
                          Get
                            ..back()
                            ..back();

                          DataHandlerService().onGoingTxStatusHelpers.add(
                              OnGoingTxStatusHelper(
                                  opHash: opHash,
                                  status: TransactionStatus.pending,
                                  transactionAmount:
                                      operationModel.amount == 0.0
                                          ? "1 ${operationModel.model.nodes}"
                                          : operationModel.amount!
                                                  .toStringAsFixed(6)
                                                  .removeTrailing0 +
                                              " " +
                                              (operationModel.model
                                                      as AccountTokenModel)
                                                  .symbol!,
                                  tezAddress: operationModel.receiveAddress!
                                      .tz1Short()));
                          transactionStatusSnackbar(
                            status: TransactionStatus.pending,
                            tezAddress:
                                operationModel.receiveAddress!.tz1Short(),
                            transactionAmount: operationModel.amount == 0.0
                                ? "1 ${operationModel.model.nodes}"
                                : operationModel.amount!
                                        .toStringAsFixed(6)
                                        .removeTrailing0 +
                                    " " +
                                    (operationModel.model as AccountTokenModel)
                                        .symbol!,
                          );
                        }),
                    0.02.vspace,
                    SolidButton(
                      title: 'Share Naan',
                      textColor: Colors.white,
                      onPressed: () {
                        Share.share(
                            "👋 Hey friend! You should download naan, it's my favorite Tezos wallet to buy Tez, send transactions, connecting to Dapps and exploring NFT gallery of anyone. ${AppConstant.naanWebsite}");
                      },
                    ),
                  ],
                ),
                enterBottomSheetDuration: const Duration(milliseconds: 180),
                exitBottomSheetDuration: const Duration(milliseconds: 150),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Platform.isAndroid
                    ? SvgPicture.asset(
                        "${PathConst.SVG}fingerprint.svg",
                        color: ColorConst.Neutral.shade100,
                        width: 15.sp,
                      )
                    : SvgPicture.asset(
                        "${PathConst.SVG}faceid.svg",
                        color: ColorConst.Neutral.shade100,
                        width: 20.sp,
                      ),
                0.02.hspace,
                Text(
                  "Hold to Send",
                  style: titleSmall.copyWith(
                      fontSize: 14.aR, color: ColorConst.Neutral.shade100),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget getNftImage(nfTmodel) {
    return CircleAvatar(
      radius: 22,
      foregroundImage: NetworkImage(
          "https://assets.objkt.media/file/assets-003/${nfTmodel.faContract}/${nfTmodel.tokenId.toString()}/thumb400"),
    );
  }

  Widget getTokenImage(tokenModel) => CircleAvatar(
        radius: 22,
        backgroundColor: ColorConst.NeutralVariant.shade60.withOpacity(0.2),
        child: tokenModel.iconUrl!.startsWith("assets")
            ? Image.asset(
                tokenModel.iconUrl!,
                fit: BoxFit.cover,
              )
            : tokenModel.iconUrl!.endsWith(".svg")
                ? SvgPicture.network(
                    tokenModel.iconUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(tokenModel.iconUrl!
                                  .startsWith("ipfs")
                              ? "https://ipfs.io/ipfs/${tokenModel.iconUrl!.replaceAll("ipfs://", '')}"
                              : tokenModel.iconUrl!)),
                    ),
                  ),
      );
}
