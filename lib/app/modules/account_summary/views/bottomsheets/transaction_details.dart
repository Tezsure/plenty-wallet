import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:naan_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:naan_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/send_page/views/widgets/add_contact_sheet.dart';
import 'package:naan_wallet/app/modules/settings_page/widget/manage_accounts_sheet.dart';
import 'package:naan_wallet/utils/colors/colors.dart';
import 'package:naan_wallet/utils/common_functions.dart';
import 'package:naan_wallet/utils/extensions/size_extension.dart';
import 'package:naan_wallet/utils/styles/styles.dart';
import 'package:naan_wallet/utils/utils.dart';

import '../../../../../utils/constants/path_const.dart';
import '../../../../data/services/service_config/service_config.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/token_info.dart';

class TransactionDetailsBottomSheet extends GetView<TransactionController> {
  final TxHistoryModel transactionModel;
  final TokenInfo tokenInfo;
  final String userAccountAddress;

  const TransactionDetailsBottomSheet(
      {super.key,
      required this.transactionModel,
      required this.tokenInfo,
      required this.userAccountAddress});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "Transaction details",
      blurRadius: 50,
      width: 1.width,
      height: 450.arP,
      titleAlignment: Alignment.center,
      titleStyle: titleMedium,
      bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        Center(
          child: Text(
              DateFormat('MM/dd/yyyy HH:mm')
                  // displaying formatted date
                  .format(
                      DateTime.parse(transactionModel.timestamp!).toLocal()),
              style: labelMedium.copyWith(
                  fontSize: 12.aR, color: ColorConst.NeutralVariant.shade60)),
        ),
        0.02.vspace,
        Row(
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
            0.01.hspace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                        transactionModel.sender!.address!
                                .contains(userAccountAddress)
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 14.aR,
                        color: ColorConst.NeutralVariant.shade60),
                    Text(
                        transactionModel.sender!.address!
                                .contains(userAccountAddress)
                            ? ' Sent'
                            : ' Received',
                        style: labelLarge.copyWith(
                            fontSize: 14.aR,
                            color: ColorConst.NeutralVariant.shade60,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.aR),
                  child: Text(
                    tokenInfo.isNft ? tokenInfo.tokenSymbol : tokenInfo.name,
                    style: labelLarge.copyWith(
                        fontSize: 14.aR, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ],
        ),
        0.02.vspace,
        Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: const Color(0xff1E1C1F),
          child: SizedBox(
            height: 60.aR,
            child: Center(
              child: ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: SizedBox(
                    width: 0.6.width,
                    child: Text(
                        tokenInfo.isNft
                            ? tokenInfo.name
                            : transactionModel.sender!.address!
                                    .contains(userAccountAddress)
                                ? '- ${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}'
                                : '+${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: bodyLarge.copyWith(
                            color: transactionModel.sender!.address!
                                    .contains(userAccountAddress)
                                ? Colors.white
                                : ColorConst.naanCustomColor)),
                  ),
                  trailing: Text(
                    tokenInfo.token!.operationStatus != "applied"
                        ? "failed"
                        : "\$${tokenInfo.dollarAmount.toStringAsFixed(6)}",
                    style: labelLarge.copyWith(
                        letterSpacing: 0.5.aR,
                        fontWeight: FontWeight.w400,
                        color: tokenInfo.token!.operationStatus != "applied"
                            ? ColorConst.NaanRed
                            : Colors.white,
                        fontSize: 14.aR),
                  )),
            ),
          ),
        ),
        0.02.vspace,
        const Divider(
          color: Color(0xff1E1C1F),
        ),
        0.012.vspace,
        tokenInfo.token!.operationStatus != "applied" ||
                getSenderAddress().isEmpty
            ? const SizedBox()
            : Obx(() {
                if (controller.contacts.isEmpty) {
                  return contactTile(
                    null,
                  );
                } else {
                  return contactTile(
                    controller.contacts.firstWhereOrNull(
                        (element) => element.address == getSenderAddress()),
                  );
                }
              }),
        const Spacer(),
        Center(
          child: BouncingWidget(
            onPressed: () {
              CommonFunctions.launchURL(
                  "https://tzkt.io/${transactionModel.hash!}");
            },
            child: Container(
                margin: EdgeInsets.only(top: 40.aR, bottom: 45.aR),
                width: 0.32.width,
                height: 31.aR,
                decoration: BoxDecoration(
                    color: const Color(0xff1E1C1F).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('view on tzkt.io',
                        style: labelMedium.copyWith(
                            fontSize: 12.aR,
                            fontWeight: FontWeight.w600,
                            color: ColorConst.NeutralVariant.shade60)),
                    0.01.hspace,
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 12.aR,
                      color: ColorConst.NeutralVariant.shade60,
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget contactTile(
    ContactModel? contact,
  ) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 22.aR,
          child: contact != null
              ? Image.asset(
                  contact.imagePath,
                )
              : SvgPicture.asset(
                  'assets/svg/send.svg',
                ),
        ),
        0.02.hspace,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "From",
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
                  contact != null
                      ? contact.name
                      : getSenderAddress().tz1Short(),
                  style: bodyMedium.copyWith(
                      fontSize: 14.aR, letterSpacing: 0.5.aR),
                ),
                0.02.hspace,
                BouncingWidget(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                      text: contact != null
                          ? contact.address
                          : transactionModel.sender!.address!
                                  .contains(userAccountAddress)
                              ? transactionModel.parameter?.value == null
                                  ? transactionModel.target!.address!
                                  : senderAddress(
                                      transactionModel,
                                      transactionModel.sender!.address!
                                          .contains(userAccountAddress))!
                              : transactionModel.parameter?.value == null
                                  ? transactionModel.sender!.address!
                                  : senderAddress(
                                      transactionModel,
                                      transactionModel.sender!.address!
                                          .contains(userAccountAddress))!,
                    ));
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
        getSenderAddress().isValidWalletAddress
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
                      if (contact == null &&
                          getSenderAddress().isValidWalletAddress) ...[
                        CustomPopupMenuItem(
                          height: 30.arP,
                          width: 120.arP,
                          padding: EdgeInsets.symmetric(horizontal: 10.arP),
                          onTap: () {
                            CommonFunctions.bottomSheet(
                              AddContactBottomSheet(
                                  isTransactionContact: true,
                                  contactModel: ContactModel(
                                      name: '',
                                      address: getSenderAddress(),
                                      imagePath:
                                          ServiceConfig.allAssetsProfileImages[
                                              Random().nextInt(
                                        ServiceConfig
                                                .allAssetsProfileImages.length -
                                            1,
                                      )])),
                            ).whenComplete(() => controller.contact?.value =
                                controller.getContact(getSenderAddress()));
                          },
                          child: Text(
                            "Add to contacts",
                            style: labelMedium,
                          ),
                        ),
                      ] else if (contact != null &&
                          getSenderAddress().isValidWalletAddress) ...[
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
                                      name: contact.name,
                                      address: getSenderAddress(),
                                      imagePath:
                                          ServiceConfig.allAssetsProfileImages[
                                              Random().nextInt(
                                        ServiceConfig
                                                .allAssetsProfileImages.length -
                                            1,
                                      )])),
                            ).whenComplete(() => controller.contact?.value =
                                controller.getContact(getSenderAddress()));
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
                              RemoveContactBottomSheet(contactModel: contact),
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

  String getSenderAddress() =>
      transactionModel.sender!.address!.contains(userAccountAddress)
          ? transactionModel.parameter?.value == null
              ? transactionModel.target?.address ??
                  transactionModel.newDelegate?.address ??
                  ""
              : senderAddress(
                      transactionModel,
                      transactionModel.sender!.address!
                          .contains(userAccountAddress)) ??
                  ""
          : transactionModel.parameter?.value == null
              ? transactionModel.sender!.address!
              : senderAddress(
                      transactionModel,
                      transactionModel.sender!.address!
                          .contains(userAccountAddress)) ??
                  "";

  String? senderAddress(TxHistoryModel model, bool isSent) {
    if (transactionModel.operationStatus != "applied") return "";
    if (transactionModel.parameter?.value is List) {
      return isSent
          ? (transactionModel.parameter?.value[0]?['txs']?[0]?['to_'] ??
              transactionModel.parameter?.value[0]?['add_operator']
                  ?['operator'] ??
              "")
          : transactionModel.parameter?.value[0]['from_'];
    } else if (transactionModel.parameter?.value is Map) {
      return isSent
          ? transactionModel.parameter?.value['to']
          : transactionModel.parameter?.value['from'];
    } else if (transactionModel.parameter?.value is String) {
      var decoded = jsonDecode(transactionModel.parameter!.value);
      if (decoded is Map) {
        return isSent ? decoded['to'] : decoded['from'];
      } else if (decoded is List) {
        return isSent ? decoded[0]['txs'][0]['to_'] : decoded[0]['from_'];
      }
    } else {
      return "";
    }
    return "";
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
