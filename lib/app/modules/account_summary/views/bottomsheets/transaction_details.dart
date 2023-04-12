import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/account_summary/controllers/account_summary_controller.dart';
import 'package:naan_wallet/app/modules/account_summary/views/bottomsheets/fee_detail_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:naan_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/add_contact_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/manage_accounts_sheet.dart';
import 'package:naan_wallet/app/modules/veNFT.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/constants/constants.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../utils/constants/path_const.dart';
import '../../../../data/services/service_config/service_config.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/token_info.dart';

class TransactionDetailsBottomSheet extends GetView<TransactionController> {
  // final TxHistoryModel transactionModel;
  TokenInfo tokenInfo;
  final String userAccountAddress;
  final double xtzPrice;
  TransactionDetailsBottomSheet(
      {super.key,
      // required this.transactionModel,
      required this.tokenInfo,
      required this.userAccountAddress,
      required this.xtzPrice});

  @override
  Widget build(BuildContext context) {
    // print(tokenInfo.token!.toJson());

    final source = tokenInfo.source;
    final destination = tokenInfo.destination;
    return NaanBottomSheet(
      // blurRadius: 50,
      width: 1.width,
      isScrollControlled: true,
      // height: .8.height,
      // bottomSheetHorizontalPadding: 0,

      // bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22.arP),
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: AppConstant.naanBottomSheetHeight),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      const BottomSheetHeading(
                        title: "",
                      ),
                      0.02.vspace,
                      Image.asset(
                        tokenInfo.token == null ||
                                tokenInfo.token!.operationStatus == "applied"
                            ? "assets/transaction/success.png"
                            : "assets/transaction/failed.png",
                        height: 60.arP,
                        width: 60.arP,
                      ),
                      0.02.vspace,
                      Text(
                        tokenInfo.token?.getTxType(userAccountAddress) ??
                            "Received",
                        style: titleLarge,
                      ),
                      0.01.vspace,
                      Center(
                        child: Text(
                            DateFormat('MM/dd/yyyy HH:mm')
                                // displaying formatted date
                                .format(tokenInfo.timeStamp!.toLocal()),
                            style: labelMedium.copyWith(
                                color: ColorConst.NeutralVariant.shade60)),
                      ),
                      0.02.vspace,
                      const Divider(
                        color: Color(0xff1E1C1F),
                      ),
                      0.02.vspace,
                      // tokenInfo.token != null ||
                      //         tokenInfo.token?.operationStatus != "applied" ||
                      (source?.address?.isEmpty ?? true)
                          ? const SizedBox()
                          : contactTile(source!, "From"),
                      0.02.vspace,
                      // tokenInfo.token != null ||
                      //         tokenInfo.token?.operationStatus != "applied" ||
                      (destination?.address?.isEmpty ?? true)
                          ? const SizedBox()
                          : contactTile(destination!, "To"),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.arP),
                          color: const Color(0xff1E1C1F),
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 24.arP,
                        ),
                        child: Column(
                          children: [
                            TxTokenInfo(
                              tokenInfo: tokenInfo,
                              userAccountAddress: userAccountAddress,
                              xtzPrice: xtzPrice,
                            ),
                            ...tokenInfo.internalOperation
                                .map((e) => TxTokenInfo(
                                      tokenInfo: e,
                                      userAccountAddress: userAccountAddress,
                                      xtzPrice: xtzPrice,
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Color(0xff1E1C1F),
        ),
        0.02.vspace,
        // BouncingWidget(
        //   onPressed: tokenInfo.token == null
        //       ? null
        //       : () {
        //           CommonFunctions.bottomSheet(TransactionFeeDetailShet(
        //             tokenInfo: tokenInfo,
        //             userAccountAddress: userAccountAddress,
        //             xtzPrice: xtzPrice,
        //           ));
        //         },
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "Fees",
        //         style: labelMedium.copyWith(
        //             color: ColorConst.NeutralVariant.shade60),
        //       ),
        //       Row(
        //         children: [
        //           Text(
        //             calculateFees().roundUpDollar(xtzPrice, decimals: 6),
        //             style: labelMedium,
        //           ),
        //           SizedBox(
        //             width: 4.arP,
        //           ),
        //           Icon(
        //             Icons.info_outline,
        //             color: ColorConst.NeutralVariant.shade60,
        //             size: 16.arP,
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        // 0.02.vspace,
        SolidButton(
          title: 'view on tzkt.io',
          onPressed: () {
            CommonFunctions.bottomSheet(
              const DappBrowserView(),
              fullscreen: true,
              settings: RouteSettings(
                arguments: "https://tzkt.io/${tokenInfo.token?.hash!}",
              ),
            );
          },
        ),
        const BottomButtonPadding()
      ],
    );
  }

  double calculateFees() {
    double fees = 0.0;
    if (tokenInfo.token == null) return fees;
    // For-loop
    if (tokenInfo.token!.bakerFee != null) fees += tokenInfo.token!.bakerFee!;
    if (tokenInfo.token!.storageFee != null) {
      fees += tokenInfo.token!.storageFee!;
    }
    if (tokenInfo.token!.allocationFee != null) {
      fees += tokenInfo.token!.allocationFee!;
    }
    if (tokenInfo.token!.gasUsed != null) fees += tokenInfo.token!.gasUsed!;
    fees = fees / 1e6;
    return fees;
  }

  Widget contactTile(AliasAddress contact, String type) {
    return Row(
      children: [
        ClipOval(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 22.aR,
            child: Image.network(
              "https://services.tzkt.io/v1/avatars/${contact.address!}",
              errorBuilder: (context, error, stackTrace) {
                return SvgPicture.asset(
                  'assets/svg/send.svg',
                );
              },
            ),
          ),
        ),
        0.02.hspace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: bodySmall.copyWith(
                  fontSize: 12.aR,
                  color: ColorConst.NeutralVariant.shade60,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  contact.alias ?? contact.address!.tz1Short(),
                  style: bodyMedium.copyWith(
                      fontSize: 14.aR, letterSpacing: 0.5.aR),
                ),
                0.02.hspace,
                BouncingWidget(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: contact.address));
                    Get.rawSnackbar(
                      maxWidth: 0.45.width,
                      backgroundColor: Colors.transparent,
                      snackPosition: SnackPosition.BOTTOM,
                      snackStyle: SnackStyle.FLOATING,
                      padding: const EdgeInsets.only(bottom: 60),
                      messageText: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: ColorConst.Neutral.shade10,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Copied to clipboard",
                              style: labelSmall,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    '${PathConst.SVG}copy.svg',
                    color: Colors.white,
                    fit: BoxFit.contain,
                    height: 16.aR,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        contact.address!.isValidWalletAddress
            ? Obx(() => PopupMenuButton(
                  position: PopupMenuPosition.under,
                  enableFeedback: true,
                  onCanceled: () =>
                      controller.isTransactionPopUpOpened.value = false,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: const Color(0xff421121),
                  itemBuilder: (_) {
                    controller.isTransactionPopUpOpened.value = true;

                    return <PopupMenuEntry>[
                      if (contact.address!.isValidWalletAddress) ...[
                        CustomPopupMenuItem(
                          height: 30.arP,
                          width: 120.arP,
                          padding: EdgeInsets.symmetric(horizontal: 10.arP),
                          onTap: () {
                            CommonFunctions.bottomSheet(
                              AddContactBottomSheet(
                                  isTransactionContact: true,
                                  contactModel: ContactModel(
                                      name: contact.alias ?? "",
                                      address: contact.address!,
                                      imagePath:
                                          ServiceConfig.allAssetsProfileImages[
                                              Random().nextInt(
                                        ServiceConfig
                                                .allAssetsProfileImages.length -
                                            1,
                                      )])),
                            ).whenComplete(() => controller.contact?.value =
                                controller.getContact(contact.address!));
                          },
                          child: Text(
                            "Add to contacts",
                            style: labelMedium,
                          ),
                        ),
                      ] else if (contact.address!.isValidWalletAddress) ...[
                        CustomPopupMenuItem(
                          height: 30.aR,
                          width: 100.aR,
                          padding: EdgeInsets.symmetric(horizontal: 11.aR),
                          onTap: () {
                            CommonFunctions.bottomSheet(
                              AddContactBottomSheet(
                                  isEditContact: true,
                                  isTransactionContact: true,
                                  contactModel: ContactModel(
                                      name: contact.alias ?? "Account",
                                      address: contact.address!,
                                      imagePath:
                                          ServiceConfig.allAssetsProfileImages[
                                              Random().nextInt(
                                        ServiceConfig
                                                .allAssetsProfileImages.length -
                                            1,
                                      )])),
                            ).whenComplete(() => controller.contact?.value =
                                controller.getContact(contact.address!));
                          },
                          child: Text(
                            "Edit ",
                            style: labelMedium.copyWith(fontSize: 12.aR),
                          ),
                        ),
                        CustomPopupMenuDivider(
                          height: 1,
                          color: ColorConst.Neutral.shade50,
                          padding: EdgeInsets.symmetric(horizontal: 0.arP),
                          thickness: 1,
                        ),
                        CustomPopupMenuItem(
                          padding: EdgeInsets.symmetric(horizontal: 10.arP),
                          height: 30.aR,
                          width: 100.aR,
                          onTap: () {
                            CommonFunctions.bottomSheet(
                              RemoveContactBottomSheet(
                                  contactModel: ContactModel(
                                      name: contact.alias ?? "",
                                      address: contact.address!,
                                      imagePath: ServiceConfig
                                          .allAssetsProfileImages.first)),
                            );
                          },
                          child: Text(
                            "Remove ",
                            style: labelMedium.copyWith(
                                fontSize: 12.aR,
                                color: ColorConst.Error.shade60),
                          ),
                        ),
                      ],
                    ];
                  },
                  child: Container(
                    height: 24.aR,
                    width: 24.aR,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.isTransactionPopUpOpened.value
                            ? ColorConst.Neutral.shade10
                            : Colors.transparent),
                    child: Icon(
                      Icons.more_horiz,
                      size: 24.aR,
                      color: Colors.white,
                    ),
                  ),
                ))
            : const SizedBox(),
      ],
    );
  }
}

