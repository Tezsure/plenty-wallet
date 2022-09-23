import 'package:dartez/dartez.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/data_handler_service.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/helpers/on_going_tx_helper.dart';
import 'package:naan_wallet/app/data/services/operation_service/operation_service.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/account_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/operation_model.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
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
      width: 1.width,
      height: 355.sp,
      title: 'Sending',
      titleAlignment: Alignment.center,
      titleStyle: titleMedium,
      bottomSheetHorizontalPadding: 10,
      bottomSheetWidgets: [
        ListTile(
          title: Text(
            controller.isNFTPage.value
                ? controller.selectedNftModel!.name!
                : '\$${controller.amountUsdController.text}',
            style: headlineSmall,
          ),
          subtitle: Text(
            controller.isNFTPage.value
                ? controller.selectedNftModel!.fa!.name!
                : '${controller.amountController.text} ${controller.selectedTokenModel!.symbol}',
            style: bodyMedium.copyWith(color: ColorConst.Primary.shade70),
          ),
          trailing: controller.isNFTPage.value
              ? getNftImage(controller.selectedNftModel)
              : getTokenImage(controller.selectedTokenModel),
        ),
        ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            leading: Container(
              height: 24,
              width: 36,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorConst.NeutralVariant.shade60.withOpacity(0.2)),
              child: Center(
                child: Text(
                  'to',
                  style: labelSmall.copyWith(
                      color: ColorConst.NeutralVariant.shade60),
                ),
              ),
            ),
            trailing: SvgPicture.asset('assets/svg/chevron_down.svg')),
        ListTile(
            title: Text(
              controller.selectedReceiver.value!.name,
              style: headlineSmall,
            ),
            subtitle: SizedBox(
              width: 0.3.width,
              child: Row(
                children: [
                  Text(
                    controller.selectedReceiver.value!.address.tz1Short(),
                    style:
                        bodyMedium.copyWith(color: ColorConst.Primary.shade70),
                  ),
                  0.02.hspace,
                  Icon(
                    Icons.copy,
                    color: ColorConst.Primary.shade60,
                    size: 10,
                  ),
                ],
              ),
            ),
            trailing: Image.asset(
              controller.selectedReceiver.value!.imagePath,
              width: 44,
            )),
        0.02.vspace,
        Align(
          alignment: Alignment.center,
          child: SolidButton(
            title: 'Hold to Send',
            width: 0.85.width,
            isLoading: isLoading,
            onPressed: () async {
              if (isLoading.value) {
                return;
              }
              isLoading.value = true;
              // submit Tx
              KeyStoreModel keyStoreModel = KeyStoreModel(
                publicKeyHash: controller.senderAccountModel!.publicKeyHash!,
                secretKey: controller.senderAccountModel!.secretKey,
                publicKey: controller.senderAccountModel!.publicKey,
              );
              OperationModel operationModel;

              String opHash;

              if (controller.isNFTPage.value) {
                operationModel = OperationModel<NftTokenModel>();
              } else {
                operationModel = OperationModel<AccountTokenModel>();
              }

              // operationModel
              //     .counter = int.parse((await HttpService.performGetRequest(
              //         ServiceConfig.currentSelectedNode,
              //         endpoint:
              //             "chains/main/blocks/head/context/contracts/${keyStoreModel.publicKeyHash}/counter"))
              //     .trim()
              //     .replaceAll('"', ""));

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
              Get.bottomSheet(NaanBottomSheet(
                height: 380.sp,
                bottomSheetWidgets: [
                  0.04.vspace,
                  Align(
                    alignment: Alignment.center,
                    child: LottieBuilder.asset(
                      '${PathConst.SEND_PAGE}lottie/send_success.json',
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
                  0.02.vspace,
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
                      title: 'Got it',
                      onPressed: () {
                        Get
                          ..back()
                          ..back();

                        DataHandlerService().onGoingTxStatusHelpers.add(
                            OnGoingTxStatusHelper(
                                opHash: opHash,
                                status: TransactionStatus.pending,
                                transactionAmount: operationModel.amount == 0.0
                                    ? "1 ${operationModel.model.name}"
                                    : operationModel.amount!
                                            .toStringAsFixed(6)
                                            .removeTrailing0 +
                                        " " +
                                        (operationModel.model
                                                as AccountTokenModel)
                                            .symbol!,
                                tezAddress:
                                    operationModel.receiveAddress!.tz1Short()));
                        transactionStatusSnackbar(
                          status: TransactionStatus.pending,
                          tezAddress: operationModel.receiveAddress!.tz1Short(),
                          transactionAmount: operationModel.amount == 0.0
                              ? "1 ${operationModel.model.name}"
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
                          "👋 Hey friend! You should download naan, it's my favorite Tezos wallet to buy Tez, send transactions, connecting to Dapps and exploring NFT gallery of anyone. https://naanwallet.com");
                    },
                  ),
                ],
              ));
            },
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
