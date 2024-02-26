import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plenty_wallet/app/data/services/data_handler_service/nft_and_txhistory_handler/nft_and_txhistory_handler.dart';
import 'package:plenty_wallet/app/data/services/rpc_service/http_service.dart';
import 'package:plenty_wallet/app/data/services/service_models/contact_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/nft_token_model.dart';
import 'package:plenty_wallet/app/data/services/service_models/tx_history_model.dart';
import 'package:plenty_wallet/app/data/services/user_storage_service/user_storage_service.dart';
import 'package:plenty_wallet/app/modules/account_summary/views/bottomsheets/fee_detail_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bottom_sheet.dart';
import 'package:plenty_wallet/app/modules/common_widgets/bouncing_widget.dart';
import 'package:plenty_wallet/app/modules/common_widgets/solid_button.dart';
import 'package:plenty_wallet/app/modules/custom_gallery/widgets/custom_nft_detail_sheet.dart';
import 'package:plenty_wallet/app/modules/dapp_browser/views/dapp_browser_view.dart';
import 'package:plenty_wallet/app/modules/home_page/controllers/home_page_controller.dart';
import 'package:plenty_wallet/app/modules/send_page/controllers/send_page_controller.dart';
import 'package:plenty_wallet/app/modules/send_page/views/send_page.dart';
import 'package:plenty_wallet/app/modules/send_page/views/widgets/add_contact_sheet.dart';
import 'package:plenty_wallet/app/modules/settings_page/widget/manage_accounts_sheet.dart';
import 'package:plenty_wallet/app/modules/veNFT.dart';
import 'package:plenty_wallet/utils/colors/colors.dart';
import 'package:plenty_wallet/utils/common_functions.dart';
import 'package:plenty_wallet/utils/constants/constants.dart';
import 'package:plenty_wallet/utils/extensions/size_extension.dart';
import 'package:plenty_wallet/utils/styles/styles.dart';
import 'package:plenty_wallet/utils/utils.dart';