class TxTokenInfo extends StatelessWidget {
  TxTokenInfo({
    super.key,
    required this.tokenInfo,
    required this.userAccountAddress,
    required this.xtzPrice,
    this.showAmount = true,
  });

  TokenInfo tokenInfo;
  final String userAccountAddress;
  final double xtzPrice;

  bool showAmount;

  @override
  Widget build(BuildContext context) {
    final selectedAccount = Get.find<HomePageController>()
        .userAccounts[Get.find<HomePageController>().selectedIndex.value]
        .publicKeyHash!;
    final tokenList = Get.find<AccountSummaryController>().tokensList;
    if (tokenInfo.token != null) {
      final transactionInterface =
          tokenInfo.token!.transactionInterface(tokenList);
      if (!tokenInfo.isNft) {
        tokenInfo = tokenInfo.copyWith(
          imageUrl: transactionInterface.imageUrl,
          name: transactionInterface.name,
          tokenAmount: tokenInfo.token!.getAmount(
            tokenList,
            selectedAccount,
          ),
        );
        tokenInfo = tokenInfo.copyWith(
            dollarAmount:
                transactionInterface.rate! * xtzPrice * tokenInfo.tokenAmount);
      }
      if (tokenInfo.name.isEmpty) {
        tokenInfo = tokenInfo.copyWith(
            nftTokenId: transactionInterface.tokenID,
            address: transactionInterface.contractAddress);
        return _loadNFTTransaction();
      }
    } else {
      if (tokenInfo.name.isEmpty) {
        return _loadNFTTransaction();
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.arP, horizontal: 10.arP),
      // margin: EdgeInsets.symmetric(
      //   vertical: 24.arP,
      // ),
      // decoration: showAmount
      //     ? null
      // : BoxDecoration(
      //     borderRadius: BorderRadius.circular(8.arP),
      //     color: const Color(0xff1E1C1F),
      //   ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20.aR,
            backgroundColor: ColorConst.NeutralVariant.shade60,
            child: tokenInfo.imageUrl.startsWith("assets")
                ? Image.asset(
                    tokenInfo.imageUrl,
                    fit: BoxFit.cover,
                  )
                : tokenInfo.imageUrl.endsWith(".svg")
                    ? SvgPicture.network(
                        tokenInfo.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : tokenInfo.nftContractAddress ==
                            "KT18kkvmUoefkdok5mrjU6fxsm7xmumy1NEw"
                        ? ClipOval(child: VeNFT(url: tokenInfo.imageUrl))
                        : Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: NetworkImage(tokenInfo.imageUrl
                                          .startsWith("ipfs")
                                      ? "https://ipfs.io/ipfs/${tokenInfo.imageUrl.replaceAll("ipfs://", '')}"
                                      : tokenInfo.imageUrl)),
                            ),
                          ),
          ),
          SizedBox(
            width: 12.arP,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                      tokenInfo.token?.getTxIcon(selectedAccount) ??
                          "assets/transaction/down.png",
                      width: 14.aR,
                      height: 14.arP,
                      color: ColorConst.NeutralVariant.shade60),
                  Container(
                    constraints: BoxConstraints(maxWidth: .5.width),
                    child: Text(
                        " ${tokenInfo.token?.getTxType(selectedAccount) ?? "Received"}",
                        maxLines: 1,
                        style: labelMedium.copyWith(
                          color: ColorConst.NeutralVariant.shade60,
                        )),
                  ),
                ],
              ),
              Container(
                constraints: BoxConstraints(maxWidth: .5.width),
                padding: EdgeInsets.only(top: 6.aR),
                child: Text(
                  tokenInfo.name,
                  maxLines: 1,
                  style: labelLarge.copyWith(
                      fontSize: 14.aR, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          const Spacer(),
          if (showAmount)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    tokenInfo.isNft
                        ? "${tokenInfo.tokenAmount == 0.0 ? "1" : tokenInfo.tokenAmount.toStringAsFixed(0)} ${tokenInfo.tokenSymbol}"
                        : getColor(tokenInfo.token) == ColorConst.NaanRed
                            ? '- ${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}'
                            : '+${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: bodySmall.copyWith(
                        color: tokenInfo.source!.address!
                                .contains(userAccountAddress)
                            ? ColorConst.NeutralVariant.shade60
                            : ColorConst.naanCustomColor)),
                SizedBox(
                  height: 6.arP,
                ),
                Text(
                  tokenInfo.token != null &&
                          tokenInfo.token?.operationStatus != "applied"
                      ? "failed"
                      : tokenInfo.dollarAmount
                          .roundUpDollar(xtzPrice, decimals: 6),
                  style: bodyMedium.copyWith(
                    color: tokenInfo.token == null ||
                            tokenInfo.token!.operationStatus != "applied"
                        ? getColor(tokenInfo.token)
                        : Colors.white,
                  ),
                )
              ],
            )
        ],
      ),
    );
  }

  Widget _loadNFTTransaction() {
    final tokenList = Get.find<AccountSummaryController>().tokensList;
    if (tokenInfo.token != null) {
      final transactionInterface =
          tokenInfo.token!.transactionInterface(tokenList);
      tokenInfo = tokenInfo.copyWith(
          nftTokenId: transactionInterface.tokenID,
          address: transactionInterface.contractAddress);
    }
    return FutureBuilder(
        future: ObjktNftApiService().getTransactionNFT(
            tokenInfo.nftContractAddress!, tokenInfo.nftTokenId!),
        builder: ((context, AsyncSnapshot<NftTokenModel> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(8.0.arP),
                child: const CupertinoActivityIndicator(
                  color: ColorConst.Primary,
                ),
              ),
            );
          } else if (snapshot.data!.name == null) {
            return Container();
          } else {
            tokenInfo = tokenInfo.copyWith(
                isNft: true,
                tokenSymbol: snapshot.data!.fa!.name.toString(),
                dollarAmount: (snapshot.data!.lowestAsk == null
                        ? 0
                        : (snapshot.data!.lowestAsk / 1e6)) *
                    xtzPrice,
                tokenAmount: snapshot.data!.lowestAsk != null &&
                        snapshot.data!.lowestAsk != 0
                    ? snapshot.data!.lowestAsk / 1e6
                    : 0,
                name: snapshot.data!.name.toString(),
                imageUrl: snapshot.data!.displayUri);
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tokenInfo.timeStamp!.isSameMonth(tokenInfo.timeStamp!)
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(
                            top: 16.arP, left: 16.arP, bottom: 16.arP),
                        child: Text(
                          DateFormat.MMMM()
                              // displaying formatted date
                              .format(
                                  DateTime.parse(tokenInfo.token!.timestamp!)),
                          style: labelLarge,
                        ),
                      ),
                TxTokenInfo(
                  tokenInfo: tokenInfo,
                  xtzPrice: xtzPrice,
                  userAccountAddress: userAccountAddress,
                ),
              ],
            );
          }
        }));
  }

  Color getColor(TxHistoryModel? data) {
    if (data == null) return ColorConst.naanCustomColor;
    final selectedAccount = Get.find<HomePageController>()
        .userAccounts[Get.find<HomePageController>().selectedIndex.value]
        .publicKeyHash!;
    if (data.isSent(selectedAccount)) {
      return ColorConst.NaanRed;
    }
    if (data.isReceived(selectedAccount)) {
      return ColorConst.naanCustomColor;
    }
    if (data.getTxType(selectedAccount) == "Contract interaction" &&
        (data.amount ?? 0) > 0 &&
        data.sender!.address == selectedAccount) {
      return ColorConst.NaanRed;
    }
    return Colors.white;
  }
}

