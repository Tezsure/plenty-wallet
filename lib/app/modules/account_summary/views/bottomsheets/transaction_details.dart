import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:naan_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:naan_wallet/app/data/services/rpc_service/http_service.dart';
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
import 'package:naan_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:naan_wallet/app/modules/send_page/views/send_page.dart';
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
import '../pages/crypto_tab.dart';

class TransactionDetailsBottomSheet extends StatefulWidget {
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
  State<TransactionDetailsBottomSheet> createState() =>
      _TransactionDetailsBottomSheetState();
}

class _TransactionDetailsBottomSheetState
    extends State<TransactionDetailsBottomSheet> {
  final controller = Get.find<TransactionController>();

  @override
  void initState() {
    if (widget.tokenInfo.hash == null) {
      try {
        HttpService.performGetRequest(
                "https://api.tzkt.io/v1/operations/transactions?id=${widget.tokenInfo.lastId}")
            .then((value) {
          widget.tokenInfo =
              widget.tokenInfo.copyWith(hash: jsonDecode(value)[0]["hash"]);
          setState(() {});
        });
      } catch (e) {
        print(e.toString());
      }
    }
    // TODO: implement initState
    super.initState();
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      // blurRadius: 50,
      width: 1.width,
      isScrollControlled: true,
      // height: .8.height,
      // bottomSheetHorizontalPadding: 0,

      // bottomSheetHorizontalPadding: 16.arP,
      bottomSheetWidgets: [
        Obx(() {
          widget.tokenInfo = widget.tokenInfo.copyWith(
              lastId: widget.tokenInfo.token!.lastid.toString(),
              source: widget.tokenInfo.token!.source(
                userAccounts: Get.find<HomePageController>().userAccounts,
                contacts: controller.contacts,
              ),
              destination: widget.tokenInfo.token!.destination(
                userAccounts: Get.find<HomePageController>().userAccounts,
                contacts: controller.contacts,
              ));
          // print(tokenInfo.token!.toJson());
//https://api.tzkt.io/v1/operations/transactions?id=505096501723136
          final source = widget.tokenInfo.source;
          final destination = widget.tokenInfo.destination;
          return Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(22.arP),
                  child: Column(
                    children: [
                      const BottomSheetHeading(
                        title: "",
                      ),
                      0.02.vspace,
                      Image.asset(
                        widget.tokenInfo.token == null ||
                                widget.tokenInfo.token!.operationStatus ==
                                    "applied"
                            ? "assets/transaction/success.png"
                            : "assets/transaction/failed.png",
                        height: 60.arP,
                        width: 60.arP,
                      ),
                      0.02.vspace,
                      Text(
                        widget.tokenInfo.token
                                ?.getTxType(widget.userAccountAddress) ??
                            "Received",
                        style: titleLarge,
                      ),
                      0.01.vspace,
                      Center(
                        child: Text(
                            DateFormat('MM/dd/yyyy HH:mm')
                                // displaying formatted date
                                .format(widget.tokenInfo.timeStamp!.toLocal()),
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
                              tokenInfo: widget.tokenInfo,
                              userAccountAddress: widget.userAccountAddress,
                              xtzPrice: widget.xtzPrice,
                            ),
                            ...widget.tokenInfo.internalOperation
                                .map((e) => TxTokenInfo(
                                      tokenInfo: e,
                                      userAccountAddress:
                                          widget.userAccountAddress,
                                      xtzPrice: widget.xtzPrice,
                                    ))
                                .toList(),
                          ],
                        ),
                      ),
                      _buildFooter(context),
                    ],
                  ))
            ],
          );
        }),
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
        if (widget.tokenInfo.hash != null)
          SolidButton(
            width: 1.width - 64.arP,
            title: 'view on tzkt.io',
            onPressed: () {
              CommonFunctions.bottomSheet(
                const DappBrowserView(),
                fullscreen: true,
                settings: RouteSettings(
                  arguments: "https://tzkt.io/${widget.tokenInfo.hash ?? ""}",
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
    if (widget.tokenInfo.token == null) return fees;
    // For-loop
    if (widget.tokenInfo.token!.bakerFee != null) {
      fees += widget.tokenInfo.token!.bakerFee!;
    }
    if (widget.tokenInfo.token!.storageFee != null) {
      fees += widget.tokenInfo.token!.storageFee!;
    }
    if (widget.tokenInfo.token!.allocationFee != null) {
      fees += widget.tokenInfo.token!.allocationFee!;
    }
    if (widget.tokenInfo.token!.gasUsed != null) {
      fees += widget.tokenInfo.token!.gasUsed!;
    }
    fees = fees / 1e6;
    return fees;
  }

  Widget contactTile(AliasAddress contact, String type) {
    bool isContactSaved =
        controller.contacts.any((e) => e.address == contact.address);
    final contactImage = controller.contacts
        .firstWhere((e) => e.address == contact.address,
            orElse: () => ContactModel(
                name: "",
                imagePath: ServiceConfig.allAssetsProfileImages.first,
                address: ""))
        .imagePath;
    return PopupMenuButton(
      tooltip: "", enabled: contact.address!.isValidWalletAddress,
      position: PopupMenuPosition.over,
      enableFeedback: true,
      // onCanceled: () => controller.isTransactionPopUpOpened.value = false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.arP)),
      color: const Color(0xff1E1C1F),
      itemBuilder: (BuildContext context) {
        // controller.isTransactionPopUpOpened.value = true;
        if (!contact.address!.isValidWalletAddress) return [];
        return <PopupMenuEntry>[
          _buildPopupMenu(contact, "Copy address", '${PathConst.SVG}copy.svg',
              () {
            copyAddress(contact);
          }, subtitle: contact.address?.tz1Short()),
          _buildDivider(),
          if (contact.address!.isValidWalletAddress & !isContactSaved) ...[
            _buildPopupMenu(contact, "Add to contacts",
                "assets/transaction/add_contact.png", () {
              CommonFunctions.bottomSheet(
                AddContactBottomSheet(
                    isTransactionContact: true,
                    contactModel: ContactModel(
                        name: contact.alias ?? "",
                        address: contact.address!,
                        imagePath: contactImage)),
              ).whenComplete(() => controller.contact?.value =
                  controller.getContact(contact.address!));
            }),
          ] else if (contact.address!.isValidWalletAddress &&
              isContactSaved) ...[
            _buildPopupMenu(
              contact,
              "Edit",
              "assets/transaction/edit.png",
              () {
                CommonFunctions.bottomSheet(
                  AddContactBottomSheet(
                      isEditContact: true,
                      isTransactionContact: true,
                      contactModel: ContactModel(
                          name: contact.alias ?? "Account",
                          address: contact.address!,
                          imagePath: contactImage)),
                ).whenComplete(() => controller.contact?.value =
                    controller.getContact(contact.address!));
              },
            ),
            _buildDivider(),
            _buildPopupMenu(
                contact,
                "Remove",
                "assets/transaction/trash.png",
                () => CommonFunctions.bottomSheet(
                      RemoveContactBottomSheet(
                          contactModel: ContactModel(
                              name: contact.alias ?? "",
                              address: contact.address!,
                              imagePath: contactImage)),
                    )),
          ],
          _buildDivider(),
          _buildPopupMenu(
            contact,
            "Send",
            "${PathConst.HOME_PAGE}send.png",
            () {
              final home = Get.find<HomePageController>();
              CommonFunctions.bottomSheet(
                const SendPage(),
                fullscreen: true,
                settings: RouteSettings(
                  arguments: home.userAccounts[home.selectedIndex.value],
                ),
              );
              Future.delayed(const Duration(milliseconds: 300), () async {
                Get.find<SendPageController>().scanner(contact.address!);
              });
            },
          ),
        ];
      },
      child: Row(
        children: [
          ClipOval(
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 22.aR,
              child: isContactSaved
                  ? Image.asset(contactImage)
                  : Image.network(
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
              SizedBox(
                height: 4.arP,
              ),
              Text(
                contact.alias ?? contact.address!.tz1Short(),
                style: bodyMedium,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  CustomPopupMenuDivider _buildDivider() {
    return CustomPopupMenuDivider(
      height: 1.arP,
      color: const Color(0xFF373737),
      padding: EdgeInsets.zero,
      thickness: 1,
    );
  }

  CustomPopupMenuItem _buildPopupMenu(
      AliasAddress contact, String title, String icon, Function() onTap,
      {String? subtitle}) {
    return CustomPopupMenuItem(
      height: subtitle != null ? 56.arP : 34.arP,
      width: .3.width,
      padding: EdgeInsets.symmetric(horizontal: 10.arP),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: bodySmall,
              ),
              if (subtitle != null)
                Padding(
                  padding: EdgeInsets.only(top: 4.arP),
                  child: Text(
                    subtitle,
                    style: bodySmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60),
                  ),
                )
            ],
          ),
          icon.contains(".svg")
              ? SvgPicture.asset(
                  icon,
                  color: Colors.white,
                  height: 16.arP,
                  width: 16.arP,
                )
              : Image.asset(
                  icon,
                  height: 16.arP,
                  color: Colors.white,
                  width: 16.arP,
                )
        ],
      ),
    );
  }

  void copyAddress(
    AliasAddress contact,
  ) {
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
                        : getColor(tokenInfo.token, userAccountAddress) ==
                                ColorConst.NeutralVariant.shade99
                            ? '- ${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}'
                            : '+${tokenInfo.tokenAmount.toStringAsFixed(6)} ${tokenInfo.tokenSymbol}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: bodySmall.copyWith(
                        color: ColorConst.NeutralVariant.shade60)),
                SizedBox(
                  height: 6.arP,
                ),
                Text(
                  tokenInfo.token == null ||
                          tokenInfo.token?.operationStatus == 'applied'
                      ? getColor(tokenInfo.token, selectedAccount) ==
                              ColorConst.NeutralVariant.shade99
                          ? '- ${(tokenInfo.dollarAmount).roundUpDollar(xtzPrice)}'
                          : (tokenInfo.dollarAmount).roundUpDollar(xtzPrice)
                      : "failed",
                  style: labelLarge.copyWith(
                      fontWeight: FontWeight.w400,
                      color: tokenInfo.token == null ||
                              tokenInfo.token?.operationStatus == 'applied'
                          ? getColor(tokenInfo.token, userAccountAddress)
                          : ColorConst.NaanRed),
                ),
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
            return const TokensSkeleton(
              itemCount: 1,
              isScrollable: false,
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
                tokenInfo.timeStamp!.isSameDay(tokenInfo.timeStamp!)
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

  Color getColor(TxHistoryModel? data, String selectedAccount) {
    if (data == null) return ColorConst.naanCustomColor;
    if (data.isSent(selectedAccount)) {
      return ColorConst.NeutralVariant.shade99;
    }
    if (data.isReceived(selectedAccount)) {
      return ColorConst.naanCustomColor;
    }
    if (data.getTxType(selectedAccount) == "Contract interaction" &&
        (data.amount ?? 0) > 0 &&
        data.sender!.address == selectedAccount) {
      return ColorConst.NeutralVariant.shade99;
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
      height: 262.arP, title: "Delete contact",
      // bottomSheetHorizontalPadding: 32,
      // blurRadius: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      bottomSheetWidgets: [
        0.02.vspace,
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
            width: 1.width - 64.arP,
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
          width: 1.width - 64.arP,
          primaryColor: const Color(0xff1E1C1F),
          title: "Cancel",
          onPressed: Get.back,
        ),
      ],
    );
  }
}
