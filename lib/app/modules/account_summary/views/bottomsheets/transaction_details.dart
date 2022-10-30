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
      blurRadius: 50,
      width: 1.width,
      height: 0.53.height,
      titleAlignment: Alignment.center,
      titleStyle: titleMedium,
      bottomSheetHorizontalPadding: 12.sp,
      bottomSheetWidgets: [
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Transaction Details\n',
                style: titleLarge,
                children: [
                  WidgetSpan(child: 0.02.vspace),
                  TextSpan(
                      text: DateFormat('MM/dd/yyyy HH:mm')
                          // displaying formatted date
                          .format(DateTime.parse(transactionModel.timestamp!)
                              .toLocal()),
                      style: labelSmall.copyWith(
                          color: ColorConst.NeutralVariant.shade60)),
                ]),
          ),
        ),
        0.02.vspace,
        ListTile(
          leading: CircleAvatar(
            radius: 20.sp,
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
          visualDensity: VisualDensity.compact,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                  transactionModel.sender!.address!.contains(userAccountAddress)
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 18.sp,
                  color: ColorConst.NeutralVariant.shade60),
              Text(
                  transactionModel.sender!.address!.contains(userAccountAddress)
                      ? ' Sent'
                      : ' Received',
                  style: labelLarge.copyWith(
                      color: ColorConst.NeutralVariant.shade60,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          subtitle: Text(
            tokenInfo.isNft ? tokenInfo.tokenSymbol : tokenInfo.name,
            style: labelLarge,
          ),
        ),
        0.012.vspace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: const Color(0xff1E1C1F).withOpacity(0.8),
            child: SizedBox(
              height: 60.sp,
              child: Center(
                child: ListTile(
                    visualDensity: VisualDensity.compact,
                    leading: Text(
                        tokenInfo.isNft
                            ? tokenInfo.name
                            : transactionModel.sender!.address!
                                    .contains(userAccountAddress)
                                ? '- ${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}'
                                : '${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}',
                        style: labelLarge.copyWith(
                            fontWeight: FontWeight.w400,
                            color: transactionModel.sender!.address!
                                    .contains(userAccountAddress)
                                ? Colors.white
                                : ColorConst.naanCustomColor)),
                    trailing: Text(
                      "\$${tokenInfo.dollarAmount.toStringAsFixed(6)}",
                      style: labelMedium.copyWith(fontWeight: FontWeight.w400),
                    )),
              ),
            ),
          ),
        ),
        0.02.vspace,
        Divider(
          indent: 16.sp,
          endIndent: 16.sp,
          color: const Color(0xff1E1C1F),
        ),
        Obx(() {
          if (controller.contacts.isEmpty) {
            return contactTile(null);
          } else {
            return contactTile(controller.contacts.firstWhereOrNull(
                (element) => element.address == getSenderAddress()));
          }
        }),
        Center(
          child: GestureDetector(
            onTap: () {
              CommonFunctions.launchURL(
                  "https://tzkt.io/${transactionModel.hash!}");
            },
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 20.sp),
                width: 0.32.width,
                height: 31.sp,
                decoration: BoxDecoration(
                    color: const Color(0xff1E1C1F).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('view on tzkt.io',
                        style: labelSmall.copyWith(
                            color: ColorConst.NeutralVariant.shade60)),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: 12.sp,
                      color: ColorConst.NeutralVariant.shade60,
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget contactTile(ContactModel? contact) {
    return ListTile(
      leading: contact != null
          ? Image.asset(
              contact.imagePath,
              height: 40.sp,
            )
          : SvgPicture.asset(
              'assets/svg/send.svg',
              height: 40.sp,
            ),
      title: Text(
        'From',
        style: bodySmall.copyWith(
            color: ColorConst.NeutralVariant.shade60,
            fontWeight: FontWeight.w600),
      ),
      subtitle: Row(
        children: [
          Text(
            contact != null ? contact.name : getSenderAddress().tz1Short(),
            style: bodyMedium,
          ),
          0.02.hspace,
          GestureDetector(
            onTap: () {
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
                message: "Copied to clipboard",
                shouldIconPulse: true,
                snackPosition: SnackPosition.BOTTOM,
                maxWidth: 0.9.width,
                margin: EdgeInsets.only(
                  bottom: 20.sp,
                ),
                duration: const Duration(milliseconds: 700),
              );
            },
            child: SvgPicture.asset(
              '${PathConst.SVG}copy.svg',
              color: Colors.white,
              fit: BoxFit.contain,
              height: 16.sp,
            ),
          ),
        ],
      ),
      trailing: getSenderAddress().isValidWalletAddress
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
                        height: 30.sp,
                        width: 120.sp,
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        onTap: () {
                          Get.bottomSheet(
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
                            isScrollControlled: true,
                            barrierColor: Colors.transparent,
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
                        height: 30.sp,
                        width: 100.sp,
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                        onTap: () {
                          Get.bottomSheet(
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
                            isScrollControlled: true,
                            barrierColor: Colors.transparent,
                          ).whenComplete(() => controller.contact?.value =
                              controller.getContact(getSenderAddress()));
                        },
                        child: Text(
                          "Edit ",
                          style: labelMedium,
                        ),
                      ),
                      CustomPopupMenuDivider(
                        height: 1,
                        color: ColorConst.Neutral.shade50,
                        padding: EdgeInsets.symmetric(horizontal: 0.sp),
                        thickness: 1,
                      ),
                      CustomPopupMenuItem(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        height: 30.sp,
                        width: 100.sp,
                        onTap: () {
                          Get.bottomSheet(
                            RemoveContactBottomSheet(contactModel: contact),
                            barrierColor: Colors.transparent,
                          );
                        },
                        child: Text(
                          "Remove ",
                          style: labelMedium.apply(
                              color: ColorConst.Error.shade60),
                        ),
                      ),
                    ],
                  ];
                },
                child: Container(
                  height: 24.sp,
                  width: 24.sp,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.isTransactionPopUpOpened.value
                          ? ColorConst.Neutral.shade10
                          : Colors.transparent),
                  child: Icon(
                    Icons.more_horiz,
                    size: 24.sp,
                    color: Colors.white,
                  ),
                ),
              ))
          : const SizedBox(),
    );
  }

  String getSenderAddress() => transactionModel.sender!.address!
          .contains(userAccountAddress)
      ? transactionModel.parameter?.value == null
          ? transactionModel.target!.address!
          : senderAddress(transactionModel,
              transactionModel.sender!.address!.contains(userAccountAddress))!
      : transactionModel.parameter?.value == null
          ? transactionModel.sender!.address!
          : senderAddress(transactionModel,
              transactionModel.sender!.address!.contains(userAccountAddress))!;

  String? senderAddress(TxHistoryModel model, bool isSent) {
    if (transactionModel.parameter?.value is List) {
      return isSent
          ? transactionModel.parameter?.value[0]['txs'][0]['to_']
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
    return null;
  }
}

class RemoveContactBottomSheet extends GetView<TransactionController> {
  final ContactModel contactModel;
  const RemoveContactBottomSheet({super.key, required this.contactModel});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      height: 262.sp,
      bottomSheetHorizontalPadding: 32,
      blurRadius: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      bottomSheetWidgets: [
        Text(
          'Delete Contact',
          style: titleLarge,
        ),
        0.03.vspace,
        Text(
          'Do you want to remove "${contactModel.name}"\n from your contacts?',
          textAlign: TextAlign.center,
          style: labelMedium.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorConst.NeutralVariant.shade60),
        ),
        0.025.vspace,
        SolidButton(
            primaryColor: const Color(0xff1E1C1F),
            title: "Remove contact",
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
          primaryColor: const Color(0xff1E1C1F),
          title: "Cancel",
          onPressed: Get.back,
        ),
      ],
    );
  }
}