import '../../../../../utils/constants/path_const.dart';
import '../../../../data/services/service_config/service_config.dart';
import '../../../../data/services/service_models/token_price_model.dart';
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
  TxHistoryModel? txHistoryModel;
  @override
  void initState() {
    if (widget.tokenInfo.hash == null) {
      try {
        HttpService.performGetRequest(
                "https://api.tzkt.io/v1/operations/transactions?id=${widget.tokenInfo.lastId}")
            .then((value) {
          final data = jsonDecode(value)[0];
          widget.tokenInfo = widget.tokenInfo.copyWith(
            hash: data["hash"],
          );
          txHistoryModel = TxHistoryModel(
              bakerFee: data["bakerFee"],
              storageFee: data["storageFee"],
              allocationFee: data["allocationFee"],
              gasUsed: data["gasUsed"]);
          setState(() {});
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    // TODO: implement initState
    super.initState();
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return NaanBottomSheet(
      width: 1.width, bottomSheetHorizontalPadding: 0,
      // title: "",
      height: AppConstant.naanBottomSheetHeight,
      bottomSheetWidgets: [
        Obx(() {
          final source = widget.tokenInfo.source == null
              ? null
              : getAddressAlias(widget.tokenInfo.source!,
                  userAccounts: Get.find<HomePageController>().userAccounts,
                  contacts: controller.contacts);
          final destination = widget.tokenInfo.destination == null
              ? null
              : getAddressAlias(widget.tokenInfo.destination!,
                  userAccounts: Get.find<HomePageController>().userAccounts,
                  contacts: controller.contacts);
          return SizedBox(
            height: AppConstant.naanBottomSheetChildHeight,
            child: Navigator(onGenerateRoute: (_) {
              return MaterialPageRoute(builder: (context) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.arP),
                  child: Column(
                    children: [
                      BottomSheetHeading(
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
                            (widget.tokenInfo.isSent ? "Sent" : "Received"),
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
                      0.02.vspace,

                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.arP),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                // const BottomSheetHeading(
                                //   title: "",
                                // ),

                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.arP),
                                    color: const Color(0xff1E1C1F),
                                  ),
                                  // margin: EdgeInsets.only(
                                  //   bottom: 24.arP,
                                  // ),
                                  child: Column(
                                    children: [
                                      BouncingWidget(
                                        onPressed: widget.tokenInfo.isNft
                                            ? () {
                                                final contractAddress = widget
                                                    .tokenInfo
                                                    .nftContractAddress;
                                                final tokenId =
                                                    widget.tokenInfo.nftTokenId;
                                                CommonFunctions.bottomSheet(
                                                    CustomNFTDetailBottomSheet(
                                                      nftUrl:
                                                          "https://objkt.com/asset/$contractAddress/$tokenId",
                                                    ),
                                                    fullscreen: true);
                                              }
                                            : null,
                                        child: TxTokenInfo(
                                          tokensList: controller.tokensList,
                                          tokenInfo: widget.tokenInfo,
                                          userAccountAddress:
                                              widget.userAccountAddress,
                                          xtzPrice: widget.xtzPrice,
                                        ),
                                      ),
                                      ...widget.tokenInfo.internalOperation
                                          .map((e) => BouncingWidget(
                                                onPressed: !e.isNft
                                                    ? null
                                                    : () {
                                                        final contractAddress = e
                                                                .nftContractAddress ??
                                                            e.token
                                                                ?.transactionInterface(
                                                                    controller
                                                                        .tokensList)
                                                                .contractAddress;
                                                        final tokenId = e
                                                                .nftTokenId ??
                                                            e.token
                                                                ?.transactionInterface(
                                                                    controller
                                                                        .tokensList)
                                                                .tokenID;
                                                        CommonFunctions.bottomSheet(
                                                            CustomNFTDetailBottomSheet(
                                                              nftUrl:
                                                                  "https://objkt.com/asset/$contractAddress/$tokenId",
                                                            ),
                                                            fullscreen: true);
                                                      },
                                                child: TxTokenInfo(
                                                  tokensList:
                                                      controller.tokensList,
                                                  tokenInfo: e,
                                                  userAccountAddress:
                                                      widget.userAccountAddress,
                                                  xtzPrice: widget.xtzPrice,
                                                ),
                                              ))
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _buildFooter(context)
                    ],
                  ),
                );
              });
            }),
          );
        }),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    if (widget.tokenInfo.hash == null) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Color(0xff1E1C1F),
        ),
        0.02.vspace,
        BouncingWidget(
          onPressed: () {
            if (widget.tokenInfo.token == null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => TransactionFeeDetailShet(
                            tokensList: controller.tokensList,
                            tokenInfo: widget.tokenInfo
                                .copyWith(token: txHistoryModel),
                            userAccountAddress: widget.userAccountAddress,
                            xtzPrice: widget.xtzPrice,
                          )));
              // CommonFunctions.bottomSheet(TransactionFeeDetailShet(
              //   tokenInfo: widget.tokenInfo.copyWith(token: txHistoryModel),
              //   userAccountAddress: widget.userAccountAddress,
              //   xtzPrice: widget.xtzPrice,
              // ));
            } else {
              int bakerFees = widget.tokenInfo.token?.bakerFee ?? 0;
              int allocationFee = widget.tokenInfo.token?.allocationFee ?? 0;
              int gasUsed = widget.tokenInfo.token?.gasUsed ?? 0;
              int storageFee = widget.tokenInfo.token?.storageFee ?? 0;
              for (var element in widget.tokenInfo.internalOperation) {
                bakerFees += element.token!.bakerFee ?? 0;
                allocationFee += element.token!.allocationFee ?? 0;
                gasUsed += element.token!.gasUsed ?? 0;
                storageFee += element.token!.storageFee ?? 0;
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => TransactionFeeDetailShet(
                            tokensList: controller.tokensList,
                            tokenInfo: widget.tokenInfo,
                            userAccountAddress: widget.userAccountAddress,
                            xtzPrice: widget.xtzPrice,
                          )));
              // CommonFunctions.bottomSheet(TransactionFeeDetailShet(
              //   tokenInfo: widget.tokenInfo,
              //   userAccountAddress: widget.userAccountAddress,
              //   xtzPrice: widget.xtzPrice,
              // ));
            }
          },
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
                    calculateFees().roundUpDollar(widget.xtzPrice, decimals: 6),
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
        Center(
          child: SolidButton(
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
        ),
        // const BottomButtonPadding()
      ],
    );
  }

  double calculateFees() {
    double fees = 0.0;
    TxHistoryModel? token = widget.tokenInfo.token ?? txHistoryModel;
    if (token == null) return fees;
    // For-loop
    if (token.bakerFee != null) {
      fees += token.bakerFee!;
    }
    if (token.storageFee != null) {
      fees += token.storageFee!;
    }
    if (token.allocationFee != null) {
      fees += token.allocationFee!;
    }
    if (token.gasUsed != null) {
      fees += token.gasUsed!;
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
      offset: Offset(-1.width, 50),
      tooltip: "", enabled: contact.address!.isValidWalletAddress,
      position: PopupMenuPosition.over,
      enableFeedback: true,
      // onCanceled: () => controller.isTransactionPopUpOpened.value = false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.arP)),
      color: const Color(0xff1E1C1F),
      padding: EdgeInsets.symmetric(horizontal: 16.arP),
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
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: .75.width),
                    child: Text(
                      (contact.alias ?? contact.address!.tz1Short()),
                      style: bodyMedium, maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
    Clipboard.setData(ClipboardData(text: contact.address!));
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
    required this.tokensList,
    this.showAmount = true,
  });

  TokenInfo tokenInfo;
  List<TokenPriceModel> tokensList;
  final String userAccountAddress;
  final double xtzPrice;

  bool showAmount;

  @override
  Widget build(BuildContext context) {
    final selectedAccount = Get.find<HomePageController>()
        .userAccounts[Get.find<HomePageController>().selectedIndex.value]
        .publicKeyHash!;

    if (tokenInfo.token != null) {
      final transactionInterface =
          tokenInfo.token!.transactionInterface(tokensList);
      if (!tokenInfo.isNft) {
        tokenInfo = tokenInfo.copyWith(
          imageUrl: transactionInterface.imageUrl,
          name: transactionInterface.name,
          tokenAmount: tokenInfo.token!.getAmount(
            tokensList,
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
          Container(
            constraints: BoxConstraints(maxWidth: .345.width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                        tokenInfo.token?.getTxIcon(selectedAccount) ??
                            (tokenInfo.isSent
                                ? "assets/transaction/up.png"
                                : "assets/transaction/down.png"),
                        width: 14.aR,
                        height: 14.arP,
                        color: ColorConst.NeutralVariant.shade60),
                    Container(
                      constraints: BoxConstraints(maxWidth: .5.width),
                      child: Text(
                          " ${tokenInfo.token?.getTxType(selectedAccount) ?? (tokenInfo.isSent ? "Sent" : "Received")}",
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
          ),
          const Spacer(),
          if (showAmount)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                    tokenInfo.isNft
                        ? "${tokenInfo.tokenAmount == 0.0 ? "1" : tokenInfo.tokenAmount.toStringAsFixed(0)} ${tokenInfo.tokenSymbol}"
                        : tokenInfo.token
                                    ?.getTxType(selectedAccount)
                                    .startsWith("Delegated") ??
                                false
                            ? '${tokenInfo.tokenAmount.toStringAsFixed(6).removeTrailing0} ${tokenInfo.tokenSymbol}'
                            : getColor(tokenInfo.token, userAccountAddress) ==
                                    ColorConst.NeutralVariant.shade99
                                ? '- ${tokenInfo.tokenAmount.toStringAsFixed(6).removeTrailing0} ${tokenInfo.tokenSymbol}'
                                : '+${tokenInfo.tokenAmount.toStringAsFixed(6).removeTrailing0} ${tokenInfo.tokenSymbol}',
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
                      ? tokenInfo.token
                                  ?.getTxType(selectedAccount)
                                  .startsWith("Delegated") ??
                              false
                          ? (tokenInfo.dollarAmount / xtzPrice)
                              .roundUpDollar(xtzPrice)
                              .removeTrailing0
                          : getColor(tokenInfo.token, selectedAccount) ==
                                  ColorConst.NeutralVariant.shade99
                              ? '- ${(tokenInfo.dollarAmount / xtzPrice).roundUpDollar(xtzPrice).removeTrailing0}'
                              : (tokenInfo.dollarAmount / xtzPrice)
                                  .roundUpDollar(xtzPrice)
                                  .removeTrailing0
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
    if (tokenInfo.token != null) {
      final transactionInterface =
          tokenInfo.token!.transactionInterface(tokensList);
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
                // tokenInfo.timeStamp!.displayDate(tokenInfo.timeStamp!)
                //     ? const SizedBox()
                //     : Padding(
                //         padding: EdgeInsets.only(
                //             top: 16.arP, left: 16.arP, bottom: 16.arP),
                //         child: Text(
                //           DateFormat.MMMM()
                //               // displaying formatted date
                //               .format(
                //                   DateTime.parse(tokenInfo.token!.timestamp!)),
                //           style: labelLarge,
                //         ),
                //       ),
                TxTokenInfo(
                  tokensList: tokensList,
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
