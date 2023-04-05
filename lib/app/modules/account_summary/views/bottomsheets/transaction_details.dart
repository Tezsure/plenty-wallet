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
import 'package:naan_wallet/app/modules/common_widgets/bottom_button_padding.dart';
import 'package:naan_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:naan_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:naan_wallet/app/modules/common_widgets/info_button.dart';
import 'package:naan_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:naan_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
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
  final double xtzPrice;
  const TransactionDetailsBottomSheet(
      {super.key,
      required this.transactionModel,
      required this.tokenInfo,
      required this.userAccountAddress,
      required this.xtzPrice});

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      title: "",
      // blurRadius: 50,
      width: 1.width,
      isScrollControlled: true,
      // height: .8.height,

      // bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        Column(
          children: [
            0.02.vspace,
            Image.asset(
              tokenInfo.token!.operationStatus == "applied"
                  ? "assets/transaction/success.png"
                  : "assets/transaction/failed.png",
              height: 60.arP,
              width: 60.arP,
            ),
            0.02.vspace,
            Text(
              transactionModel.actionType,
              style: titleLarge,
            ),
            0.01.vspace,
            Center(
              child: Text(
                  DateFormat('MM/dd/yyyy HH:mm')
                      // displaying formatted date
                      .format(DateTime.parse(transactionModel.timestamp!)
                          .toLocal()),
                  style: labelMedium.copyWith(
                      color: ColorConst.NeutralVariant.shade60)),
            ),
            0.02.vspace,
            const Divider(
              color: Color(0xff1E1C1F),
            ),
            0.02.vspace,
            if (!transactionModel.actionType.contains("Delegated"))
              tokenInfo.token!.operationStatus != "applied" ||
                      transactionModel.send.address!.isEmpty
                  ? const SizedBox()
                  : contactTile(transactionModel.send, "From"),
            0.02.vspace,
            tokenInfo.token!.operationStatus != "applied" ||
                    transactionModel.reciever.address!.isEmpty
                ? const SizedBox()
                : contactTile(transactionModel.reciever, "To"),
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
                  _buildTokenInfo(tokenInfo),
                  ...tokenInfo.internalOperation
                      .map((e) => _buildTokenInfo(e))
                      .toList(),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Color(0xff1E1C1F),
        ),
        0.02.vspace,
        BouncingWidget(
          onPressed: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fees",
                style: labelMedium.copyWith(
                    color: ColorConst.NeutralVariant.shade60),
              ),
              Row(
                children: [
                  Text(
                    0.0018.roundUpDollar(xtzPrice, decimals: 6),
                    style: labelMedium,
                  ),
                  SizedBox(
                    width: 4.arP,
                  ),
                  Icon(
                    Icons.info_outline,
                    color: ColorConst.NeutralVariant.shade60,
                    size: 16.arP,
                  ),
                ],
              ),
            ],
          ),
        ),
        0.02.vspace,
        SolidButton(
          title: 'view on tzkt.io',
          onPressed: () {
            CommonFunctions.bottomSheet(
              const DappBrowserView(),
              fullscreen: true,
              settings: RouteSettings(
                arguments: "https://tzkt.io/${transactionModel.hash!}",
              ),
            );
          },
        ),
        const BottomButtonPadding()
      ],
    );
  }

  Widget _buildTokenInfo(TokenInfo info) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.arP, horizontal: 10.arP),
      // margin: EdgeInsets.symmetric(
      //   vertical: 24.arP,
      // ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(8.arP),
      //   color: const Color(0xff1E1C1F),
      // ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.aR,
            backgroundColor: ColorConst.NeutralVariant.shade60,
            child: info.imageUrl.startsWith("assets")
                ? Image.asset(
                    info.imageUrl,
                    fit: BoxFit.cover,
                  )
                : info.imageUrl.endsWith(".svg")
                    ? SvgPicture.network(
                        info.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(info.imageUrl
                                      .startsWith("ipfs")
                                  ? "https://ipfs.io/ipfs/${info.imageUrl.replaceAll("ipfs://", '')}"
                                  : info.imageUrl)),
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
                      info.token!.sender!.address!.contains(userAccountAddress)
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 14.aR,
                      color: ColorConst.NeutralVariant.shade60),
                  Container(
                    constraints: BoxConstraints(maxWidth: .5.width),
                    child: Text(" ${info.token!.actionType}",
                        style: labelMedium.copyWith(
                          color: ColorConst.NeutralVariant.shade60,
                        )),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 5.aR),
                child: Text(
                  info.isNft ? tokenInfo.tokenSymbol : tokenInfo.name,
                  style: labelLarge.copyWith(
                      fontSize: 14.aR, fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  info.isNft
                      ? info.name
                      : info.token!.sender!.address!
                              .contains(userAccountAddress)
                          ? '- ${info.tokenAmount.toStringAsFixed(6)} ${info.tokenSymbol}'
                          : '+${info.tokenAmount.toStringAsFixed(6)} ${info.tokenSymbol}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: bodySmall.copyWith(
                      color: info.token!.sender!.address!
                              .contains(userAccountAddress)
                          ? ColorConst.NeutralVariant.shade60
                          : ColorConst.naanCustomColor)),
              Text(
                info.token!.operationStatus != "applied"
                    ? "failed"
                    : tokenInfo.dollarAmount
                        .roundUpDollar(xtzPrice, decimals: 6),
                style: bodyMedium.copyWith(
                  color: info.token!.operationStatus != "applied"
                      ? ColorConst.NaanRed
                      : Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
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
                                      name: transactionModel.send.alias ?? "",
                                      address: transactionModel.send.address!,
                                      imagePath:
                                          ServiceConfig.allAssetsProfileImages[
                                              Random().nextInt(
                                        ServiceConfig
                                                .allAssetsProfileImages.length -
                                            1,
                                      )])),
                            ).whenComplete(() => controller.contact?.value =
                                controller.getContact(
                                    transactionModel.send.address!));
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
                                      address: transactionModel.send.address!,
                                      imagePath:
                                          ServiceConfig.allAssetsProfileImages[
                                              Random().nextInt(
                                        ServiceConfig
                                                .allAssetsProfileImages.length -
                                            1,
                                      )])),
                            ).whenComplete(() => controller.contact?.value =
                                controller.getContact(
                                    transactionModel.send.address!));
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