class RemoveContactBottomSheet extends GetView<TransactionController> {
  final ContactModel contactModel;
  const RemoveContactBottomSheet({super.key, required this.contactModel});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      height: 262.arP,
      bottomSheetHorizontalPadding: 32,
      blurRadius: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      bottomSheetWidgets: [
        0.01.vspace,
        Text(
          'Delete Contact',
          style: titleLarge.copyWith(fontSize: 22.arP),
        ),
        0.03.vspace,
        Text(
          'Do you want to remove "${contactModel.name}"\n from your contacts?',
          textAlign: TextAlign.center,
          style: labelMedium.copyWith(
              fontSize: 12.aR,
              fontWeight: FontWeight.w400,
              color: ColorConst.NeutralVariant.shade60),
        ),
        0.025.vspace,
        SolidButton(
            primaryColor: const Color(0xff1E1C1F),
            title: "Remove contact",
            height: 52.aR,
            textColor: ColorConst.Error.shade60,
            onPressed: () async {
              controller.contacts.removeWhere(
                  (element) => element.address == contactModel.address);
              await UserStorageService().updateContactList(controller.contacts);
              await controller.updateSavedContacts();
              Get
                ..back()
                ..back();
            }),
        0.02.vspace,
        SolidButton(
          height: 52.aR,
          primaryColor: const Color(0xff1E1C1F),
          title: "Cancel",
          onPressed: Get.back,
        ),
      ],
    );
  }
}
